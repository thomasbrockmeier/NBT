classdef nbt_Stat
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        testName
        testOptions
        groups
        biomarkers
        biomarkerIdentifiers = cell(1,1);
        channels
        channelsRegionsSwitch
        pValues
        statValues
        statStruct 
    end
    
    methods
        function StatObj = nbt_Stat()
            
        end
        
       % plot()
       % createReport();
       function obj = calculate(obj)
          
       end
       % checkPreCondition();
        
    end
    
end

