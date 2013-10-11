function gui_adv(x, y)
%
% This file is needed by FASTICAG

% This is the advanced options -dialog

% @(#)$Id: gui_adv.m,v 1.4 2004/07/27 13:09:26 jarmo Exp $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables

import external.fastica.*;

% Handle to the window
global hf_FastICA_AdvOpt;

% Handles to some of the controls in window
global hpm_FastICA_finetune;
global he_FastICA_a1;
global he_FastICA_a2;
global he_FastICA_myy;
global he_FastICA_epsilon;
global he_FastICA_maxIterations;
global he_FastICA_maxFinetune;
global he_FastICA_sampleSize
global hpm_FastICA_initState;
global hb_FastICA_initGuess;
global ht_FastICA_initGuess;
global hpm_FastICA_displayMode;
global he_FastICA_displayInterval;
global hpm_FastICA_verbose;

% Some of the main variables needed
global g_FastICA_initGuess;
global g_FastICA_finetune;
global g_FastICA_a1;
global g_FastICA_a2;
global g_FastICA_myy;
global g_FastICA_epsilon;
global g_FastICA_maxNumIte;
global g_FastICA_maxFinetune;
global g_FastICA_initState;
global g_FastICA_sampleSize;
global g_FastICA_displayMo;
global g_FastICA_displayIn;
global g_FastICA_verbose;

global c_FastICA_appr_strD;
global c_FastICA_appr_strV;
global c_FastICA_finetune_strD;
global c_FastICA_finetune_strV;
global c_FastICA_iSta_strD;
global c_FastICA_iSta_strV;
global c_FastICA_dMod_strD;
global c_FastICA_dMod_strV;
global c_FastICA_verb_strD;
global c_FastICA_verb_strV;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configuration options
FIGURENAME = 'FastICA: advanced options';
FIGURETAG = 'f_FastICAAdvOpt';
FIGURESIZE = [x y 450 280];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check to see if this figure is already open - it should not!
% Can't have more than one copy - otherwise the global
% variables and handles can get mixed up.
if ~isempty(findobj('Tag',FIGURETAG))
  error('Error: advanced options dialog already open!');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize some of the controls' values

% Did we already load some initial guess
pm_initState_Value = g_FastICA_initState;
if isempty(g_FastICA_initGuess) | (g_FastICA_initGuess == 1)
  t_initGuess_String = 'Not loaded';
else
  t_initGuess_String = 'Loaded';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the figure
a = figure('Color',[0.8 0.8 0.8], ...
	   'PaperType','a4letter', ...
	   'Name', FIGURENAME, ...
	   'NumberTitle', 'off', ...
	   'Tag', FIGURETAG, ...
	   'Position', FIGURESIZE, ...
	   'MenuBar', 'none');
set (a, 'Resize', 'off');

hf_FastICA_AdvOpt = a;

set(hf_FastICA_AdvOpt, 'HandleVisibility', 'callback');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% From here on it get's ugly as I have not had time to clean it up


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the frames
pos_l=2;
pos_w=FIGURESIZE(3)-4;
pos_h=FIGURESIZE(4)-4;
pos_t=2;
h_f_adv_background = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'Style','frame', ...
  'Tag','f_adv_background');

pos_w=120;
pos_l=FIGURESIZE(3)-(pos_w+2+2);
pos_h=FIGURESIZE(4)-2*4;
pos_t=4;
h_f_adv_side = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'Style','frame', ...
  'Tag','f_adv_side');

pos_l=4;
pos_w=FIGURESIZE(3)-8-pos_w-2;
pos_h=FIGURESIZE(4)-8;
pos_t=4;
h_f_advopt = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'Style','frame', ...
  'Tag','f_advopt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controls in f_advopt
bgc = get(h_f_advopt, 'BackgroundColor');

pos_w1=230;
pos_w2=70;

pos_frame=get(h_f_advopt, 'Position');
pos_h = 20;
pos_t = pos_frame(2) + pos_frame(4) - pos_h - 6;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Fine-tune (g)', ...
  'Style','text', ...
  'Tag','t_727');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
