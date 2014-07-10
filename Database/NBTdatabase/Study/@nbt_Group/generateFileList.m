function GrpObj=generateFileList(GrpObj,FileInfo)
%This function will generate the FileList based on parameters in the
%nbt_Group Object.

if(isempty(FileInfo))
   FileInfo=getFileInfo(GrpObj); 
end

FileInfo_index=zeros(size(FileInfo));
if ~isempty(GrpObj.ConditionID)
    for counter=1:numel(GrpObj.ConditionID)
        FileInfo_index(:,2)=FileInfo_index(:,2)+strcmp(GrpObj.ConditionID(counter),FileInfo(:,2));
    end
end
if ~isempty(GrpObj.ProjectID)
    for counter=1:numel(GrpObj.ProjectID)
        FileInfo_index(:,3)=FileInfo_index(:,3)+strcmp(GrpObj.ProjectID(counter),FileInfo(:,3));
    end
end
if ~isempty(GrpObj.SubjectID)
    for counter=1:numel(GrpObj.SubjectID)
        FileInfo_index(:,4)=FileInfo_index(:,4)+strcmp(GrpObj.SubjectID(counter),FileInfo(:,4));
    end
end
if ~isempty(GrpObj.Gender)
    for counter=1:numel(GrpObj.Gender)
        FileInfo_index(:,6)=FileInfo_index(:,6)+strcmp(GrpObj.Gender(counter),FileInfo(:,6));
    end
else
    FileInfo_index(:,6)=ones(size(FileInfo_index(:,6)));
end
if ~isempty(GrpObj.Age)
    for counter=1:numel(GrpObj.Age)
        FileInfo_index(:,7)=FileInfo_index(:,7)+(cell2mat(FileInfo(:,7))== GrpObj.Age(counter));
    end
else
    FileInfo_index(:,7)=ones(size(FileInfo_index(:,7)));
end
SelFiles=find(FileInfo_index(:,2).*FileInfo_index(:,3).*FileInfo_index(:,4).*FileInfo_index(:,6).*FileInfo_index(:,7));
icounter = 0;
disp('NBT is sorting the files...')
%Here we check if the analysis files exists
%--- scan files in the folder
%--- for files copied from a mac
startindex = 0;
d = dir(GrpObj.DatabaseLocation);
for i = 1:length(d)
    if  d(i).isdir || strcmp(d(i).name(1),'.') || strcmp(d(i).name(1:2),'..') || strcmp(d(i).name(1:2),'._')
        startindex = i+1;
    end
end
for j = 1:length(SelFiles)
    for i = startindex:length(d)
        if strcmp(d(i).name,cell2mat(FileInfo(SelFiles(j),1)))
            icounter = icounter +1;
            SelectedFiles(icounter) = d(i);
            break; %no reason to look more
        else
            if(i == length(d))
                %we did not find the analysis file; issue a
                %warning
                warning(['The analysis file ' cell2mat(FileInfo(SelFiles(j),1)) ' was not found']);
            end
        end
    end
end

GrpObj.FileList = SelectedFiles;
end