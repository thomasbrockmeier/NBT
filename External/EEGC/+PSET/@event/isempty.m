function y = isempty(obj)
% isempty - Returns true if an event object has not been initalized
%
%   Y = isempty(OBJ) returns true if event object OBJ has not been
%   initialized. 
%
% See also: PSET/event
y = true(size(obj));
for i = 1:numel(obj),
    if ~isempty(obj(i).Time) || ~isempty(obj(i).Sample),
        y(i) = false;        
    end
end