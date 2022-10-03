classdef Nodal2DQuad < Nodal2D
    methods
        function Nref = eval_ref(this, k, X, msh)
            % evaluates the reference shape function (either identity or
            % gradient)
            %
            % Nref = eval(ref, this, k, x_local, mesh)
            
            if isa(msh.reference_element, 'Quad1')
                x = X(1,:);
                y = X(2,:);
                if this.operator == Operators.I
                    if k == 1
                        Nref = 1/4*(1 - x).*(1 - y);
                    elseif k == 2
                        Nref = 1/4*(1 + x).*(1 - y);
                    elseif k == 3
                        Nref = 1/4*(1 + x).*(1 + y);
                    elseif k == 4
                        Nref = 1/4*(1 - x).*(1 + y);
                    end
                else
                    if k == 1
                        Nref = 1/4*[-(1-y); -(1-x)];
                    elseif k == 2
                        Nref = 1/4*[(1-y); -(1+x)];
                    elseif k == 3
                        Nref = 1/4*[(1+y); (1+x)];
                    elseif k == 4
                        Nref = 1/4*[-(1+y); (1-x)];
                    end
                end
            else
                error('Shape function not implemented.');
            end
        end
        
        function [Nf, order, Nvars] = get_data(this, msh)
            %getData Data for matrix assembly.
            %
            %
            if isa(msh.reference_element, 'Quad1')
                Nf = 4;
                if this.operator == Operators.I
                    order = 2;
                else
                    order = 1;
                end
                Nvars = msh.number_of_nodes;
            else
                error('Invalid mapping')
            end
        end
    end
end