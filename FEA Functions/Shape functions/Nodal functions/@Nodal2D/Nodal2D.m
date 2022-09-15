classdef Nodal2D < ShapeFunctionBase
    % Nodal2D Lagrange (nodal) shape function in 2D.
    %
    %  Class for representing and evaluating shape functions and their partial derivatives.
    %  Objects of the class can be instantiated with
    %
    %   * N = Nodal2D( Operators.I ) or Nodal2D() for evaluating the function
    %   itself.
    %
    %   * N = Nodal2D( Operators.grad ) for evaluating function gradients.
    %
    %   * N = Nodal2D( Operators.curl ) for evaluating curls.
    %
    %  The actual evaluation is performed with N.eval(args) by
    %  specifying
    %
    %    * the mesh used
    %
    %    * elements of the mesh to evaluate on
    %
    %    * LOCAL coordinates to evaluate on. The local coordinates must fall
    %    within the so-called reference element (unit-triangle ((0,0),
    %    (1,0), (0,1)) for triangular elements) associated with the mesh
    %    element types. The actual evaluation then takes place on the GLOBAL
    %    coordinates, i.e. a point within each of the listed _elements_
    %    corresponding to the given local coordinate. For instance, the
    %    local point [0.25;0.25] is mapped (more or less) to the global element
    %    center.
    %
    %    * Index of shape function. As nodal shape functions are each
    %    associated with a mesh node, there are 3 shape functions that are
    %    non-zero over a first-order element. Example: for the element _e_,
    %    the shape function _k_ is associated the node mesh.t(k, e).
    
    methods
        function this = Nodal2D(varargin)
            %Nodal2D Constructor
            %
            % this = Nodal()
            %
            %   For evaluating raw nodal shape function N.
            %
            % this = Nodal( Operators.grad )
            %
            % this = Nodal( Operators.curl )
            %
            %   For evaluating grad N or curl N, respectively.
            
            if numel(varargin)
                this.operator = varargin{1};
            end
        end
        
        N = eval(this, k, X, msh, varargin)
        
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
            %getData Data for matrix assembly.
            %
            %
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
        
        function inds = get_dof_indices(~, k, msh, varargin)
            if ~numel(varargin) || ~any(varargin{1}) || (varargin{1}(1)<0)
                inds = msh.elements(k,:);
            else
                inds = msh.elements(k, varargin{1});
            end
        end
        
    end
end
