function fill(this, elements, vals, varargin)


n = 2; %size(this.elements, 1);

if isempty(elements)
    elements = 1:this.number_of_elements;
end
Ne = numel(elements);

X = zeros(n, Ne);
Y = zeros(n, Ne);

ne = 2;
for k = 1:ne
    X(k, :) = this.nodes(1, this.elements(k, elements));
    Y(k, :) = this.nodes(2, this.elements(k, elements));
end

%parsing values
if numel(vals) == this.number_of_elements
    vals2 = zeros(ne, Ne);
    for k = 1:ne
        vals2(k,:) = vals(elements);
    end
    vals = vals2;
else
    error('Unhandled case');
end
    
patch(X, Y, vals, 'edgecolor', 'interp', varargin{:});

end