%The method defines new groups. If called with empty input the
%defineGroupGUI is called.
function GrpObj=defineGroup(GrpObj)
if(isempty(GrpObj))
     GrpObj = nbt_Group;
     GUIswitch = 1;
end
%First we load information about the content of the database
[InfoCell, GrpObj,FileInfo] = getInfo(GrpObj);

if(GUIswitch)
    GrpObj = defineGroupGUI(GrpObj, InfoCell);
end

%Populate empty fields from InfoCell
if(isempty(GrpObj.projectID))
    GrpObj.projectID = InfoCell{1,2};
end
if(isempty(GrpObj.subjectID))
   GrpObj.subjectID = InfoCell{2,2}; 
end
if(isempty(GrpObj.conditionID))
   GrpObj.conditionID = InfoCell{4,2}; 
end
if(isempty(GrpObj.gender))
   GrpObj.gender = InfoCell{5,2};
end
if(isempty(GrpObj.age))
   GrpObj.age = InfoCell{6,2};
end

% if File based generate FileList
if(strcmp(GrpObj.databaseType,'File'))
    GrpObj = generateFileList(GrpObj,FileInfo);
end
end