%% Examples of field for the statdata class
    
statdata.biomarker;% biomarkername
statdata.test % test name
statdata.statistic %statistics function
statdata.func %statistics test function
                
%% normality test
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.cdf1  %struct cumulative distribution function biomarker1 
statdata.h %hypothesis
statdata.p %pvalue
statdata.KS %kstat
statdata.critval %critical value
%subregions
statdata.c1_regions = nan(n_regions,n_sub); %biomarker1 per region
statdata.cdf_c1_regions %struct cumulative distribution function biomarker1 per region
statdata.h_regions %hypothesis
statdata.p_regions %value
statdata.KS_regions %kstat
statdata.critval_regions %critical value
% case of 2 conditions
statdata.diffC2C1 = nan(n_biom,n_sub);%biomarker difference
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.c2 = nan(n_biom,n_sub);%biomarker2
statdata.cdf1 %struct cumulative distribution function biomarker1 
statdata.cdf2 %struct cumulative distribution function biomarker2
statdata.h %hypothesis
statdata.p %pvalue
statdata.KS %kstat
statdata.critval %critical value
% case of 2 conditions(subregions)                
statdata.c1_regions = nan(n_regions,n_sub); %biomarker1 per region
statdata.c2_regions = nan(n_regions,n_sub); %biomarker2 per region
statdata.diff_regions = nan(n_regions,n_sub); %biomarker difference per region
statdata.cdf_c1_regions %struct cumulative distribution function biomarker1 per region
statdata.cdf_c2_regions %struct cumulative distribution function biomarker2 per region
statdata.h_regions %hypothesis
statdata.p_regions %pvalue
statdata.KS_regions %kstat
statdata.critval_regions %critical value
statdata.h1 %hypothesis
statdata.h2 %hypothesis
statdata.p1 %pvalue
statdata.p2 %pvalue
statdata.KS1 %kstat
statdata.KS2 %kstat
statdata.critval1_regions %critical value
statdata.critval2_regions %critical value

