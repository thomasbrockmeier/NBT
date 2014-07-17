
classdef nbt_PLI < nbt_CrossChannelBiomarker 
    properties
        pliVal
    end
    methods
        function BiomarkerObject = nbt_PLI(NumChannels)
            BiomarkerObject.pliVal = nan(NumChannels,NumChannels); 
            BiomarkerObject.Biomarkers ={'pliVal'};
        end
    end

end

