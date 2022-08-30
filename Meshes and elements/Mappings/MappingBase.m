classdef (Abstract) MappingBase < handle
    properties
        parent_mesh
    end
    
    properties (Abstract)
        order
    end
    
    methods (Abstract)
        [F, F0] = evaluate_mapping(this, elements, local_coordinates)
        
        %mapping_determinant Mapping Jacobian determinan
        % detF = mapping_determinant(this, elements, local_coordinates)
        % detF = mapping_determinant(this, mapping_matrix)
        detF = mapping_determinant(this, varargin)
        
    end
end