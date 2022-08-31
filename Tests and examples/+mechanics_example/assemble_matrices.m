%assemble_matrices
% Assemble the required matrices for centrifugal stress analysis, using the
% 2D plane-strain formulation.

Np = msh.number_of_nodes;

N = Nodal2D(Operators.grad);
S11 = FEMatrixConstructor();
S22 = FEMatrixConstructor();
S12 = FEMatrixConstructor();
J1 = [1 0;0 0;0 1]; %for Voigt notation
J2 = [0 0;0 1;1 0];

rhos = zeros(1, msh.number_of_elements);
for k = 1:numel(materials)
    mat = materials(k);
   
    els = mat.elements;
    rhos(els) = mat.density;
    tens = mat.stiffness_tensor;
        
    S11.assemble_matrix(N, N, reshape(J1'*tens*J1, [], 1), els, msh);
    S22.assemble_matrix(N, N, reshape(J2'*tens*J2, [], 1), els, msh);
    S12.assemble_matrix(N, N, reshape(J1'*tens*J2, [], 1), els, msh);
end

S11 = S11.finalize(Np, Np);
S12 = S12.finalize(Np, Np);
S22 = S22.finalize(Np, Np);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% boundary condition matrix

n_cw = D.n_cw; %clock-wise boundary
n_ccw = D.n_ccw; %counter-clockwise
n_dir_all = [D.n_dir Np+D.n_dir]; %all zero dofs

%all non-air nodes
modelled_elements = [materials.elements];
nodes_in_modelled_elements = unique(msh.elements(:, modelled_elements));
n_modelled = setdiff(nodes_in_modelled_elements', n_dir_all);

%all zero nodes = actual boundary nodes plus nodes in air
ndir = union(setdiff(1:(2*Np), [n_modelled Np+n_modelled]), n_dir_all);

%updating periodic boundary nodes
n_ccw = setdiff(n_ccw, ndir, 'stable');
n_cw = setdiff(n_cw, ndir, 'stable');

%sector angle
asector = 2*pi/symmetry_sectors;

%assembling boundary condition matrix
BC = InterpolatingMatrixConstructor();

%add zero nodes
BC.add_zeros([Np+n_cw ndir]);

%add periodic / interpolated dofs
master_nodes = [n_ccw Np+n_ccw];
minion_nodes = [(abs(cos(asector))>1e-4)*n_cw (abs(sin(asector))>1e-4)*n_cw];
periodicity_coefficient = [(abs(cos(asector))>1e-4).*cos(asector)*ones(1, numel(n_cw)) ...
    (abs(sin(asector))>1e-4).*sin(asector)*ones(1, numel(n_cw))];
BC.add_part([master_nodes; minion_nodes; periodicity_coefficient]);

%finalize the all-to-free-dofs mapping matrix
P = BC.finalize(2*Np);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% centrifugal stress vector

x0 = msh.element_centers(modelled_elements);
s_x = wm^2 * rhos(modelled_elements) .* x0(1,:);
s_y = wm^2 * rhos(modelled_elements) .* x0(2,:);

xfun = @(~, x, varargin)( wm^2*rhos(modelled_elements).*x(1,:) );
yfun = @(~, x, varargin)( wm^2*rhos(modelled_elements).*x(2,:) );
fx = FEMatrixConstructor();
fx.assemble_matrix( Nodal2D(), IDfun(), s_x, modelled_elements, msh);
fx = fx.finalize(Np, 1);

fy = FEMatrixConstructor().assemble_matrix( Nodal2D(), IDfun(), s_y, modelled_elements, msh);
fy = fy.finalize(Np, 1);