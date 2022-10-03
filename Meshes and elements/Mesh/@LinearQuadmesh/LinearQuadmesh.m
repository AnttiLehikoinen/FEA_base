classdef LinearQuadmesh < FEMeshBase
    properties
        nodes
        elements

        edges
    end

    properties (Constant)
        reference_element = Quad1
        mapping = LinearQuadMapping
    end

    methods
        function triplot(this, els, varargin)
            if isempty(els)
                els = 1:this.number_of_elements;
            end
            for k = 1:4
                kn = mod(k, 4) + 1;

                X = [this.nodes(1, this.elements(k, els)); this.nodes(1, this.elements(kn, els))];
                Y = [this.nodes(2, this.elements(k, els)); this.nodes(2, this.elements(kn, els))];
                plot(X, Y, varargin{:});
            end
        end

    end
end