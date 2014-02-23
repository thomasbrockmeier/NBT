classdef nbt_wackermann < nbt_Biomarker

    properties
    sigma
    phi
    omega
    end

    methods
        function BiomarkerObject=nbt_wackermann(NumChannels)
            BiomarkerObject.sigma = nan(NumChannels,1);
            BiomarkerObject.phi = nan(NumChannels,1);
            BiomarkerObject.omega = nan(NumChannels,1);
            
            BiomarkerObject.PrimaryBiomarker = 'sigma';
            BiomarkerObject.Biomarkers = {'sigma','phi','omega'};
        end
    end
end
