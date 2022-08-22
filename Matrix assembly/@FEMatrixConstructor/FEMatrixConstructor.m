classdef FEMatrixConstructor < MatrixConstructorBase
    methods
        this = assemble_matrix(this, test_function, shape_function, material_property, ...
            elements, mesh)
        
        function this = assemble_vector(this, test_function, material_property, ...
                elements, mesh)
            
            this = this.assemble_matrix(test_function, IDfun, material_property, ...
                elements, mesh);
        end
        
    end
end