function y = isfloat(pset)
% ISFLOAT True for pset objects.
%
%   ISFLOAT(PSET) returns true if PSET is a pset object.
%
% See also: PSET/ISA, PSET/DOUBLE, PSET/SINGLE, PSET/ISNUMERIC,
% PSET/ISINTEGER

y = isfloat(eval([pset.Precision '(0);']));


end