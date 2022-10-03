classdef (Abstract) FEMeshBase < AbstractMeshBase
    %FEMeshBase Base class of finite-element-compatible meshes.
    %
    % This (Abstract) class extends the AbstractMeshBase class, defining
    % the functionality required for finite element analysis. Indeed, in
    % addition to the basic mesh data, this class defines a reference
    % element particular to the mesh, and a mapping from the reference
    % element to the given global element.
    %
    % Finally, the class defines functions for getting the integration
    % points (quadrature) for the reference element, and assembly data for
    % matrix assembly.
    properties (Abstract)
        nodes
        elements
        edges
    end
    properties (Abstract, Constant)
        %reference_element Reference element for the mesh.
        %
        % Of the ReferenceElementBase class.
        reference_element
        
        %mapping Mapping from the reference element to global elements.
        % 
        % Of the MappingBase class.
        mapping
    end

    properties (Dependent)
        number_of_edges
    end

    methods
        function this = FEMeshBase(nodes, elements, varargin)
            this.mapping.parent_mesh = this;
            if nargin >= 2
                this.nodes = nodes;
                this.elements = elements;
            end
        end
    end
    methods

        function detF = mapping_determinant(this, varargin)
            error('Should not be called')
            detF = this.mapping.mapping_determinant(varargin{:});
        end
        
        function [F, F0] = evaluate_mapping(this, varargin)
            %evaluate_mapping Evaluate mapping.
            %
            % See MappingBase.evaluate_mapping for syntax.
            [F, F0] = this.mapping.evaluate_mapping(varargin{:});
        end

        function [x, w] = get_integration_points(this, order)
            %get_integration_points Get quadrature points.
            %
            % [x, w] = get_integration_points(this, order) returns the
            % integration points x (ndim x number of points) and the
            % corresponding weights w (1 x number of points) to integrate a
            % polynomial of order in the reference element.
            %
            % By default, calls this.reference_element.get_integration_points
            [x, w] = this.reference_element.get_integration_points(order, this);
        end

        plot_edges(this, inds, varargin)
        
        %get_assembly_parameters Matrix assemble paramaters.
        %
        % [x_quad, w_quad, Nrows, Ncols, N_test, N_shape] = ...
        %    get_assembly_parameters(this, test_function, shape_function)
        %
        % Returns all the required assembly parameters:
        %   * x_quad : integration points
        %   * w_quad : integration weights
        %   * Nrows : number of rows to allocate
        %   * Ncols : number of columns to allocate
        %   * N_test : number of test functions per reference element
        %   * N_shape : number of shape functions per reference element
        %
        % As an input, the method takes the desired test and shape function
        % objects, of the ShapeFunctionBase class.
        %
        % The number of integration points is defined to integrate the
        % product of the test and shape functions over the reference
        % element.
        %
        % get_assembly_parameters(this, fun_test, fun_shape, n_fun) to
        % integrate a triple product of the test function, shape function,
        % and function of order n_fun over the reference element.
        [x_quad, w_quad, Nrows, Ncols, N_test, N_shape] = ...
            get_assembly_parameters(this, fun_test, fun_shape, varargin)

        function n = get.number_of_edges(this)
            n = size(this.edges, 2);
        end

        function F_msh = spawn_mesh_specific_shape_function(this, F)
            F_msh = this.reference_element.spawn_mesh_specific_shape_function(F, this);
        end
    end

end