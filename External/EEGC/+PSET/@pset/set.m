function pin = set(pin, varargin)
% SET - Sets properties values from pset objects
%
%   VALUE = set(EV, PROP_NAME, PROP_VALUE)
%
% See also: PSET/event, PSET/event/set

if nargin < 2,
    error('PSET:pset:set:invalidInput', ...
        'At least two input arguments are expected.');
end


% List of user-defined properties
if ~isempty(pin.Info),
    udef_props = fieldnames(pin.Info);
else
    udef_props = {};
end

% List of built-in properties
[~, ~, bin_props] = fieldnames(pin); 
bin_props = setdiff(bin_props, udef_props);

for j = 1:2:length(varargin)
    prop_name = varargin{j};
    prop_value = varargin{j+1};
    
    % First check whether the property is built-in
    [tf, loc] = ismember(lower(prop_name), lower(bin_props));
    if tf,
        pin.(bin_props{loc}) = prop_value;
    else
        % Otherwise, try with the user defined properties
        [tf, loc] = ismember(lower(prop_name), lower(udef_props));
        if tf,
            pin.Info.(udef_props{loc}) = prop_value;            
        else
            % Add a new property
            pin.Info.(lower(prop_name)) = prop_value;            
        end        
    end  
end