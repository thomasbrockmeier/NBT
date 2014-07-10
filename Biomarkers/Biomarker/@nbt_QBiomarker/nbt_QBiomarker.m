% nbt_QBiomarker(NumChannels) - Creates a Q biomarker object - this is the
% basic NBT biomarker object for questionaire or behavioural data.

%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2014), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2014 Simon-Shlomo Poil  (Neuronal Oscillations and Cognition group, 
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
% -


classdef nbt_QBiomarker < nbt_CoreBiomarker
    properties
    end
    methods
        function BiomarkerObject = nbt_QBiomarker()
        end
        
        function biomarkerObject=nbt_UpdateBiomarkerInfo(biomarkerObject, subjectInfo)
            biomarkerObject.lastUpdate = datestr(now);
            [~, biomarkerObject.nbtVersion] = nbt_getVersion;
            biomarkerObject.subjectInfo = subjectInfo;
        end
    end 
end
