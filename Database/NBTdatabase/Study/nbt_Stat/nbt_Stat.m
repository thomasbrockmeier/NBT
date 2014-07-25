classdef nbt_Stat
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        testName
        testOptions
        groups
        biomarker
        biomarkerIdentifiers
        
        intermediateData  %== [pool/poolkeys
        
        results %== pvalues and r values
        
        %add statresults..
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

