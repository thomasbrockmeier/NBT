function y = eq(a,b)
% == Equal.
%   A == B does element by element comparisons between two arrays of event
%   objects or between an array of event objects and a string.
%
% See also: PSET/event

import MISC.isevent;

if ~isevent(a),
    tmp = a;
    a = b;
    b = tmp;
end

y = false(size(a));

if ischar(b),
    for i = 1:numel(a) 
        y(i) = strcmpi(a(i).Type, b);        
    end
elseif iscell(b),
    for i = 1:numel(a)
       y(i) = ismember(a(i).Type, b); 
    end
elseif isnumeric(b),
    for i = 1:numel(a)
        y(i) = abs((a(i).Type-b)) < eps;        
    end    
elseif isevent(b),
    if numel(b) > 1 && (ndims(a)~=ndims(b) || ~all(size(a)==size(b))),
        error('PSET:event:invalidDimensions', ...
            'The dimensions of the input arguments do not match.');
    end
    for i = 1:prod(size(a)) %#ok<PSIZE> 
        if numel(b) > 1,
            j = i;
        else
            j = 1;
        end
        y(i) = strcmpi(a(i).Type, b(j).Type) && ...
            a(i).Sample == b(j).Sample && ...
            (a(i).Time-b(j).Time)<eps && ...
            a(i).Offset == b(j).Offset && ...
            a(i).Duration == b(j).Duration && ...
            (a(i).TimeSpan - b(j).TimeSpan) < eps && ...
            ((isempty(a(i).Value) && isempty(b(j).Value)) || ...
            (a(i).Value == b(j).Value)) && ...
            ((isempty(a(i).Dims) && isempty(b(j).Dims)) || ...
            ((length(a(i).Dims) == length(b(j).Dims)) && ...
            (all(a(i).Dims == b(j).Dims))));        
    end    
else
    error('PSET:event:eq:invalidType', ...
        'Invalid comparison between incompatible types.');
    
end
