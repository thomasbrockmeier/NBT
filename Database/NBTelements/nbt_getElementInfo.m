function nbt_getElementInfo(NBTelementBase,ElementID)
if(strcmp(NBTelementBase,'base'))
    NBTelementList = evalin('base', 'nbt_ExtractObject(''nbt_NBTelement'')');
else
    load(NBTelementBase)
    NBTelementList = nbt_ExtractObject('nbt_NBTelement');
end

for i=1:length(NBTelementList)
    NBTelement = eval(NBTelementList{1,i});
   if(NBTelement.ElementID == ElementID)
       disp([num2str(ElementID) ' : ' NBTelementList(i)])
   end
end
end