function b = struct(a)
% STRUCT Converts an array of event objects into an array of structs
%
%   STRUCT_ARRAY = struct(EVENT_ARRAY)
%
% See also: PSET/event/ftEvent

aprops = properties(class(a));

nprops = length(aprops);

laprops = cell(size(aprops));
for i = 1:nprops
   laprops{i} = lower(aprops{i}); 
end
b = cell2struct(cell(1,length(laprops)), laprops, 2);
b = repmat(b,size(a));
for i = 1:numel(a)
    for j = 1:nprops
       b(i).(laprops{j}) = a(i).(aprops{j});
    end
end