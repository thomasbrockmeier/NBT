function [y,idx] = sort(a,dim,mode,prop)
%

if numel(a) < 1, 
    y = a;
    idx = [];
    return; 
end

if any(isempty(a)),
    error('Cannot sort empty events');
end
if nargin < 4, 
    if ~isempty(a(1).Sample),
        prop = 'Sample'; 
    elseif ~isempty(a(1).Time),
        prop = 'Time';     
    end
end
if nargin < 3 || isempty(mode), mode = 'ascend'; end
if nargin < 2 || isempty(dim), 
    if numel(a) == length(a),
        [~,dim] = max(size(a));
    else
        dim = 1;
    end
end

sample = nan(size(a));
for i = 1:numel(a),
    sample(i) = a(i).(prop);
end

[~, idx] = sort(sample, dim, mode);
y = a(idx);


