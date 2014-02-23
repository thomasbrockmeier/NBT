% GUI function for the NBTelement database

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

function nbt_NBTelement_gui()

stop = 0;
while stop == 0 
[res userdata err structout] = inputgui( 'geometry', { [1 1] }, ...
    'geomvert', [5], 'uilist', { ...
    { 'style', 'text', 'string', [ 'NBTelements options:' 10 10 ] }, ...
    { 'style', 'listbox', 'string', 'Connect NBTelements|Query database|Close menu' 'tag' 'choice' } }, 'title', 'NBT - NBTdatabase' );

switch structout.choice
    case 1
        nbt_ConnectNBTelements
    case 2
        nbt_NBTelementGUIcmd
    case 3 
        stop = 1;
end

end
disp('NBTelements stopped')
end