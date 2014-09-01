% Copyright (C) 2010  Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
%
function nbt_NBTRunBadChannelRejection(varargin)
% specify folder containing files
if (length(varargin)<1 ||isempty(varargin{1}) || ~ischar(varargin{1}))
    data_directoryname = uigetdir('C:\','Please select a folder with EGI signal files you want to convert');
else
    data_directoryname=varargin{1};
end
if length(varargin)<2 || isempty(varargin{2})
    save_directoryname = uigetdir('C:\','Please select a folder in which you want to save the NBT files');
else
    save_directoryname=varargin{2};
end

current=cd;
cd ([data_directoryname]);
d = dir(data_directoryname);


% looping through all files in folder
for j=3:length(d)
    if (~d(j).isdir)
        FileEx = strfind(d(j).name,'raw');
        if( ~isempty(FileEx))
            % specify filename, ask user
            
            
            fn = d(j).name;
            filename = [data_directoryname '\' fn];
            % Find information from filename
            FileNameIndex = strfind(filename,'.');
            ProjectID = filename(1:(FileNameIndex(1)-1));
            SubjectID = filename((FileNameIndex(1)+2):(FileNameIndex(2)-1));
            DateRec   = filename((FileNameIndex(2)+1):(FileNameIndex(3)-1));
            Condition = filename((FileNameIndex(3)+1):(FileNameIndex(4)-1));
            
            % and load file
            disp('Filename:')
            disp(filename)
            disp('File loading... Please Wait')
            
            
            EEG = pop_readegi(filename);
            EEG.ref = EEG.nbchan;
            
            warning('Loading HGSN channel locations - this layout may not be correct for all systems!')
            switch EEG.nbchan
                case 129
                    EEG.chanlocs = readlocs('GSN-HydroCel-129.sfp');
                    EEG.ref = 129;
                case 257
                    EEG.chanlocs = readlocs('GSN-HydroCel-257.sfp');
                    EEG.ref = 257;
            end
            EEG = eeg_checkset(EEG);
            
            RawSignalInfo = nbt_CreateInfoObject(fn, 'raw', EEG.srate);
            EEG.setname = RawSignalInfo.file_name;
            EEG.NBTinfo = RawSignalInfo;
            
            
            %bad channel rejection
            EEG=nbt_FindBadChannels(EEG,'s');
         
            
            RawSignal = NBTSignal(EEG.data,EEG.srate, SubjectID, 0, EEG.ref, DateRec, Condition, 'nbt_NBTRunBadChannelRejection', [], 'EGI',ProjectID,[]);
            RawSignalInfo = EEG.NBTinfo;
            EEG=rmfield(EEG,'NBTinfo');
            EEG.data = [];
            RawSignalInfo.Interface.EEG=EEG;
            
            
            disp('Writing to disk... Please Wait')
            filename = [filename(1:(end-3)) 'mat'];
            save (([filename]), 'RawSignal', 'RawSignalInfo')
            disp('File saved')
        else
            disp('No .raw files found in folder')
        end
    end
end
cd(current)
end