classdef (Abstract) FEMeshBase < AbstractMeshBase
    properties
        nodes
        elements
    end
    properties (Abstract, Constant)
        reference_element
        mapping
    end

    methods
        function this = FEMeshBase(nodes, elements, varargin)
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

        function [x, w] = get_integration_points(this, order)
            [x, w] = this.reference_element.get_integration_points(order, this);
        end
        
        [x_quad, w_quad, Nrows, Ncols, N_test, N_shape] = ...
            get_assembly_parameters(this, fun_test, fun_shape, varargin)
    end

end