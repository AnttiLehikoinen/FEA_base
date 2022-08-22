classdef TriMapping1stOrder < MappingBase
    properties
        order = 0;
    end
    methods
        [F, F0] = evaluate_mapping(this, elements, local_coordinates)
        
        function detF = mapping_determinant(this, varargin)
            if nargin == 2
                mapping_matrix = varargin{1};
            else
                elements = varargin{1};
                local_coordinates = varargin{2};
                mapping_matrix = this.evaluate_mapping(elements, local_coordinates);
            end
            detF = matrixDeterminant2D(mapping_matrix);
            
        end
        
    end
end
   