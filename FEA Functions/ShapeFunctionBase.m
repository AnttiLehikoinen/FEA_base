classdef (Abstract) ShapeFunctionBase < handle
    properties
        operator = Operators.I
    end
    
    methods
        function bl = equals(this, other)
            bl = false;
            if strcmpi(class(this), class(other))
                bl = this.operator == other.operator;
            end
        end
    end
            
    
    methods (Abstract)
        N = eval(this, k, X, msh, varargin)
        [number_of_functions, function_order, ndof] = get_data(this, msh) 
        inds = get_dof_indices(this, k, msh, varargin)
    end
end
    