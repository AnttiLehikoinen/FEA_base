classdef ShellMesh2D < FEMeshBase
    properties
        parent_mesh
        elements
        edges
    end
    
    properties (Dependent)
        thickness
        nodes
    end
    
    properties (Hidden)
        given_nodes
    end
    
    properties (Constant)
        reference_element = Quad1
        mapping = ThinShellMapping2D
    end
    
    methods
        function triplot(this, els, varargin)
        end

        fill(this, elements, varargin)
    end
    
    methods
        function v = get.thickness(this)
            v = this.mapping.thickness;
        end
        function set.thickness(this, v)
            this.mapping.thickness = v;
        end
        function x = get.nodes(this)
            if isempty(this.parent_mesh)
                x = this.given_nodes;
            else
                x = this.parent_mesh.nodes;
            end
        end
        function set.nodes(this, x)
            if isempty(this.parent_mesh)
                this.given_nodes = x;
            else
                error('Cannot set nodes when this.parent_mesh has been defined.');
            end
        end
    end
end