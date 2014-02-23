% nbt_doBarlow BARLOW calculates ACTIVITY, MOBILITY, COMPLEXITY
%
% Usage:
%   biomarkerObject = nbt_DoBarlow(...)
%  
%  [...] = barlow(S,0)
%       calculates stationary Hjorth parameter 
%  [...] = barlow(S,UC) with 0<UC<1,
%       calculates time-varying Hjorth parameter using 
%       exponential window 
%  [...] = barlow(S,N) with N>1,
%       calculates time-varying Hjorth parameter using 
%       rectangulare window of length N
%  [...] = barlow(S,B,A) with B>=1 oder length(B)>1,
%       calulates time-varying Hjorth parameters using 
%       transfer function B(z)/A(z) for windowing %
%
% Inputs:
%       S       data (each channel is a column)
%       UC      update coefficient 
%       B,A     filter coefficients (window function) 
%
% Outputs:
%   
%
% Example:
%    
% References:
% [1] Goncharova II, Barlow JS.
%   Changes in EEG mean frequency and spectral purity during spontaneous alpha blocking.
%   Electroencephalogr Clin Neurophysiol. 1990 Sep;76(3):197-204. 
%	This file is a modified version of barlow.m ; Copyright (C) 2004,2008,2009 by Alois Schloegl <a.schloegl@ieee.org>
%    	Barlow.m is part of the BIOSIG-toolbox http://biosig.sf.net/
% See also: 
%   TDP, HJORTH, WACKERMANN
  
%------------------------------------------------------------------------------------
% Originally created by "your name" (2010), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) <year>  <Main Author>  (Neuronal Oscillations and Cognition group, 
% Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, 
% Neuroscience Campus Amsterdam, VU University Amsterdam)
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
% -------------------------------------------------------------------------

function biomarkerObject = nbt_doBarlow(Signal,SignalInfo,UC,A)

biomarkerObject=nbt_barlow(size(Signal,2));

K = size(Signal,2); 	% number of electrodes K, number of samples N

d0 = Signal(:,:);
d1 = diff([zeros(1,K);Signal(:,:)],[],1);
d2 = diff([zeros(1,K);d1],[],1);

FLAG_ReplaceNaN = 0;

if nargin<2, 
        UC = 0; 
end;
if nargin<3;
        if UC==0,
                                
        elseif UC>=1,
                B = ones(1,UC);
                A = UC;
        elseif UC<1,
                FLAG_ReplaceNaN = 1;
                B = UC; 
                A = [1, UC-1];
        end;
else
        B = UC;    
end;


if ~UC,
        m0 = mean(abs(d0));
        m1 = mean(abs(d1));
        m2 = mean(abs(d2));
else
        if FLAG_ReplaceNaN;
                d0(isnan(d0)) = 0;
                d1(isnan(d1)) = 0;
                d2(isnan(d2)) = 0;
        end;
        m0 = filter(B,A,abs(d0))./filter(B,A,double(~isnan(d0)));
        m1 = filter(B,A,abs(d1))./filter(B,A,double(~isnan(d1)));
        m2 = filter(B,A,abs(d2))./filter(B,A,double(~isnan(d2)));
end;

biomarkerObject.amplitude = m0; 
biomarkerObject.frequency = m1./m0; 
biomarkerObject.spi = (biomarkerObject.frequency.*biomarkerObject.frequency)./(m2.*biomarkerObject.amplitude);
biomarkerObject = nbt_UpdateBiomarkerInfo(biomarkerObject, SignalInfo);
end

