%initialize_stuff. Load stored motor data, transform to usable form.

D = load('Data/IPM_rotor.mat');

symmetry_sectors = 6;
rpm = 6000;
wm = 2*pi*rpm/60;

%creating mesh object
nodes = D.nodes;
elements = D.elements;
msh = TriMesh(D.nodes, D.elements);

% parsing material properties

%iron
iron = struct();
iron.density = 7900;
E = 1.8500e+11;
nu = 0.3; 
iron.stiffness_tensor = E/((1+nu)*(1-2*nu)) *[1-nu nu 0;nu 1-nu 0;0 0 (1-2*nu)/2];
iron.elements = D.iron;

%PMs
magnet = struct();
magnet.density = 7500;
E = 1.6000e+11;
nu = 0.24;
magnet.stiffness_tensor = E/((1+nu)*(1-2*nu)) *[1-nu nu 0;nu 1-nu 0;0 0 (1-2*nu)/2];
magnet.elements = D.magnet_elements;

%array of properties
materials = [magnet, iron];
