function b = fieldtrip(a)
% fieldtrip - Converts an array of event objects into an array of Fieldtrip
% event structures
%
%   STRUCT_ARRAY = fieldtrip(EVENT_ARRAY)
%
% See also: PSET/event, PSET/event/struct, PSET/event/eeglab

b = rmfield(struct(a),'dims');