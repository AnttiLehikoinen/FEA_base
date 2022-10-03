classdef Triangle1stOrder
    properties (Constant)
        nodes = [0 0;1 0;0 1]'
        edges = [1 2; 2 3; 3 1]'

        polynomial_base = []
    end

    methods
        [x, w] = get_integration_points(~, order, varargin)

        function F_msh = spawn_mesh_specific_shape_function(this, F_base, ~)
            if isa(F_base, 'Nodal2D')
                F_msh = Nodal2DTri(F_base.operator);
            else
                error('Unhandled shape function.')
            end
        end
    end
end