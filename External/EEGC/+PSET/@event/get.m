function varargout = get(ev, varargin)
% GET - Gets properties values of event objects
%
%   VALUE = get(EV, PROP_NAME)
%
% See also: PSET/event, PSET/event/set

if nargin < 2,
    error('PSET:event:get:invalidInput', ...
        'At least two input arguments are expected.');
end

varargout = cell(size(varargin));

for j = 1:length(varargin)
    prop_name = varargin{j};
    % Deal with the first event separately (just to speed up things later)
    try
        prop_value = ev(1).(prop_name);
        if length(ev) > 1,
            varargout{j} = cell(length(ev),1);
            varargout{j}{1} = prop_value;
        else
            varargout{j} = prop_value;
        end
        for i = 2:length(ev)
            varargout{j}{i} = ev(i).(prop_name);
        end
    catch %#ok<*CTCH>
        try
            % The provided property is not standard -> try Info
            prop_name = lower(prop_name);
            prop_value = ev(1).Info.(prop_name);
            if length(ev) > 1,
                varargout{j} = cell(length(ev),1);
                varargout{j}{1} = prop_value;
            else
                varargout{j} = prop_value;
            end
            for i = 2:length(ev)
                varargout{j}{i} = ev(i).Info.(prop_name);
            end
        catch
            % Ignore this property
            warning('PSET:event:get:invalidProperty', ...
                'Property ''%s'' is not defined.', prop_name);
            continue;
        end
    end
    
end