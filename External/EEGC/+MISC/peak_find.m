function maxima = peak_find(x)
% peak_find() - A simple (but fast) function to find local maxima

x = x(:);
upordown = sign(diff(x));
maxflags = [upordown(1)<0; diff(upordown)<0; upordown(end)>0];
maxima   = find(maxflags);


