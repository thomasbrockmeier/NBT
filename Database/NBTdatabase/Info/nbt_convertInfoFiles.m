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
%
function nbt_convertInfoFiles(startpath)
d = dir(startpath);
for j=3:length(d)
    if (d(j).isdir)
        nbt_convertInfoFiles([startpath filesep  d(j).name ]);
    else
        b  = strfind(d(j).name,'mat');
        cc = strfind(d(j).name,'info');
        
        if (~isempty(b) && ~isempty(cc))
            % here comes the conversion
            oldInfo = load(d(j).name);
            oldInfoFields = fields(oldInfo);
            %First we create the SubjectInfo
            SubjectInfo = nbt_SubjectInfo;
            
            
            SubjectInfo.projectInfo = [oldInfo.(oldInfoFields{1}).projectID '.mat'];
            SubjectInfo.researcherID = oldInfo.(oldInfoFields{1}).researcherID;
            SubjectInfo.subjectID = oldInfo.(oldInfoFields{1}).subjectID;
            SubjectInfo.conditionID = oldInfo.(oldInfoFields{1}).condition;
            SubjectInfo.fileName = oldInfo.(oldInfoFields{1}).file_name;
            SubjectInfo.fileNameFormat = oldInfo.(oldInfoFields{1}).file_name_format;
            SubjectInfo.dateOfRecording = oldInfo.(oldInfoFields{1}).time_of_recording;
            SubjectInfo.notes = oldInfo.(oldInfoFields{1}).notes;
            SubjectInfo.subjectGender = oldInfo.(oldInfoFields{1}).subject_gender;
            SubjectInfo.subjectAge = oldInfo.(oldInfoFields{1}).subject_age;
            SubjectInfo.subjectHeadsize = oldInfo.(oldInfoFields{1}).subject_headsize;
            SubjectInfo.subjectHandedness = oldInfo.(oldInfoFields{1}).subject_handedness;
            SubjectInfo.subjectMedication = oldInfo.(oldInfoFields{1}).subject_medication;
            SubjectInfo.info = oldInfo.(oldInfoFields{1}).Info;
            SubjectInfo.lastUpdate = oldInfo.(oldInfoFields{1}).LastUpdate;
            [~, SubjectInfo.listOfBiomarkers] = nbt_extractBiomarkers([d(j).name(1:end-8) 'analysis.mat']);%load from analysis
            
            
            
            
            
            %then we create the SignalInfo objects
            for i=1:length(oldInfoFields)
                
                
            end
            
            
            
            
            
            
            
            
            
            
            
            
        end
    end
end
end