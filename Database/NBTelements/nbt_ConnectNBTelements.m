% Script to create and connect an NBTelement database tree. 

% Copyright (C) 2010 Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
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


NumLevels = input('How many levels does the NBTelement structure have? ');
for i=1:NumLevels
    disp('Level:')
    disp(i)
    Elements = input('Which elements exist on this level?, define as [ElementID1, ElementID2] ');
    for ii=1:length(Elements)
        disp('ElementID')
        disp(Elements(ii))
        ElementName = input('What is the name of this NBTelement? ','s');
        ParentName = input('What is the parent of this NBTelement?, write name ','s');
        if(~isempty(ParentName))
            stop =0;
            while stop==0
            try
            eval(['Key =[int2str(' int2str(Elements(ii)) ') ''.'' ' ParentName '.Key]'])
            eval(['Uplink =' ParentName '.ElementID;'])
            eval([ElementName '=nbt_NBTelement(Elements(ii),Key,Uplink)'])
            stop = 1;
            catch
                ParentName = input('This NBTelement does not exist! Please chcek the name.. What is the parent of this NBTelement?, write name ','s');
            end
            end
        else
            Key = int2str(Elements(ii));
            Uplink = [];
            eval([ElementName '=nbt_NBTelement(Elements(ii),Key,Uplink)'])
        end
    end
end

s = whos;
for i=1:length(s)
    if(~strcmp(s(i).class,'nbt_NBTelement'))
        eval(['clear ' s(i).name])
    end
end
clear i
clear s