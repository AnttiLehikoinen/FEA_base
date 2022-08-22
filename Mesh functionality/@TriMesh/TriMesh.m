classdef TriMesh < MeshBase
    properties
        t2e %triangle-to-edges incidence
        e2t %edge-to-triangle indicence
    end
    properties (Constant)
        mapping = TriMapping1stOrder();
    end
    
    %dependent utility stuff
    properties (Dependent)
        number_of_edges
    end
    
    methods
        function [x, w] = get_integration_points(this, order)
            [x, w] = get_2DtriangleIntegrationPoints(order);
        end
    end
    
    %getters for dependent properties
    methods
        function n = get.number_of_edges(this)
            n = size(this.edges, 2);
        end
    end
end