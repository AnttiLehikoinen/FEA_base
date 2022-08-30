classdef TransposedArray < MappingArrayBase
    properties
        parent
    end
    methods
        function this = TransposedArray(parent_array)
            this.parent = parent_array;
        end
        
        function a = ctranspose(this)
            a = this.parent;
        end
        
        function y = mtimes(this, x)
            y = this.parent.apply_mapping_on_vector(x, true, false);
        end
        
        function y =  mldivide(this, x)
            y = this.parent.apply_mapping_on_vector(x, true, true);
        end
        
        function y = apply_mapping_on_vector(this, x, is_trps, is_inverse)
            y = this.parent.apply_mapping_on_vector(x, ~is_trps, is_inverse);
        end
            
    end
end