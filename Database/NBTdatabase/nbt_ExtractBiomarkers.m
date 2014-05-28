function [BiomarkerObjects,Biomarkers]=nbt_ExtractBiomarkers(s)
BiomarkerObjects = cell(0,0);
error(nargchk(0,1,nargin))
if(~exist('s','var'))
    s=evalin('caller','whos');
  counter=1;
for ii=1:length(s)
    if(strcmp(superclasses(s(ii).class),'nbt_Biomarker')) 
        BiomarkerObjects = [BiomarkerObjects, s(ii).name];
        Biomarkers{counter}=evalin('caller',[s( ii ).name,'.Biomarkers']);
        counter=counter+1;
    end
end
    
else
    load(s)
    s = whos;
      counter=1;
      
% temporary adjustement
for ii=1:length(s)
    if(strcmp(superclasses(s(ii).class),'nbt_Biomarker')) & ~strcmp(s(ii).class,'nbt_ARSQ')
        BiomarkerObjects = [BiomarkerObjects, s(ii).name];
        Biomarkers{counter}=eval([s( ii ).name,'.Biomarkers']);
        counter=counter+1;
    elseif (strcmp(superclasses(s(ii).class),'nbt_Biomarker')) & strcmp(s(ii).class,'nbt_ARSQ')
        BiomarkerObjects = [BiomarkerObjects, s(ii).name];
        Biomarkers{counter}={'Answers'};
        counter=counter+1;
        
    end
end
end


end