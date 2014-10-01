function obj = nan(ndims, npoints, varargin)
% NAN Builds a pset object filled with nans
%
%   OBJ = nan(NDIMS, NPOINTS) creates a temporary pset object OBJ that
%   contains a pointset of dimensionality NDIMS and cardinality NPOINTS. 
%
%
% See also: PSET/pset

import PSET.generate_data;

if nargin < 1, ndims = []; end
if nargin < 2, npoints = []; end
if nargin < 3, varargin = {}; end

obj = generate_data('nan', ndims, npoints, varargin{:});