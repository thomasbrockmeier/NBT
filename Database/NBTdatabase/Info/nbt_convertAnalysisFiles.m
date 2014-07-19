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


function nbt_convertAnalysisFiles(startpath,signalName)

if isempty(signalName)
    everyFile = cell2mat(inputdlg('Do you want to define a different signal attached for each biomarker? {y/n}: ' ));
    
    if strcmp(everyFile(1),'y')
        
    else
        if strcmp(everyFile(1),'n')
            signalName = cell2mat(inputdlg('Please type SignalName (e.g. RawSignal): ' ));
            
        else
            disp('please either input y or n')
            return
            
        end
        
    end
    
    
end
d= dir (startpath);
for j=3:length(d)
    if (d(j).isdir )
        nbt_convertAnalysisFiles([startpath filesep d(j).name ],signalName);
    else
        b = strfind(d(j).name,'mat');
        cc= strfind(d(j).name,'analysis');
        
        if (~isempty(b)  && ~isempty(cc))
            % here comes the conversion
            oldBiomarkers = load(d(j).name);
            oldBiomarkerFields = fields(oldBiomarkers);
            if ~isempty(signalName)
                sigInfo = load([d(j).name(1:end-12) 'info.mat']);
                SubjectInfo = sigInfo.SubjectInfo;
                eval([signalName ' = sigInfo.' signalName ';']);
            end
            
            for i=1:length(oldBiomarkerFields)
                
                if(isa(oldBiomarkers.(oldBiomarkerFields{i}),'nbt_CoreBiomarker'))
                    if(isa(oldBiomarkers.(oldBiomarkerFields{i}),'nbt_SignalBiomarker'))
                        eval([ oldBiomarkerFields{i} '= convertBiomarker( oldBiomarkers.(oldBiomarkerFields{i}),d(j).name);']);
                        if isempty(signalName)
                            signalName = cell2mat(inputdlg(['Please type SignalName (e.g. RawSignal) for : ' oldBiomarkerFields{i}]));
                            sigInfo = load([d(j).name(1:end-12) 'info.mat']);
                            SubjectInfo = sigInfo.SubjectInfo;
                            eval([signalName ' = sigInfo.' signalName ';']);
                        end
                        eval([ oldBiomarkerFields{i} '= nbt_UpdateBiomarkerInfo( oldBiomarkers.(oldBiomarkerFields{i}),' signalName ');']);
                        
                        eval([signalName '.listOfBiomarkers = [' signalName '.listOfBiomarkers ; {''' oldBiomarkerFields{i} '''}];']);
                        
                        save(d(j).name,(oldBiomarkerFields{i}),'-append')
                    else
                        eval([ oldBiomarkerFields{i} '= convertBiomarker( oldBiomarkers.(oldBiomarkerFields{i}),d(j).name);']);
                        eval(['SubjectInfo.listOfBiomarkers = [SubjectInfo.listOfBiomarkers ; {''' oldBiomarkerFields{i} '''}];']);
                        
                        save(d(j).name,(oldBiomarkerFields{i}),'-append')
                    end
                end
                
            end
            save([d(j).name(1:end-12) 'info.mat'],signalName,'SubjectInfo','-append')
        end
    end
end
end