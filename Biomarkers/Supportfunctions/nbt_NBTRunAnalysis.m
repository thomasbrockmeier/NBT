% Copyright (C) 2008  Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
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

function nbt_NBTRunAnalysisAll(varargin)
[script, savescript] = NBTwrapper(23);
nbt_NBTcompute(script,'ICA','/media/Data/AD2009/AD2009/Set1','/media/Data/AD2009/AD2009/Set1')
end


function [NBTfunction_handle,NBTfunction_handleSave]=NBTwrapper(NumChannels)

delta_hp = 1;
delta_lp = 3;
delta_fo = 2;

theta_hp = 4;
theta_lp = 7;
theta_fo = 0.5;

alpha_hp = 8;
alpha_lp = 13;
alpha_fo = 0.26;


beta_hp = 13;
beta_lp = 30;
beta_fo = 0.16;

gamma_hp = 30;
gamma_lp = 45;
gamma_fo = 0.07;



    function NBTscript(Signal, SignalInfo, SaveDir)

        PeakFit = nbt_doPeakFit(Signal, SignalInfo);       
        nbt_SaveClearObject('PeakFit', SignalInfo, SaveDir)
        SignalInfo.frequencyRange = [1 45];
       
    end




    function NBTsaveScript(SignalInfo, savedir)
        %This script saves the biomarkers in an _analysis file
        cd (savedir)
        s = whos;
        for ii=1:length(s)
            if(strcmp(s(ii).class,'NBTSignal'))
                clear([s(ii).name])
            end
        end
        path = pwd;
        an_file = [path,'/',SignalInfo.file_name,'_autoclean.mat'];
        
        if(exist(an_file,'file') == 2)
            save(an_file,'-append')
            disp('ATTENTION: Analysis File already exists. Appending to existing file!');
            disp('ATTENTION: Data saved succesfully.');
        elseif(exist(an_file,'file') == 0)
            save(an_file)
            disp('ATTENTION: There is no Analysis File in the current folder.');
            disp('ATTENTION: Data saved succesfully.');
            clear save_dialog save_file
        end
    end

NBTfunction_handle = @NBTscript;
NBTfunction_handleSave =@NBTsaveScript;
end


