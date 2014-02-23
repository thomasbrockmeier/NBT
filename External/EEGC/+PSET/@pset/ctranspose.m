function y = ctranspose(obj)
% ' Complex conjugate transpose
%
%   OBJ' is the complex conjugate tranpose of a pset object OBJ.
%
% See also: PSET/pset, PSET/TRANSPOSE

y = conj(obj);
y = transpose(y);
