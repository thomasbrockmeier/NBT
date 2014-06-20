classdef nbt_Group %NBT GroupObject - contain group definitions + Database pointers.
    properties
        DatabaseType %e.g. NBTelement, File
        DatabaseLocation %path to files 
        ProjectID %
        SubjectID
        Age
        Gender
        ConditionID
        Biomarker
        FreqBand
        Parameters %for additional search parameters.
    end
    
    methods (Access = public)
        function dbObj = nbt_Group %object contructor
            dbObj.DatabaseType = 'NBTelement';
        end
        
        nbt_GroupObject = nbt_definegroup %Returns a group object based on selections (e.g., from the GUI)
        
        nbt_DataObject = nbt_GetData(nbt_GroupObject, Parameters) %Returns a nbt_Data Object based on the GroupObject and additional parameters
    end 
end

