function [n_points, n_bytes] = get_nb_points(fid, ndims, precision)
% get_nb_points - Returns the number of points stored in a binary file
%
%   [N_POINTS, N_BYTES] = pset.get_nb_points(FID, NDIMS, PRECISION) where FID
%   is a valid file identifier, NDIMS is the dimensionality fo the points and
%   PRECISION is the precision of the binary file. N_POINTS is the number
%   of points stored in the file and N_BYTES is the number of bytes used by
%   one point.
%
%   See also: PSET

import PSET.globals; 
import PSET.pset;
import MISC.sizeof;

if nargin < 3 || isempty(precision), 
    precision = globals.evaluate.Precision;
end

n_bytes = sizeof(precision)*ndims;

fseek(fid,0,'eof');
pos = ftell(fid);
n_points = floor(pos/n_bytes);
fseek(fid,0,'bof');
if (ceil(pos/(n_bytes*ndims)) - n_points) > eps,
    error('PSET:pset:get_nb_points:inconsistentNbPoints',...
        'There is an inconsistent number of points in this file.');
end

    

end