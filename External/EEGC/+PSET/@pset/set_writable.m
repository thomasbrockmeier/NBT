function set_writable(obj, v)
% set_writable - Sets the Writable property of the file maps associated to
% a pset object
%
%   set_writable(OBJ, VALUE)
%
%   *This is a private method of the class pset
%
% See also: PSET

for i = 1:length(obj.MemoryMap)
    obj.MemoryMap{i}.Writable = v;
end


end