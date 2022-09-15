
msh = ShellMesh2D();


msh.nodes = [0 0;1 0;2 1]';
msh.elements = [1 2 4 5;2 3 5 6]';

msh.thickness = 1;

Ng = Nodal2DQuad(Operators.grad);

Mc = FEMatrixConstructor();
Mc.assemble_matrix(Ng, Ng, 1, [], msh);
S = Mc.finalize(6, 6);

F = msh.evaluate_mapping