% Copyright (C) 2009  Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
%

% ChangeLog - see version control log for details
% <date> - Version <#> - <text>


function AmpDistObject= nbt_FindAmpDist(AmpDistObject, Signal, InfoObject)

%%get info from InfoObject
AmpDistObject = nbt_UpdateBiomarkerInfo(AmpDistObject, InfoObject);


for ChannelID = 1:(size(Signal,2)) % loop over channels
    ChId = GetChannelID;
    AmpDistObject.Kurtosis(ChId) = kurtosis(Signal(:,ChId));
    AmpDistObject.Skewness(ChId) = skewness(Signal(:,ChId));
    AmpDistObject.Iqr(ChId) = iqr(Signal(:,ChId));
    AmpDistObject.Median(ChId) = median(Signal(:,ChId));
    AmpDistObject.Range(ChId) = range(Signal(:,ChId));
    AmpDistObject.Cov(ChId) = std(Signal(:,ChId))/median(Signal(:,ChId));
end

AmpDistObject.DateLastUpdate = datestr(now);

%% Nested functions part
    function ChID = GetChannelID
        % function finds the current ChannelID
        if ( InfoObject.channelID ~= 0)
            ChID = InfoObject.channelID;
        else
            ChID = ChannelID;
        end
    end
end