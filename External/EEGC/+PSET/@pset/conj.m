function y = conj(obj)
% CONJ Complex conjugate
%
%   OBJ2 = CONJ(OBJ) is the complex conjugate of a pset object OBJ.
%
% See also: PSET/pset, PSET/CTRANSPOSE

y = copy(obj);
writable = obj.Writable;
y.Writable = true;
s.type = '()';
for i = 1:obj.NbChunks
    [index, data] = get_chunk(obj, i);
    data = conj(data);
    if y.Transposed,        
        s.subs = {index, 1:obj.NbDims};        
    else
        s.subs = {1:obj.NbDims, index};        
    end    
    y = subsasgn(y, s, data);
end
y.Writable = writable;
    

