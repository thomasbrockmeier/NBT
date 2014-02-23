function y = double(obj)
% DOUBLE Convert pset object to numeric array with double precision
%
%   double(PSET) converts pset object PSET into a double precision numeric
%   array.
%
% See also: PSET/SINGLE, PSET/ISFLOAT, PSET/ISNUMERIC

if strcmpi(obj.Precision, 'double'),
    y = obj;
else
    y = double(obj(:,:));
end

end