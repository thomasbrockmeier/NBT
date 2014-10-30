function obj = rename_file(obj, new_name, new_name_header)
% rename_file - Changes the name of the file associated to a pset object
%
%   OBJ = rename_file(OBJ, NEW_NAME) renames the files associated to the pset
%   object OBJ so that the new data file name will be [NEW_NAME].eegc and
%   the new header file name (if any) will be [NEW_NAME].mat. 
%
%   OBJ = rename_file(OBJ, NEW_BIN_NAME, NEW_MAT_NAME) sets different names
%   for the data file ([NEW_BIN_NAME].eegc) and for the header file
%   ([NEW_HDR_NAME].mat).
%
%   Note 1:
%   --------
%   Note that the file extension of the file names passed as input
%   arguments will be ignored and standard extensions will be used instead.
%   The default extensions can be modified by editing the text file
%   +PSET/@globals/globals.txt. 
%
%   Note 2:
%   --------
%   Renaming the associated files requires an intermediate destruction of
%   the provided pset object and the creation of an identical copy of the
%   original pset object. This means that the following command:
%
%   rename_file(OBJ, NEW_NAME)
%
%   will simply destroy OBJ. Thus, you should always use:
%
%   OBJ = rename_file(OBJ, NEW_NAME);   
%
% See also: PSET/pset/copy

import PSET.globals;
import PSET.pset;

if nargin < 3 || isempty(new_name_header),
    new_name_header = new_name;
end

HDR_EXT = globals.evaluate.HeaderFileExt;
DATA_EXT = globals.evaluate.DataFileExt;

% Copy all the fields of the pset object
data_file = obj.DataFile;
header_file = obj.HeaderFile;
temporary = obj.Temporary;
transposed = obj.Transposed;
precision = obj.Precision;
writable = obj.Writable;
header = obj.Header;
ndims = obj.NbDims;

% Clear the pset object in order to be able to rename the file
obj.Temporary = false;
delete(obj);

% Rename both data and header files
[pathstr, new_name] = fileparts(new_name);
if isempty(pathstr),
    try
        new_name = [session.getInstance.Folder filesep new_name DATA_EXT]; 
    catch %#ok<*CTCH>
        new_name = [pwd filesep new_name DATA_EXT];    
    end
else
    new_name = [pathstr filesep new_name DATA_EXT];
end
movefile(data_file, new_name);

[pathstr, new_name_header] = fileparts(new_name_header);
if isempty(pathstr),
    try
        new_name_header = [session.getInstance.Folder filesep new_name_header HDR_EXT];
    catch
        new_name_header = [pwd filesep new_name_header HDR_EXT];    
    end
else
    new_name_header = [pathstr filesep new_name_header HDR_EXT];
end

if ~isempty(header_file),
    movefile(header_file, new_name_header);
end

% Create a pset object associated to the new files
if isempty(header_file),
    new_name_header = header;
end
obj = pset(new_name, ndims, ...
    'Header', new_name_header, ...
    'Temporary', temporary, ...
    'Precision', precision, ...
    'Writable', writable);

if transposed,
    transpose(obj);
end
    
