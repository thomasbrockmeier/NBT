

% Multifractal detrended fluctuation analysis (MFDFA)
% Input---------------------------------------------
% signal:       input signal
% m:            polynomial order for the detrending
% scmin:        lower bound of the window size s
% scmax:        upper bound of the window size s
% ressc:        number of elements in s
% qmin          lower bound of q
% qmax          upper bound of q
% qres          number of elements in q

% Output--------------------------------------------
% s:            scale
% q:            q-order
% Hq:            q-generalized Hurst exponent
% Fq:           q-generalized scaling function Fq(s,q)
% alpha:        hoelder exponent (see equation (13) and (15) in Kantelhardt et al.(2002))
% f_alpha:      Multifractal spectrum (see equation (13) and (15) Kantelhardt et al.(2002))
% References: Kandtelhardt et al. (2002). Multifractal detrended fluctuation analysis of nonstationary time series. Physica A, 316.
% Ihlen & Vereijken (2010), Journal of Experimental Psychology: General. 
% Ihlen (2012), Frontiers in Physiology
% See also:
% NBT_SCALING_DFA

%------------------------------------------------------------------------------------
% Originally created by Espen A. F. Ihlen (espenale@svt.ntnu.no), 2009
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2009 Espen A. F. Ihlen 
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
% -


function biomarkerObject = nbt_doMFDFA(Signal,SignalInfo,m,scmin,scmax,ressc,qmin,qmax,qres)

biomarkerObject = nbt_MFDFA(size(Signal,2));
Signal = nbt_RemoveIntervals(Signal,SignalInfo);

biomarkerObject = nbt_UpdateBiomarkerInfo(biomarkerObject, SignalInfo);

q=linspace(qmin,qmax,qres);
for ChId = 1:size(Signal,2)
    Fluct=cumsum(Signal(:,ChId)-mean(Signal(:,ChId))./std(Signal(:,ChId)));
    FluctRev=fliplr(Fluct);
    N=length(Fluct);
    
    ScaleNumb=linspace(log2(scmin),log2(scmax),ressc);
    s=round(2.^ScaleNumb);
    
    
    for ns=1:length(s)%,
        % disp(strcat('computing scale number_',num2str(ns)));
        Ns=floor(s(ns)\N);
        Var = nan(Ns,length(q));
        Varr = nan(Ns,length(q));
        for v=1:Ns,
            SegNumb=((((v-1)*s(ns))+1):(v*s(ns)))';
            Seg=Fluct(SegNumb);
            SegRev=FluctRev(SegNumb);
%             try
            poly=polyfit(SegNumb,Seg,m);
            polyr=polyfit(SegNumb,SegRev,m);
%             catch
%             end
            fit=polyval(poly,SegNumb);
            fitr=polyval(polyr,SegNumb);
            tmp1 = ((sum((Seg-fit).^2))/s(ns));
            tmp2 = ((sum((SegRev-fitr).^2))/s(ns));
            q2 = q./2;
            for nq=1:length(q);
                Var(v,nq)=tmp1^(q2(nq));
                Varr(v,nq)=tmp2^(q2(nq));
            end;
        end
        for nq=1:length(q),
            Fq(ns,nq)=((sum(Var(:,nq))+sum(Varr(:,nq)))/(2*Ns))^(1/q(nq));
        end
        Fq(ns,find(q==0))=(Fq(ns,find(q==0)-1)+Fq(ns,find(q==0)+1))./2;
        %clear Var Varr
    end
    
    for nq=1:length(q);
        P=polyfit(log2(s'),log2(Fq(:,nq)),1);
        Hq(nq)=P(1);
    end
    
    tau=(q.*Hq)-1;
    
    % alpha=diff(tau+1).*((length(q)-1)/range(q));
    % f_alpha=(q(2:end).*alpha)-tau(2:end);
    alpha = diff(tau)./((q(2)-q(1)));
    f_alpha = (q(1:(end-1)).*alpha) - tau(1:(end-1));
    
    
    biomarkerObject.s{ChId,1}       = s;
    biomarkerObject.q{ChId,1}       = q;
    biomarkerObject.Hq{ChId,1}      = Hq;
    biomarkerObject.Fq{ChId,1}      = Fq;
    biomarkerObject.alpha{ChId,1}   = alpha;
    biomarkerObject.f_alpha{ChId,1} = f_alpha;
    biomarkerObject.alphaRange(ChId) = range(alpha);
    biomarkerObject.HqRange(ChId) = range(Hq);
end
end