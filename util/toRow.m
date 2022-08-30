function y = toRow(x)

if size(x, 1) > 1
    y = transpose(x);
else
    y = x;
end

end