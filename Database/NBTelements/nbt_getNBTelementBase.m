

%add this to the top of your file
nbt_NextID = 0;
s=evalin('caller','whos');
for ii=1:length(s)
    if(strcmp(s(ii).class,'nbt_NBTelement'))
        nbt_NextID = nbt_NextID +1;
         eval([ 'NBTelementName  = evalin(''caller'', ''' s(ii).name ''');'])
         eval([ NBTelementName.name '= NBTelementName'])
    end
end






