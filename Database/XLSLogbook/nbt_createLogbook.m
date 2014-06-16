% Will create standard NBT XLSlogbook
%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2014), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2012 Simon-Shlomo Poil
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
% ---------------------------------------------------------------------------------------

function nbt_createLogbook(ProjectInfo)

% Create general stucture
GenStruct = {'Logbook';' ';'Recording #'; 'Project information'; 'ProjectID'; 'ResearcherID'; 'Date'; 'Start time'; 'End time'; '   '; 'Subject information'; 'Name (optional)'; 'SubjectID';'Gender';'Age';'Handedness';'Mother tongue';'Informed consent signed';'Energy drink number'; '   ';'Acquisition settings'; 'EEG Lab'; 'Folder name';'Acquisition template'; 'ARSQ version';'Sampling rate';'Filter settings'; 'High impedance channels';'EGI EEG-net ID';'Earplugs';'   '; 'Sessions' };
ConditionIDs = fieldnames(ProjectInfo.Info.ProjectInfo.condition);
for CID = 1:length(ConditionIDs)
   GenStruct{length(GenStruct)+1,1} = ['Condition ' int2str(CID)];
   GenStruct{length(GenStruct)+1,1} = 'Description';
   GenStruct{length(GenStruct)+1,1} = 'EEG file name';
   GenStruct{length(GenStruct)+1,1} = 'ARSQ name';
   GenStruct{length(GenStruct)+1,1} = 'ARSQ Completion time';
   GenStruct{length(GenStruct)+1,1} = 'Remarks';
end
xlwrite('NBTLogbook.xls', GenStruct,1,'A1');

% Import data from external sources
% call to nbt_importFromXLS (Return populated ProjectInfo)
%ProjectInfo = nbt_Info.importSubjectInfoFromCSV('HNcourse2014_Screening - Sheet1.csv',ProjectInfo);
%Populate sheet.
for SID = 1:30%length(ProjectInfo.Info.SubjectInfo)
ImportStruct{1,SID} = ProjectInfo.projectID;
%ImportStruct{9,SID} = ProjectInfo.Info.SubjectInfo(SID).subjectID;
%ImportStruct{11,SID} = ProjectInfo.Info.SubjectInfo(SID).subject_age;
%ImportStruct{12,SID} = ProjectInfo.Info.SubjectInfo(SID).subject_handedness;
RandomDrink=randperm(2);
ImportStruct{15,SID} = RandomDrink(1);
Cindex = 13+15;
%Add conditions from ProjectInfo
for CID=1:length(ConditionIDs)
    ImportStruct{Cindex+1,SID} = ConditionIDs{CID};
    ImportStruct{Cindex+2,SID} = ProjectInfo.Info.ProjectInfo.condition.(ConditionIDs{CID});
    Cindex = Cindex+2+4;
end
end
xlwrite('NBTLogbook.xls', ImportStruct,1,'B5');


end