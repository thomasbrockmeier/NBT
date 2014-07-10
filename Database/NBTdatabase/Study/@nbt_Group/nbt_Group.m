classdef nbt_Group %NBT GroupObject - contains group definitions + Database pointers.
    properties
        databaseType %e.g. NBTelement, File
        databaseLocation %path to files 
        groupName
        fileList
        projectID %
        subjectID
        age
        gender
        conditionID
        biomarker
        frequencyRange
        parameters %for additional search parameters.
    end
    
    methods (Access = public)
        function GrpObj = nbt_Group %object contructor
            GrpObj.databaseType = 'File'; % 'NBTelement' or 'File'
        end
                
        nbt_DataObject = getData(nbt_GroupObject, Parameters) %Returns a nbt_Data Object based on the GroupObject and additional parameters
        
       [InfoCell, nbt_GroupObject, FileInfo] = getInfo(nbt_GroupObject) %Returns a cell with information about the database.
       nbt_GroupObject = generateFileList(nbt_GroupObject, FileInfo);
       [FileInfo, nbt_GroupObject] = getFileInfo(nbt_GroupObject);
    end 
    
    methods (Static = true)
        nbt_GroupObject = defineGroup(GrpObj) %Returns a group object based on selections (e.g., from the GUI) 
    end
end

