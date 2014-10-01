%We assume the NBTelementBase has been loaded

%First we find the structure of the database.
NBTelementList =  nbt_ExtractObject('nbt_NBTelement');
    %generate list for gui
    
    elementlist = NBTelementList{1,1};
    if(size(NBTelementList,2)>1)
    for i=2:size(NBTelementList,2)
        elementlist = [ elementlist '|' NBTelementList{1,i}];
    end
    end
    

%Ask user to select which NBTelement to get
[res userdata err structout] = inputgui( 'geometry', { [1 2] }, ...
    'geomvert', [10], 'uilist', { ...
    { 'style', 'text', 'string', [ 'NBTelements:' 10 10 ] }, ...
    { 'style', 'listbox', 'string', elementlist 'tag' 'choice' } }, 'title', 'NBT - NBTdatabase' );

%give info about parent
OutElement = eval(NBTelementList{1,res{1,1}});
for i=1:length(NBTelementList)
    NBTelement = eval(NBTelementList{1,i});
   if(NBTelement.ElementID == OutElement.Uplink)
       disp('You selected:');
       disp(NBTelementList(res{1,1}));
       disp('Which is a child of:');
       disp(NBTelementList(i))
   end
end

%ask for conditions
