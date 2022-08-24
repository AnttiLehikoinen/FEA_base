classdef MeshBase < handle
    properties
        elements
    end
    properties (Abstract)
        nodes
    end
end