function nbt_CreateDDiag(NBTelementBasePath, SubjectList, DDiagList, MatchList)
load(NBTelementBasePath)
NextID = size(who,1)+1;

DDiagListNew = nan(length(DDiagList),1);
if(exist('MatchList','var')) % then we dynamically create the DDiagList
    for i=1:length(DDiagList)
       for mm=1:length(MatchList)
           if(strcmpi(MatchList{mm,1}, DDiagList{i,1}))
               DDiagListNew(i) = mm;
           end
       end
    end
end
DDiagList = DDiagListNew';
SubjectList = nbt_GetData(Subject, {Subject,[]});

eval(['DDiag = nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.1'', 1);'])

DDiag = nbt_SetData(DDiag, DDiagList , {Subject,SubjectList});
clear SubjectList
clear DDiagList
clear DDiagListNew
clear NextID
DDiag.Info = MatchList;
clear MatchList
clear i
clear mm

save(NBTelementBasePath)
end