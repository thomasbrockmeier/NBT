function [data, header] = dlmread(filename, delim, r, c, varargin)
% dlmread - Read ASCII delimited file
%
%   DATA = dlmread(FILENAME, DELIM) reads numeric data from the ASCII
%   delimited file FILENAME. DELIM is the delimiter used in the file. If
%   not provided, blank spaces will be used as delimiter characters.
%
%   [DATA, HEADER] = dlmread(FILENAME, DELIM) reads numeric data from the
%   ASCII delimited file FILENAME but allows for a header row containing
%   text fields. These header fields are returned in cell array HEADER.
%
%   DATA = dlmread(FILENAME, DELIM, R, C) specifies the row R and column C
%   where the upper-left corner of the data lies in the file.
%
%   [DATA, HEADER] = dlmread(FILENAME, DELIM, R) returns R header lines in
%   cell array HEADER.
%
%
% See also: DLMREAD

import MISC.process_varargin;

if nargin < 4 || isempty(c), c = 0; end
if nargin < 3, r = []; end
if nargin < 3 || isempty(delim), delim = ''; end

if nargin < 1 || isempty(filename),
    error('MISC:dlmread:invalidInput', ...
        'First input argument must be a valid file name.');
end

% Default options
verbose = true;

% Process input options
THIS_OPTIONS = {'verbose'};
eval(process_varargin(THIS_OPTIONS, varargin));

if nargout < 2,
    if isempty(r), r = 0; end
    try
        data = dlmread(filename, delim, r, c);
    catch %#ok<CTCH>
        [data, ~] = dlmread(filename, delim, r, c);
    end
elseif ~isempty(r) && r < 1,
    data = dlmread(filename, delim, r, c);
    header = {};
else
    if isempty(r), r = 1; end
    % Read the header rows
    header = [];
    fid = fopen(filename, 'r');
    for i = 1:r
        fline = textscan(fid, '%s[^\n]', 'Delimiter', '');
        fline = fline{1}{1};
        fline = textscan(fline, '%s', 'Delimiter', delim);
        header = [header;fline]; %#ok<AGROW>
    end
    if size(header,1) < 2,
        header = header{1};
    end
    try
        data = dlmread(filename, delim, r, c);
        return;
    catch %#ok<CTCH>
        warning('MISC:dlmread:safeMode', ...
            'File could not be read using fast mode. Trying with slow mode.');
    end   
    
    % Find out the number of columns and rows in the data field    
    n_rows = str2double(perl('+MISC/countlines.pl', filename));
    tmp = textscan(fid, '%s', 1, 'Delimiter', '');
    fline = textscan(tmp{1}{1}, '%s', 'Delimiter', delim);
    n_cols = length(fline{1})-c;
    fline = tmp;   
    data = nan(n_rows, n_cols);
    line_count = 0;
    if verbose,
        fprintf('\n(+MISC/dlmread) Reading data rows...');
    end
    while ~isempty(fline{1})
        fline = fline{1}{1};
        fline = textscan(fline, '%s', 'Delimiter', delim);
        line_count = line_count + 1;
        for i = (c+1):length(fline{1}),
            tmp = str2double(strrep(fline{1}{i},',','.'));
            if ~isempty(tmp),
                data(line_count, i) = tmp;
            end
        end
        fline = textscan(fid, '%s[^\n]', 1, 'Delimiter', '');
        
        if verbose && ~mod(line_count, floor(n_rows/10)),
            fprintf('.');
        end        
    end
    if verbose,
        fprintf('\n(+MISC/dlmread) Done reading data rows\n');
    end
end

end

