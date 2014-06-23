function [InfoCell, GrpObj, FileInfo]=getInfo(GrpObj)
% Return an InfoCell which, e.g., can be used to fill the boxes in the
% defineGroup GUI.

switch GrpObj.DatabaseType
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
        
        for mm=1:length(SubjList);
            readsubject{mm} = SubjList(mm);
        end 
        FileInfo = [];
    case 'File' %File based database.
        [FileInfo, GrpObj] =getFileInfo(GrpObj);
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
end