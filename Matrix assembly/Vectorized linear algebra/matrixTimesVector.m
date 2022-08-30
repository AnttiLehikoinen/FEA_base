function b = matrixTimesVector(M, v, varargin)

if size(M,1) == 1
    b = M.*v;
elseif size(M,1) == 4
    ind_11 = 1;
    ind_21 = 2;
    ind_12 = 3;
    ind_22 = 4;
    b = [M(ind_11,:).*v(1,:)+M(ind_12,:).*v(2,:);
            M(ind_21,:).*v(1,:)+M(ind_22,:).*v(2,:)];
end

end