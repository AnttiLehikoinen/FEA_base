
%material property array
nu = ones(1, msh.number_of_elements);

Ng = Nodal2D(Operators.grad);

%assembling stiffness matrix
Mc = FEMatrixConstructor();
Mc.assemble_matrix(Ng, Ng, nu, [], msh);
S = Mc.finalize();

%the same with the simplified approach
Ssimple = FEMatrixConstructor.assemble_simple(Ng, Ng, nu, [], msh, msh.number_of_nodes);

norm(Ssimple - full(S))

figure(2); clf; hold on; box on;
title('Matrix sparsity pattern');
spy(S);