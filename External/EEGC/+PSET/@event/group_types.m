function obj = group_types(obj)
% group_types - Attempts to group event labels in fewer groups
%
%   EV_OUT = group_types(EV) attempts to group the types of the elements of
%   event array EV so that fewer types of events are present in the output
%   array EV_OUT. This is done by looking for event types that include a
%   serial number, e.g. 'TR pulse 1' and 'TR pulse 2' would be grouped
%   under type 'TR pulse'.
%
% See also: PSET/event
import MISC.strtrim;

if numel(obj) < 1, return; end

n_ev = numel(obj);
types = cell(n_ev,1);
if ischar(obj(1).Type)
    for i = 1:n_ev
        types{i} = strtrim(remove_numbers(obj(i).Type));
    end
else
    error('PSET:event:group_types:invalidType', ...
        'The Type field of event structs must be a string.');
end

[B,~,J] = unique(types);

if length(B) < length(types),
    for i = 1:length(B)
        idx = find(J==i);
        for j = 1:length(idx)
            obj(idx(j)).Type = B{i};
        end
    end
end


end


function str = remove_numbers(str)

l_str = length(str);
isnumber = false(1,l_str);
for j = 1:l_str
    if ~isnan(str2double(str(j))),
        isnumber(j) = true;
    end
end
if ~all(isnumber),
    str(isnumber) = [];
end

end