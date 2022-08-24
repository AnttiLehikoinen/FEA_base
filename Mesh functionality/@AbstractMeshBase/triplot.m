function triplot(this, elements, varargin)

if isempty(elements)
    elements = 1:this.number_of_elements;
end

triplot(this.elements(:, elements)', ...
    this.nodes(1, :), this.nodes(2,:), ...
    varargin{:});

end