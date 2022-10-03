%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creating mesh

nodes = [0 0; 1 0; 1 1; 0 1;
    0 1; 1 1;
    1 2; 0 2]';

%triangle mesh
%%{
msh = TriMesh();
msh.nodes = nodes;
msh.elements = [1 2 4; 2 3 4;
    5 6 7; 5 7 8]';

elements_with_source = [2 3];
%}

%quad mesh
%{
msh = LinearQuadmesh();
msh.nodes = nodes;
msh.elements = [1 2 3 4;5 6 7 8]';
elements_with_source = [1 2];
%}

figure(1); clf; hold on; box on; axis equal;
msh.triplot([]);

msh_shell = ShellMesh2D();
msh_shell.nodes = msh.nodes;
msh_shell.elements = [3 4 5 6]';
msh_shell.thickness = 1e-3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% materials

iron = struct();
E = 1.8500e+11;
nu = 0.3; 
iron.stiffness_tensor = E/((1+nu)*(1-2*nu)) *[1-nu nu 0;nu 1-nu 0;0 0 (1-2*nu)/2];
iron.elements = 1:msh.number_of_elements;
iron.mesh = msh;

glue = struct();
E = 3.35e9;
nu = 0.3; %FIXME check this
glue.stiffness_tensor = E/((1+nu)*(1-2*nu)) *[1-nu nu 0;nu 1-nu 0;0 0 (1-2*nu)/2];
glue.elements = [];
glue.mesh = msh_shell;

msh_shell.thickness = 0.05e-3;


materials = [iron, glue];