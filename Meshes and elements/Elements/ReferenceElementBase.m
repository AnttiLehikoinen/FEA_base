classdef (Abstract) ReferenceElementBase < handle
    properties (Abstract, Constant)
        nodes
        edges

        polynomial_base
    end

    methods (Abstract)
        [x, w] = get_integration_points(this, order, mesh)
    end
end