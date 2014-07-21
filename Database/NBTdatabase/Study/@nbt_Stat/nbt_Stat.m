classdef nbt_Stat
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        Test
        TestOptions
        GroupObjects
        Biomarkers
        BiomarkerIdentifiers
        
        IntermediateData  %== [pool/poolkeys
        
        Results %== pvalues and r values
        
        %add statresults..
    end
    
    methods
        plot()
        createReport();
        calculate();
        checkPreCondition();
    end
    
end

