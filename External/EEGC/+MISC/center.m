function y = center(a)
% CENTER Removes mean from a matrix
%
%   Y = CENTER(A) removes the mean from matrix A
%

import MISC.center; 

if iscell(a),
    y = cell(size(a));
    for i = 1:numel(a)
        y{i} = center(a{i});
    end    
elseif isnumeric(a) && ndims(a)>2,
    y = nan(size(a));
    for i = 1:size(a,3)
        y(:,:,i) = center(a(:,:,i));        
    end    
elseif isnumeric(a) && ndims(a)==2,
    y = a - repmat(mean(a,2),1,size(a,2));
else
    error('MISC:center:invalidInput', ...
        'Input argument must be a 2-dimensional numeric array or a pset object.');    
end
