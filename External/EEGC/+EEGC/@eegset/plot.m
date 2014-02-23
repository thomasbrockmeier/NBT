function h = plot(obj, varargin)
% PLOT Plots an eegset object using EEGLAB's eegplot
%
%   plot(OBJ) plots the object OBJ using the default plotting options.
%
%   plot(OBJ, 'opt1_name', opt1_val,..., 'optN_name', optN_val) where
%   ('opt_name',opt_val) are pairs of property names and property values.
%   For a list of valid properties see the help of eegplot.
%
% See also: eegplot, EEGC/eegset

import MISC.process_varargin;


THIS_OPTIONS = {'srate','winlength', 'data2','events'};

% Default options
srate = obj.SamplingRate;
winlength = 15;
data2 = [];
events = [];

% Allow the user to override the default options
[cmd_str, remove] = process_varargin(THIS_OPTIONS, varargin);
eval(cmd_str);
varargin(remove) = [];

% Convert events to EEGLAB format
if isempty(events) && (isempty(obj.EventEEGLAB) || length(obj.EventEEGLAB)~=length(obj.Event)),
    obj.EventEEGLAB = eeglab(obj.Event);    
    events = obj.EventEEGLAB;
elseif isempty(events),
    events = obj.EventEEGLAB;
else
    events = eeglabEvent(events);
end

% Transpose, if necessary
if obj.Transposed,
    transposed_flag = true;
    obj.Transposed = false;
else
    transposed_flag = false;
end

% Use eegplot to plot the data
if isempty(data2),
    eegplot(obj, 'srate', srate, 'winlength', winlength, ...
        'events', events, varargin{:});
else
    eegplot(obj, 'srate', srate, 'winlength', winlength, ...
        'events', events, 'data2', data2, varargin{:});
end
h = gcf;

obj.Transposed = transposed_flag;
