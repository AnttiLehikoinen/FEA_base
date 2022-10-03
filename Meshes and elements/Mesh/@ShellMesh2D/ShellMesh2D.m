classdef ShellMesh2D < FEMeshBase
    properties
        nodes
        elements

        edges
    end
    
    properties (Dependent)
        thickness
    end
    
    properties (Constant)
        reference_element = Quad1
        mapping = ThinShellMapping2D
    end
    
    methods
        function triplot(this, els, varargin)
        end
        
        function v = get.thickness(this)
            v = this.mapping.thickness;
        end
        function set.thickness(this, v)
            this.mapping.thickness = v;
        end

        fill(this, elements, varargin)
    end
end