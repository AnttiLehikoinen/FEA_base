

nodes = [0 0;
    1 0;
    0 1;
    1 1]';

elements = [1 2 3;3 4 2]';

msh = TriMesh(nodes, elements);

msh.evaluate_mapping