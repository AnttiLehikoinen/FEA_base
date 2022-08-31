classdef FEMatrixConstructor < MatrixConstructorBase
    %FEMatrixConstructor Finite-element matrix constructor.
    %
    % A versatile class for assembling finite-element matrices.
    %
    % The functionality is built for assembling matrices where the entries
    % are
    %
    % S(i,j) = Int_dV dot(f_i, v * f_j) dV, where
    %   * f_i : the i:th test function
    %   * v : a material property function
    %   * f_j : the j:th test function
    %   * dV : a subset of the entire mesh volume to integrate over
    % 
    % In practice, these are specified as
    %   * a test function object of the ShapeFunctionBase class
    %   * a shape function object of the ShapeFunctionBase class
    %   * an array of material properties, (so far) constant for each
    %   element.
    %       * function support is a future feature
    %   * a list of elements to integrate over.
    %   * the mesh in question
    methods
        %assemble_matrix Increment matrix with a given integration.
        %
        % this = assemble_matrix(this, test_function, shape_function, ...
        %   material_property, elements, mesh)
        %
        % See the class help for syntax.
        this = assemble_matrix(this, test_function, shape_function, material_property, ...
            elements, mesh)
        
        %assemble_vector Assemble or increment a vector.
        %
        % this = assemble_vector(this, test_function, material_property, ...
        %        elements, mesh)
        %
        % See the class help for syntax.
        function this = assemble_vector(this, test_function, material_property, ...
                elements, mesh)
            
            this = this.assemble_matrix(test_function, IDfun, material_property, ...
                elements, mesh);
        end 
    end
    
    methods (Static)
        %assemble_simple Simple non-sparse non-vectorized assembly.
        %
        % M = assemble_simple(test_function, shape_function, material_property, ...
        %    elements, mesh, N)
        %
        % See the class help for syntax.
        M = assemble_simple(test_function, shape_function, material_property, ...
            elements, mesh, N)
    end
end