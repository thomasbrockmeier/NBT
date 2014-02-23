function nbt_AddSubjectInfo(NBTelementBasePath, SubjectList, NBTelementName, ValueList)
load(NBTelementBasePath)
NextID = size(who,1)+1;

eval([ NBTelementName '= nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.1'', 1);'])

eval([ NBTelementName '= nbt_SetData(' NBTelementName ', ValueList , {Subject,SubjectList});'])
clear SubjectList
clear ValueList
clear NBTelementName
clear NextID

save(NBTelementBasePath)
end