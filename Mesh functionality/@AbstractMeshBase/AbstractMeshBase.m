classdef (Abstract) AbstractMeshBase < handle
    properties (Abstract)
        nodes
        elements
    end
    properties (Dependent)
        number_of_nodes
        number_of_elements
    end

    methods
        x0 = element_centers(this, elements)
        fill(this, varargin)
        triplot(this, varargin)
    end
    
    methods
        function n = get.number_of_elements(this)
            n = size(this.elements, 2);
        end
        function n = get.number_of_nodes(this)
            n = size(this.nodes, 2);
        end
    end
end