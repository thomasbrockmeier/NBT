% nbt_WindowMarker - 
%
% Usage:
%   WindowMarker = nbt_WindowMarker(BiomarkerObject, BiomarkerFuncHandle,
%   varargin )
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
% Originally created by Simon-Shlomo Poil (2008), see NBT website (http://www.nbtwiki.net) for current email address
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


classdef nbt_WindowMarker < nbt_Biomarker
    %% OscBobject class constructor
    % OscBursts(NumSubjects, NumChannels) - Creates a Oscillation Bursts object for 'NumSubjects' number of
    % subjects, and 'NumChannels' numbers of channels
    %% Copyright (c) 2008, Simon-Shlomo Poil (Center for Neurogenomics and Cognitive Research (CNCR), VU University Amsterdam)
    %% ChangeLog - remember to set NBTversion property
    %$ Version 1.0 - 22 June 2009 : Modified by Simon-Shlomo Poil, simonshlomo.poil@cncr.vu.nl$
    % Implementing new matlab object structure.
    
    properties
        BiomarkerObject
        BiomarkerFuncHandle
        BiomarkerOptions
        MarkerValue
    end
    
    methods
        function WindowMarker = nbt_WindowMarker(BiomarkerObject, BiomarkerFuncHandle, varargin )
            WindowMarker.BiomarkerObject = BiomarkerObject;
            WindowMarker.BiomarkerFuncHandle = BiomarkerFuncHandle;
            WindowMarker.BiomarkerOptions = varargin;
            
            WindowMarker.MarkerValue = cell(1,1);
            
        end
        
        function WMobject = nbt_FindWindowMarker(WMobject,NBTSignal, SignalInfo, WindowSize, WindowMethod)
            
            
            % define marker, window size, window type, channels, subject
            % do windowing and sent to algorithm, return,
            % find marker value, store in cell
            
            MasterSignal = NBTSignal.Signal;
                  
            %method 'hard'
            Interval = [1 WindowSize];
            MarkerValueContainer = nan(floor(length(MasterSignal)/WindowSize),size(MasterSignal,2)); %(number of windows, number of channels)
            
            for i=1:floor(length(MasterSignal)/WindowSize)
                tic
                NBTSignal.Signal = MasterSignal.Signal(Interval(1):Interval(2),:);
                % call biomarker function
                 TempObject = WMobject.BiomarkerFuncHandle(WMobject.BiomarkerObject, NBTSignal, SignalInfo, WMobject.BiomarkerOptions{:});
                 
                 TempContainer = TempObject.(TempObject.PrimaryBiomarker);
                 MarkerValueContainer(i,:) = TempContainer;
                Interval = Interval + WindowSize;
                toc
            end
            
            WMobject.MarkerValue{1,1} = MarkerValueContainer;
            
        end
    end
    
    
end
