

xs = linspace(-1, 1, 10);

[x, y] = meshgrid(xs);

%x = [-]
%x = -1;y = -1;

msh = LinearQuadmesh();
msh.nodes = [-1 -1;1 -1;1 1;-1 1]';
msh.elements = [1 2 3 4]';


N = Nodal2DQuad();
k = 4;

F = N.eval(k, [x(:)'; y(:)'], msh, 1);


N = Nodal2DQuad(Operators.grad);
Fg = N.eval(k, [x(:)'; y(:)'], msh, 1);

%[Fgx, Fgy] = gradient(reshape(F, size(x))*2/(numel(xs)-1));

figure(10); clf; hold on;
surf(x, y, reshape(F, size(x)));
quiver(x(:), y(:), Fg(1,:)', Fg(2,:)')

%quiver(x, y, Fgx, Fgy, 'r')