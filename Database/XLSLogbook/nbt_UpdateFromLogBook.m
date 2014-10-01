function nbt_UpdateFromLogBook(Signal, SignalInfo, SignalPath,filenameLogBook,SignalName)
%Update SignalInfo with info from XLSLogbook

%Read LogBook - we assume the projectID is ok for now
try
    [d,d,LogBookData] = xlsread(filenameLogBook);
catch me
    try
        pause(0.5);
        [d,d,LogBookData] = xlsread(filenameLogBook);
    catch me
        try
            pause(0.5);
            [d,d,LogBookData] = xlsread(filenameLogBook);
        catch me
            
            try
                pause(0.5);
                [d,d,LogBookData] = xlsread(filenameLogBook);
            catch me
                
                try
                    pause(0.5);
                    [d,d,LogBookData] = xlsread(filenameLogBook);
                catch me
                end
            end
        end
    end
end

for i=3:2:size(LogBookData,2)
    if(str2num(LogBookData{13,i}(2:end)) == SignalInfo.subjectID)
        %ok we found the subject - read info
        SignalInfo.researcherID = LogBookData{6,i};
        SignalInfo.subject_age = LogBookData{15,i};
        SignalInfo.subject_gender = LogBookData{14 ,i};
        SignalInfo.subject_handedness = LogBookData{16,i};
        SignalInfo.subject_medication = LogBookData{19,i};
    end
end

nbt_SaveSignal([],SignalInfo,SignalPath,1,SignalName);
end