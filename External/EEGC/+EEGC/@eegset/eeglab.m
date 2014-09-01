function EEG = eeglab(a)
% EEGLAB Converts an array of eegset objects into an array of EEGLAB data
% structures
%
%   EEG = eeglab(EEGSET_ARRAY) converts the array of eegset objects
%   EEGSET_ARRAY into an array of EEGLAB data structures.
%
% Note:
%   This conversion routine requires the EEGLAB toolbox:
%   http://sccn.ucsd.edu/eeglab/
%
% See also: EEGC/eegset

% Find if any of the input eegset objects is discontinuous
discontinuous_flag = false;
for i = 1:numel(a),
    if ~a(i).Continuous,
        discontinuous_flag = true;
        break;
    end
end

for i = 1:numel(a),  
    tmp = eeg_emptyset;
    tmp.nbchan = size(a(i),1);
    tmp.srate = a(i).SamplingRate;
    tmp.data = a;
    tmp.xmin = 0;
    
    [~, f_name] = fileparts(a(i).DataFile);
    tmp.setname     = sprintf('%s file', f_name);
    tmp.comments    = [ 'Original file: ' a(i).DataFile ];
    tmp.pnts = size(a(i),2);
    tmp.trials = 1;
    
    if ~isempty(a(i).SensorLocation),
        tmp.chanlocs = a(i).SensorLocation;
    else
        tmp.chanlocs = struct('labels', cellstr(char(a(i).SensorLabel)));
    end
    
    tmp.event = eeglab(a(i).Event);
    
    tmp = eeg_checkset(tmp,'makeur');   % Make EEG.urevent field
    tmp = eeg_checkset(tmp);
    
    if discontinuous_flag,
        if a(i).Continuous,
            tmp.samplingtimes = [];
        else
            tmp.samplingtimes = a(i).SamplingTime;
        end
    end
    
    tmp.hdr = a(i).Header;
    
    EEG(i) = tmp;    %#ok<AGROW>
    
    
end

