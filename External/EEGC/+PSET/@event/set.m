function ev = set(ev, varargin)
% SET - Sets properties values of event objects
%
%   EV = set(EV, PROP_NAME, PROP_VALUE) sets the value of property
%   PROP_NAME to PROP_VALUE for the event object EV. EV can also be an
%   array of event objects.
%
% See also: PSET/event, PSET/event/get


if ~mod(nargin, 2),
    error('PSET:event:set:invalidInput', ...
        'An odd number of input arguments is expected.');
end


% Check that the provided property values are valid
tmp = struct;
for j = 1:2:length(varargin)
    try
        tmp.(varargin{j}) = [];
    catch
        error('PSET:event:set:invalidInput', ...
            'The property name ''%s'' is invalid.', varargin{j});
    end
end

for j = 1:2:length(varargin)
    prop_name = varargin{j};
    prop_value = varargin{j+1};
    % Deal with the first event separately (just to speed up things)
    try        
        ev(1).(prop_name) = prop_value;        
        for i = 2:length(ev)
            ev(i).(prop_name) = prop_value;            
        end
    catch %#ok<*CTCH>
        % The provided property is not standard -> to Info
        prop_name = lower(prop_name);
        ev(1).Info.(prop_name) = prop_value;
        for i = 2:length(ev)
            ev(i).Info.(prop_name) = prop_value;            
        end
    end
    
end


end
