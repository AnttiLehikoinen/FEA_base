classdef MappingArray2x2 < MappingArrayBase
    methods
        y = apply_mapping_on_vector(this, x, is_trps, is_inverse)
    end
    
    methods
        function this = MappingArray2x2(F, detF)
            if nargin == 0
                return;
            end
            if nargin >= 1
                this.array = F;
            end
            if nargin >=2
                this.determinant = detF;
            else
                this.determinant = matrixDeterminant2D(this.array);
            end
        end
            
        
        function a = ctranspose(this)
            a = TransposedArray(this);
        end
        
        function y = mtimes(this, x)
            y = this.apply_mapping_on_vector(x, false, false);
        end
        
        function y =  mldivide(this, x)
            y = this.apply_mapping_on_vector(x, false, true);
        end
    end
end