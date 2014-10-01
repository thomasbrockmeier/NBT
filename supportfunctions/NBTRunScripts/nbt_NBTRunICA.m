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

% ChangeLog - see version control log for details
% <date> - Version <#> - <text>

function NBTRunAnalysis(varargin)
tic
[script, savescript] = NBTwrapper(40,23);
toc
tic
nbt_NBTcompute(script,savescript,'RawSignal')
toc
clear script
clear savescript




end


function [NBTfunction_handle,NBTfunction_handleSave]=NBTwrapper(NumSubjects,NumChannels)
ICA = [];
ICAInfo = [];
    function NBTscript(ICA, ICAInfo)
        try
            EEG = ICAInfo.Interface.EEG;
        catch
            EEG = eeg_emptyset;
        end
        EEG.setname = ICAInfo.file_name;
        EEG.srate = ICAInfo.converted_sample_frequency;
        EEG.data = ICA.Signal';
        EEG.pnts = size(EEG.data,2);
        ICAInfo.Interface.EEG=[];
        EEG.NBTinfo = ICAInfo;
        EEG = eeg_checkset(EEG);
       % EEG = nbt_filterbeforeICA(EEG, 'EEG.data = nbt_filter_firHp(EEG.data,0.5,EEG.srate,4);',4);
        ICA.Signal = EEG.data';
        ICAInfo = EEG.NBTinfo;
        EEG.data = [];
        ICAInfo.Interface.EEG = EEG;
    end

    function NBTsaveScript
        s = whos;
        for ii=1:length(s)
            if(strcmp(s(ii).class,'NBTSignal'))
                clear([s(ii).name])
            end
        end
        path = pwd;
        an_file = [path,'/',SignalInfo.file_name,'.mat'];
        save(an_file)
        
    end

NBTfunction_handle = @NBTscript;
NBTfunction_handleSave =@NBTsaveScript;
end


