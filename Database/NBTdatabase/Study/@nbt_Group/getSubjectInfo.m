% This method returns an InfoCell which, e.g., can be used to fill the boxes in the
% defineGroup GUI.
function [InfoCell, BioCell, IdentCell,GrpObj, FileInfo] = getSubjectInfo(GrpObj)
%First we determine which database is used.
switch GrpObj.databaseType
    case 'NBTelement' %NBTelement database in base.
        %Any Elements loaded?
        s = evalin('base', 'whos');
        k = 0;
        for i = 1:length(s)
            if strcmp(s(i).class,'nbt_NBTelement');
                k= k+1;
                flds{k} = s(i).name;
            end
        end
        if k==0
            try
                disp('Loading NBTelementBase.mat...please wait...')
                evalin('base', 'load(''NBTelementBase.mat'')');
            catch % in the case the NBTelement database does not exist
                disp('NBTeleementBase.mat not found...generating...')
                disp('NBT: Assuming your data is in current directory: importing from current directory')
                nbt_importGroupInfos(pwd); %import data to NBTelements
                nbt_pruneElementTree;      %prune elements with only one level
                evalin('base', 'load(''NBTelementBase.mat'')');
            end
            s = whos('-file','NBTelementBase.mat');
            m = 1;
            for i = 1:length(s)
                if(strcmp(s(i).class, 'nbt_NBTelement'))
                    flds{m} = s(i).name;
                    m = m+1;
                end
            end
        end
        
        for i = 1:length(flds)
            index(i) = evalin('base',[flds{i} '.ElementID';]);
        end
        
        [~, inds] = sort(index);
        
        %InfoCell = cell(length(inds),2);
        k = 0;
        n = 0;
        m = 0;
        for i = 1:length(inds)
            if evalin('base',[flds{inds(i)} '.Identifier';])
                m= m+1;
                IdentCell{m,1} = flds{inds(i)};
                IdentCell{m,2} = evalin('base',[flds{inds(i)} '.Data';]);
            else
                bios = evalin('base',[flds{inds(i)} '.Biomarkers';]);
                if isempty(bios);
                    k= k+1;
                    InfoCell{k,1} = flds{inds(i)};
                    InfoCell{k,2} = evalin('base',[flds{inds(i)} '.Data';]);
                else
                    for j = 1:length(bios)
                        n = n+1;
                        BioCell{n} = [flds{inds(i)} '.' bios{j}];
                    end
                end
            end
        end
    case 'File' %File based database.
        disp('This part does not work yet')
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

end