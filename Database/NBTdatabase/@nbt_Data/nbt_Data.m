classdef nbt_Data
    %nbt_Data contains collections of biomarker data. 
    
    properties
        Data
        Biomarker
        %Further parameters..
        Group %pointer to Group object
        OutputFormat %output format - remove nans, etc. cell vs matrix vs struct
    end 
    
    methods
        
    end
    
     methods (Hidden = true)
       dbObj = OutputFormating %called by GetData before returning Data 
    end
    
end

