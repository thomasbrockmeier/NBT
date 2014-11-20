function nbt_importSubjectInfo(infoPath, XLSfilename, subjectIDcolumn, importParameters)
%import XLS file
[dummy,dummy,rawXLS] = xlsread(XLSfilename);
%generate SubjectID index
ii = 1;
SubjectIDList = nan(size(rawXLS,1)-1,1);
for i=2:size(rawXLS,1)
    SubjectIDList(ii) = rawXLS{i,subjectIDcolumn};
    ii= ii+1;
end
subjectsMissing = [];
subjectsAdded = [];

fileTree = nbt_ExtractTree(infoPath, 'mat', 'info');
for m = 1:length(fileTree)
    clear SubjectInfo
    disp(['Importing subject info from ' fileTree{1,m} ])
    load(fileTree{1,m},'SubjectInfo')
    subjectIndex = find(SubjectIDList == SubjectInfo.subjectID)+1;
    if (length(subjectIndex) ~=1)
       subjectsMissing = [subjectsMissing; SubjectInfo.subjectID];
       disp('Subject not found or subject numbers not correct, in:') 
       disp(fileTree{1,m});
        for ip = 1:size(importParameters,1)
            SubjectInfo.info.(importParameters{ip,1}) = nan(1,1);
        end
    else
        subjectsAdded = [subjectsAdded; SubjectInfo.subjectID];
        for ip = 1:size(importParameters,1)
            SubjectInfo.info.(importParameters{ip,1}) = rawXLS{subjectIndex,importParameters{ip,2}};
        end
    end
    save(fileTree{1,m},'SubjectInfo','-append')
end
disp('Following subjects were missing or do not have consistent IDs')
disp(unique(subjectsMissing));
disp('Following subjects had infomation added successfully')
disp(unique(subjectsAdded));
  
end