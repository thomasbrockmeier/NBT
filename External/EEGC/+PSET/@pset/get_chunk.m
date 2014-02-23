function [p_index, y] = get_chunk(obj, chunk_index)
% get_chunk - Gets a data chunk from a pset object
%
%   [P_INDEX, DATA] = get_chunk(OBJ, CHUNK_INDEX) returns a data chunk from
%   a pset object OBJ. The second input argument is the index of the chunk.
%   The second output argument is a numeric matrix with the point values 
%   corresponding to the given chunk. The first output (P_INDEX) is an
%   array with the indices that correspond to the points in the chunk. The
%   number of chunks that are needed to load a whole pset object is
%   stored in property NbChunks.
%
%   Note that the dimensions of DATA depend on whether the pset has or has
%   not been tranposed.
%
%   See also: PSET/PSET/SUBSREF

n_chunks = obj.NbChunks;
if chunk_index > n_chunks || chunk_index < 0,
    error('PSET:pset:getChunk', ...
        'Chunk index must be a natural number less than %d', n_chunks);
elseif chunk_index > (n_chunks-1),
    p_index = obj.ChunkIndices(chunk_index):obj.NbPoints;    
else
    p_index = obj.ChunkIndices(chunk_index):obj.ChunkIndices(chunk_index+1)-1;    
end

if nargout < 2,
    return;
end

if obj.Transposed,
    s.type = '()';
    s.subs = {p_index, 1:obj.NbDims};
    y = subsref(obj, s);
else
    s.type = '()';
    s.subs = {1:obj.NbDims, p_index};
    y = subsref(obj, s);
end