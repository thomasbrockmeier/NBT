%% SignalInfo object class constructor
% SignalInfo  = nbt_SignalInfo
%
% See also:
%   nbt_CreateInfoObject

%--------------------------------------------------------------------------
% Copyright (C) 2014  Simon-Shlomo Poil
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
%--------------------------------------------------------------------------


classdef nbt_SignalInfo
    properties
        subjectInfo
        signalName
        signalID
        signalSHA256
        signalOrigin
        researcherID
        signalType
        frequencyRange
        filterSettings
        timeOfRecording
        originalSamplingFrequency
        notes
        badChannels
        nonEEGch
        eyeCh
        reference
        lastUpdate
        log
        interface
        nbtVersion
        listOfBiomarkers
    end
    
    properties(Dependent)
        convertedSamplingFrequency
    end
    
    properties(Access=private)
       privconverted_sample_frequency 
    end
    
    methods
        function SignalInfo = nbt_SignalInfo
            if(isempty(SignalInfo.nbtVersion))
                SignalInfo.nbtVersion = nbt_getVersion;
            end
            if(isempty(SignalInfo.signalID))
                SignalInfo.signalID = nbt_MakeNBTDID;
            end
            SignalInfo.lastUpdate = datestr(now);
        end
        
        %we support only setting .convertedSamplingFrequency
        function obj = set.convertedSamplingFrequency(obj, value)
                if(isempty(obj.originalSamplingFrequency))
                    obj.originalSamplingFrequency = value;
                end
                obj.privconverted_sample_frequency = value;
        end
        
        function v = get.convertedSamplingFrequency(obj)
            v = obj.privconverted_sample_frequency;
        end
        
        function Biomarker = SetBadChannelsToNaN(Info,Biomarker)
            Biomarker(:,find(Info.badChannels)) = nan(size(Biomarker,1),length(find(Info.badChannels)));
        end 
        
        function yesno = checkHash(SignalInfo, Signal)
            yesno = false;
            if(~isempty(SignalInfo.signalSHA256)
                yesno = strcmp(nbt_getHash(Signal),SignalInfo.signalSHA256)
            end
        end
    end
end