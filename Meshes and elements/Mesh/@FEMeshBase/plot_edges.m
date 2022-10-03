function plot_edges(this, inds, varargin)

if isempty(inds)
    inds = 1:this.number_of_edges;
end

xstart = this.nodes(:, this.edges(1, inds));
xend = this.nodes(:, this.edges(2, inds));

plot([xstart(1,:); xend(1,:)], ...
    [xstart(2,:); xend(2,:)], ...
    varargin{:});

end