function parse_incidence(this)

raw_edges = zeros(2, 0);
edef = this.reference_element.edges;
for k = 1:size(edef, 2)
    n_start = this.elements(edef(1, k), :);
    n_end = this.elements(edef(2, k), :);

    raw_edges = [raw_edges, [n_start; n_end]];
end

this.edges = unique(sort(raw_edges,1)', 'rows')';

%getting element-to-edge indicence
[~, t2e_raw] = ismember(sort(raw_edges,1)', this.edges', 'rows');
this.elements_to_edges = reshape(t2e_raw, this.number_of_elements, [])';

%parsing directions
for k = 1:size(this.elements_to_edges, 1)*0
    first_edge_node = this.edges(1, this.elements_to_edges(k, :));
    first_element_node = this.elements(edef(1, k), :);

    %flipping where needed
    inds = first_edge_node ~= first_element_node;
    this.elements_to_edges(k, inds) = -this.elements_to_edges(inds);
end

%getting edge-to-element incidence
this.edges_to_elements = zeros(2, this.number_of_edges);
for k = 1:this.number_of_elements
    for k2 = 1:size(this.elements,1)
        edge_ind = abs(this.elements_to_edges(k2, k));
        if this.edges_to_elements(1,edge_ind) == 0
            this.edges_to_elements(1, edge_ind) = k;
        else
            this.edges_to_elements(2, edge_ind) = k;
        end
    end
end     
        

end