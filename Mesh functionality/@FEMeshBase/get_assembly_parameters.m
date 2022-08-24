function [x_quad, w_quad, Nrows, Ncols, N_test, N_shape] = ...
            get_assembly_parameters(this, fun_test, fun_shape, varargin)
        
[N_test, order_test, Nrows] = fun_test.get_data(this);
[N_shape, order_shape, Ncols] = fun_shape.get_data(this);

%parsing nonlinearity order
if numel(varargin)
    order_nonlin = varargin{1}; %extra integration order due to eg. nonlinearity
    if order_shape == 0
        order_nonlin = 0; %nonlinearity has no effect if shape functions are constants
    end
    if numel(varargin)>1
        if ~isempty(varargin{2})
            order_nonlin = order_nonlin + varargin{2};
        end
    end
else
    order_nonlin = 0;
end

order_curvature = this.mapping.order;
    

[x_quad, w_quad] = this.get_integration_points(order_test + order_shape + order_nonlin + order_curvature);