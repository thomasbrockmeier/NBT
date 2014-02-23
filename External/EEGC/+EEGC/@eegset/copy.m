function y = copy(obj, varargin)
% copy() - Copies an EEGC.eegset object
%
% Usage:
%   >> Y = copy(X)
%   >> Y = copy(X, 'PNAME1', PVAL1, ..., 'PNAMEn', PVALn)
%
% Input:
%   X               - An EEGC.eegset object
%   'PNAMEi', PVALi - Pairs of property names/property values that will be
%                     modified in the copied eegset object.
%
% Output:
%   Y   - An EEGC.eegset object which is an identical copy of X. %         
%
% Note:
%   The data file to which X points will be copied and Y will point to the
%   copied file. This means that subsequent changes in X (resp. Y) do not
%   affect Y (resp. X). 
%
% See also: EEGC.eegset

import MISC.process_varargin;
import EEGC.eegset;
import MISC.get_full_path;

DATA_EXT = PSET.globals.evaluate.DataFileExt;

% Options that will be processed by this function
THIS_OPTIONS = {'datafile'};

% Defaults
datafile = [];

% Process input arguments
[cmd_str, remove_flag] = process_varargin(THIS_OPTIONS, varargin);
eval(cmd_str);
varargin(remove_flag) = [];

if isempty(datafile),
    datafile = session.getInstance.tmpFileName;
end

% Create a copy of the data file
[pathstr, new_name] = fileparts(get_full_path(datafile));
if isempty(pathstr),
    try
        new_name = [session.getInstance.Folder filesep new_name DATA_EXT]; 
    catch  %#ok<CTCH>
        new_name = [pwd filesep new_name DATA_EXT];    
    end
else
    new_name = [pathstr filesep new_name DATA_EXT];
end
copyfile(obj.DataFile, new_name);

% Create an eegset object associated to the new files
y = eegset(new_name, obj.NbDims);
[~,~, set_props] = fieldnames(obj);
for i = 1:length(set_props),
   y = set(y, set_props{i}, get(obj, set_props{i})); 
end
i=1;
while i<length(varargin)
   y = set(y, varargin{i}, varargin{i+1});
   i = i+2;
end



end
