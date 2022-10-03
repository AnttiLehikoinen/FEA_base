
nodes = [0 0; 1 0; 1 1; 0 1;
    1 2; 0 2]';

%triangle mesh
%%{
msh = TriMesh();
msh.nodes = nodes;
msh.elements = [1 2 4; 2 3 4;
    4 3 5; 5 6 4]';

elements_with_source = [2 3];
%}

%quad mesh
%{
msh = LinearQuadmesh();
msh.nodes = nodes;
msh.elements = [1 2 3 4;4 3 5 6]';
elements_with_source = 2;
%}


figure(1); clf; hold on; box on; axis equal;
msh.triplot(4);


%material property array
nu = ones(1, msh.number_of_elements);

Ng = Nodal2D(Operators.grad);

%assembling stiffness matrix
Mc = FEMatrixConstructor();
Mc.assemble_matrix(Ng, Ng, nu, [], msh);

S = Mc.finalize();

%load vector with heat generation in one element
P = 10; %power density
N = Nodal2D();
Fc = FEMatrixConstructor();
Fc.assemble_vector(N, P, elements_with_source, msh);
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