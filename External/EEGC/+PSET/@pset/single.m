function y = single(obj)
% SINGLE Convert pset object to numeric array with single precision
%
%   single(PSET) converts pset object PSET into a single precision numeric
%   array.
%
% See also: PSET/DOUBLE, PSET/ISFLOAT, PSET/ISNUMERIC

y = single(obj(:,:));

end