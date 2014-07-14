% Copyright (C) 2011 Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
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


function nbt_convertAnalysisFiles(startpath)
d= dir (startpath);
for j=3:length(d)
    if (d(j).isdir )
        nbt_convertAnalysisFiles([startpath filesep d(j).name ]);
    else
        b = strfind(d(j).name,'mat');
        cc= strfind(d(j).name,'analysis');
        
        if (~isempty(b)  && ~isempty(cc))
            % here comes the conversion
            oldBiomarkers = load(d(j).name);
            oldBiomarkerFields = fields(oldBiomarkers);
            
            for i=1:length(oldBiomarkerFields)
                if(isa(oldBiomarkers.(oldBiomarkerFields{i}),'nbt_CoreBiomarker'))
                   eval([ oldBiomarkerFields{i} '= convertBiomarker( oldBiomarkers.(oldBiomarkerFields{i}),d(j).name);']);
                   save(d(j).name,(oldBiomarkerFields{i}),'-append')
                end
            end
        end
    end
end
end