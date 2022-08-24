function fill(this, elements, varargin)


n = size(this.elements, 1);

if isempty(elements)
    elements = 1:this.number_of_elements;
end
Ne = numel(elements);

X = zeros(n, Ne);
Y = zeros(n, Ne);

for k = 1:size(this.elements, 1)
    X(k, :) = this.nodes(1, this.elements(k, elements));
    Y(k, :) = this.nodes(2, this.elements(k, elements));
end
patch(X, Y, varargin{:});

end