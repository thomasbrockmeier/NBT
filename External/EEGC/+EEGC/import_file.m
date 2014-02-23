function pset_obj = import_file(data_file, varargin)
% IMPORT_FILE Imports a data file
%
%   EEGSET = import_file(DATA_FILE) imports the dataset stored in the file
%   DATA_FILE. The output is an eegset object(see help EEGC/eegset).
%
%   EEGSET = import_file(DATA_FILE, [OPT1, VAL1, ...]) where (OPTN, VALN)
%   are pairs of property names and property values.
%
%   EEGSET = import_file(DATA_FILE, 'ReadEvents', false) will not attempt
%   to read any event information. It will, however, attempt to read the
%   sampling times in the case of an EDF+D file.
%
%   EEGSET = import_file(DATA_FILE, 'ReadTime', false) will not attempt to
%   read the sampling instants. This option is only meaningful when dealing
%   with EDF+D files.
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
%       HeaderFile: Char array (defaults to empty)
%           Name of the file where the header information is stored. If
%           left empty the header information will be assumed to be
%           contained in the data file.
%
%       ReadEvents: Logical (defaults to true)
%           Attempt to read events?
%
%       SignalType: Cell array (defaults to {}, i.e. read all types)
%           Type of signals to read. This is meaningful only for EDFPLUS
%           files.
%
%       Verbose: Logical value (default: true)
%           Determines whether status messages should be displayed during
%           execution.
%
%   TO-DO: Add boundary events when loading discontinuous EDF+ files
%   TO-DO: Import sensor locations from FieldTrip and EEGLAB datasets
%   TO-DO: Import epoched EEGLAB datasets
%
%   NOTE 1:
%   This function may require the FILEIO module from the FieldTrip toolbox.
%   More information about Fieldtrip at:  http://fieldtrip.fcdonders.nl
%
%   NOTE 2:
%   This function requires the EDFPLUS package for importing EDF+ files.
%
%   NOTE 3:
%   Any optional argument passed to this function which is not in the list
%   above will be directly passed to the child function that reads the data
%   file. The child function is EDFPLUS/read for EDF+ files and
%   ft_read_header and ft_read_data for other file formats. See the help of
%   those functions for more information about valid options.
%
%   NOTE 4:
%   When importing EDF+D files it is highly recommended to force reading
%   also the sampling times (ReadTime=true). In such a case, the boundaries
%   between non-contiguous records will be marked by an event of type:
%   'block boundary'. THIS IS NOT IMPLEMENTED YET!
%
%
% #-----------------------------------------------------------------------#
% # The EEGC package for MATLAB v1.0 (R20101116)                          #
% #-----------------------------------------------------------------------#
% # Author:  German Gomez-Herrero <g.gomez@nin.knaw.nl>                   #
% #          Netherlands Institute for Neuroscience                       #
% #          Amsterdam, The Netherlands                                   #
% #-----------------------------------------------------------------------#
%
% See also PSET/PSET, PSET/EVENT, EDFPLUS/READ, FT_READ_HEADER, FT_READ_DATA


import PSET.event;
import MISC.sizeof;
import MISC.process_varargin;
import EEGC.eegset;
import EDFPLUS.isedfplus;


% Options that are recognized by this function (in lowercase!)
THIS_OPTIONS = {'precision', 'writable', 'temporary', 'chunkSize', ...
    'headerfile', 'readevents','filename','verbose','grouptypes'};

if nargin < 1, help import_file; end


% Global parameters
DEF_PRECISION = EEGC.globals.evaluate.Precision;
DEF_CHUNKSIZE = EEGC.globals.evaluate.LargestMemoryChunk;
DEF_VERBOSE = EEGC.globals.evaluate.Verbose;
HDR_EXT = EEGC.globals.evaluate.HeaderFileExt;
DATA_EXT = EEGC.globals.evaluate.DataFileExt;


% Default properties of the output eegset object
filename = [];
headerfile = [];
precision = DEF_PRECISION;
chunksize = DEF_CHUNKSIZE;
verbose = DEF_VERBOSE;
writable = false;
temporary = false;
readevents = true;

% Process vararagin
[cmd_str, remove] = process_varargin(THIS_OPTIONS, varargin);
eval(cmd_str);
varargin(remove) = [];

if verbose,
    fprintf('\n');
    start_cputime = cputime;
end


if isempty(filename),
    % Generate a unique file name: It assumes that a session object already exists
    filename = session.getInstance.tmpFileName;
end


if isempty(headerfile),
    headerfile = data_file;
end

[fpath, ~, ext] = fileparts(data_file);

% # ----------------------------------------------------------------------#
% # READ HEADER INFORMATION                                               #
% # ----------------------------------------------------------------------#
if verbose,
    fprintf('\n(+EEGC/import_file) Reading header information...');
end
continuous_flag = true; % are data records continuous?

