function [P] = define_parameters(data,P)
% Function to calculate SL and chaotic model parameters and print in
% command window
%   Input:
%   data:   matrix of your signal dataset <n_samples,n_channels>
%   P:      structure P. containing:
%           fs: sampling frequency
%           lag: time-delay embedding lag
%           m: time-delay embedding dimension m
%           p_ref: fraction of state-vectors to be taken as recurrences
%           model: in case of a model: 1, in case of MEG data: 0
%               dt: time-step in sec.
%               t: time-vector in sec.
%               f1: frequency determant of driver system 
%               f2: frequency determant of response system
%               sn: signal-to-noise ratio
%               x0: x initial starting value
%               y0: y initial starting value
%               z0: z initial starting value
%               e: coupling strength between source systems [0 1]
%               - Rossler parameters
%               a: chaotic system's parameter a
%               b: chaotic system's parameter b
%               c: chaotic system's parameter c
%               - Henon parameters
%               a1: driver system's parameter a
%               a2: response system's parameter a
%               b: both system's parameter b
%           progress: 1 to print progress in command window, 0 otherwise
%               i: current iteration
%               Ni: total number of iterations
%               t0: cputime-stamp at start of the algorithm
%   Output:
%   P: updated structure P
%% P calculation

P.n_samples = size(data,1);

% calculate the high and low pass filter
P.hf = P.fs/(3*P.lag);
P.lf = (3*P.hf)/(P.m-1);

P.speed   = round(P.lag*P.m*0.9);

% window sizes and nber of iterations
P.w1          = (2*P.lag)*(P.m-1);
P.w2          = P.n_samples;
P.n_rec       = ((P.w2/P.m) - P.w1 + 1 )*P.p_ref;
P.n_it      = floor((P.n_samples-P.lag*(P.m-1))/P.speed)-ceil(1/P.speed)+1;

%% P output
clc
fprintf(2,'PARAMETERS\n');
fprintf(2,'----------\n');
fprintf(2,'Data\n');
fprintf(2,'fs:       %.0f Hz\n',P.fs);
fprintf(2,'Samples:  %.0f\n',P.n_samples);
fprintf(2,'Length:   %.2f sec.\n',P.n_samples/P.fs);
fprintf(2,'Channels: %.0f\n',P.n_chans);
fprintf(2,'Mean:     %.2f\n',mean(mean(data,1)));
fprintf(2,'std:      %.2f\n\n',mean(std(data,0,1)));

fprintf(2,'Filter\n');
fprintf(2,'High pass: %.2f Hz\n',P.lf);
fprintf(2,'Low pass:  %.2f Hz\n\n',P.hf);

fprintf(2,'SL Settings\n');
fprintf(2,'Lag:          %.0f\n',P.lag);
fprintf(2,'Dimensions:   %.0f\n',P.m);
fprintf(2,'Window 1:     %.0f\n',P.w1);
fprintf(2,'Window 2:     %.0f\n',P.w2);
if size(P.p_ref) > 1
    fprintf(2,'n_rec:        -\n');
    fprintf(2,'p_ref:        matrix\n');
else
    fprintf(2,'n_rec:        %.0f\n',P.n_rec);
    fprintf(2,'p_ref:        %.3f\n',P.p_ref);
end
fprintf(2,'Speed factor: %.0f\n',P.speed);
fprintf(2,'Iterations:   %.0f\n',P.n_it);

if P.model
    if P.rossler
        fprintf(2,'\nModel Settings\n');
        fprintf(2,'dt:           %.2f sec.\n',P.dt);
        fprintf(2,'Length:       %.2f sec.\n',P.t(end)/100);
        fprintf(2,'f1:           %.2f\n',P.f1);
        fprintf(2,'f2:           %.2f\n',P.f2);
        fprintf(2,'Signal/noise: %.0f\n',P.sn);
        fprintf(2,'x0:           %.1f\n',P.x0);
        fprintf(2,'y0:           %.1f\n',P.y0);
        fprintf(2,'z0:           %.1f\n',P.z0);
        fprintf(2,'a:            %.1f\n',P.a);
        fprintf(2,'b:            %.1f\n',P.b);
        fprintf(2,'c:            %.1f\n',P.c);
        fprintf(2,'coupling:     %.2f\n',P.e);
    end
    if P.henon
        fprintf(2,'\nModel Settings\n');
        fprintf(2,'dt:           %.3f sec.\n',P.dt);
        fprintf(2,'Length:       %.3f sec.\n',P.t(end));
        fprintf(2,'x0:           %.1f\n',P.x0);
        fprintf(2,'y0:           %.1f\n',P.y0);
        fprintf(2,'a1:           %.1f\n',P.a1);
        fprintf(2,'a2:           %.1f\n',P.a2);
        fprintf(2,'b:            %.1f\n',P.b);
        fprintf(2,'coupling:     %.2f\n',P.e);
    end
end

P.t_rem = ((cputime-P.t0)/(P.i/P.Ni))*(1-(P.i/P.Ni));
hours = floor(P.t_rem/3600);
delta = P.t_rem - (hours*3600);
minutes = floor(delta/60);
seconds = delta - (minutes*60);

if P.progress
    fprintf(2,'\nProgress: ');
    fprintf(2,'%.0f%% \n',(P.i/P.Ni)*100);
    fprintf(2,'Est. time remaining: ');
    fprintf(2,'%.0fh %.0fm %.0fs \n',hours,minutes,seconds);
end
fprintf(2,'----------\n');
end