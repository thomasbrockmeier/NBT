function H = signal2hankel(x, embeddim)
%

import MISC.ispset;
import MISC.subset;

if nargin < 2 ||  isempty(embeddim), embeddim = 1; end

if ispset(x),
    tmp = delay_embed(x, embeddim, 1);
else
    tmp = MISC.delay_embed(x, embeddim, 1);
end
H  = flipud(subset(tmp, [],1:(length(x)-embeddim+1)));
