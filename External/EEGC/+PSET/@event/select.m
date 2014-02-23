function ev_out = select(ev, varargin)
% select - Selects events that fulfil some criteria
%
%
%   Documentation to be done
%
% See also: SPT

import PSET.event;
import MISC.process_varargin;


if nargin < 2,
    ev_out = ev;
    return;
end

% Options accepted by this function
THIS_OPTIONS = varargin(1:2:end);

% Default options
for i = 1:length(THIS_OPTIONS),
    eval([THIS_OPTIONS{i} '=[];']);
end

% Process varargin
eval(process_varargin(THIS_OPTIONS, varargin));

% Select the events
selection = true(size(ev));
for i = 1:length(THIS_OPTIONS)
    value = eval(THIS_OPTIONS{i});
    if isempty(value), continue; end    
    if length(value) < 2,
        for j = 1:numel(ev)
            query = get(ev(j), THIS_OPTIONS{i});
            if isempty(query) || any(isnan(query) | query ~= value),
                selection(j) = false;
            end       
        end
    else
        for j = 1:numel(ev)
            query = get(ev(j), THIS_OPTIONS{i});
            if isempty(query) || any(isnan(query) | query > value(2) | query < value(1)),
                selection(j) = false;
            end            
        end
    end
end
ev_out = ev(selection);