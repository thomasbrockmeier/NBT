function obj = randn(ndims, npoints, varargin)
% RANDN Builds a pset object filled with normally distributed random numbers
%
%   OBJ = randn(NDIMS, NPOINTS)
%
% See also: PSET/pset

import PSET.generate_data;

if nargin < 1, ndims = []; end
if nargin < 2, npoints = []; end
if nargin < 3, varargin = {}; end

obj = generate_data('randn', ndims, npoints, varargin{:});