classdef TriMesh < FEMeshBase
    %TriMesh Basic first-order triangular FE mesh.
    properties
        nodes
        elements
        edges
        edges_to_elements %triangle-to-edges incidence
        elements_to_edges %edge-to-triangle indicence
    end
    properties (Constant)
        reference_element = Triangle1stOrder()
        mapping = TriMapping1stOrder()
    end

    %getters for dependent properties
    methods
        function this = TriMesh(varargin)
            this = this@FEMeshBase(varargin{:});
            if numel(varargin)
                this.parse_incidence();
            end
        end

        parse_incidence(this)
    end
end