function eegset_obj = import_eeglab(EEG, varargin)
% IMPORT_EEGLAB Imports an EEGLAB data structure
%
%   EEGSET = import_eeglab(EEG) imports the dataset stored in the EEGLAB
%   structure EEG. The output is an eegset object.
%
%   EEGSET = import_eeglab(DATA_FILE, [OPT1, VAL1, ...]) where (OPTN, VALN)
%   are pairs of property names and property values.
%
%   Property/Value pairs and descriptions:
%
%       Filename: Char array (defaults to a random name)
%           File name of the files associated to the generated datasets.
%           Namely, the associated files will be [filename].eegc for the
%           data file and [filename].mat for the header file.
%
%       Precision: Char array (defaults to 'double')
%           Precision of the numeric values stored in the output binary file.
%           Supported char arrays are 'int8', 'int16', 'int32', 'int64',
%           'uint8', 'uint16', 'uint32', 'uint64', 'single', and 'double'.
%
%       Writable: True or false (defaults to false).
%           Access level which determines whether the pset may be assigned
%           to. That is, whether obj(index) = value assignments are
%           allowed.
%
%       Temporary: True or false (default to false)
%           Determines whether the files associated with the generated pset
%           should be erased after the object goes out of scope or is otherwise
%           cleared.
%
%       ChunkSize: Scalar (default: see @globals/globals.txt)
%           Largest size of the data chunks that can be loaded into
%           MATLAB's workspace.
%
%       Verbose: Logical value (default: true)
%           Determines whether status messages should be displayed during
%           execution.
%
%   TO-DO: import also sensors locations!
%
%   NOTE 1:
%   This function requires the EEGLAB toolbox.
%   More information about EEGLAB at:  http://sccn.ucsd.edu/eeglab/
%
% See also EEGC/EEGSET, EEGLAB

import PSET.event;
import MISC.sizeof;
import MISC.process_varargin;
import MISC.struct2xml;
import EEGC.eegset;

% Options that are recognized by this function (in lowercase!)
THIS_OPTIONS = {'filename', 'precision', 'writable', 'temporary', ...
    'chunkSize', 'verbose'};

if nargin < 1, help import_eeglab; end

% Global parameters
DEF_PRECISION = EEGC.globals.evaluate.Precision;
DEF_CHUNKSIZE = EEGC.globals.evaluate.LargestMemoryChunk;
DEF_VERBOSE = EEGC.globals.evaluate.Verbose;
DATA_EXT = EEGC.globals.evaluate.DataFileExt;

% Default properties of the output eegset object
filename = [];
precision = DEF_PRECISION;
chunksize = DEF_CHUNKSIZE;
verbose = DEF_VERBOSE;
writable = false;
temporary = false;

% Process vararagin
cmd_str = process_varargin(THIS_OPTIONS, varargin);
eval(cmd_str);


if isempty(filename),
    % Generate a unique file name: It assumes that a session object already exists
    filename = session.getInstance.tmpFileName;
end

% Open the output binary file for writing
fid = fopen([filename DATA_EXT], 'w');
if verbose,
    fprintf('\n(+EEGC/import_eeglab) Writing data to binary file...');
end
% Store the data values into a binary file
chunksize = floor(chunksize/(sizeof(precision)*EEG.nbchan)); % in samples
if EEG.trials > 1,
    chunksize = floor(chunksize/size(EEG.data,2));       % in trials
    boundary = 1:chunksize:EEG.trials;
    if boundary(end) < EEG.trials,
        boundary = [boundary,  EEG.trials + 1];
    else
        boundary(end) = boundary(end)+1;
    end
else
    boundary = 1:chunksize:EEG.pnts;
    if boundary(end) < EEG.pnts,
        boundary = [boundary,  EEG.pnts + 1];
    else
        boundary(end) = boundary(end)+1;
    end
end

n_chunks = length(boundary) - 1;

