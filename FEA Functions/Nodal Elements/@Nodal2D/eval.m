function N = eval(this, k, X, msh, varargin)
%eval Global evaluation.
%
% vals = eval(this, k, x_local, mesh, elements)
%
%   Evaluates (this.op x N_k), where N_k is the k:th node of
%   the elementType of the given mesh. The expression is
%   evaluated at the _global_ coordinates
%   corresponding to the given _local_ coordinates, on the
%   specified _elements_ of the given _mesh_.
%
%   Input arguments:
%
%       * k : index of shape function to evaluate. 1...3 for
%       first-order triangular elements.
%
%       * x_local : local coordinates to evaluate at.
%
%       * mesh : the mesh to evaluate on.
%
%       * elements : indices of elements (mesh.t(:, elements))
%       to evaluate on.
%
%
% vals = eval(this, k, x_local, mapping, mapping_determinant)
%
%   The same as above, but specify the local-to-global mapping
%   and its determinant instead of the element indices. Mainly
%   used for speed purposes.
%
%   Input arguments:
%
%       * mapping : see SimpleMesh.getMappingMatrix
%
%       * mapping_determinant : see MatrixDeterminant

Nref = this.eval_ref(k, X, msh);
if this.operator == Operators.I
    % identity needed? --> return
    N = Nref; return;
end

%getting mapping
if size(varargin{1}, 1) == 4
    F = varargin{1};
    detF = varargin{2};
else
    F = msh.evaluate_mapping(varargin{1}, X);
    detF = matrixDeterminant(F);
end

%evaluating global gradient / curl
N = matrixTimesVector(F, Nref, true, true, detF); %gradient
if this.operator == Operators.grad
    return;
elseif this.operator == Operators.curl
    N = [0 1;-1 0] * N;
    return;
else
    error('Invalid operator');
end
end