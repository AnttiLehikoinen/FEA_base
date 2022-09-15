
msh = TriMesh();
msh.nodes = [0 0; 1 0; 0 1; 1 1;
    0 1; 1 1;
    0 2; 1 2]';
msh.elements = [1 2 3; 2 3 4;
    5 6 8; 5 7 8]';

figure(1); clf; hold on; box on; axis equal;
msh.triplot([]);

msh_shell = ShellMesh2D();
msh_shell.nodes = msh.nodes;
msh_shell.elements = [3 4 6 5]';
msh_shell.thickness = 0.01;

%material property array
nu = ones(1, msh.number_of_elements);

Ng = Nodal2D(Operators.grad);
Ngq = Nodal2DQuad(Operators.grad);

%assembling stiffness matrix
Mc = FEMatrixConstructor();
Mc.assemble_matrix(Ng, Ng, nu, [], msh);
Mc.assemble_matrix(Ngq, Ngq, 0.8, [], msh_shell);

S = Mc.finalize();

%load vector with heat generation in one element
P = 10; %power density
ke = [3 4];
N = Nodal2D();
Fc = FEMatrixConstructor();
Fc.assemble_vector(N, P, ke, msh);
F = Fc.finalize();

%matrix for boundary conditions
Pc = InterpolatingMatrixConstructor();
Pc.add_zeros([1 2]);
P = Pc.finalize(msh.number_of_nodes);

%solving
Tfree = (P'*S*P) \ (P'*F); %free variables
T = full(P * Tfree); %all variables

figure(3); clf; hold on; box on;
title('Surface plot of temperature');
msh.trisurf([], T);

figure(4); clf; hold on; box on;
title('Color plot of temperature');
msh.fill([], T);

colormap(jet);
colorbar;