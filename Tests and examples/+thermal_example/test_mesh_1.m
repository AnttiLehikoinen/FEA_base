

nodes = [0 0;
    1 0;
    0 1;
    1 1;
    0 2;
    1 2]';

elements = [1 2 3;
    3 4 2;
    3 5 6;
    3 4 6]';

msh = TriMesh(nodes, elements);

figure(1); clf; hold on; box on; axis equal;
title('Mesh');
msh.triplot([]);

msh.evaluate_mapping