classdef (Abstract) MappingArrayBase
    properties
        array
        determinant
    end
    
    methods (Abstract)
        a = ctranspose(this)
        y = mtimes(this, x)
        y =  mldivide(this, x)
        
        apply_mapping_on_vector(this, x, is_trps, is_inverse)
    end
end
    