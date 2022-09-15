classdef ThinShellMapping2D < MappingBase
    properties
        thickness = 0
        order = 0
    end
    
    methods
        function [F, F0] = evaluate_mapping(this, elements, local_coordinates)
            if nargin == 1 || isempty(elements)
                elements = 1:this.parent_mesh.number_of_elements;
            end
            msh = this.parent_mesh;
            
            
            tangent = msh.nodes(:, msh.elements(2,elements)) - ...
                msh.nodes(:, msh.elements(1,elements));
            
            F0 = msh.nodes(:, msh.elements(1,elements));
            
            unit_normal = [0 -1;1 0] * (tangent ./ sqrt(sum(tangent.^2,1)));
            
            Farr = [tangent; this.thickness * unit_normal];
            F = MappingArray2x2(Farr);
        end
    end
end
            
            