classdef nbt_PSD < nbt_SignalBiomarker

    %% Copyright (c) 2008, Simon-Shlomo Poil (Center for Neurogenomics and Cognitive Research (CNCR), VU University Amsterdam)
    %% ChangeLog - remember to set NBTversion property
    %$ Version 1.0 - 22 June 2009 : Modified by Simon-Shlomo Poil,simonshlomo.poil@cncr.vu.nl$
    % Implementing new matlab object structure.

    properties
        PSDlogy
        PSDlogx
        PSD_LowFrequencyFit
        PSD_HighFrequencyFit
    end

    methods
        function PSDobject = nbt_PSD(NumChannels)
            if nargin == 0
                NumChannels = 1;
            end
            PSDobject.MarkerValues = nan(NumChannels,1);
            PSDobject.PSDlogy = cell(NumChannels,1);
            PSDobject.PSDlogx = [];
            PSDobject.PSD_LowFrequencyFit;
            PSDobject.PSD_HighFrequencyFit;
        end
    end
end