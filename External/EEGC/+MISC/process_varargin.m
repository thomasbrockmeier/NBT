function [cmd_str, remove] = process_varargin(option_names, cell_array)
% PROCESS_VARARGIN Processes a variable number of input arguments
%
%   [CMD_STR, REMOVE] = process_varargin(OPT_NAMES, VARARGIN)
%

cmd_str = '';

nargin = length(cell_array);
remove = false(1,nargin);
arg_itr = 1;
while arg_itr < nargin
    if ~ischar(cell_array{arg_itr}),
        error('MISC:process_varargin:invalidInput', ...
            'Input arguments must be in pairs (propname, propvalue).');
    end
    
    [~, loc] = ismember(lower(cell_array{arg_itr}), lower(option_names));
    if loc > 0
        cmd_str = [cmd_str option_names{loc} '=varargin{' num2str(arg_itr+1)  '};']; %#ok<AGROW>
        remove(arg_itr:arg_itr+1) = true;
    end
    
    arg_itr = arg_itr + 2;
end
