function y = plus(a, b)
% + Plus. 
%
%   A + B adds B to the contents of pset object A. B can be either a
%   numeric array or a pset object.
%
% See also: PSET/pset


import MISC.ispset;

% Check data dimensions
if ~all(size(a)==size(b)) && ~((prod(size(a))==1) || prod(size(b))==1), %#ok<PSIZE>
    error('PSET:pset:plus:dimensionMismatch', 'Data dimensions do not match.');
end

if ~ispset(a),        
    tmp = a;
    a = b;
    b = tmp;    
end

if a.NbChunks > 1,
    if a.Transposed,
        y = PSET.nan(size(a,2),size(a,1));
        y.Transposed = true;
    else
        y = PSET.nan(size(a,1),size(a,2));
    end
else
    y = nan(size(a,1),size(a,2));
end

if ispset(y),
    y.Writable = true;
end

for i = 1:a.NbChunks
    [index, dataa] = get_chunk(a, i);
    if ispset(b),
        [~, datab] = get_chunk(b, i);
    elseif numel(b)==1,
        datab = b(1);
    else
        if a.Transposed,
            datab = b(index, :);
        else
            datab = b(:, index);
        end
    end    
    if a.Transposed,        
        s.subs = {index, 1:a.NbDims};        
    else
        s.subs = {1:a.NbDims, index};        
    end
    s.type = '()';
    y = subsasgn(y, s, dataa + datab);
end