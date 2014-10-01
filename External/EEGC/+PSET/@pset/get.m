function varargout = get(pin, varargin)
% GET - Gets properties values from pset objects
%
%   VALUE = get(EV, PROP_NAME)
%
% See also: PSET/event, PSET/event/set



% List of Built-in properties
bin_props = setdiff(fieldnames(pin), 'Info');

% List of user-defined properties
if ~isempty(pin.Info),
    udef_props = fieldnames(pin.Info);
else
    udef_props = {};
end

if nargin < 2,
    varargout{1} = [bin_props;udef_props];    
else
    varargout = cell(size(varargin));
end

for j = 1:length(varargin)
    prop_name = varargin{j};
    
    % First check whether the property is built-in
    [tf, loc] = ismember(lower(prop_name), lower(bin_props));
    if tf,
        varargout{j} = pin.(bin_props{loc});
    else
        % Otherwise, try with the user defined properties
        [tf, loc] = ismember(lower(prop_name), lower(udef_props));
        if tf,
            varargout{j} = pin.Info.(udef_props{loc});            
        else
            continue;            
        end        
    end  
end