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
        FileInfo_index(:,3)=FileInfo_index(:,3)+strcmp(GrpObj.ProjectID(counter),dingus(:,3));
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
        FileInfo_index(:,7)=FileInfo_index(:,7)+(cell2mat(FileInfo(:,7))== str2double(cell2mat(GrpObj.Age(counter))));
    end
else
    FileInfo_index(:,7)=ones(size(FileInfo_index(:,7)));
end
SelFiles=find(FileInfo_index(:,2).*FileInfo_index(:,3).*FileInfo_index(:,4).*FileInfo_index(:,6).*FileInfo_index(:,7));
icounter = 0;
disp('NBT is sorting the files...')
%Here we check if the analysis files exists
for j = 1:length(SelFiles)
    for i = startindex:length(d)
        if strcmp(d(i).name,cell2mat(FileInfo(SelFiles(j),1)))
            d(i).path = path;
            group_name = get(text_ui8,'String');
            d(i).group_name = group_name;
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