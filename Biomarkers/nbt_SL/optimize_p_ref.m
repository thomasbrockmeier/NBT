function [AREA, PREF, P] = optimize_p_ref(data,P)
% function to calculate optimal p_ref values for one pair of time signals
% Input:
%   data: matrix containing two time signals <samples, 2>
%   P: parameter structure containing
%       m: time-delay embedding dimension m in samples
%       lag:  time-delay in samples
%       norm: 1 if data is not normalized, 0 if otherwise
% Output:
%   AREA: matrix of area sizes between M_hits and M_rec <n_pref,2>
%   PREF: pair of optimal p_ref values, one for each time signal
%   P: updated parameter structure

%initialize variables
P.n_samples = size(data,1);
P.p_ref   = 1/((P.n_samples/P.m)-(2*P.lag)*(P.m-1)+P.m);
P.p_ref_v = P.p_ref:P.p_ref:.3;
n_p = length(P.p_ref_v);

AREA = NaN(n_p,2);
PREF = NaN(1,2);

for p = 1:n_p
    
    P.p_ref = P.p_ref_v(p);
    
    if P.norm == 1
        [data, P] = normalize(data,P);
    end
    
    [~, ~, REC, D, ~, P] = sl(data,[],P);
    
    d_x = squeeze(D(1,:,:));
    d_y = squeeze(D(2,:,:));
    
    rec_x = squeeze(REC(1,:,:));
    rec_y = squeeze(REC(2,:,:));
    
    hits = rec_x .* rec_y;
    
    d_x_rec = d_x .* rec_x;
    d_y_rec = d_y .* rec_y;
    
    d_x_hit = d_x .* hits;
    d_y_hit = d_y .* hits;
    
    %define x_bins and matrix f_hist
    x_bins = 1/1000:20/1000:20;
    f_hist = zeros(3,2,P.n_it,length(x_bins));
    for c_i = 1:P.n_it
        
        d_x_tmp = d_x(c_i,d_x(c_i,:) > 0);
        if isempty(d_x_tmp)
            f_hist(1,1,c_i,:) = 0;
        else
            hstgrm = hist(d_x_tmp,x_bins);
            c_hist = cumsum(hstgrm);
            f_hist(1,1,c_i,:) = c_hist./c_hist(end);
        end
        
        d_y_tmp = d_y(c_i,d_y(c_i,:) > 0);
        if isempty(d_y_tmp)
            f_hist(1,2,c_i,:) = 0;
        else
            hstgrm = hist(d_y_tmp,x_bins);
            c_hist = cumsum(hstgrm);
            f_hist(1,2,c_i,:) = c_hist./c_hist(end);
        end
        
        d_x_rec_tmp = d_x_rec(c_i,d_x_rec(c_i,:) > 0);
        if isempty(d_x_rec_tmp)
            f_hist(2,1,c_i,:) = 0;
        else
            hstgrm = hist(d_x_rec_tmp,x_bins);
            c_hist = cumsum(hstgrm);
            f_hist(2,1,c_i,:) = c_hist./c_hist(end);
        end
        
        d_y_rec_tmp = d_y_rec(c_i,d_y_rec(c_i,:) > 0);
        if isempty(d_y_rec_tmp)
            f_hist(2,2,c_i,:) = 0;
        else
            hstgrm = hist(d_y_rec_tmp,x_bins);
            c_hist = cumsum(hstgrm);
            f_hist(2,2,c_i,:) = c_hist./c_hist(end);
        end
        
        d_x_hit_tmp = d_x_hit(c_i,d_x_hit(c_i,:) > 0);
        if isempty(d_x_hit_tmp)
            f_hist(3,1,c_i,:) = 0;
        else
            hstgrm = hist(d_x_hit_tmp,x_bins);
            c_hist = cumsum(hstgrm);
            f_hist(3,1,c_i,:) = c_hist./c_hist(end);
        end
        
        d_y_hit_tmp = d_y_hit(c_i,d_y_hit(c_i,:) > 0);
        if isempty(d_y_hit_tmp)
            f_hist(3,2,c_i,:) = 0;
        else
            hstgrm = hist(d_y_hit_tmp,x_bins);
            c_hist = cumsum(hstgrm);
            f_hist(3,2,c_i,:) = c_hist./c_hist(end);
        end
        
    end
    
    %now calculate the mean over all iterations
    f_hist_x     = squeeze(f_hist(1,1,:,:));
    f_hist_y     = squeeze(f_hist(1,2,:,:));
    f_hist_x_rec = squeeze(f_hist(2,1,:,:));
    f_hist_y_rec = squeeze(f_hist(2,2,:,:));
    f_hist_x_hit = squeeze(f_hist(3,1,:,:));
    f_hist_y_hit = squeeze(f_hist(3,2,:,:));
    
    f_hist_x     = mean(f_hist_x,1);
    f_hist_y     = mean(f_hist_y,1);
    f_hist_x_rec = mean(f_hist_x_rec,1);
    f_hist_y_rec = mean(f_hist_y_rec,1);
    f_hist_x_hit = mean(f_hist_x_hit,1);
    f_hist_y_hit = mean(f_hist_y_hit,1);
    
    f_hist_x_rec = f_hist_x_rec ./ f_hist_x_rec(end);
    f_hist_y_rec = f_hist_y_rec ./ f_hist_y_rec(end);
    f_hist_x_hit = f_hist_x_hit ./ f_hist_x_hit(end);
    f_hist_y_hit = f_hist_y_hit ./ f_hist_y_hit(end);
    
    valid_x_hit = f_hist_x_hit(f_hist_x_hit > 0 & f_hist_x_hit < 1);
    valid_x_rec = f_hist_x_rec(f_hist_x_hit > 0 & f_hist_x_hit < 1);
    valid_y_hit = f_hist_y_hit(f_hist_y_hit > 0 & f_hist_y_hit < 1);
    valid_y_rec = f_hist_y_rec(f_hist_y_hit > 0 & f_hist_y_hit < 1);
    
    a_y = sum(abs(valid_y_hit - valid_y_rec));
    a_x = sum(abs(valid_x_hit - valid_x_rec));
    
    AREA(p,1) = a_x;
    AREA(p,2) = a_y;
        
end

peak = peakdetection(AREA(:,1),1);
PREF(1) = P.p_ref_v(peak);
peak = peakdetection(AREA(:,2),1);
PREF(2) = P.p_ref_v(peak);

end