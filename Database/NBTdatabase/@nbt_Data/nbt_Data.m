classdef nbt_Data
    %nbt_Data contains collections of biomarker data and is mainly produced
    %by the getData method of the nbt_Group object
    
    properties
        DataStore %function handle to nested DataStore (NBTelement based)
        Biomarker
        %Further parameters..
        Group %pointer to Group object
        OutputFormat %output format - remove nans, etc. cell vs matrix vs struct
    end 
    
    methods
       Biomarker = getBiomarker(nbt_DataObject, Parameters, OutputFormat);   
    end
    
     methods (Hidden = true)
       DataObj = OutputFormating(DataObj) %called by GetData before returning Data 
    end
    
end

