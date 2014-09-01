%  Copyright (C) 2010: Simon-Shlomo Poil
function nbt_importBiomarkers(startpath)
if(~exist('startpath','var'))
    startpath = uigetdir('C:\','Select folder with NBT analysis files');
end
% load('NBTelementBase.mat')
%NBTelement structure
% 1 > Subject
% 2 > Condition
% 3 > FrequencyBand
% % 4 etc. > Biomarkers
Project = nbt_NBTelement(1,'1',[]);
Subject = nbt_NBTelement(2, '2.1', 1);
Condition = nbt_NBTelement(3, '3.2.1',2);
FrequencyBand = nbt_NBTelement(4,'4.3.2.1',3);
Age = nbt_NBTelement(5, '5.3.2.1', 3);
Gender = nbt_NBTelement(6,'6.2.1', 2);
NextID = 7;

%determine tree
FileList = nbt_ExtractTree(startpath,'mat','analysis');

for i=1:length(FileList)
    load(FileList{1,i}) %load analysis file
    disp(FileList{1,i})
    BiomarkerList = nbt_extractBiomarkers; % build biomarker list
    
    clear SubjectInfo;
    load([ FileList{1,i}(1:end-12) 'info.mat'],'SubjectInfo') % load info file

    

    for m=1:length(BiomarkerList)
        % create NBTelement, unless it exists
        eval(['NBTelementName = class(' BiomarkerList{1,m} ');']);
        try
            eval(['FreqRange = ' BiomarkerList{1,m} '.frequencyRange;'])
            if(size(FreqRange,1)>1)
                FreqRange = [];
            end
        catch
            FreqRange = [];
        end
        
        if(~isempty(FreqRange))
            FreqRange = {int2str(FreqRange)};
        end
        SubjectID = SubjectInfo.subjectID;
        if(~isempty(SubjectID))
            addflag = ~exist(NBTelementName,'var');
            if(addflag)
                if(~isempty(FreqRange))
                    eval([NBTelementName '= nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.4.3.2.1'', 4);'])
                else
                    eval([NBTelementName '= nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.3.2.1'', 3);'])
                end
                NextID = NextID + 1;
            end
            
            %set data in NBTelements
            % update Project with new project
            Project = nbt_SetData(Project, {SubjectInfo.projectInfo(1:end-4)}, []);
            % update Subject with new subject
            Subject = nbt_SetData(Subject, SubjectInfo.subjectID, {Project, SubjectInfo.projectInfo(1:end-4)});
            % update Condition
            Condition = nbt_SetData(Condition, { SubjectInfo.conditionID }, {Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});
            
            % Add frequency band if relevant
            if(~isempty(FreqRange))
                FrequencyBand = nbt_SetData(FrequencyBand, FreqRange, {Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});
            end
            
            %Create the Data cell
            eval(['NumBiomarkers = length(' BiomarkerList{1,m} '.biomarkers);']);
            if(NumBiomarkers ~=0)
                for dd = 1:NumBiomarkers
                    eval( ['DataString = nbt_cellc(' BiomarkerList{1,m} '.biomarkers,dd);']);
                    eval(['Data{dd,1} = ' BiomarkerList{1,m} '.' DataString ';']);
                    eval([NBTelementName '.Biomarkers{ dd ,1} = DataString; '])
                end
                if(isempty(FreqRange))
                    eval([NBTelementName ' = nbt_SetData(' NBTelementName ', Data, {Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID;Project, SubjectInfo.projectInfo(1:end-4)});']);
                else
                    eval([NBTelementName ' = nbt_SetData(' NBTelementName ', Data, {FrequencyBand, FreqRange; Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID;Project, SubjectInfo.projectInfo(1:end-4)});']);
                end
                clear Data
            end
        end
    end
    % delete BiomarkerList..
    cellfun(@clear,BiomarkerList);
    %add Age and Gender
    try
        Age = nbt_SetData(Age, SubjectInfo.subjectAge, {Condition, SubjectInfo.conditionID; Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});
    catch
    end
    try
        Gender = nbt_SetData(Gender, {SubjectInfo.subjectGender}, { Subject, SubjectInfo.subjectID; Project, SubjectInfo.projectInfo(1:end-4)});
    catch
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






