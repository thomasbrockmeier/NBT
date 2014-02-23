function y = subset(obj, i1, i2)
% SUBSET Selects a subset of dimensions/points from a pset object
%
%   OBJ2 = SUBSET(OBJ, I1, I2) creates a new pset object OBJ2 such that
%   OBJ2(:,:) = OBJ(I1, I2).
%
% See also: PSET/pset

import PSET.nan;

if nargin < 3 || isempty(i2), i2 = 1:size(obj,2); end
if nargin < 2 || isempty(i1), i1 = 1:size(obj,1); end

if obj.Transposed,
    transposed_flag = true;
    obj.Transposed = false;
    tmp = i2;
    i2 = i1;
    i1 = tmp;
else
    transposed_flag = false;
end

y = PSET.nan(length(i1), length(i2));

idx = 1:max(obj.ChunkSize):length(i2);
if idx(end)<length(i2),
    idx = [idx length(i2)];
end    

s.type = '()';
for j = 1:(length(idx)-1)
    this_idx = idx(j):idx(j+1);
    this_i2 = i2(this_idx);
    s.subs = {i1, this_i2};
    data = subsref(obj, s);
    s.subs = {1:length(i1), this_idx};
    y = subsasgn(y, s, data);
end

y.Transposed = transposed_flag;
obj.Transposed = transposed_flag;




