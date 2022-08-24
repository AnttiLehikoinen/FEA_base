

nodes = [0 0;1 0;0 1; 1 1]';
elements = [1 2 3;2 3 4]';

msh = RealMesh();
msh.nodes = nodes;
msh.elements = elements;

figure(1); clf; hold on; box on; axis equal;
msh.triplot();


msh2 = ProxyMesh();
msh2.parent_mesh = msh;
msh2.elements = elements;

figure(2); clf; hold on; box on; axis equal;
msh2.triplot();