if EEG.trials > 1,
    for chunk_itr = 1:n_chunks
        dat = EEG.data(:,:,boundary(chunk_itr):boundary(chunk_itr+1)-1);
        dat = reshape(dat, size(dat,1),size(dat,2)*size(dat,3));
        % Write a chunk of trials to the output binary file
        fwrite(fid, dat(:), precision);
        if verbose,
            fprintf('.');
        end
    end
else
    for chunk_itr = 1:n_chunks
        dat = EEG.data(:,boundary(chunk_itr):boundary(chunk_itr+1)-1);
        % Write a chunk of samples to the output binary file
        fwrite(fid, dat(:), precision);
        if verbose,
            fprintf('.');
        end
    end
    
end
fclose(fid);
if verbose,
    fprintf('\n(+EEGC/import_eeglab) Done writing binary file');
end

% Import EEGLAB events
n_ev = length(EEG.event);

ev = [];
if n_ev > 0
    ev = repmat(event, n_ev,1);
    if verbose,
        fprintf('\n(+EEGC/import_eeglab) Generating EEGLAB events...');
    end
    % If there are events at all
    diff_fields = setdiff(fieldnames(EEG.event(1)), {'type','duration'});
    n_diff_fields = length(diff_fields);
    for i = 1:length(diff_fields),
        xml_struct.(diff_fields{i}) = [];
    end
    if isfield(EEG.event(1), 'duration'),
        for i = 1:n_ev
            for j = 1:n_diff_fields,
                xml_struct.(diff_fields{j}) = EEG.event(i).(diff_fields{j});
            end
            if ~isempty(EEG.event(i).duration) && ...
                    ~isnan(EEG.event(i).duration) && ...
                    EEG.event(i).duration > 0,
                ev(i) = event(EEG.event(i).latency, ...
                    'Type', EEG.event(i).type, ...
                    'Duration', EEG.event(i).duration,...
                    'Time', EEG.event(i).latency/EEG.srate, ...
                    'Info', xml_struct);
            else
                ev(i) = event(EEG.event(i).latency, ...
                    'Type', EEG.event(i).type, ...
                    'Time', EEG.event(i).latency/EEG.srate, ...
                    'Info', xml_struct);
            end
        end
    else
        for i = 1:n_ev
            for j = 1:n_diff_fields,
                xml_struct.(diff_fields{j}) = EEG.event(i).(diff_fields{j});
            end
            ev(i) = event(round(EEG.event(i).latency), ...
                'Type', EEG.event(i).type, ...
                'Time', EEG.event(i).latency/EEG.srate, ...
                'Info', xml_struct);
        end
    end
    if verbose,
        fprintf('\n(+EEGC/import_eeglab) Done generating EEGLAB events');
    end
end

% Create the output eegset object
if verbose,
    fprintf('\n(+EEGC/import_eeglab) Creating output eegset object...');
end

if isfield(EEG, 'samplingtime'), 
    samplingtime = EEG.samplingtime;
    continuous_flag = false;
else
    samplingtime = [];
    continuous_flag = true;
end
sensorlabel = cell(length(EEG.chanlocs),1);
for i = 1:length(EEG.chanlocs)
    sensorlabel{i} = EEG.chanlocs(i).labels;
end

eegset_obj = eegset([filename DATA_EXT], EEG.nbchan, ...
    'Precision', precision, ...
    'Writable', writable, ...
    'Temporary', temporary, ...    
    'SamplingRate', EEG.srate,...
    'SensorLabel', sensorlabel, ...    
    'SamplingTime', samplingtime,...
    'StartDate', datestr(now,'dd-mm-yyyy'), ...
    'StartTime', datestr(now,'HH:MM:SS'), ...
    'Event', ev, ...
    'Continuous', continuous_flag);
if verbose,
    fprintf('\n(+EEGC/import_eeglab) Done creating output eegset object');
end
