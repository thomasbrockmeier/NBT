% Dynamic Time Warping - DTW
%
% Inputs:
% nbt_Biomarker_template = biomarker object to be updated 
% Signal = NBT Signal matrix for which the biomarkers will be computed
% SignalInfo = NBT Info object
% This function computes the desired biomarkers and updates the NBT Biomarker object 
% with the biomarker values. 
%
% Output: biomarker object
% Reference:
% http://en.wikipedia.org/wiki/Dynamic_time_warping


% Copyright (C) 2014 Simon-Shlomo Poil
% Based on Wikipedia code 
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


function DTWobject = nbt_doDTW(Signal,SignalInfo, window)

%%   give information to the user
disp(['Computing marker values for ',SignalInfo.file_name])

%% remove artifact intervals
Signal = nbt_RemoveIntervals(Signal,SignalInfo);

%% Initialize the biomarker object
DTWobject = nbt_DTW(size(Signal,2)); 

%%   Compute markervalues. Add here your algorithm to compute the biomarker
%%   values, for example:
for Ch1 = 1:size(Signal,2)
   for Ch2 = Ch1:size(Signal,2) 
       tic
       DTWobject.d(Ch1,Ch2) = nbt_calculateDTW(Signal(:,Ch1), Signal(:,Ch2), window);
       toc
   end
end

DTWobject.window = window;

%% update biomarker objects (here we used the biomarker template):
DTWobject = nbt_UpdateBiomarkerInfo(DTWobject, SignalInfo);
end

function [d, window] = nbt_calculateDTW(Signal1, Signal2, window)
if nargin<3
    window=Inf;
end

LengthSignal1 = length(Signal1);
LengthSignal2 = length(Signal2);
if(window < abs(LengthSignal1-LengthSignal2)) 
    window = abs(LengthSignal1-LengthSignal2); 
    warning('Window Size adjusted')
end

%% init
D = zeros(2*window+2,2)+Inf;
D(1,1)=0;
for i = window+1:(LengthSignal1-window)
    disp(i)
    jj = 0;
    for j = (i-window):(i+window)
         jj = jj+1;
         cost = abs(Signal1(i,1)-Signal2(j,1));
         D(jj+1,2) = cost + min([D(jj+1,1), D(jj,2), D(jj,1)]);
    end
    %shift D
    D(:,1) = D(:,2);
    D(:,2) = Inf;
    D(1:(end-1),1) = D(2:end,1);
    D(end,1) = Inf;
end
d = D(end-1,1);
end