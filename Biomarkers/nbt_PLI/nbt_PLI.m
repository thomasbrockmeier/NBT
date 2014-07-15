
classdef nbt_PLI < nbt_Biomarker 
    properties
        pliVal
    end
    methods
        function BiomarkerObject = nbt_Biomarker_template(NumChannels)
            BiomarkerObject.pliVal = nan(NumChannels,NumChannels); 
            BiomarkerObject.Biomarkers ={'pliVal'};
        end
    end

end

