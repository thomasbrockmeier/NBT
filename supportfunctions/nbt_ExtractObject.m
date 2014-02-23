function ObjectList=nbt_ExtractObject(objectname)
ObjectList = cell(0,0);
s=evalin('caller','whos');
for ii=1:length(s)
    if(strcmp(s(ii).class,objectname))
        ObjectList = [ObjectList, s(ii).name];
    end
end
end