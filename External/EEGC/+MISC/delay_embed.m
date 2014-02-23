function Y = delay_embed(X, k, step, shift)
% DELAY_EMBED - Delays-embed a signal
%
% Y = delay_embed(X, K, STEP, SHIFT)
%
% where
%
% K is te "embedding factor"
%
% STEP is the embedding delay
%
% SHIFT is the embedding shift

if nargin < 4 || isempty(shift), shift = 0; end
if nargin < 3 || isempty(step), step = 1; end
if nargin < 2 || isempty(k) || isempty(X),
    error('Not enough input arguments');
end

% deal with the case of multiple input signals
if iscell(X),
    Y = cell(size(X));
    for i = 1:length(X)
        Y{i} = delay_embed(X{i}, k, shift, step);        
    end
    return;
end

if k < 0,
    error('The embedding factor must be a natural number.');
end
if shift < 0,
    error('The embedding shift must be greater or equal to zero.');
end
if step < 1,
    error('The embedding delay must be a natural number');
end

n = size(X,1);

embed_dimension = k * n;
embed_sample_width = (k-1) * step + 1;
extra_samples = shift + embed_sample_width - 1;
X = [X X(:,1:extra_samples)];
embed_samples = (size(X,2) - shift) - embed_sample_width + 1;

Y = zeros(embed_dimension, embed_samples, class(X));

for j = 1:k
   s = (shift+step*(j-1)+1); 
   Y((j-1)*n+1:j*n,:) = X(:,s:(s+embed_samples-1));
end

Y = flipud(Y);

