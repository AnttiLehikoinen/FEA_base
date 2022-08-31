%solve_and_visualize Solve displacements.
%
% Solves the displacements, and visualizes them and the von Mises stresses.

diplacement_multiplier_for_plotting = 1e3;

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
msh.fill(els, Svm(els)/1e6, 'linestyle', 'none'); colormap('jet'); colorbar;
%caxis([0 200]);
title('Von Mises stress (MPa)');