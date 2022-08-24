classdef (Abstract) MeshUtil < MeshBase
    methods
        function triplot(this)
            triplot(this.elements', this.nodes(1,:), this.nodes(2,:));
        end
    end
end
