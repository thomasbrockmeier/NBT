%  Copyright (C) 2010: Simon-Shlomo Poil
function nbt_importGroupInfos(startpath)
if(~exist('startpath','var'))
    startpath = uigetdir(pwd,'Select folder with NBT analysis files');
end

%SubjectInfo properties
%projectInfo
%researcherID
%subjectID
%conditionID
%lastUpdate
%listOfBiomarkers

% load('NBTelementBase.mat')
%NBTelement structure

Project = nbt_NBTelement(1,'1',[]);
Subject = nbt_NBTelement(2, '2.1',1);
Condition = nbt_NBTelement(3,'3.2.1',2);
Signals = nbt_NBTelement(4,'4.3.2.1',3);
% could include last Update

NextID = 5;

%determine tree
FileList = nbt_ExtractTree(startpath,'mat','analysis');

for i=1:length(FileList)
    clear SubjectInfo;
    load([ FileList{1,i}(1:end-12) 'info.mat'],'SubjectInfo') % load info file
    
    signalFields = nbt_extractSignals([ FileList{1,i}(1:end-12) 'info.mat']);
    subjectFields = fields(SubjectInfo.info);
    
    
    for m=1:length(subjectFields)
        % create NBTelement, unless it exists
        NBTelementName = subjectFields{m};
        eval(['NBTelementClass = class(SubjectInfo.info.' NBTelementName ');']);
        eval(['NBTelementData = SubjectInfo.info.' NBTelementName ';']);
        if isempty(NBTelementData)
            NBTelementData = NaN;
        end
        
        addflag = ~exist(NBTelementName,'var');
        if(addflag)
            eval([NBTelementName '= nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.3.2.1'', 3);']);
            NextID = NextID + 1;
        end
        
        Project = nbt_SetData(Project, {SubjectInfo.projectInfo(1:end-4)}, []);
        Subject = nbt_SetData(Subject, SubjectInfo.subjectID, {Project, SubjectInfo.projectInfo(1:end-4)});
        Condition = nbt_SetData(Condition, {SubjectInfo.conditionID}, {Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});
        
        if strcmp(NBTelementClass,'char')
            eval([NBTelementName '= nbt_SetData(' NBTelementName ', {NBTelementData}, {Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});']);
        else
            eval([NBTelementName '= nbt_SetData(' NBTelementName ', NBTelementData, {Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});']);
        end
        
    end
    
    for m = 1:length(signalFields)
         Signals = nbt_SetData(Signals,{signalFields{m}},{Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});
    end
    
end



s = whos;
for ii=1:length(s)
    if(~strcmp(s(ii).class,'nbt_NBTelement') && ~strcmp(s(ii).name,'s'))
        clear([s(ii).name])
    end
end
clear s
clear ii


save NBTelementBase.mat
disp('NBTelements imported')
disp('NBTelementBase.mat saved in')
disp(pwd)
end






