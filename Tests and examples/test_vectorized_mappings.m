
Ntest = 10;

M = cell(1, Ntest);
F_colm = zeros(4, Ntest);

%generating random matrices
for k = 1:Ntest
    M{k} = eye(1) + randn(2,2);
    F_colm(:,k) = M{k}(:);
end

F = MappingArray2x2(F_colm);

%matrix-vector product
v = randn(2, 1);
yref = zeros(2, Ntest);

yvec = F * v;
for k = 1:Ntest
    yref(:,k) = M{k} * v;
end
norm(yref-yvec)

%same with transpose
yvec = F'*v;
for k = 1:Ntest
    yref(:,k) = M{k}' * v;
end
norm(yref-yvec)

%same with inverse
yvec = F \ v;
for k = 1:Ntest
    yref(:,k) = M{k} \ v;
end
norm(yref-yvec)

%inverse-transpose
yvec = F' \ v;
for k = 1:Ntest
    yref(:,k) = M{k}' \ v;
end
norm(yref-yvec)



    