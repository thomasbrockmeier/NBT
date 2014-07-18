%% SubjectInfo object class constructor
% SubjectInfo = nbt_SubjectInfo
%
% See also:
%   nbt_CreateInfoObject

%--------------------------------------------------------------------------
% Copyright (C) 2014 Simon-Shlomo Poil
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
%--------------------------------------------------------------------------


classdef nbt_SubjectInfo
    properties
        projectInfo
        subjectID
        conditionID
        
        fileName
        fileNameFormat
        lastUpdate
        listOfBiomarkers
        
        info
        %This should contain all other fields that can you can define groups by.  Please use the names given below where possible
        % dateOfRecording
        % subjectGender
        % subjectAge
        % subjectHeadsize
        % subjectHandedness
        % subjectMedication
        % subjectClassification
        % notes
        % researcherID
        
    end
    
    
    methods
        function SubjectInfo = nbt_SubjectInfo
            SubjectInfo.lastUpdate = datestr(now);
            SubjectInfo.info.dateOfRecording = [];
            SubjectInfo.info.subjectGender = [];
            SubjectInfo.info.subjectAge = [];
            SubjectInfo.info.subjectHeadsize = [];
            SubjectInfo.info.subjectHandedness = [];
            SubjectInfo.info.subjectMedication   = [];
            SubjectInfo.info.subjectClassification = [];
            SubjectInfo.info.notes = [];
            SubjectInfo.info.researcherID = [];
        end
    end
    
    methods(Static)
        InfoObject = importSubjectInfoFromXLS;
        InfoObject = importSubjectInfoFromCSV(filename,InfoObject);
    end
end