classdef (Abstract) MappingBase < handle
    %MappingBase Base class for mappings.
    %
    % A mapping defines a mapping from the reference element of
    % this.parent_mesh, to a given global element of the parent mesh.
    properties
        %parent_mesh Parent mesh.
        parent_mesh
    end
    
    properties (Abstract)
        %order Order of the mapping.
        order
    end
    
    methods (Abstract)
        %evaluate_mapping Evaluate the mapping.
        %
        % [F, F0] = evaluate_mapping(this, elements, local_coordinates)
        % evaluates the mapping for the list of elements given, at the
        % given local coordinates on the reference element.
        %
        % Returns a vectorized mapping F of the MappingArrayBase class.
        [F, F0] = evaluate_mapping(this, elements, local_coordinates)      
    end
end