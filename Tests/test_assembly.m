
clc

Ng = Nodal2D(Operators.grad);

Mc = FEMatrixConstructor();


nu = [1, 1];

Mc.assemble_matrix(Ng, Ng, nu, [], msh);

M = Mc.finalize();

figure(1); clf; hold on; box on;
spy(M);