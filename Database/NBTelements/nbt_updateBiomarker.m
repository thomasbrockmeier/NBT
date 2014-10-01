function nbt_updateBiomarker(startpath, NBTelementBasePath, BiomarkerName, NBTelementName)
load(NBTelementBasePath)

eval(['ElementID = ' NBTelementName '.ElementID;'])

eval(['clear(''' NBTelementName ''')']) %we delete the NBTelement we have.

FileList = nbt_ExtractTree(startpath,'mat','analysis');


for i=1:length(FileList)
    load(FileList{1,i}) %load analysis file
    disp(FileList{1,i})
    BiomarkerList = nbt_ExtractBiomarkers; % build biomarker list, we need this to delete biomarkers afterwards
    
    
    eval(['FreqRange = ' BiomarkerName '.FrequencyRange;'])
    if(~isempty(FreqRange))
        FreqRange = {int2str(FreqRange)};
    end
    eval(['SubjectID = ' BiomarkerName '.SubjectID;'])
    if(~isempty(SubjectID))
        addflag = ~exist(NBTelementName,'var');
        if(addflag)
            if(~isempty(FreqRange))
                eval([NBTelementName '= nbt_NBTelement(' int2str(ElementID) ',''' int2str(ElementID) '.3.2.1'', 3);'])
            else
                eval([NBTelementName '= nbt_NBTelement(' int2str(ElementID) ',''' int2str(ElementID) '.2.1'', 2);'])
            end
        end
        
        %set data in NBTelements
        % update Subject with new subject
        
        eval(['Subject = nbt_SetData(Subject,' BiomarkerName '.SubjectID,[]);']);
        % update Condition
        eval(['Condition = nbt_SetData(Condition,{' BiomarkerName '.Condition},{Subject,'  BiomarkerName '.SubjectID});']);
        
        % Add frequency band if relevant
        
        if(~isempty(FreqRange))
            eval(['FrequencyBand = nbt_SetData(FrequencyBand,FreqRange,{Condition,' BiomarkerName '.Condition; Subject,'   BiomarkerName '.SubjectID});']);
        end
        
        %Create the Data cell
        eval(['NumBiomarkers = length(' BiomarkerName '.Biomarkers);']);
        if(NumBiomarkers ~=0)
            for dd = 1:NumBiomarkers
                eval( ['DataString = nbt_cellc(' BiomarkerName '.Biomarkers,dd);']);
                eval(['Data{dd,1} = ' BiomarkerName '.' DataString ';']);
                eval([NBTelementName '.Biomarkers{ dd ,1} = DataString; '])
            end
            if(isempty(FreqRange))
                eval([NBTelementName ' = nbt_SetData(' NBTelementName ', Data, {Condition,' BiomarkerName '.Condition; Subject,'   BiomarkerName '.SubjectID});']);
            else
                eval([NBTelementName ' = nbt_SetData(' NBTelementName ', Data, {FrequencyBand, FreqRange; Condition,' BiomarkerName '.Condition; Subject,'   BiomarkerName '.SubjectID});']);
            end
            clear Data
        end
    end
end
% delete BiomarkerList..
cellfun(@clear,BiomarkerList);

s = whos;
for ii=1:length(s)
    if(~strcmp(s(ii).class,'nbt_NBTelement') && ~strcmp(s(ii).name,'s') && ~strcmp(s(ii).name,'NBTelementBasePath'))
        clear([s(ii).name])
    end
end
clear s
clear ii


%save(NBTelementBasePath)
save('NBTelementBase.mat' )
end