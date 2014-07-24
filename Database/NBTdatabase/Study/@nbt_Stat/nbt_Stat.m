classdef nbt_Stat
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        testName
        
        testOptions
        groupObjects
        biomarkers
        biomarkerIdentifiers
        
        intermediateData  %== [pool/poolkeys
        
        results %== pvalues and r values
        
        %add statresults..
    end
    
    methods
        function StatObj = nbt_Stat()
            
        end
        
        plot()
        createReport();
        calculate();
        checkPreCondition();
        
    end
    
end

