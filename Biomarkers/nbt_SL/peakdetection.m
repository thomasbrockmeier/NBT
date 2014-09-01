function peak = peakdetection(a,nh)
% function to detect the largest area between M_hits and M_rec. This
% function is part of the p_ref optimization algorithm
% Input:
%   a: vector of area values
%   nh: size of shifting window = 1 sample
% Output:
%   peak: maximal area value in vector a

% Initialize peakentries
peakentries = NaN(1,length(a));

for i = 1:length(a)
    
    lb = i-nh;
    ub = i+nh;
    if lb < 1; lb = 1; end
    if ub > length(a); ub = length(a); end
    
    peakentries(i) = max(a(lb:ub)) == a(i);
    
end

peakentries(end)=0;
peakentries = logical(peakentries);

peak = find(a == max(a(peakentries)),1,'First');

end