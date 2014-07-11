% This method returns an InfoCell which, e.g., can be used to fill the boxes in the
% defineGroup GUI.
function [InfoCell, GrpObj, FileInfo]=getInfo(GrpObj)
%First we determine which database is used.
switch GrpObj.databaseType 
    case 'NBTelement' %NBTelement database in base.
        try
            readconditions = evalin('base', 'Condition.Data');
        catch %in the case the NBTelement database is not loaded
            try
                evalin('base', 'load(''NBTelementBase.mat'')');
            catch % in the case the NBTelement database does not exist
                nbt_importBiomarkers
                evalin('base', 'load(''NBTelementBase.mat'')');
            end
            readconditions = evalin('base', 'Condition.Data');
        end
        SubjList = evalin('base', 'Subject.Data');
        readproject = evalin('base', 'Project.Data');
        readgender=evalin('base','Gender.Data');
        readage=evalin('base','Age.Data');
        readdate = evalin('base','Date.Data');
        
        readsubject = cell(length(SubjList),1);
        for mm=1:length(SubjList);
            readsubject{mm} = SubjList(mm);
        end
        
        %Populate Biomarkers
        s=evalin('base','whos');
        FreqBands = evalin('base', 'FrequencyBand.Data');
        counter =0;
        for ii=1:length(s)
            if(strcmp(s(ii).class,'nbt_NBTelement'))
                NBTe = evalin('base',s(ii).name);
                if(~isempty(NBTe.Biomarkers))
                    if(NBTe.Uplink == 4)
                        for fb = 1:length(FreqBands)
                            counter = counter+1;
                            biomarker_objects{counter} = [s(ii).name '.' FreqBands{1,fb}];
                            biomarkers{counter} = NBTe.Biomarkers;
                        end
                    else
                        counter = counter+1;
                        biomarker_objects{counter} = s(ii).name;
                        biomarkers{counter} = NBTe.Biomarkers;
                    end
                end
            end
        end
        FileInfo = [];
    case 'File' %File based database.
        [FileInfo, GrpObj] = getFileInfo(GrpObj);
        readconditions = unique(FileInfo(:,2));
        readproject = unique(FileInfo(:,3));
        readsubject = unique(FileInfo(:,4));
        readdate = unique(FileInfo(:,5));
        
        temp=FileInfo(:,6);
        emptyCells = cellfun(@isempty,temp);
        temp(emptyCells) = [];
        readgender=unique(temp);
        
        temp=FileInfo(:,7);
        emptyCells = cellfun(@isempty,temp);
        temp(emptyCells) = [];
        readage=unique(cell2mat((temp)));
        [biomarker_objects,biomarkers] = nbt_extractBiomarkers([GrpObj.databaseLocation filesep FileInfo{1,1}]);
end


%Contruct InfoCell
InfoCell = cell(6,2);
InfoCell{1,1} = 'ProjectID';
InfoCell{1,2} = readproject;
InfoCell{2,1} = 'SubjectID';
InfoCell{2,2} = readsubject;
InfoCell{3,1} = 'time_of_recording';
InfoCell{3,2} = readdate;
InfoCell{4,1} = 'ConditionID';
InfoCell{4,2} = readconditions;
InfoCell{5,1} = 'Gender';
InfoCell{5,2} = readgender;
InfoCell{6,1} = 'Age';
InfoCell{6,2} = readage;

k = 1;
for i = 1:length(biomarker_objects)
    tmp = biomarkers{i};
    for j = 1:length(tmp)
        biom{k} = [biomarker_objects{i} '.' tmp{j}];
        k = k+1;
    end
end
GrpObj.Biomarker = biom(:);
end