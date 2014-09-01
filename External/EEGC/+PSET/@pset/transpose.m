function y = transpose(obj)
% .' Transpose
%
%   OBJ.' is the non-conjugate transpose of a pset object
%
% See also: PSET/CTRANSPOSE

y = copy(obj);
y.Transposed = ~y.Transposed;

end