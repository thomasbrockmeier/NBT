classdef nbt_db  
    properties
        DatabaseType %e.g. NBTelement, File
        DatabaseLocation %path to files 
        Data
        ProjectID %
        SubjectID
        ConditionID
        Biomarker
        Parameters %for addtional search parameters.
        OutputFormat %output format - remove nans, etc. cell vs matrix vs struct
    end
    
    methods (Access = Public)
        dbObj = nbt_db
        dbObj = nbt_GetData(dbObj) %get data
    end
    methods (Hidden = True)
       dbObj = OutputFormating %called by GetData before returning Data 
    end
    
end

