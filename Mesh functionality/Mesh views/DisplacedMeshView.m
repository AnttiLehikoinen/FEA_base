classdef DisplacedMeshView < AbstractMeshBase
    properties
        parent_mesh

        displacement
    end
    properties (Dependent)
        nodes
        elements
    end

    methods
        function this = DisplacedMeshView(parent)
            this.parent_mesh = parent;
        end

        function x = get.nodes(this)
            x = this.parent_mesh.nodes;
            Np = size(x, 2);
            dx = [this.displacement(1:Np)';
                this.displacement(Np + (1:Np))'];
            x = x + dx;
        end

        function s = get.elements(this)
            s = this.parent_mesh.elements;
        end
    end
end