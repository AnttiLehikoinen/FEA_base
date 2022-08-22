% assembling matrices

Np = msh.number_of_elements;

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

n_cw = D.n_cw;
n_ccw = D.n_ccw;
n_dir_all = [D.n_dir Np+D.n_dir];


%all non-air nodes
modelled_elements = [materials.elements];
nodes_in_modelled_elements = unique(msh.elements(:, modelled_elements));
n_modelled = setdiff(nodes_in_modelled_elements', n_dir_all);

%all dirichlet nodes = actual boundary nodes plus nodes in air
ndir = union(setdiff(1:(2*Np), [n_modelled Np+n_modelled]), n_dir_all);

%updating periodic boundary nodes
n_ccw = setdiff(n_ccw, ndir, 'stable');
n_cw = setdiff(n_cw, ndir, 'stable');

%sector angle
asector = 2*pi/symmetry_sectors;

%boundary data
P_zero = [Np+n_cw ndir; zeros(2, numel(n_cw)+numel(ndir))];
P_periodic = [n_ccw Np+n_ccw;
    (abs(cos(asector))>1e-4)*n_cw (abs(sin(asector))>1e-4)*n_cw;
    (abs(cos(asector))>1e-4).*cos(asector)*ones(1, numel(n_cw)) ...
    (abs(sin(asector))>1e-4).*sin(asector)*ones(1, numel(n_cw))];

%combining
P_data = {[P_zero P_periodic]};

temp = intersect(P_periodic(1,:), P_zero(1,:));

%assembling interpolation matrix
P = assemble_TotalMasterSlaveMatrix(2*Np, P_data, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% centrifugal stress vector

x0 = msh.element_centers(modelled_elements);
s_x = wm^2 * rhos(modelled_elements) .* x0(1,:);
s_y = wm^2 * rhos(modelled_elements) .* x0(2,:);

xfun = @(~, x, varargin)( wm^2*rhos(modelled_elements).*x(1,:) );
yfun = @(~, x, varargin)( wm^2*rhos(modelled_elements).*x(2,:) );
fx = FEMatrixConstructor();
fx.assemble_matrix( Nodal2D(), IDfun(), s_x, modelled_elements, msh);
fx = fx.finalize();
fy = FEMatrixConstructor().assemble_with_fun( Nodal2D(), IDfun(), s_y, modelled_elements, msh).finalize();
