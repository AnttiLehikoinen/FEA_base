%solving simplified heat equation example

%load vector with heat generation in one element
P = 10; %power density
ke = 4;
N = Nodal2D();
Fc = FEMatrixConstructor();
Fc.assemble_vector(N, P, ke, msh);
F = Fc.finalize();

%matrix for boundary conditions
Pc = InterpolatingMatrixConstructor();
Pc.add_zeros([1 3]);
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