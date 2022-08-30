classdef (Abstract) ShapeFunctionBase < handle
    %ShapeFunctionBase Base class for shape functions.
    %
    % 
    properties
        %operator Operator associated with the function object.
        %
        % Defaults to Operators.I = identity operator
        operator = Operators.I
    end
    
    methods
        function bl = equals(this, other)
            %equals Are two shape functions the same
            %
            % bl = equals(this, other) returns true if this and other are
            % both of the same class and have the same operator, false
            % otherwise.
            bl = false;
            if strcmpi(class(this), class(other))
                bl = this.operator == other.operator;
            end
        end
    end
            
    
    methods (Abstract)
        %eval Evaluate the shape function.
        %
        % y = eval(this, k, X, msh, elements)
        %   Returns the values of the k:th shape function associated with
        %   msh.reference-element, evaluated at the point X in the local
        %   coordinate system (associated with the same reference element),
        %   evaluated in the mesh elements specified in the 2xN array
        %   elements.
        %
        %   Input arguments:
        %       * k : index of the shape function
        %       * X : local coordinates, ndim x N array, where normally N =
        %       1
        %       * msh : an FEMeshBase object to evaluate on
        %       * elements : array of indices to elements to evaluate on
        %   
        % y = eval(this, k, X, msh, mapping) instead evaluates with a given
        % MappingArrayBase object, for somewhat increased speed.
        N = eval(this, k, X, msh, varargin)
        
        %get_data Return assembly data.
        %
        % [number_of_functions, function_order, ndof] = get_data(this, msh)
        % returns the following data:
        %   * number_of_functions : number of shape functions per reference
        %   element
        %   * function_order : order of this, >= 0
        %   * ndof : number of total degrees of freedom. Equal to the
        %   number of nodes for typical 1st-order meshes.
        [number_of_functions, function_order, ndof] = get_data(this, msh)
        
        %get_dof_indices Indices to the degrees of freedom.
        %
        % inds = get_dof_indices(this, k, msh)
        %   returns the indices to the degrees of freedom. Inputs:
        %       * k : number of the shape function for the reference
        %       element
        %       * msh : mesh used
        %
        % inds = get_dof_indices(this, k, msh, elements) operates on the
        % specified elements only.
        inds = get_dof_indices(this, k, msh, varargin)
    end
end
    