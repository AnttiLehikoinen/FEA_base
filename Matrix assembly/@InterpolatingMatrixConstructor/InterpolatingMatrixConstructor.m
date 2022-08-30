classdef InterpolatingMatrixConstructor < MatrixConstructorBase
    properties
        parts = {};
        dof_identities
    end
    
    methods
        function this = add_part(this, p)
            this.parts = [this.parts, {p}];
        end
        
        function this = add_zeros(this, n)
            this.add_part( [toRow(n); zeros(2, numel(n))] );
        end
        
        P = finalize(this, varargin)
    end
end
    