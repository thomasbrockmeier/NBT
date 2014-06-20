classdef nbt_db  
    properties
        DatabaseType %e.g. NBTelement, File
        DatabaseLocation %path to files 
        Data
        ProjectID %
        SubjectID
        ConditionID
        Age
        Gender
        Biomarker
        Parameters %for additional search parameters.
        OutputFormat %output format - remove nans, etc. cell vs matrix vs struct
    end
    
    methods (Access = public)
        function dbObj = nbt_db %object contructor
            dbObj.DatabaseType = 'NBTelement';
        end
        
        dbObj = nbt_GetData(dbObj) %get data
    end
    methods (Hidden = true)
       dbObj = OutputFormating %called by GetData before returning Data 
    end
    
end

