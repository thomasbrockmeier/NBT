function y = cov(a, b, flag)
% COV Covariance matrix 
%
%   C = cov(OBJ) where OBJ is a pset object with dimensionality N and C is
%   a CxC covariance matrix.
%
% See also: PSET/pset

a.Transposed = ~a.Transposed;
if nargin < 2 || isempty(b),
    y = a*a';
else
    y = a*b';
end

if nargin > 2 && flag == 1,
    y = (1/a.NbPoints)*y;
else
    y = (1/(a.NbPoints-1))*y;
end
a.Transposed = ~a.Transposed;