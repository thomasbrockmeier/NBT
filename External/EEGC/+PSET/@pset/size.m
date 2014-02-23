function varargout = size(obj, dim)
% SIZE Size of a pset object
%
%   D = SIZE(OBJ) for a pset object OBJ containing M N-dimensional points,
%   returns the two-element row vector D = [N M]. If the pset object has
%   been transposed (i.e. its property Tranposed is set to true) then SIZE
%   returns the vector D = [M N].
%
%   [M,N] = SIZE(OBJ) for pset object OBJ, returns the number of dimensions
%   and points of OBJ as separate output variables.
%
%   [M1,M2,...,Mk] = SIZE(OBJ) returns M1=M, M2=N and Mk=1 for k>2.
%
% See also: PSET/LENGTH, PSET/NDIMS, PSET/NUMEL

if nargout > 1 && nargin > 1,
    error('PSET:pset:size:badopt','Unknown command option.');    
end

if nargin < 2
    if nargout > 1,
        varargout = cell(nargout,1);
        for i = 1:nargout
            if i < 2
                if obj.Transposed,
                    varargout(i) = {obj.NbPoints};
                else
                    varargout(i) = {obj.NbDims};
                end
            elseif i < 3
                if obj.Transposed,
                    varargout(i) = {obj.NbDims};
                else
                    varargout(i) = {obj.NbPoints};
                end
            else
                varargout(i) = {1};
            end
        end
    else
        if obj.Transposed,
            varargout = {[obj.NbPoints obj.NbDims]};
        else
            varargout = {[obj.NbDims obj.NbPoints]};
        end
    end
else
    if dim > 2,
        varargout = {1};
    elseif dim > 1,
        if obj.Transposed,
            varargout = {obj.NbDims};
        else
            varargout = {obj.NbPoints};
        end
    elseif dim > 0,
        if obj.Transposed,
            varargout = {obj.NbPoints};
        else
            varargout = {obj.NbDims};
        end
    else
        error('PSET:pset:size:dimensionMustBePositiveInteger', ...
            'Dimension argument must be a positive integer scalar within indexing range.');        
    end
    
end


