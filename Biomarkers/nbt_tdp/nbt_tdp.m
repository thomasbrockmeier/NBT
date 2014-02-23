classdef nbt_tdp < nbt_Biomarker
%NBT_TDP Summary of this class goes here
%   Detailed explanation goes here

   properties
       f
       g
   end

   methods
       function biomarkerObject = nbt_tdp(NumChannels)
           biomarkerObject.f = nan(NumChannels,1);
           biomarkerObject.g = nan(NumChannels,1);
           biomarkerObject.Biomarkers = {'f', 'g'};
       end
   end
end 
