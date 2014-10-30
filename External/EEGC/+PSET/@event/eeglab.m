function ev = eeglab(a, varargin)
% EEGLAB Converts and array of event objects into an array of EEGLAB
% event structures
%
%   STRUCT_ARRAY = eeglab(EVENT_ARRAY) returns a struct array that should
%   be placed in field 'event' of the 'EEG' structure corresponding to
%   an EEGLAB dataset.
%
%   
%
% See also: EEGLAB, PSET/event, PSET/event/struct, PSET/event/fieldtrip

import PSET.globals;
import MISC.process_varargin;

if numel(a)<1 || all(isempty(a)),
    ev = [];
    return;
end

THIS_OPTIONS = {'groupindexedtypes'};
grouptypes = globals.evaluate.GroupIndexedEvents;

eval(process_varargin(THIS_OPTIONS, varargin));


ev_struct = struct('type', '', 'latency', []);
fnames = {'Time'};
for i = 1:length(fnames),
    ev_struct.(fnames{i}) = [];
end
if ~isempty(a(1).Info),
    fnames = fieldnames(a(1).Info);    
    for i = 1:numel(fnames)
        if ischar(a(1).Info.(fnames{i})),
            ev_struct.(fnames{i}) = '';        
        elseif isnumeric(a(1).Info.(fnames{i})),
            ev_struct.(fnames{i}) = '';   
        else
            error('PSET:event:eeglab:invalidFieldType', ...
                'Event property ''%s'' if of an invalid type.', fnames{i});            
        end
    end
end

if grouptypes && ~isnumeric(a(1).Type),
     a = group_types(a);
end

ev = repmat(ev_struct, 1, numel(a));
for i = 1:numel(a)
    ev(i).type = a(i).Type;
    ev(i).latency = a(i).Sample-1;
    for j = 1:length(fnames),
        try
            ev(i).(fnames{j}) = a(i).(fnames{j});
        catch %#ok<CTCH>
            try
                ev(i).(fnames{j}) = a(i).Info.(fnames{j});
            catch %#ok<CTCH>
                % do nothing
            end
        end
    end
end


end