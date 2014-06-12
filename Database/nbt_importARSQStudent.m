function nbt_importARSQStudent(filename, SignalInfo, SaveDir)

ARSQData = importdata([filename '.csv']);
rsq = nbt_ARSQ(68);
%% Populate the ARSQ 
%Normal ARSQ
if(size(ARSQData.textdata,2) > 20)
    %Questions
    for i=1:(size(ARSQData.textdata,2))
        IndQ=strfind(ARSQData.textdata{i,1},'"');
        rsq.Questions{i,1} = ARSQData.textdata{i,1}(IndQ(1)+1:IndQ(2)-1);
    end
    %Answers 
    for i=1:(size(ARSQData.textdata,2))
        rsq.Answers(i,1) = ARSQData.data(i)+1;
    end
else %PLN task
    PLNIndex = [1:15 17:19];
    ARSQIndex = [11 1 21 2 4 24 14 15 6 17 51 20 8 9 52 56 57 58];
    for i=1:15
        IndQ = strfind(ARSQData.textdata{PLNIndex(i),1},'"');
        rsq.Questions{ARSQIndex(i),1} = ARSQData.textdata{PLNIndex(i),1}(IndQ(1)+1:IndQ(2)-1);
        rsq.Answers(ARSQIndex(i),1) = ARSQData.data(PLNIndex(i))+1;
    end
end 
%Add factors
tmpQ = rsq.Answers;
rsq.Questions{59,1} = 'Discontnuity of Mind';
rsq.Questions{60,1} = 'Theory of Mind';
rsq.Questions{61,1} = 'Self';
rsq.Questions{62,1} = 'Planning';
rsq.Questions{63,1} = 'Sleepiness';
rsq.Questions{64,1} = 'Comfort';
rsq.Questions{65,1} = 'Somatic Awareness';
rsq.Questions{66,1} = 'Health Concern';
rsq.Questions{67,1} = 'Visual Thought';
rsq.Questions{68,1} = 'Verbal Thought';
rsq.Answers(59,1) = nanmedian(tmpQ([1,11,21]));
rsq.Answers(60,1) = nanmedian(tmpQ([2,12,22]));
rsq.Answers(61,1) = nanmedian(tmpQ([3,13,23]));
rsq.Answers(62,1) = nanmedian(tmpQ([4,14,24]));
rsq.Answers(63,1) = nanmedian(tmpQ([5,15,25]));
rsq.Answers(64,1) = nanmedian(tmpQ([6,16,26]));
rsq.Answers(65,1) = nanmedian(tmpQ([7,17,27]));
rsq.Answers(66,1) = nanmedian(tmpQ([10,20,30]));
rsq.Answers(67,1) = nanmedian(tmpQ([8,18,28]));
rsq.Answers(68,1) = nanmedian(tmpQ([9,19,29]));

rsq = nbt_UpdateBiomarkerInfo(rsq, SignalInfo);
nbt_SaveClearObject('rsq', SignalInfo, SaveDir)
end