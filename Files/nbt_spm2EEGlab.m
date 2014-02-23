%
% Script (can't run as fxn!) for importing continuous data from SPM to EEGlab.
%   - Handles continuous or epoched data
%   - Also imports event information
%
% INPUT: S (optional) stucture containing (optional) subfields {defaults}:
%   D         - filename of SPM data to import {prompt}
%   chans     - [1:Nchannels] channels to import {D.channels.eeg}
%   outfname  - ['string'] output filename {D.fname (with .set ext)}
%   plotchans - [0|1] plot channel locations {1 (yes)}
%
% OUTPUT: 
%   EEG    = EEGLAB data structure
%   .set   = EEGLAB data file
%   .xyz   = EEGLAB channel location file
%
% EXAMPLE:
%   S.D = '/path/to/data/block1.mat';
%   S.chans = 1:102;
%   S.outfstem = '_magsonly';
%   S.plotchans = 0;
%   meg_spm2eeglab
%
% By Jason Taylor (15/8/2007)
%   JT updated (3/3/2008)
%

% Works as a script; won't work as a function...
%function [EEG] = spm_eeglab_spm2eeg(S);


%-------------------------------------------------------
% Get Parameters:
%---------------

try fname=S.D;
catch
    fname=spm_select(1,'mat','Select file for EEGLAB import...');
end
[p fstem ext]=fileparts(fname);
D=spm_eeg_load(fname);
srate=D.fsample;
ndims=length(size(D(:,:,:)));

try 
	chans=S.chans;
catch 
	chans=D.meegchannels;
end
nchans=length(chans);

try
	outfname=S.outfname;
catch
	outfname=[fstem '.set'];
end

try
	plotchans=S.plotchans;
catch
	plotchans=1;
end


% Open EEGLAB (to load toolboxes, etc.):
eeglab();


%-------------------------------------------------------
% Prepare data for import:
%------------------------

%%% HACK! (It won't run as a function, so change dir & run as script!
if isempty(p)
	p=pwd;
else
	cd(p)
end

%%% Get data, events, times:

if ndims==2 
	disp(sprintf('\nContinuous data detected.'))
	spmdata=D(chans,:,:);
	nsamps=0;
	epstart=0;
    tt = D.events;
    for tindex=1:length(tt)
	ev(tindex)=tt(tindex).value;
	t=tt(tindex).time;
	tms(tindex)=t*(1000/srate);
    end
    events = [0 0];
%	events=[ev' tms'];
elseif ndims==3
	disp(sprintf('\nEpoched data detected.'))
	spmdata=D(chans,:,:);
	nsamps=D.Nsamples;
	epstart=(1-D.events.start)*(1/D.fsample);
	ev=D.events.value;
	t=D.events.time;
	tms=zeros(size(t));
	events=[ev' tms'];
end


%-------------------------------------------------------
% Prepare channel info for import:
%--------------------------------

%%% Prepare channel locations for import:

% Could allow S.chanfname input to bypass this??

% disp(sprintf('\nPreparing channel info file...'))
% load(D.channels.ctf);
% chloc=SensLoc;
% if intersect(chans,D.channels.heog)
% 	% include heog:
% 	chloc(D.channels.heog,:)=[-.1 .12 0];
% end
% if intersect(chans,D.channels.veog)
% 	% include veog:
% 	chloc(D.channels.veog,:)=[.1 .12 0];
% end
% chanmat=[chans',chloc(chans,:),chans'];	
% dlmwrite('chan_locs.xyz',chanmat,'delimiter','\t','precision','%.4f')
% disp(sprintf('...Done.'))


%-------------------------------------------------------
% Import SPM data to EEGLAB:
%--------------------------

global EEG ALLEEG CURRENTSET;

%%% Import Data:

disp(sprintf('\nImporting data...'))
EEG = pop_importdata('dataformat', 'array',...
 'data', 'spmdata',...
 'setname', outfname,...
 'srate', srate,...
'pnts', nsamps,...
 'xmin', epstart,...
 'nbchan', nchans...
 );
disp(sprintf('...Done.'))

% Check, save:
disp(sprintf('\nChecking and saving data...'))
EEG = eeg_checkset(EEG);
EEG = pop_saveset(EEG, 'filename',outfname,'filepath',p);
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG);
eeglab redraw;
disp(sprintf('...Done.'))


%%% Import Events:

disp(sprintf('\nImporting event info...'))
if ndims==2
	EEG=pop_importevent(EEG,'append','no','event','events','fields',{'type','latency'},'timeunit',1E-3,'optimalign','off');
elseif ndims==3
	EEG=pop_importepoch(EEG,'events',{'type','latency'},'timeunit',1E-3);
end
disp(sprintf('...Done.'))

% Check, save:
EEG = eeg_checkset(EEG);
EEG = pop_saveset(EEG, 'filename',outfname, 'filepath',p);

% Import ICA weights, sphere:
if isfield(D,'ica')
	disp(sprintf('\nImporting ICA weights and sphere...'))
	EEG.icasphere=D.ica.sphere;
	EEG.icaweights=D.ica.W;
	disp(sprintf('...Done.'))

	% Check, save:
	EEG = eeg_checkset(EEG);
	EEG = pop_saveset(EEG, 'filename',outfname, 'filepath',p);
	[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG);
	eeglab redraw;
else
	disp(sprintf('\nNo ICA detected.'))
end

% Import rejections:
if ndims==3
	disp(sprintf('\nImporting rejections...'))
	EEG.reject.rejmanual=D.events.reject;
	EEG = eeg_checkset(EEG);
	EEG = pop_saveset(EEG, 'filename',outfname, 'filepath',p);
	disp(sprintf('...Done.'))
	% Update EEGLAB window
	[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG);
	eeglab redraw;
else
	disp(sprintf('\nNo rejections detected.'))
end


%-------------------------------------------------------
% Plot channels (2D):
%-------------------

% if plotchans==1
% 
% 	disp(sprintf('\nPlotting channels (2D)...'))
% 	figure; 
% 	topoplot([],EEG.chanlocs,'style','blank','electrodes','labelpoint','chaninfo',EEG.chaninfo);
% 
% 	%cont=input('Press ENTER to continue, Ctrl-C to quit');
% 
% end % if plotchans


%%% FUN STUFF TO DO IN EEGLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SELECT MAGS ONLY:
%EEG = pop_select( EEG, 'channel',[1:102] );
%EEG.setname='ce_sss_st_study1_origindefce_sss_st_study1_origindef_spm2eeg_mags';
%EEG = eeg_checkset( EEG );

% SEPARATE CONDITIONS (epoched data):
%EEG = pop_selectevent( EEG,  'epochtype',1, 'deleteevents', 'off', 'deleteepochs', 'on');
%EEG.setname='ce_sss_st_study1_origindefce_sss_st_study1_origindef_spm2eeg_mags_words';
%EEG = eeg_checkset( EEG );

%EEG = pop_selectevent( EEG,  'epochtype',2, 'deleteevents', 'off', 'deleteepochs', 'on');
%EEG.setname='ce_sss_st_study1_origindefce_sss_st_study1_origindef_spm2eeg_mags_nonwords';
%EEG = eeg_checkset( EEG );

% COMPARE COMPONENT ERPS (rmpath is because 'channames' is a duplicate command)
% - once separated into single-condition datasets, this shows each component
% 	to be viewed as two superimposed ERP traces!
%rmpath /neuro/mce/meg_1.2/
%pop_comperp(ALLEEG,0,3,2,'geom','array','addavg','on','subavg','on','diffavg','off',...
%	'tplotopt',{'colors',{'r' 'k'}});
%addpath /neuro/mce/meg_1.2/

% PLOT IC PROPERTIES (topo,erpimage,freqspectrum):
%for i=46:65
%	pop_prop( EEG, 0, i);
%end

% PLOT COMPONENT ERP IMAGE (sorted by event type):
%figure; erpimage(squeeze(EEG.icaact(27,:,:)),ev,[],'Comp 44',3,0,'erp','cbar');
%or:


%end % script

	