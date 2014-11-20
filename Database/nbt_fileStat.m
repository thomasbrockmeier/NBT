function nbt_fileStat(infoPath)

fileTree = nbt_ExtractTree(infoPath,'mat','info');

disp('File statistics for:')
disp(infoPath)
disp(['Number of info files: ' num2str(length(fileTree))])
[projectID, fileTree] = strtok(fileTree,'.'); 
projectID = unique(projectID);
disp(['Number of projects: ' num2str(length(projectID))])
[subjectID,fileTree] = strtok(fileTree,'.');
subjectID = unique(subjectID);
disp(['Number of subjects: ' num2str(length(subjectID))])
[dummy, fileTree] = strtok(fileTree,'.');
[conditionID, fileTree] = strtok(fileTree,'.');
[conditionID] = strtok(conditionID,'_');
uniqueConditionID = unique(conditionID);
disp(['Number of unique conditions: ' num2str(length(uniqueConditionID))])
for m=1:length(uniqueConditionID)
   disp(['Number of files in ' uniqueConditionID{1,m} ': ' num2str(length(nbt_searchvector(conditionID,uniqueConditionID(1,m))))]) 
end



end