if exist('+EDFPLUS/read','file') && isedfplus(data_file)
    % EDF+ -> use EDFPLUS package
    hdr = EDFPLUS.read(data_file, 'verbose', verbose, varargin{:});
    samplingrate = max(hdr.sr(hdr.is_signal));
    sensorlabel = hdr.label(hdr.is_signal);
    startdate = datenum(hdr.start_date,'dd.mm.yy');
    starttime = datenum(hdr.start_time,'HH.MM.SS');
    sensorlocation = [];
    if strcmpi(hdr.edfplus_type, 'edf+d'),
        continuous_flag = false;
    end
    
elseif strcmpi(ext, '.set')
    % EEGLAB dataset format
    hdr = load(data_file, '-mat');
    hdr = hdr.EEG;
    if hdr.trials > 1,
        error('EEGC:import_file:trialsNotSupported', ...
            'Epoched datasets are not supported yet!');
    end
    samplingrate = hdr.srate;
    samplingtime = linspace(0, hdr.pnts/samplingrate, hdr.pnts);
    sensorlabel = cell(size(hdr.chanlocs));
    for i = 1:numel(sensorlabel)
        sensorlabel{i} = hdr.chanlocs(i).labels;
    end
    startdate = datestr(now, 'dd.mm.yy');
    startdate = datenum(startdate, 'dd.mm.yy');
    starttime = datestr(now, 'HH.MM.SS');
    starttime = datenum(starttime, 'HH.MM.SS');
    sensorlocation = hdr.chanlocs;
else
    % EDF -> use FILEIO to read the file
    hdr = ft_read_header(headerfile, varargin{:});
    samplingrate = hdr.Fs;
    samplingtime = linspace(0, hdr.nSamples/samplingrate, hdr.nSamples);
    sensorlabel = hdr.label;
    startdate = datestr(now, 'dd.mm.yy');
    startdate = datenum(startdate, 'dd.mm.yy');
    starttime = datestr(now, 'HH.MM.SS');
    starttime = datenum(starttime, 'HH.MM.SS');
    sensorlocation = [];
    
end


% Save the header in .MAT format
if ~isempty(hdr),
    save([filename '.mat'], 'hdr');
end
if verbose,
    fprintf('\n(+EEGC/import_file) Done reading header information');
end

% # ----------------------------------------------------------------------#
% # READ SIGNAL VALUES                                                    #
% # ----------------------------------------------------------------------#

% Open the output binary file for writing
fid = fopen([filename DATA_EXT], 'w');
if verbose,
    fprintf('\n(+EEGC/import_file) Writing data to binary file...');
end

if exist('+EDFPLUS/read', 'file') && isedfplus(data_file),
    % European Data Format (EDF+)
    
    % Generate the chunk boundaries
    chunksize = floor(chunksize/(sizeof(precision)*hdr.ns)); % in samples
    chunksize = floor(chunksize/max(hdr.spr(hdr.is_signal))); % in data records
    boundary = 1:chunksize:hdr.nrec;
    if boundary(end) < hdr.nrec,
        boundary = [boundary,  hdr.nrec+1];
    else
        boundary(end) = boundary(end)+1;
    end
    n_chunks = length(boundary) - 1;
    
    for chunk_itr = 1:n_chunks        
        [~, dat] = EDFPLUS.read(data_file, 'startrec', boundary(chunk_itr),...
            'endrec', boundary(chunk_itr+1)-1, 'verbose', false, ...
            'hdr', hdr, varargin{:});       
            
        % Write the chunk into the output binary file
        fwrite(fid, dat(:), precision);
        if verbose,
            fprintf('.');
        end
    end
    n_dims = size(dat,1);
    
elseif strcmpi(ext, '.set'),
    % EEGLAB dataset format
    [~, ~, ext_binary] = fileparts(hdr.data);
    fid_in = fopen([fpath filesep hdr.data],'r');
    % Generate the chunk boundaries
    chunksize = floor(chunksize/(sizeof(precision)*hdr.nbchan)); % in samples
    boundary = 1:chunksize:hdr.pnts;
    if boundary(end) < hdr.pnts,
        boundary = [boundary,  hdr.pnts+1];
    else
        boundary(end) = boundary(end)+1;
    end
    n_chunks = length(boundary) - 1;
    
    if strcmpi(ext_binary, '.dat'),
        % New EEGLAB format, data is stored rowwise
        
        for chunk_itr = 1:n_chunks
            % Read n_points from the EEGLAB binary data file
            n_points = boundary(chunk_itr+1)-boundary(chunk_itr);
            format_str = [num2str(n_points) '*float32'];
            skip =  hdr.pnts - (boundary(chunk_itr+1)-1);
            dat = fread(fid_in, hdr.nbchan*n_points, format_str, skip);
            fseek(fid_in, boundary(chunk_itr+1), 'bof');
            % Write the chunk into the output binary file
            dat = reshape(dat, n_points, hdr.nbchan)';
            fwrite(fid, dat(:), precision);
            if verbose,
                fprintf('.');
            end
        end
    elseif strcmpi(ext_binary, '.fdt'),
        % Old EEGLAB format, data is stored rowwise
        for chunk_itr = 1:n_chunks
            % Read n_points from the EEGLAB binary data file
            n_points = boundary(chunk_itr+1)-boundary(chunk_itr);
            dat = fread(fid_in, [hdr.nbchan n_points], 'float32');
            % Write the chunk into the output binary file
            fwrite(fid, dat(:), precision);
            if verbose,
                fprintf('.');
            end
        end        
        
    else
        error('EEGC:import_file:unsupportedFormat', ...
            'EEGLAB data files with extension %s are not supported.', ext);
        
    end
    fclose(fid_in);
    n_dims = size(dat,1);
    
