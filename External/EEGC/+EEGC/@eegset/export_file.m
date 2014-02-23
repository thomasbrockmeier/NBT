function export_file(obj, varargin)
% EXPORT_FILE - Exports an eegset object into a variaty of file formats
%
%   export_file(EEGSET, 'filename', FILENAME) exports the eegset object
%   to a file with the provided FILENAME. In this case, export_file will
%   attempt to guess the file format using the provided file extension.
%
%   export_file(EEGSET, 'filename', FILENAME, 'format', FORMAT_TYPE)
%   specifies the format of the output file. The file format and the file
%   extension must agree or an error will be triggered. Currently, the only
%   format supported is 'eeglab'. 
%
%   Other allowed property/value pairs and descriptions:
%
%       Verbose:  Logical value (default: true)
%           Determines whether status messages should be displayed during
%           execution.
%
%   Note: 
%   If a filename is not provided, export_file will attempt to generate a
%   unique random file name. For this to be succesful a session object must
%   exist in the current workspace. See help session.
%
%
% #-----------------------------------------------------------------------#
% # The EEGC package for MATLAB                                           #
% #-----------------------------------------------------------------------#
% # Author:  German Gomez-Herrero <g.gomez@nin.knaw.nl>                   #
% #          Netherlands Institute for Neuroscience                       #
% #          Amsterdam, The Netherlands                                   #
% #-----------------------------------------------------------------------#
%
% See also: EEGC, EEGC.import_file

if nargin < 1, help import_file; end

import MISC.process_varargin;
import EEGC.globals;

% Options accepted by this function
THIS_OPTIONS = {'filename', 'format'}; 

% Default options
verbose = globals.evaluate.Verbose;
filename = [];
format = [];

% Process vararagin
eval(process_varargin(THIS_OPTIONS, varargin));

if verbose,
    fprintf('\n');
    start_cputime = cputime;
end


% Try to guess the file format
if isempty(format) && isempty(filename),
    format = globals.evaluate.ExportFileFormat;
elseif isempty(format),
    [~, ~, ext] = fileparts(filename);
    switch lower(ext)
        case '.set',
            format = 'eeglab';        
        
        otherwise
            error('EEGC:export_file:unknownFileExt', ...
                'Unknown file extension ''%s''', ext);
            
    end
end

if isempty(filename),
    % Generate a unique file name: It assumes that a session object already exists
    filename = session.getInstance.tmpFileName;
end

% Export the object into the desired file format
switch lower(format)
    case 'eeglab',
        [pathstr, name, ext] = fileparts(filename);
        tmp = eeglab(obj);
        s.type = '()';
        s.subs = {1:size(obj,1),1:size(obj,2)};
        tmp.data = subsref(tmp.data, s);
        pop_saveset(tmp, 'filename', [name ext], 'filepath', pathstr);
    otherwise
        error('EEGC:export_file:unknownFileFormat', ...
                'Unknown file format ''%s''', format);            
end

% Display the total time taken to import the file
if verbose,
    t = cputime-start_cputime;
    ndigits = ceil(log10(t));
    fprintf(['\n(+EEGC/export_file) It took %' num2str(ndigits) '.0f seconds to export the eegset object'], t);
    fprintf('\n');
end


