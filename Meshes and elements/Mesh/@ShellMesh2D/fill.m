function fill(this, elements, vals, varargin)


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

%parsing values
if numel(vals) == this.number_of_nodes && ...
        this.number_of_nodes ~= this.number_of_elements
    vals2 = zeros(size(this.elements, 1), numel(elements));
    for kf = 1:size(this.elements, 1)
        vals2(kf, :) = vals( this.elements(kf, elements) );
    end
    vals = vals2;
end
    
patch(X, Y, vals, varargin{:});

end