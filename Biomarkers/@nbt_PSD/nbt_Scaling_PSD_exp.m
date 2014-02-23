function [PSDobject] = Scaling_PSD(PSDobject,data,fs,PSD_plot,PSD_LowFrequencyFit,PSD_HighFrequencyFit,res_logbin,RecomputeSwitch)
%
%% planning new version
%[PSD_logx,PSD_logy,PSD_exp,PSD_conf,PSD_LowFrequencyFit,PSD_HighFrequencyFit] = Scaling_PSD(data,fs,PSD_LowFrequencyFit,PSD_HighFrequencyFit,PSD_plot);
% input =
% PSDobject,SignalID,Signal,fs,PSD_plothandle,PSD_LowFrequencyFit,PSD_HighFrequencyF
% it, RecomputeSwitch
%output = PSDobject
% PSDobject should atleast contain PSD_logx, PSD_logy, PSD_exp,

%% Error check insert
if(~isa(PSDobject,'PSD'))
    error('PSD:WrongInputIsNotPSD','The input object is not a PSD object')
end

% modified k.linkenkaer@nih.knaw.nl, 031212.
%
%******************************************************************************************************************
% Purpose...
%
% To compute and plot the power spectrum (PSD) of the input vector 'F' (e.g., abs(W)).
% Fit a power-law function to obtain the power-law scaling exponent.
% Plot the PSD in double logarithmic coordinates.
%
%******************************************************************************************************************
% supporting scripts:
%
% logbinning.m
%
%******************************************************************************************************************
% input parameters...
%
% data	  		: input (column) vector.
% fs			: sampling frequency.
% PSD_LowFrequencyFit	: smallest time scale (window size) to include in power-law fit (in units of seconds!).
% PSD_HighFrequencyFit	: largest time scale (window size) to include in power-law fit (in units of seconds!).
% PSD_plot		: set to 1 to plot the result; otherwise set to 0.
%
%******************************************************************************************************************
% output parameters...
% 
% PSD_logx		: the logarithmically binned frequency vector (x-axis), BUT THE LOG10 HAS NOT BEEN TAKEN!
% PSD_logy		: the PSD, BUT THE LOG10 HAS NOT BEEN TAKEN!
% PSD_exp		: the PSD power-law exponent.
% PSD_conf		: 95% confidence interval for the power-law exponent.
%
%******************************************************************************************************************
% default parameters...

res_logbin = 7;		% resolution of the logarithmic binning.

%******************************************************************************************************************

[P,S]=psd(data,length(data),fs,hanning(length(data)));


%**********************************************************************************************************************
% we want equidistant data points on a loglog scale...

[PSD_logx,PSD_logy] = LogBinning(S,P,res_logbin);

%**********************************************************************************************************************
% now we are ready for loglog regression.

PSD_LowFrequencyFit_log = min(find(PSD_logx >= PSD_LowFrequencyFit));
PSD_HighFrequencyFit_log = max(find(PSD_logx <= PSD_HighFrequencyFit));

SX=[ones(PSD_HighFrequencyFit_log-PSD_LowFrequencyFit_log + 1,1) log10(PSD_logx(PSD_LowFrequencyFit_log:PSD_HighFrequencyFit_log))'];
PY=log10(PSD_logy(PSD_LowFrequencyFit_log:PSD_HighFrequencyFit_log))';
[PSD_exp,bint,r,rint,stats]=regress(PY,SX);				% psd_exp: the psd_exp of the lsline. 
									% r: the res_psdidual, the difference between observed and predicted values.	
PSD_exp = PSD_exp(2,1);									% stats: contains the R^2 value of the fit (+ see manual).
PSD_conf=((bint(2,2))-(bint(2,1)))/2;					% compute +- 95% confidence intervals

%*************************************************************************************************************************
% Plotting the log-binned power spectrum!

if PSD_plot==1
  figure
    plot(log10(PSD_logx(PSD_LowFrequencyFit_log:PSD_HighFrequencyFit_log)),log10(PSD_logy(PSD_LowFrequencyFit_log:PSD_HighFrequencyFit_log)),'ro') 				% plotting the NOT normalized power spectrum.
      lsline
      hold on
    plot(log10(PSD_logx(2:length(PSD_logx))),log10(PSD_logy(2:length(PSD_logy))),'.')		% we fit to the specified interval but plot all data points.
      axis([log10(min(PSD_logx)) log10(max(PSD_logx)) min(log10(PSD_logy(PSD_LowFrequencyFit_log:PSD_HighFrequencyFit_log)))-1 max(log10(PSD_logy(PSD_LowFrequencyFit_log:PSD_HighFrequencyFit_log)))+1])
      grid on
      zoom on
      title(['PSD-exp = ',num2str(PSD_exp,3) ' +-=', num2str(PSD_conf,3), ', R^2 = ', num2str(stats(1,1),3)])
end