classdef nbt_Data
    %nbt_Data contains collections of biomarker data and is mainly produced
    %by the getData method of the nbt_Group object
    
    properties
        dataStore %function handle to nested DataStore (NBTelement based)
        biomarker
        %Further parameters..
        group %pointer to Group object
        outputFormat %output format - remove nans, etc. cell vs matrix vs struct
    end 
    
    methods
      function DataObject = nbt_Data  
      end
      
      
        
        
       Biomarker = getBiomarker(nbt_DataObject, Parameters, OutputFormat);   
    end
    
    methods (Static = true)
     DataObject = dataContainer(GrpObj);
    end
    
     methods (Hidden = true)
       DataObj = OutputFormating(DataObj) %called by GetData before returning Data 
    end
    
end

