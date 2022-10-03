classdef Nodal2DTri < Nodal2D
    methods
        function Nref = eval_ref(this, k, x, msh)
            % evaluates the reference shape function (either identity or
            % gradient)
            %
            % Nref = eval(ref, this, k, x_local, mesh)
            
            if isa(msh.mapping, 'TriMapping1stOrder')
                if this.operator == Operators.I
                    coeffs = {[1 -1 -1]; [0 1 0]; [0 0 1]};
                    Nref = coeffs{k} * [ones(1, size(x,2)); x];
                    return
                else
                    grads = {[-1;-1]; [1;0]; [0; 1]};
                    Nref = grads{k};
                end
            else
                error('Shape function not implemented.');
            end
        end

        function [Nf, order, Nvars] = get_data(this, msh)
            if isa(msh.mapping, 'TriMapping1stOrder')
                Nf = 3;
                if this.operator == Operators.I
                    order = 1;
                else
                    order = 0;
                end
                Nvars = msh.number_of_nodes;
            else
                error('Invalid mapping')
            end
            
        end
    end
end