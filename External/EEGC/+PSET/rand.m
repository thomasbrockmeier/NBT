function obj = rand(ndims, npoints, varargin)
% RAND Builds a pset object filled with uniformly distributed random numbers
%
%   OBJ = rand(NDIMS, NPOINTS)
%
% See also: PSET/pset

import PSET.generate_data;

if nargin < 1, ndims = []; end
if nargin < 2, npoints = []; end
if nargin < 3, varargin = {}; end

obj = generate_data('rand', ndims, npoints, varargin{:});