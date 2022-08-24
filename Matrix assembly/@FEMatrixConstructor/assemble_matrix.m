function this = assemble_matrix(this, test_function, shape_function, material_property, ...
            elements, mesh)
        
%temp
v = material_property;
fun_test = test_function;
fun_shape = shape_function;
msh = mesh;
        
%no elements listed --> going over all
if ~any(elements)
    elements = 1:mesh.number_of_elements;
end
Ne = numel(elements);


if size(v, 2) == 1
    v = bsxfun(@times, v(:,1), ones(1, numel(elements)));
elseif size(v,2) ~= numel(elements)
    v = v(:, elements);
end

%checking symmetricity
if fun_test.equals(fun_shape) && size(v,1)<=2
    symmetric = true;
else
    symmetric = false;
end

[x_quad, w_quad, Nrows, Ncols, N_test, N_shape] = msh.get_assembly_parameters(fun_test, fun_shape);
N_quad = numel(w_quad);
this.number_of_rows = Nrows; 
this.number_of_columns = Ncols;


%mapping and mapping determinant
if msh.mapping.order > 0
    detF = zeros(N_quad, Ne);
    F = cell(N_quad, 1);
    for k_quad = 1:N_quad
        F{k_quad} = msh.evaluate_mapping(elements, x_quad(:,k_quad));
        detF(k_quad,:) = msh.mapping_determinant(F{k_quad});
    end
    detFun = @(kq)( detF(kq,:) );
    Ffun = @(kq)( F{kq} );
else
    F = msh.evaluate_mapping(elements);
    detF = msh.mapping_determinant(F);
    detFun = @(kq)( detF );
    Ffun = @(kq)( F );
end

%pre-computing shape functions
Fvals_test = cell(N_quad, N_test);
for k_quad = 1:N_quad
    for k_test = 1:N_test
        Fvals_test{k_quad, k_test} = fun_test.eval(k_test, x_quad(:,k_quad), msh, Ffun(k_quad), detFun(k_quad), elements);
    end
end
if symmetric
    Fvals_shape = {};
else
    Fvals_shape = cell(N_quad, N_shape);
    for k_quad = 1:N_quad
        for k_shape = 1:N_shape
            Fvals_shape{k_quad,k_shape} = ...
                fun_shape.eval(k_shape, x_quad(:,k_quad), msh, Ffun(k_quad), detFun(k_quad), elements);
        end
    end
end


%adding indices
for k_test = 1:N_test
    if symmetric
        for k_shape = k_test:N_shape
            this.add_coordinates( fun_test.get_dof_indices(k_test, msh, elements), ...
                fun_shape.get_dof_indices(k_shape, msh, elements) );
            if k_shape ~= k_test
                this.add_coordinates( fun_shape.get_dof_indices(k_shape, msh, elements), ...
                    fun_test.get_dof_indices(k_test, msh, elements) );
            end
        end
    else
        for k_shape = 1:N_shape
            this.add_coordinates( fun_test.get_dof_indices(k_test, msh, elements), ...
                fun_shape.get_dof_indices(k_shape, msh, elements) );
        end
    end
end


%integrating
rbias = numel(this.values);
for k_quad = 1:N_quad
    ri = 1;
    for k_test = 1:N_test
        if symmetric
            for k_shape = k_test:N_shape
                %Etemp = w_quad(k_quad)*dotProduct(Fvals_test{k_quad, k_test}, Fvals_test{k_quad, k_shape}).* v .* abs(detFun(k_quad));
                Etemp = w_quad(k_quad)*FEdotProduct(Fvals_test{k_quad, k_test}, v, Fvals_test{k_quad, k_shape}) .* abs(detFun(k_quad));
                this.add_values(Etemp, ri + rbias); ri = ri + 1;
                if k_shape ~= k_test
                    this.add_values(Etemp, ri + rbias); ri = ri + 1;
                end
            end
        else
            for k_shape = 1:N_shape
                %Etemp = w_quad(k_quad)*dotProduct(Fvals_test{k_quad, k_test}, Fvals_shape{k_quad, k_shape}).* v .* abs(detFun(k_quad));
                Etemp = w_quad(k_quad)*FEdotProduct(Fvals_test{k_quad, k_test}, v, Fvals_shape{k_quad, k_shape}) .* abs(detFun(k_quad));
                this.add_values(Etemp, ri + rbias); ri = ri + 1;
                %error('Should not go here.')
            end
        end
    end
end

end