classdef (Abstract) MeshBase < handle
    properties
        nodes
        elements
    end
    properties (Abstract, Constant)
        mapping
    end
    properties (Dependent)
        number_of_nodes
        number_of_elements
    end
    methods
        function this = MeshBase(nodes, elements, varargin)
            this.mapping.parent_mesh = this;
            if nargin >= 2
                this.nodes = nodes;
                this.elements = elements;
            end
        end
    end
    methods
        function detF = mapping_determinant(this, varargin)
            detF = this.mapping.mapping_determinant(varargin{:});
        end
        function [F, F0] = evaluate_mapping(this, varargin)
            [F, F0] = this.mapping.evaluate_mapping(varargin{:});
        end
        
        x0 = element_centers(this, elements)
        
        [x_quad, w_quad, Nrows, Ncols, N_test, N_shape] = ...
            get_assembly_parameters(this, fun_test, fun_shape, varargin)
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