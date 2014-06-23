function GrpObj=defineGroup(GrpObj)
%First we load information about the content of the database
[InfoCell, GrpObj,FileInfo] = getInfo(GrpObj);

if(isempty(GrpObj))
    GrpObj = nbt_Group;
    GrpObj = defineGroupGUI(GrpObj, InfoCell);
end

%Populate empty fields from InfoCell
if(isempty(GrpObj.ProjectID))
    GrpObj.ProjectID = InfoCell{1,2};
end
if(isempty(GrpObj.SubjectID))
   GrpObj.SubjectID = InfoCell{2,2}; 
end
if(isempty(GrpObj.ConditionID)
   GrpObj.ConditionID = InfoCell{4,2}; 
end
if(isempty(GrpObj.Gender))
   GrpObj.Gender = InfoCell{5,2};
end
if(isempty(GrpObj.Age))
   GrpObj.Age = InfoCell{6,2};
end

% if File based generate FileList
if(strcmp(GrpObj.DatabaesType,'File'))
    GrpObj = generateFileList(GrpObj,FileInfo);
end
end