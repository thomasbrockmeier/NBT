classdef nbt_Group %NBT GroupObject - contain group definitions + Database pointers.
    properties
        DatabaseType %e.g. NBTelement, File
        DatabaseLocation %path to files 
        Data
        DataType %per Channels vs not 
        ProjectID %
        SubjectID
        Age
        Gender
        ConditionID
        Biomarker
        FreqBand
        Parameters %for additional search parameters.
        OutputFormat %output format - remove nans, etc. cell vs matrix vs struct
       
    end
    
    methods (Access = public)
        function dbObj = nbt_Group %object contructor
            dbObj.DatabaseType = 'NBTelement';
        end
        
        dbObj = nbt_GetData(dbObj) %get data
    end 
end

