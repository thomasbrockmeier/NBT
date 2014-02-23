function y = mtimes(a, b)
% * Matrix multiply.
%
%   A*B is the matrix product of A and B, where A is a pset object and B
%   can be either a scalar matrix or a pset object.
%
% See also: PSET/pset


import MISC.ispset;
import MISC.sizeof;
import PSET.pset;
import MISC.subset;
import PSET.globals;

n_b = prod(size(b)); %#ok<*PSIZE>
n_a = prod(size(a));

% Check data dimensions
if (ndims(b) > 2 && n_b > 1) || (ndims(a) > 2 && n_a > 1),
    error('PSET:pset:mtimes:wrongDimensions',...
        'Imputs must be 2-D, or at least one input must be scalar.');
end

if n_b > 1 && n_a>1 && size(a,2)~=size(b,1)
    error('PSET:pset:plus:dimensionMismatch', 'Data dimensions do not match.');
end

% If one of the two inputs is a scalar, call function times()
if n_a < 2 || n_b < 2,
    y = a.*b;
    return;
end

transpose_flag = false;
if ~ispset(a),
    tmp = a.';
    a = b;
    a.Transposed = ~a.Transposed;
    b = tmp;
    transpose_flag = true;
end

% Initialize output
if transpose_flag,    
    y = PSET.zeros(size(b,2), size(a,1));
    y.Transposed = a.Transposed;
else    
    y = PSET.zeros(size(b,2),size(a,1));
    y.Transposed = true;    
end
if y.NbChunks < 2,
    s.type = '()';
    s.subs = {1:size(y,1), 1:size(y,2)};
    y = subsref(y, s);
end

for i = 1:a.NbChunks
    [indexa, dataa] = get_chunk(a, i);
    
    if a.Transposed,
        if ispset(b)
            for j = 1:b.NbChunks
                [indexb, datab] = get_chunk(b, j);
                s.type = '()';
                s.subs = {indexa, indexb};
                y = subsasgn(y, s, dataa*datab);
            end
        else
            datab = b;
            indexb = 1:size(b,2);
            s.type = '()';
            s.subs = {indexa, indexb};
            y = subsasgn(y, s, dataa*datab);
        end
    else
        if n_b < 2,
            datab = b(1);
        else
            s.type = '()';
            s.subs = {indexa, 1:size(b,2)};
            datab = subsref(b, s);
        end
        try
        y = y + (dataa*datab);
        catch
            caca=5;
        end
    end
end

if transpose_flag && ispset(y),
    y.Transposed = ~y.Transposed;
elseif transpose_flag,
    y = y';
end
if transpose_flag,
    a.Transposed = ~a.Transposed;
end

if ispset(y),
    y.Writable = a.Writable;
end
