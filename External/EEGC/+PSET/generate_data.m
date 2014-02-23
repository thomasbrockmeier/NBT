function obj = generate_data(type, ndims, npoints, varargin)
% GENERATE_DATA Generates a pset object
%
%   OBJ = generate_data(TYPE, NDIMS, NPOINTS)
%
% Note 1: This function is an internal function that groups together the
% core functionality of functions such as randn, zeros, ones, nan, etc.
%
% See also: PSET/pset

import PSET.pset;
import PSET.globals;
import MISC.sizeof;
import MISC.process_varargin;

if nargin < 2 || isempty(npoints),
    error(sprintf('PSET:%s:invalidInput',type), ...
        'An scalar is expected as second input argument.');
end

if nargin < 1 || isempty(ndims),
    error(sprintf('PSET:%s:invalidInput',type), ...
        'An scalar is expected as first input argument.');
end

% Basic error checking
if ~isnumeric(ndims) || ~isnumeric(npoints) || ndims < 0 || npoints < 0,
    error(sprintf('PSET:%s:invalidInput',type), ...
        'The first two input arguments must be positive scalars.');
end

THIS_OPTIONS = {'chunksize','filename','matrix','precision'};
DATA_EXT =  globals.evaluate.DataFileExt;
chunksize = globals.evaluate.LargestMemoryChunk;
filename = [];
matrix = [];
precision = globals.evaluate.Precision;

[cmd_str,remove_flag] = process_varargin(THIS_OPTIONS, varargin);
eval(cmd_str);
varargin(remove_flag) = [];

if isempty(filename),
    filename = session.getInstance.tmpFileName;
end

chunksize = floor(chunksize/(sizeof(precision)*ndims)); % in samples

n_chunks = ceil(npoints/chunksize);
chunksize = repmat(chunksize, 1, n_chunks);
if (npoints - n_chunks*chunksize)<0,
    chunksize(end) = (npoints - (n_chunks-1)*chunksize(end)); %#ok<NASGU>
end

% Write the random numbers to the binary file
fid = fopen([filename DATA_EXT], 'w');
if strcmpi(type, 'matrix'),
    fwrite(fid, matrix(:), precision);    
else
    for chunk_itr = 1:n_chunks
        dat = eval([type '(ndims, chunksize(chunk_itr))']);
        fwrite(fid, dat(:), precision);
    end
end
fclose(fid);

% Create a temporary pset object
obj = pset([filename DATA_EXT], ndims, varargin{:});