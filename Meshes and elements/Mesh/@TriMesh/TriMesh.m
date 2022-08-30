classdef TriMesh < FEMeshBase
    properties
        t2e %triangle-to-edges incidence
        e2t %edge-to-triangle indicence
    end
    properties (Constant)
        reference_element = Triangle1stOrder()
        mapping = TriMapping1stOrder()
    end
    
    %dependent utility stuff
    properties (Dependent)
        number_of_edges
    end

    %getters for dependent properties
    methods
        function n = get.number_of_edges(this)
            n = size(this.edges, 2);
        end
    end
end