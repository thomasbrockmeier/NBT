function [type, dim, descr] = signal_types
% SIGNAL_TYPES List of signals and corresponding label and dimension
%
%   [TYPE, DIM] = signal_types; returns two Nx1 cell arrays TYPE and DIM.
%   The latter contains the signal type identifier and the former contains
%   the corresponding physical dimensions. An entry in DIM might also be a
%   cell array, meaning that multiple standard physical dimensions are
%   allowed.
%
%   [TYPE, DIM, DESCR] = signal_types; returns also a cell array DESCR with
%   a description of each signal type.
%
%   New signal types can be added to the standard by simply editing the
%   text file signal_types.txt.
%
%
% #-----------------------------------------------------------------------#
% # The EDFPLUS package for MATLAB v1.2                                   #
% #-----------------------------------------------------------------------#
% # Author:  German Gomez-Herrero <g.gomez@nin.knaw.nl>                   #
% #          Netherlands Institute for Neuroscience                       #
% #          Amsterdam, The Netherlands                                   #
% #-----------------------------------------------------------------------#
%
%
%
% See also: EDFPLUS

import MISC.get_tokens;

path = fileparts(mfilename('fullpath'));
filename = [path filesep 'signal_types.txt'];
fid = fopen(filename);
C = textscan(fid, '%s%s%s', 'CommentStyle', '#', 'Delimiter', ':');
fclose(fid);

type = cell(size(C{2}));
dim = cell(size(C{3}));
descr = cell(size(C{1}));
for i = 1:numel(C{1}),
    type{i} = strtrim(C{2}{i});
    dim{i} = get_tokens(C{3}{i},',');
    descr{i} = strtrim(C{1}{i});
end