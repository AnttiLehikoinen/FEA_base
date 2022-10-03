

edges_magnet = msh.elements_to_edges(:, D.magnet_elements);
edges_iron = msh.elements_to_edges(:, D.iron);

edges_intersect = intersect(abs(edges_magnet), abs(edges_iron));


figure(1); clf; hold on; box on; axis equal;
msh.triplot([]);
msh.plot_edges(abs(edges_intersect), 'r')

%duplicating nodes
n_to_duplicate = unique(msh.edges(:, edges_intersect));

%adding nodes
Np_old = msh.number_of_nodes;
msh.nodes = [msh.nodes, msh.nodes(:, n_to_duplicate)];

%updating magnet element definitions
new_node_indices = 1:Np_old;
new_node_indices(n_to_duplicate) = Np_old + (1:numel(n_to_duplicate));

t_mag_old = msh.elements(:, D.magnet_elements);
t_mag_new = new_node_indices(t_mag_old);
msh.elements(:, D.magnet_elements) = t_mag_new;

%old and new edge definitions
edef_old = msh.edges(:, edges_intersect);
edef_new = new_node_indices(edef_old);

%shell mesh
msh_shell = ShellMesh2D();
%msh_shell.nodes = msh.nodes;
msh_shell.parent_mesh = msh;
msh_shell.elements = [edef_old; flipud(edef_new)];

