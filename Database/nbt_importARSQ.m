function nbt_importARSQ(filename,BiomarkerName, SignalInfo, SaveDir)

ARSQData = importdata([filename '.csv']);

%% Populate the ARSQ biomarker
eval([BiomarkerName ' = nbt_ARSQ;']);
%Questions
for i=1:(size(ARSQData.textdata,2))
    IndQ=strfind(ARSQData.textdata{i,1},'"');
   eval([BiomarkerName '.Questions{i,1} = ARSQData.textdata{i,1}(IndQ(1)+1:IndQ(2)-1);']);
end
%Answers 
for i=1:(size(ARSQData.textdata,2))
   eval([BiomarkerName '.Answers{i,1} = ARSQData.data(i)+1;']);
end

%Add factors

eval([BiomarkerName ' = nbt_UpdateBiomarkerInfo(' BiomarkerName ', SignalInfo);']);
nbt_SaveClearObject(BiomarkerName, SignalInfo, SaveDir)
end