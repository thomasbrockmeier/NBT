function obj = ones(ndims, npoints, varargin)
% ONES Builds a pset object filled with ones
%
%   OBJ = ones(NDIMS, NPOINTS) creates a temporary pset object OBJ that
%   contains a pointset of dimensionality NDIMS and cardinality NPOINTS. 
%
%
% See also: PSET/pset

import PSET.generate_data;

if nargin < 1, ndims = []; end
if nargin < 2, npoints = []; end
if nargin < 3, varargin = {}; end

obj = generate_data('ones', ndims, npoints, varargin{:});