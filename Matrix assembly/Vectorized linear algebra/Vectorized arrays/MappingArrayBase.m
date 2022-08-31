classdef (Abstract) MappingArrayBase
    %MappingArrayBase Base class for vectorized mappings.
    %
    % In finite element analysis, it is required to perform a large number
    % of matrix-vector operations of the following types:
    %   * M*v
    %   * M'*v
    %   * M\v
    %   * M'\v
    % for a larger number of different matrices M, of shape 2x2 or 3x3.
    %
    % The MappingArrayBase defines a way to do just that, without the need
    % for for-loops, by simple substituting the mapping object in place of
    % 'M' in the above examples.
    properties
        %array Array of the mapping matrices.
        % Each column of array contains the mapping for one element /
        % quadrature / similar, vectorized in column-major format
        array
        
        %determinant Determinant of mapping.
        % Determinant(-like) of the mapping. Of size 1 x size(this.array,2)
        determinant
    end
    
    methods (Abstract)
        a = ctranspose(this)
        y = mtimes(this, x)
        y =  mldivide(this, x)
        
        %apply_mapping_on_vector Apply the mapping without Matlab operators
        %
        % y = apply_mapping_on_vector(this, x, is_trps, is_inverse) returns
        % the vectors y, obtained after applying the desired mapping on a
        % vector / vectors.
        %
        % Input arguments:
        %   * x : the vector to apply on
        %   * is_trps : transpose the mapping?
        %   * is_inverse : apply inverse?
        apply_mapping_on_vector(this, x, is_trps, is_inverse)
    end
end
    