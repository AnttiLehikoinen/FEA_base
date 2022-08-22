function x0 = element_centers(this, elements)

if isempty(elements)
    elements = zeros(1, this.number_of_elements);
end

x0 = zeros(size(this.nodes,1), numel(elements));
for k = 1:size(this.elements,1)
    x0 = x0 + this.nodes(:, this.elements(k, elements));
end

x0 = x0 / size(this.elements, 1);

end