hpm_FastICA_finetune = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',c_FastICA_finetune_strD, ...
  'Style','popupmenu', ...
  'Tag','pm_finetune', ...
  'Value',g_FastICA_finetune);

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Parameter a1 (g = ''tanh'')', ...
  'Style','text', ...
  'Tag','t_22');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_a1 = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Callback','gui_advc Checka1', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_a1), ...
  'Style','edit', ...
  'Tag','e_a1');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Parameter a2 (g = ''gauss'')', ...
  'Style','text', ...
  'Tag','t_222');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_a2 = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Callback','gui_advc Checka2', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_a2), ...
  'Style','edit', ...
  'Tag','e_a2');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','mu (step size)', ...
  'Style','text', ...
  'Tag','t_223');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_myy = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Callback','gui_advc CheckMyy', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_myy), ...
  'Style','edit', ...
  'Tag','e_myy');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','epsilon (stopping criterion)', ...
  'Style','text', ...
  'Tag','t_23');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_epsilon = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_epsilon), ...
  'Style','edit', ...
  'Tag','e_epsilon');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Maximum number of iterations', ...
  'Style','text', ...
  'Tag','t_24');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_maxIterations = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_maxNumIte), ...
  'Style','edit', ...
  'Tag','e_maxIterations');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Maximum iterations in fine-tuning', ...
  'Style','text', ...
  'Tag','t_2412');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_maxFinetune = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_maxFinetune), ...
  'Style','edit', ...
  'Tag','e_maxFinetune');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Sample size (proportion)', ...
  'Style','text', ...
  'Tag','t_224');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_sampleSize = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Callback','gui_advc CheckSampleSize', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_sampleSize), ...
  'Style','edit', ...
  'Tag','e_sampleSize');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Initial state', ...
  'Style','text', ...
  'Tag','t_25');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
hpm_FastICA_initState = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',c_FastICA_iSta_strD, ...
  'Style','popupmenu', ...
  'Tag','pm_initState', ...
  'Value',pm_initState_Value);

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
hb_FastICA_initGuess = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Callback','gui_advc loadGuess', ...
  'Position',[pos_l pos_t (pos_w1-60) pos_h], ...
  'String','Load initial guess', ...
  'UserData', g_FastICA_initGuess, ...
  'Tag','b_LoadGuess');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
ht_FastICA_initGuess = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[(pos_l) pos_t (pos_w2) pos_h], ...
  'String',t_initGuess_String, ...
  'Style','text', ...
  'Tag','t_initGuess');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Display mode', ...
  'Style','text', ...
  'Tag','t_27');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
hpm_FastICA_displayMode = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',c_FastICA_dMod_strD, ...
  'Style','popupmenu', ...
  'Tag','pm_displayMode', ...
  'Value',g_FastICA_displayMo);

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Iterations between displays', ...
  'Style','text', ...
  'Tag','t_28');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
he_FastICA_displayInterval = uicontrol('Parent',a, ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','right', ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',num2str(g_FastICA_displayIn), ...
  'Style','edit', ...
  'Tag','e_displayInterval');

pos_t = pos_t - pos_h;
pos_l = pos_frame(1) + 6;
b = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'HorizontalAlignment','left', ...
  'Position',[pos_l pos_t pos_w1 pos_h], ...
  'String','Verbose', ...
  'Style','text', ...
  'Tag','t_29');

pos_l = pos_frame(1) + pos_frame(3) - 6 - pos_w2;
hpm_FastICA_verbose = uicontrol('Parent',a, ...
  'BackgroundColor',bgc, ...
  'Position',[pos_l pos_t pos_w2 pos_h], ...
  'String',c_FastICA_verb_strD, ...
  'Style','popupmenu', ...
  'Tag','pm_verbose', ...
  'Value',g_FastICA_verbose);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controls in f_adv_side
pos_vspace = 6;
pos_hspace = 10;
pos_frame = get(h_f_adv_side, 'Position');
pos_w = 100;
pos_h = 30;
pos_l = pos_frame(1) + pos_hspace;
pos_t = pos_frame(2) + pos_frame(4) - pos_h - pos_vspace;
b = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Callback','gui_advc OK', ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'String','OK', ...
  'Tag','b_advOK');

pos_t=pos_t-pos_h-pos_vspace;
b = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Callback','gui_advc Cancel', ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'String','Cancel', ...
  'Tag','b_advCancel');

pos_t=pos_t-pos_h-pos_vspace;
b = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Callback','gui_advc Default', ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'String','Default', ...
  'Tag','b_advDefault');

pos_t=pos_t-pos_h-pos_vspace;
b = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Callback','gui_advc Apply', ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'String','Apply', ...
  'Tag','b_advApply');

pos_t = pos_frame(2) + pos_vspace;
b = uicontrol('Parent',a, ...
  'BackgroundColor',[0.701961 0.701961 0.701961], ...
  'Callback','gui_advc Help', ...
  'Position',[pos_l pos_t pos_w pos_h], ...
  'String','Help', ...
  'Tag','b_advHelp');

