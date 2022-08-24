classdef ProxyMesh < MeshBase & MeshUtil
    properties
        parent_mesh
    end
    properties (Dependent)
        nodes
    end
    methods
        function x = get.nodes(this)
            x = this.parent_mesh.nodes + [0.5; 0.5];
        end
    end
end
