%solve_and_visualize Solve displacements.
%
% Solves the displacements, and visualizes them and the von Mises stresses.

diplacement_multiplier_for_plotting = 1e4;

modelled_elements = [];

%solving
U = P * ( (P'*[S11 S12;S12' S22]*P) \ (P'*[fx;fy]) );
U = full(U);

%creating a mesh view for visualization
%mshp = DisplacedMeshView(msh);
%mshp.displacement = U*diplacement_multiplier_for_plotting;

%%{
mshp = LinearQuadmesh();
mshp.elements = msh.elements;
mshp.nodes = msh.nodes;
mshp.nodes = mshp.nodes + diplacement_multiplier_for_plotting * [U(1:Np)'; U((Np+1):end)'];
%}


figure(3); clf; hold on; box on; axis equal;
title('Displacements');
%msh.triplot(modelled_elements);
for k = 1:numel(materials)
    els = materials(k).elements;
    %mshp.fill(els, k, 'linestyle', 'none', 'facealpha', 0.5);
end
mshp.triplot([]);

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
mshp.fill([], Svm/1e6, 'linestyle', 'none'); colormap('jet'); colorbar;
%caxis([0 200]);
title('Von Mises stress (MPa)');


%same for shell elements
Ne = msh_shell.number_of_elements;
S = zeros(3, Ne);

G = zeros(2, Ne);
for k = 1:numel(materials)
    if ~isa(materials(k).mesh, 'ShellMesh2D')
        continue;
    end

    %els = materials(k).elements;
    els = 1:Ne;
    stiff = materials(k).stiffness_tensor;
    
    for kf = 1:4
        S(:,els) = S(:,els) + stiff*bsxfun(@times, J1*N.eval(kf, [0;0], msh_shell, els), ...
            U( mshp.elements(kf,els) )')  + ...
            stiff*bsxfun(@times, J2*N.eval(kf, [0;0], msh_shell, els), ...
            U( Np+mshp.elements(kf,els) )');

        G = N.eval(kf, [0;0], msh_shell, []) .* U( Np+mshp.elements(kf,els) )'
    end
end
Svm_shell = sqrt( S(1,:).^2 - S(1,:).*S(2,:) + S(2,:).^2 + 3*S(3,:).^2 );
Svm_shell/1e6

figure(5); clf; hold on; box on; axis equal square;
msh_shell.fill([], Svm_shell/1e6, 'linestyle', 'none'); colormap('jet'); colorbar;
%caxis([0 200]);
title('Von Mises stress (MPa)');
