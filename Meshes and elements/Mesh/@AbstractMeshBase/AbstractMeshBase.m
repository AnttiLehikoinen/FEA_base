classdef (Abstract) AbstractMeshBase < handle
    %AbstractMeshBase Abstract base class for mesh data.
    %
    % The AbstractMeshBase class defines the data storage requirements
    % (nodal coordinates and element definitions) along with some default
    % visualization functionality for all meshes.
    
    properties (Abstract)
        %nodes Nodal coordinates
        %
        % A number_of_dimensions x number_of_nodes array
        nodes
        
        %elements Element definitions.
        %
        % An (integer) array of sizes nodes_per_element x
        % number_of_elements, containing indices to the nodes (in [1,
        % number_of_nodes]) belonging to each element.
        elements
    end
    properties (Dependent)
        number_of_nodes %number of nodes
        number_of_elements %number of elements
    end

    methods
        %element_centers Return element center of mass.
        %
        % x0 = element_centers(this, elements) returns the center of mass
        % of each element, as a ndim x numel(elements) array. Give an empty
        % array for elements to get all centers.
        x0 = element_centers(this, elements)
        
        %fill Plot elements filled with color.
        %
        % fill(this, elements, varargin) where elements is the array of
        % elements (indices) to fill, with the rest of the arguments passed
        % on to patch. Give an empty array to visualize all.
        fill(this, elements, varargin)
        
        %trisurf Surface plot of values.
        %
        %trisurf(this, elements, vals, varargin) visualizes the surface
        %defined by the nodal values vals (of size this.number_of_nodes),
        %visualized on the specified elements only. Give an empty array to
        %visualize on all.
        trisurf(this, elements, vals, varargin)
        
        %triplot Plot mesh.
        %
        % triplot(this, elements, varargin) plots the specified elements.
        % Give an empty array to visualize all.
        triplot(this, elements, varargin)
        
        %plot_nodes Plot given nodes.
        %
        % plot_nodes(this, nodes, varargin) plots the specified nodes.
        plot_nodes(this, ns, varargin)
    end
    
    methods
        function n = get.number_of_elements(this)
            n = size(this.elements, 2);
        end
        function n = get.number_of_nodes(this)
            n = size(this.nodes, 2);
        end
    end
end