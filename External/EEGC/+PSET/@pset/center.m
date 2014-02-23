function y = center(a)
% CENTER Removes the mean from a pset object
%
%   Y = CENTER(A) generates a zero-mean pset object Y which is otherwise
%   identical to A.
%
% See also: PSET/pset

transposed_flag = false;
if a.Transposed,
    transposed_flag = true;
    a.Transposed = false;
end
y = a - repmat(mean(a,2),1,size(a,2));    
if transposed_flag,
    y.Transposed = true;
    a.Transposed = true;
end