classdef Triangle1stOrder
    properties (Constant)
        nodes = [0 0;1 0;0 1]'
        edges = [1 2; 2 3; 3 1]

        polynomial_base = []
    end

    methods
        [x, w] = get_integration_points(~, order, varargin)
    end
end