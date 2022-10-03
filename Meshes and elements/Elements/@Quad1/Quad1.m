classdef Quad1 < ReferenceElementBase
    properties (Constant)
        nodes = [-1 -1; 1 -1;1 1;-1 1]';
        edges = [1 2;2 3;3 4;4 1]';
        polynomial_base = [];
    end
    
    methods
        function [x, w] = get_integration_points(this, order, mesh)
            [x1, w1] = get_quadrature_points_1D(order);
            
            x = zeros(2, numel(w1)^2);
            w = zeros(1, size(x,2));
            ri = 1;
            for kx = 1:numel(w1)
                for ky = 1:numel(w1)
                    x(:, ri) = [x1(kx); x1(ky)];
                    w(ri) = w1(kx)*w1(ky);
                    ri = ri + 1;
                end
            end
        end

        function F_msh = spawn_mesh_specific_shape_function(this, F_base, ~)
            if isa(F_base, 'Nodal2D')
                F_msh = Nodal2DQuad(F_base.operator);
            else
                error('Unhandled shape function.')
            end
        end
            
    end
end