function [F, F0] = evaluate_mapping(this, elements, ~)

if nargin == 1 || isempty(elements)
    elements = 1:this.parent_mesh.number_of_elements;
end
msh = this.parent_mesh;

Farr = [msh.nodes(:, msh.elements(2,elements)) - msh.nodes(:, msh.elements(1,elements));
    msh.nodes(:, msh.elements(3,elements)) - msh.nodes(:, msh.elements(1,elements))];
F = MappingArray2x2(Farr);


F0 = msh.nodes(:, msh.elements(1,elements));

end