else
    % Other formats -> Use FILEIO
    
    % Generate data chunk boundaries
    chunksize = floor(chunksize/(sizeof(precision)*hdr.nChans)); % in samples
    if hdr.nTrials > 1,
        % Chunk size must be an integer number of trials
        chunksize = floor(chunksize/(hdr.nSamples))*hdr.nSamples;
    end
    boundary = 1:chunksize:(hdr.nSamples*hdr.nTrials);
    if boundary(end) < hdr.nSamples*hdr.nTrials,
        boundary = [boundary,  hdr.nSamples*hdr.nTrials+1];
    else
        boundary(end) = boundary(end)+1;
    end
    n_chunks = length(boundary) - 1;
    
    for chunk_itr = 1:n_chunks
        % Read a chunk of data from the file
        dat = ft_read_data(data_file, 'begsample', boundary(chunk_itr),...
            'endsample', boundary(chunk_itr+1)-1, 'checkboundary', false, ...
            varargin{2:end}); %#ok<NASGU>
        dat = eval([precision '(dat);']);
        if ndims(dat) > 2,
            dat = reshape(dat, [size(dat,1), round(numel(dat)/size(dat,1))]);
        end
        % Write the chunk into the output binary file
        fwrite(fid, dat(:), precision);
        if verbose,
            fprintf('.');
        end
    end
    n_dims = size(dat,1);
    
end

fclose(fid);
if verbose,
    fprintf('\n(+EEGC/import_file) Done writing binary file');
end


% # ----------------------------------------------------------------------#
% # READ EVENTS                                                           #
% # ----------------------------------------------------------------------#

% Read events
if readevents,
    if verbose,
        fprintf('\n(+EEGC/import_file) Reading events information...');
    end
    if exist('+EDFPLUS/read','file') && isedfplus(data_file),
        % EDF+ format
        [~, ~, event_info, samplingtime] = EDFPLUS.read(data_file, ...
            'onlyannotations', true, 'hdr', hdr, 'verbose', true);
    elseif strcmpi(ext, '.set'),
        % EEGLAB dataset format
        event_info = hdr.event;
    elseif strcmpi(ext, '.trc'),
        if ~exist('pop_readtrc','file'),
            error('EEGC:import_file:missingDependency',...
                'The TRC_Import EEGLAB plub-in needs to be installed in order to load events from Micromed TRC files.');
        end
        % Micromed TRC file
        param.filename = data_file;
        param.loadevents.state = 'yes';
        param.loadevents.type = 'marker';
        param.loadevents.dig_ch1 = '';
        param.loadevents.dig_ch1='';
        param.loadevents.dig_ch1_label='';
        param.loadevents.dig_ch2='';
        param.loadevents.dig_ch2_label='';
        param.chan_adjust_status=0;
        param.chan_adjust='';
        param.chans='1';
        tmp = pop_readtrc(param);
        event_info = tmp.event;
        clear tmp;
    else
        % Other formats
        event_info = ft_read_event(headerfile, varargin{2:end});
    end
    if verbose,
        fprintf('\n(+EEGC/import_file) Done reading events');
    end
    
    % groupTypes makes 'TR 1' and 'TR 2' become 'TR'
    if isempty(event_info),
        event_obj = [];
    else
        if verbose,
            fprintf('\n(+EEGC/import_file) Creating array of event objects...');
        end
        event_obj = PSET.event(event_info);        
        if verbose,
            fprintf('\n(+EEGC/import_file) Done creating array of event objects...');
        end
    end
    
end

% Create an eegset object
if verbose,
    fprintf('\n(+EEGC/import_file) Creating output eegset object...');
end

if ~isempty(hdr),
    hdr = [filename HDR_EXT];
end
pset_obj = eegset([filename DATA_EXT], n_dims, ...
    'Precision', precision, ...
    'Writable', writable, ...
    'Temporary', temporary, ...
    'Header', hdr,...
    'SamplingRate', samplingrate,...
    'SensorLabel', sensorlabel, ...
    'SensorLocation', sensorlocation, ...
    'SamplingTime', samplingtime,...
    'StartDate', startdate, ...
    'StartTime', starttime, ...
    'Event', event_obj, ...
    'Continuous', continuous_flag);
if verbose,
    fprintf('\n(+EEGC/import_file) Done creating output eegset object');
end

% Display the total time taken to import the file
if verbose,
    t = cputime-start_cputime;
    ndigits = ceil(log10(t));
    fprintf(['\n(+EEGC/import_file) It took %' num2str(ndigits) '.0f seconds to import the file'], t);
    fprintf('\n');
end




