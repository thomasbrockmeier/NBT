%  TDP time-domain parameters
%	extracts EEG features very fast (low computational efforts) 
%     	This is function was motivated by the Hjorth and Barlow 
%	parameters and is experimental. 
%           
%  [F,G] = TDP(...)
%  
%  [...] = tdp(S,p,0)
%       calculates the log-power of the first p-th derivatives 
%  [...] = tdp(S,p,UC) with 0<UC<1,
%       calculates time-varying power of the first p-th derivatives 
%       using an exponential window 
%  [...] = tdp(S,p,N) with N>1,
%       calculates time-varying log-power of the first p-th derivatives
%       using rectangulare window of length N
%  [...] = tdp(S,p,B,A) with B>=1 oder length(B)>1,
%       calculates time-varying log-power of the first p-th derivatives
%       using the transfer function B(z)/A(z) for windowing 
%  Input:
%       S       data (each channel is a column)
%	p	number of features
%       UC      update coefficient 
%       B,A     filter coefficients (window function) 
%  Output:
%       F	log-power of each channel and each derivative 
%		in case of p=2, this is a linear combination of log(hjorth)	
%       G	log-amplitude of each channel and each derivative
%		in case of p=2, this is a linear combination of log(barlow)	
%       
% Relationship to related parameters:	
%	Hjorth's ACTIVITY   = exp(F(:,1));
%	Hjorth's MOBILITY   = exp(F(:,2)-F(:,1))/2; 
%	Hjorth's COMPLEXITY = exp(F(:,3)-F(:,2))/2;	
%		LINELENGTH = exp(G(:,2)); 
%		AREA = exp(G(:,1)); 
% 	Barlow's AMPLITUDE = exp(G(:,1)) = AREA; 
% 	Barlow's FREQUENCY = exp(G(:,2)-G(:,1)); 
% 	Barlow's Spectral Purity Index SPI = exp(2*F(:,2)-F(:,1)-F(:,3))
%
% see also: HJORTH, BARLOW, WACKERMANN
%
% REFERENCE(S):
% [1] B. Hjorth, 
%   EEG analysis based on time domain properties
%   Electroencephalography and Clinical Neurophysiology, vol. 29, no. 3, pp. 306???310, September 1970.
% [2] B. Hjorth, 
%   Time Domain Descriptors and their Relation to particulare Model for Generation of EEG activity. 
%   in G. Dolce, H. Kunkel: CEAN Computerized EEG Analysis, Gustav Fischer 1975, S.3-8. 
% [3] Goncharova II, Barlow JS.
%   Changes in EEG mean frequency and spectral purity during spontaneous alpha blocking.
%   Electroencephalogr Clin Neurophysiol. 1990 Sep;76(3):197-204. 

%	This file is a modified version of tdp.m ; Copyright (C) 2008 by Alois Schloegl <a.schloegl@ieee.org>
%    	tdp.m is part of the BIOSIG-toolbox http://biosig.sf.net/

%modified version Copyright (C) 2010  Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
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

function biomarkerObject = nbt_doTdp(Signal,SignalInfo,p,UC,A)

biomarkerObject = nbt_tdp(size(Signal,2));
Signal = nbt_RemoveIntervals(Signal,SignalInfo);

biomarkerObject=nbt_UpdateBiomarkerInfo(biomarkerObject, SignalInfo);

K = size(Signal,2); 	% number of electrodes K, number of samples N

d0 = Signal(:,:);

FLAG_ReplaceNaN = 1;

if nargin<4, 
        UC = 0; 
end;
if nargin<5,
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
	d = Signal(:,:);
	F = log(mean(d.^2));
	for k = 1:p,
		d = diff([repmat(NaN,[1,K]);d],[],1);
	        F = [F, log(mean(d.^2))];
        end;
else
       	d = d0;
        if FLAG_ReplaceNaN;
                d(isnan(d)) = 0;
        end;
        F = log(filter(B,A,d.^2)./filter(B,A,double(~isnan(d0))));
	for k = 1:p,
		d0 = diff([repmat(NaN,[1,K]);d0],[],1);
		d  = d0;
	        if FLAG_ReplaceNaN;
                	d(isnan(d)) = 0;
        	end;
	        m = filter(B,A,d.^2)./filter(B,A,double(~isnan(d0)));
	        F = [F, log(m)];
        end;
end;


if ~UC,
	d = Signal(:,:);
	G = log(mean(abs(d)));
	for k = 1:p,
		d = diff([repmat(NaN,[1,K]);d],[],1);
	        G = [G, log(mean(abs(d)))];
        end;
else
       	d = d0;
        if FLAG_ReplaceNaN;
                d(isnan(d)) = 0;
        end;
        G = log(filter(B,A,abs(d))./filter(B,A,double(~isnan(d0))));
	for k = 1:p,
		d0 = diff([repmat(NaN,[1,K]);d0],[],1);
		d  = d0;
	        if FLAG_ReplaceNaN;
                	d(isnan(d)) = 0;
        	end;
	        m = filter(B,A,abs(d))./filter(B,A,double(~isnan(d0)));
	        G = [G, log(m)];
        end;

biomarkerObject.f = F;
biomarkerObject.g = G;
end;
