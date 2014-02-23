function y = subset(x, idx1, idx2)


if nargin < 3 || isempty(idx2),
    idx2 = 1:size(x,2);
end
if nargin < 2 || isempty(idx1),
    idx1= 1:size(x,1);
end


y = x(idx1, idx2);