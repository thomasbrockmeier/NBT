% nbt_EmbedObject - 
%
% Usage:
%   EmbedObject = nbt_EmbedObject(BiomarkerName, ObjectToAdd,
%   ParameterName,ContainerRange,TmpSwitch, TempDirName)
%
% Inputs:
%   
%
% Outputs:
%      
%
% Example:
%   
% References:
% 
% See also: 
%  
  
%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2009), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) <year>  <Main Author>  (Neuronal Oscillations and Cognition group, 
% Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, 
% Neuroscience Campus Amsterdam, VU University Amsterdam)
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
% -------------------------------------------------------------------------


classdef nbt_EmbedObject < nbt_Biomarker
    %% EmbedObject to contain Biomarker objects
    
    %% Copyright (c) 2009,  Simon-Shlomo Poil (Center for Neurogenomics and Cognitive Research (CNCR), VU University Amsterdam)
    %% ChangeLog - remember to set NBTversion property
    %$ Version 1.0 - 22 June 2009 : Modified by Simon-Shlomo Poil,simonshlomo.poil@cncr.vu.nl$
    % Implementing new matlab object structure.
    
    properties
        BiomarkerName
        Container
        TmpIndex
        TmpSwitch
        TmpFirstRead
        ParameterName
        ParameterValue
        SwapPointer
        SwapRange
    end
    
    
    methods
        function EmbedObject = nbt_EmbedObject(BiomarkerName, ObjectToAdd, ParameterName,ContainerRange,TmpSwitch, TempDirName)
            
            EmbedObject.TmpSwitch = TmpSwitch;
            
            if TmpSwitch == 0
                EmbedObject.Container = cell(length(ContainerRange),1);
                for i=1:length(ContainerRange)
                    EmbedObject.Container{i,1} = ObjectToAdd;
                end
            else
                EmbedObject.Container = cell(length(ContainerRange),1);
                for i=1:length(ContainerRange)
                    EmbedObject.Container{i,1} = ObjectToAdd;
                    EmbedObject.TmpFirstRead(i,1) =1;
                end
                SwapRange = 1:TmpSwitch:length(ContainerRange);
                EmbedObject.TmpIndex = cell(length(SwapRange),2);
                for SwapIndex=1:(length(SwapRange)-1)
                    EmbedObject.TmpIndex{SwapIndex,1} = tempname(TempDirName); % create temp names
                    EmbedObject.TmpIndex{SwapIndex,2} = SwapRange(SwapIndex):(SwapRange(SwapIndex+1)-1);
                end
                EmbedObject.TmpIndex{SwapIndex+1,1} = tempname(TempDirName);
                EmbedObject.TmpIndex{SwapIndex+1,2} = SwapRange(SwapIndex+1):length(ContainerRange);
                EmbedObject.SwapRange = SwapRange;
            end
            EmbedObject.BiomarkerName = BiomarkerName;
            EmbedObject.ParameterName = ParameterName;
            EmbedObject.ParameterValue = ContainerRange;
            EmbedObject.DateLastUpdate = datestr(now);
            EmbedObject.SwapPointer = 1;
        end
        
        function EmbedObject = AddObject(EmbedObject, ObjectToAdd, ParameterValue)
            ParameterIndex = find(EmbedObject.ParameterValue == ParameterValue);
            if EmbedObject.TmpSwitch == 0
                EmbedObject.Container{ParameterIndex,1} = ObjectToAdd;
            else
                if(~isempty(find(EmbedObject.TmpIndex{EmbedObject.SwapPointer,2} == ParameterIndex)))
                    %swap pointer current - save to memory
                    EmbedObject.Container{ParameterIndex,1} = ObjectToAdd;
                else
                    % save current swap block
                    save((EmbedObject.TmpIndex{EmbedObject.SwapPointer,1}),'EmbedObject');
                    for mm = EmbedObject.TmpIndex{EmbedObject.SwapPointer,2}
                        EmbedObject.Container{mm,1} = [];
                        EmbedObject.TmpFirstRead(mm,1) = 0;
                    end
                    % Find new SwapPointer
                    for mm=1:EmbedObject.SwapRange
                        if (~isempty(find(EmbedObject.TmpIndex{mm,2} == ParameterIndex)))
                            break
                        end
                    end
                    EmbedObject.SwapPointer = mm;
                    EmbedLoad = load (EmbedObject.TmpIndex{EmbedObject.SwapPointer,1});
                    EmbedObject.Container = EmbedLoad.Container;
                    EmbedObject.Container{ParameterIndex,1} = ObjectToAdd;
                end
            end
            
        
        EmbedObject.DateLastUpdate = datestr(now);
    end
    
    
    function OutputObject = nbt_GetObject(EmbedObject, ParameterValue)
    ParameterIndex = find(EmbedObject.ParameterValue == ParameterValue);
   try
        if EmbedObject.TmpSwitch == 0
            OutputObject = EmbedObject.Container{ParameterIndex,1};
        else
            if(EmbedObject.TmpFirstRead(ParameterIndex,1) == 0)
                if(~isempty(find(EmbedObject.TmpIndex{EmbedObject.SwapPointer,2} == ParameterIndex)))
                    %swap pointer current - save to memory
                    OutputObject = EmbedObject.Container{ParameterIndex,1};
                else
                    % Find new SwapPointer
                    for mm=1:EmbedObject.SwapRange
                        if (~isempty(find(EmbedObject.TmpIndex{mm,2} == ParameterIndex)))
                            break
                        end
                    end
                    EmbedObject.SwapPointer = mm;
                    EmbedLoad = load (EmbedObject.TmpIndex{EmbedObject.SwapPointer,1});
                    EmbedObject.Container = EmbedLoad.Container;
                    OutputObject = EmbedObject.Container{ParameterIndex,1};
                end
            else
                OutputObject = EmbedObject.Container{ParameterIndex,1};
            end
        end
   catch te
        disp('You asked for: ')
        disp('ParameterValue ')
        disp(ParameterValue)
        disp('This EmbedObject contains: ')
        disp(EmbedObject.ParameterValue)
        error('The ParameterValue does not exists')
    end
    end
    
    function nbt_CollectAndSaveEmbedObject(EmbedObject, FileName, ObjectName)
    if EmbedObject.TmpSwitch ~= 0
        for i=1:length(EmbedObject.SwapRange)
            EmbedLoad = load (EmbedObject.TmpIndex{i,1});
            for mm=EmbedObject.TmpIndex{i,2}
                EmbedObject.Container{mm,1} = EmbedLoad.Container{mm,1};
            end
            delete ([EmbedObject.TmpIndex{i,1},'.mat'])
        end
        eval([ObjectName,'=EmbedObject']);
        clear EmbedObject
        eval(['save ',FileName,'.mat ',ObjectName])
    else
        error('You can not collect this EmbedObject, it is not stored on disk)')
    end
    end
    
end



end