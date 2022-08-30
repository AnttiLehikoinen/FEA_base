function y = apply_mapping_on_vector(this, v, is_trps, is_inverse)


if is_trps
    ind_11 = 1;
    ind_21 = 3;
    ind_12 = 2;
    ind_22 = 4;
else
    ind_11 = 1;
    ind_21 = 2;
    ind_12 = 3;
    ind_22 = 4;
end

M = this.array;

if is_inverse
    %returns vectorized det(F)*F\V or det(F)*F'\V
    y = [M(ind_22,:).*v(1,:)-M(ind_12,:).*v(2,:);
        -M(ind_21,:).*v(1,:)+M(ind_11,:).*v(2,:)];
    y = bsxfun(@rdivide, y, this.determinant);
else
    %returns vectorized F*V or F'*B
    y = [M(ind_11,:).*v(1,:)+M(ind_12,:).*v(2,:);
        M(ind_21,:).*v(1,:)+M(ind_22,:).*v(2,:)];
end


end