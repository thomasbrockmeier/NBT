
classdef nbt_PLI < nbt_CrossChannelBiomarker
    properties
        pliVal
        Median
        Mean 
        IQR
        Std
    end
    methods
        function BiomarkerObject = nbt_PLI(NumChannels)
            BiomarkerObject.pliVal = nan(NumChannels,NumChannels); 
            BiomarkerObject.Biomarkers ={'pliVal'};
        end
    end

end

