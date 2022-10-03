classdef (Abstract) ReferenceElementBase < handle
    %ReferenceElementBase Base class for reference elements.
    %
    % Defines the reference element.
    properties (Abstract, Constant)
        %nodes Nodes of the reference element.
        %
        % A ndim x number of nodes array.
        nodes
        
        %edges Edges of the reference element.
        %
        % A 2 x number of edges array, of indices to the nodes.
        edges

        %polynomial_base Polynomial base for the element.
        %
        % A ndim x dimension of base array, specifying the exponents of
        % each coordinate and basis function, on each column. For instance,
        % [1; 1] would correspond to xref*yref, while [0;0] would be 1.
        %
        % Could be used for defining Lagrangian shape functions of arbitrary
        % order.
        polynomial_base
    end

    methods (Abstract)
        %get_integration_points Return integration points.
        %
        % [x, w] = get_integration_points(this, order, mesh)
        [x, w] = get_integration_points(this, order, mesh)

        F_msh = spawn_mesh_specific_shape_function(F_base, mesh)
    end
end