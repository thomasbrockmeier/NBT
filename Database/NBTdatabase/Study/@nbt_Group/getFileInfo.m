function [FileInfo, GrpObj] = getFileInfo(GrpObj)
%This function loads FileInfo
if isempty(GrpObj.databaseLocation)
    GrpObj.databaseLocation = uigetdir([],'Select folder with NBT Signals');
end
path = GrpObj.databaseLocation;
d = dir(GrpObj.databaseLocation);

%--- scan files in the folder
%--- for files copied from a mac
startindex = 0;
for i = 1:length(d)
    if  d(i).isdir || strcmp(d(i).name(1),'.') || strcmp(d(i).name(1:2),'..') || strcmp(d(i).name(1:2),'._')
        startindex = i+1;
    end
end
%---
pro=1;
disp('Please wait: NBT is checking the files in your folder...')
for i = startindex:length(d)
    if isempty(findstr(d(i).name,'analysis')) && ~isempty(findstr(d(i).name,'info')) && ~isempty(findstr(d(i).name(end-3:end),'.mat')) && isempty(findstr(d(i).name,'statistics'))
        index = findstr(d(i).name,'.');
        index2 = findstr(d(i).name,'_');
        
        % Load info file
        Loaded = load([path filesep d(i).name]);
        
        Infofields = fieldnames(Loaded);
        Firstfield = Infofields{1};
        clear Loaded Infofields;
        
        SignalInfo = load([path filesep d(i).name],Firstfield);
        SignalInfo = eval(strcat('SignalInfo.',Firstfield));
        
        %% FileInfo collects data for further selection
        FileInfo(pro,1)= {strcat(d(i).name(1:index2-1),'_analysis.mat')};%contains filename
        FileInfo(pro,2) = {d(i).name(index(3)+1:index2-1)}; %ConditionID
        FileInfo(pro,3) = {d(i).name(1:index(1)-1)}; %ProjectID
        FileInfo(pro,4) = {d(i).name(index(1)+1:index(2)-1)}; %SubjectID
        FileInfo(pro,5) = {d(i).name(index(2)+1:index(3)-1)}; %Recording Date
        
        if ~isempty(SignalInfo.subject_gender)
            FileInfo(pro,6) = {SignalInfo.subject_gender};
        else
            FileInfo(pro,6) = {[]};
        end
        
        if ~isempty(SignalInfo.subject_age)
            if isa(SignalInfo.subject_age,'char')
                FileInfo(pro,7) = {str2num(SignalInfo.subject_age)};
            else
                FileInfo(pro,7) = {SignalInfo.subject_age};
            end
        else
            FileInfo(pro,7) = {[]};
        end
        pro=pro+1;
    end
end
end