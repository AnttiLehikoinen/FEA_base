classdef MatrixConstructorBase < handle
    properties
        coordinates = {}
        values = {}
        number_of_rows = -1
        number_of_columns = -1
    end
    
    methods
        function add_triplets(this, I, J, E)
            this.add_coordinates(I, J);
            this.add_values(E);
        end
        
        function add_coordinates(this, I, J)
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