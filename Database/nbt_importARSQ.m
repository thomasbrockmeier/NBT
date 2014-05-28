function nbt_importARSQ(filename,SignalInfo, SaveDir)

%filename should be "*_analysis.mat"
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

ARSQData = nbt_importCSV([filename '.csv'],1,56,formatSpec);

%% Populate the ARSQ biomarker
rsq = nbt_ARSQ;
%Questions
for i=1:(size(ARSQData,1)-2)
    IndQ=strfind(ARSQData{i,1},'"');
    rsq.Questions{i,1} = ARSQData{i,1}(IndQ(3)+1:IndQ(4)-1);
end
%Answers 
AnswerPos = size(ARSQData,1);
for i=1:(size(ARSQData,2))
   rsq.Answers{i,1} = ARSQData{AnswerPos,i};
end

rsq = nbt_UpdateBiomarkerInfo(rsq, SignalInfo);
nbt_SaveClearObject('rsq', SignalInfo, SaveDir)
end