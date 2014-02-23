function y = detrend(x, varargin)
% detrend

import MISC.process_varargin;
import MISC.subset;

THIS_OPTIONS = {'windowlength', 'windowoverlap'};


% Default options
windowlength = length(x);
windowoverlap = globals.evaluate.WindowOverlap;

eval(process_varargin(THIS_OPTIONS, varargin));   


% Determine the window length (if not provided by user)
if isempty(windowlength),
    chunk_size = globals.evaluate.LargestMemoryChunk;
    windowlength = floor(sqrt(chunk_size/sizeof(precision)));    
end