%% ttest 
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.meanc1 = nan(n_biom,1);%mean biomarker1
statdata.h = nan(n_biom,1);%hypothesis 
statdata.p = nan(n_biom,1);%pvalue
statdata.C = nan(n_biom,2);%confidence interval
%subregions              
statdata.c1_regions = nan(n_regions,n_sub); %biomarker1 per region
statdata.mean_c1_regions = nan(n_regions,1);%mean biomarker1 per region
statdata.h_regions = nan(n_regions,1);%hypothesis
statdata.p_regions = nan(n_regions,1);%pvalue
statdata.C_regions = nan(n_regions,2);%confidence interval
%case of 2 conditions                
statdata.diffC2C1 = nan(n_biom,n_sub);%biomarker difference
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.c2 = nan(n_biom,n_sub);%biomarker2
statdata.meanc1 = nan(n_biom,1);%mean biomarker1
statdata.meanc2 = nan(n_biom,1);%mean biomarker2
statdata.h = nan(n_biom,1);%hypothesis
statdata.p = nan(n_biom,1);%pvalue
statdata.C = nan(n_biom,2);%confidence interval
%case of 2 conditions(subregions)                
statdata.c1_regions = nan(n_regions,n_sub); %biomarker1 per region
statdata.c2_regions = nan(n_regions,n_sub); %biomarker2 per region
statdata.diff_regions = nan(n_regions,n_sub); %biomarker difference per region
statdata.mean_c1_regions = nan(n_regions,1);%mean biomarker1 per region
statdata.mean_c2_regions = nan(n_regions,1);%mean biomarker2 per region
statdata.h_regions = nan(n_regions,1);%hypothesis
statdata.p_regions = nan(n_regions,1);%pvalue
statdata.C_regions = nan(n_regions,2);%confidence interval
statdata.h1 = nan(n_regions,1);%hypothesis
statdata.h2 = nan(n_regions,1);%hypothesis
statdata.p1 = nan(n_regions,1);%pvalue
statdata.p2 = nan(n_regions,1);%pvalue
statdata.C1 = nan(n_regions,2);%confidence interval
statdata.C2 = nan(n_regions,2);%confidence interval
%% signrank
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.medianc1 = nan(n_biom,1);%median biomarker1
statdata.p = nan(n_biom,1);%pvalue
statdata.C = nan(n_biom,2);%confidence interval
%subregions                  
statdata.c1_regions = nan(n_regions,n_sub);% biomarker1 per region
statdata.median_c1_regions = nan(n_regions,1);
statdata.p_regions = nan(n_regions,1);%pvalue
statdata.C_regions = nan(n_regions,2);%confidence interval
%case of 2 conditions                   
statdata.diffC2C1 = nan(n_biom,n_sub);%biomarker diff
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.c2 = nan(n_biom,n_sub);%biomarker2
statdata.medianc1 = nan(n_biom,1);%median biomarker1
statdata.medianc2 = nan(n_biom,1);%median biomarker2
statdata.p = nan(n_biom,1);%pvalue
statdata.C = nan(n_biom,2);%confidence interval
%case of 2 conditions(subregions)                 
statdata.c1_regions = nan(n_regions,n_sub);% biomarker1 per region
statdata.c2_regions = nan(n_regions,n_sub);% biomarker2 per region
statdata.diff_regions = nan(n_regions,n_sub);% biomarker difference per region
statdata.median_c1_regions = nan(n_regions,1);%median biomarker1
statdata.median_c2_regions = nan(n_regions,1);%median biomarker2
statdata.p_regions = nan(n_regions,1);%pvalue
statdata.C_regions = nan(n_regions,2);%confidence interval
statdata.C1 = nan(n_regions,2);%confidence interval
statdata.C2 = nan(n_regions,2);%confidence interval
%% ttest2
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.c2 = nan(n_biom,n_sub);%biomarker2
statdata.meanc1 = nan(n_biom,1);%mean biomarker1
statdata.meanc2 = nan(n_biom,1);%mean biomarker2
statdata.h = nan(n_biom,1);%hypothesis
statdata.p = nan(n_biom,1);%pvalue
statdata.C = nan(n_biom,2);%confidence interval
statdata.Diffc2c1 = nan(n_biom,n_sub);%biomarker mean diff
%subregions                 
statdata.c1_regions = nan(n_regions,n_sub);% biomarker1 per region
statdata.c2_regions = nan(n_regions,n_sub);% biomarker2 per region
statdata.mean_c1_regions = nan(n_regions,1);%mean biomarker1 per region
statdata.mean_c2_regions = nan(n_regions,1);%mean biomarker2 per region
statdata.h_regions = nan(n_regions,1); %hypothesis
statdata.p_regions = nan(n_regions,1);%pvalue
statdata.C_regions = nan(n_regions,2);%confidence interval
statdata.h1 = nan(n_regions,1);%hypothesis
statdata.h2 = nan(n_regions,1);%hypothesis
statdata.p1 = nan(n_regions,1);%pvalue
statdata.p2 = nan(n_regions,1);%pvalue
statdata.C1 = nan(n_regions,2);%confidence interval
statdata.C2 = nan(n_regions,2);%confidence interval
%% ranksum
statdata.c1 = nan(n_biom,n_sub);%biomarker1
statdata.c2 = nan(n_biom,n_sub);%biomarker2
statdata.medianc1 = nan(n_biom,1);%median biomarker1
statdata.medianc2 = nan(n_biom,1);%median biomarker2
statdata.p = nan(n_biom,1);%pvalue
statdata.C = nan(n_biom,2);%confidence interval
statdata.Diffc2c1 = nan(n_biom,n_sub);%biomarker median diff
%subregions 
statdata.c1_regions = nan(n_regions,n_sub);% biomarker1 per region
statdata.c2_regions = nan(n_regions,n_sub);% biomarker2 per region
statdata.median_c1_regions = nan(n_regions,1);%median biomarker1 per region
statdata.median_c2_regions = nan(n_regions,1);%median biomarker2 per region
statdata.p_regions = nan(n_regions,1);%pvalue
statdata.C_regions = nan(n_regions,2);%confidence interval
statdata.C1 = nan(n_regions,2);%confidence interval
statdata.C2 = nan(n_regions,2);%confidence interval