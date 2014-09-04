function [ TrainMatrix,  TestMatrix, TrainOutcome, TestOutcome] = nbt_RandomSubsampler( DataMatrix,Outcome,TestLimit,SamplingType )
switch SamplingType
    case 'simple'
            RandSubj = randperm(length(Outcome)); %we make a random permutation of our subjects.
            TrainMatrix = DataMatrix(RandSubj(TestLimit+1:end),:);
            TestMatrix =  DataMatrix(RandSubj(1:TestLimit),:);
            TrainOutcome = Outcome(RandSubj(TestLimit+1:end));
            TestOutcome = Outcome(RandSubj(1:TestLimit));
    case 'stratified' %preserves class balance in training and test sets
        % For more details see Witten, Frank & Hall "Data Mining" page 152
        
        TestMatrix=[];
        TestOutcome=[];
        TrainMatrix=[];
        TrainOutcome=[];
        ClassIds=unique(Outcome);
        for iotta=1:numel(ClassIds)
            ClassIndexes{iotta}=find(Outcome==ClassIds(iotta));
            ClassIndexes{iotta}=ClassIndexes{iotta}(randperm(length(ClassIndexes{iotta})));
            ClassFreq(iotta)=sum(Outcome==ClassIds(iotta))/numel(Outcome);
            TrainMatrix=[TrainMatrix;DataMatrix(ClassIndexes{iotta}(floor(TestLimit*ClassFreq(iotta))+1:end),:)];
            TrainOutcome=[TrainOutcome;Outcome(ClassIndexes{iotta}(floor(TestLimit*ClassFreq(iotta))+1:end))];
            TestMatrix=[TestMatrix;DataMatrix(ClassIndexes{iotta}(1:floor(TestLimit*ClassFreq(iotta))),:)];
            TestOutcome=[TestOutcome;Outcome(ClassIndexes{iotta}(1:floor(TestLimit*ClassFreq(iotta))))];
        end
end

