function M = assemble_simple(test_function, shape_function, material_property, ...
            elements, msh, N)
        
        
M = zeros(N);

if isempty(elements)
    elements = 1:msh.number_of_elements;
end

[xq, wq] = msh.get_integration_points(0); %hard-coded one-point quadrature

for k_element = 1:numel(elements)
    element = elements(k_element);
    
    mapping = msh.evaluate_mapping(element);
    mapping_determinant = mapping.determinant;
    
    for k_test = 1:3
        F_test = test_function.eval(k_test, xq, msh, element);
        row_ind = test_function.get_dof_indices(k_test, msh, element);
        
        for k_shape = 1:3
            F_shape = shape_function.eval(k_shape, xq, msh, element);
            col_ind = shape_function.get_dof_indices(k_shape, msh, element);
            
            %incrementing matrix
            M(row_ind, col_ind) = M(row_ind, col_ind) + ...
                wq * dot(F_test, F_shape) * material_property(element) * ...
                abs(mapping_determinant);
        end
    end
end

end
    