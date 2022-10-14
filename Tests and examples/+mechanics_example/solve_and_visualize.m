%solve_and_visualize Solve displacements.
%
% Solves the displacements, and visualizes them and the von Mises stresses.

diplacement_multiplier_for_plotting = 0.5e3;

%solving
U = P * ( (P'*[S11 S12;S12' S22]*P) \ (P'*[fx;fy]) );

%creating a mesh view for visualization
mshp = DisplacedMeshView(msh);
mshp.displacement = U*diplacement_multiplier_for_plotting;


figure(3); clf; hold on; box on; axis equal tight;
title('Displacements');
msh.triplot(modelled_elements);
for k = 1:numel(materials)
    els = materials(k).elements;
    mshp.fill(els, k, 'linestyle', 'none', 'facealpha', 0.5);
end

%computing and plotting stress
Ne = msh.number_of_elements;
S = zeros(3, Ne);
for k = 1:numel(materials)
    if isa(materials(k).mesh, 'ShellMesh2D')
        continue;
    end

    els = materials(k).elements;
    stiff = materials(k).stiffness_tensor;

    for kf = 1:3
        S(:,els) = S(:,els) + stiff*bsxfun(@times, J1*N.eval(kf, [0.25;0.25], msh, els), ...
            U( msh.elements(kf,els) )')  + ...
            stiff*bsxfun(@times, J2*N.eval(kf, [0.25;0.25], msh, els), ...
            U( Np+msh.elements(kf,els) )');
    end
end
Svm = sqrt( S(1,:).^2 - S(1,:).*S(2,:) + S(2,:).^2 + 3*S(3,:).^2 );

figure(4); clf; hold on; box on; axis equal square;
els = modelled_elements;
mshp.fill(els, Svm(els)/1e6, 'linestyle', 'none'); colormap('jet'); colorbar;
%caxis([0 200]);
title('Von Mises stress (MPa)');

%same for shell elements
Ne = msh_shell.number_of_elements;
S = zeros(3, Ne);
for k = 1:numel(materials)
    if ~isa(materials(k).mesh, 'ShellMesh2D')
        continue;
    end

    %els = materials(k).elements;
    els = 1:Ne;
    stiff = materials(k).stiffness_tensor;
    
    for kf = 1:size(msh_shell.elements,1)
        S(:,els) = S(:,els) + stiff*bsxfun(@times, J1*N.eval(kf, [0;0], msh_shell, els), ...
            U( msh_shell.elements(kf,els) )')  + ...
            stiff*bsxfun(@times, J2*N.eval(kf, [0;0], msh_shell, els), ...
            U( Np+msh_shell.elements(kf,els) )');
    end
end
Svm = sqrt( S(1,:).^2 - S(1,:).*S(2,:) + S(2,:).^2 + 3*S(3,:).^2 );

msh_shell.parent_mesh = mshp;
msh_shell.fill([], Svm/1e6, 'linewidth', 2);
msh_shell.parent_mesh = msh; %THIS IS IMPORTANT
%caxis([0 200]);
title('Von Mises stress (MPa)');
