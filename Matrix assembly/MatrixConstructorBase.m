classdef MatrixConstructorBase < handle
    %MatrixConstructorBase Constructor for sparse matrices.
    %
    % The MatrixConstructorBase allows building sparse matrices in an
    % incremental fashion, without a huge overhead.
    %
    % For best performance, the assembly should still be performed in
    % vectorized format, i.e. adding a larger set of (row_index, column_index,
    % value_index) triplets for a large number of elements at once.
    %
    % Also supports higher-order quadratures, i.e. incrementing an
    % already-added triplet values.
    properties
        coordinates = {}
        values = {}
        number_of_rows = -1
        number_of_columns = -1
    end
    
    methods
        function add_triplets(this, I, J, E)
            %add_triplets Add triplets to the matrix.
            %
            % add_triplets(this, I, J, E) is equivalent to calling
            % S(i, j) = e,
            % for (i,j,e) = (I(k), J(k), E(k)) with k = 1...numel(I)
            this.add_coordinates(I, J);
            this.add_values(E);
        end
        
        function add_coordinates(this, I, J)
            %add_coordinates Add coordinate-pairs.
            %
            % add_coordinates(this, I, J) adds a (hopefully large) set of
            % coordinate pairs.
            assert(size(I, 1)==1)
            assert(size(J, 1)==1)

            %expanding if needed
            if size(I, 2) == 1
                I = repmat(I, 1, numel(J));
            end
            if size(J, 2) == 1
                J = repmat(J, 1, numel(I));
            end
            
            this.coordinates = [this.coordinates, {[I;J]}];
        end
        
        function add_values(this, values, triplet_set_index)
            %add_values Add or increment values.
            %
            % add_values(this, values) adds or increments the values 
            % corresponding to the last-added coordinate-pair set.
            % 
            % add_values(this, values, triplet_set_index) increments values
            % of the coordinate set specified.
            assert(size(values, 1) == 1);
            if nargin == 2 || ...
                    triplet_set_index == numel(this.values) + 1
                %normal addition
                this.values = [this.values, {values}];
            elseif nargin == 3 && triplet_set_index <= numel(this.values)
                this.values{triplet_set_index} = this.values{triplet_set_index} + ...
                    values;
            else
                error('Invalid triplet_set_index.');
            end 
        end
        
        function S = finalize(this, varargin)
            %finalize Return final sparse matrix.
            %
            % S = finalize(this) returns a matrix of size
            % this.number_of_rows x this.number_of_columns. These values
            % must have been set at some point prior to calling this.
            %
            % S = finalize(this, args) to instead pass the desired
            % arguments (typically Nrows, Ncols) to Matlab's sparse.
            coords = [this.coordinates{:}];
            vals = [this.values{:}];
            
            if size(coords, 2) ~= size(vals, 2)
                error('The numbers of coordinate-pairs and values differ.');
            end
            if ~numel(varargin)
                assert(this.number_of_rows > 0, 'Number of rows not set');
                assert(this.number_of_columns > 0, 'Number of columns not set');
                S = sparse(coords(1,:), coords(2,:), ...
                    vals, this.number_of_rows, this.number_of_columns);
                return
            end
            S  = sparse(coords(1,:), coords(2,:), ...
                    vals, varargin{:});
        end
    end
end