% nbt_statisticslog - this function is part of the statistics GUI, it stores the list of statistics functions
% implemented in NBT
%
% Usage:
%  s = nbt_statisticslog(index)
%
% Inputs:
%   index is an integer indicating the test in the list of the statistics
%   interface 
% Outputs:
%  s ia a struct containing information on the selected statistical test
%
% Example:
%  
%
% References:
% 
% See also: 
%  nbt_selectrunstatistics
  
%------------------------------------------------------------------------------------
% Originally created by Giuseppina Schiavone (2012), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) <year>  <Main Author>  (Neuronal Oscillations and Cognition group, 
% Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, 
% Neuroscience Campus Amsterdam, VU University Amsterdam)
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
% -------------------------------------------------------------------------
% --------------


function s = nbt_statisticslog(index)
s.statType = [];
switch index
    case 1 % Not statistics just plotting
        s.statistic=@nanmedian;
        s.statfunc = @nanmedian;
        s.statfuncname='Grand median plot';
        s.statname='nanmedian';
    case 2 % Normality (Univariate): Lilliefors test
        s.statistic=@nbt_cdfcalc_modified;
        s.statfunc = @lillietest;
        s.statfuncname='Lilliefors test';
        s.statname='cdf';
    case 3 % Normality (Univariate): Shapiro-Wilk test
        s.statistic = @swtest;% see test statistics inside swtest function
        s.statfunc =@swtest; 
        s.statfuncname='Shapiro-Wilk test';
        s.statname = 'SWstatistic';
    case 4 % Parametric (Univariate): Student paired t-test
        s.statistic=@nanmean;
        s.statfunc = @ttest;
        s.statfuncname='Student paired t-test';
        s.statname='mean';
    case 5 % Non-Parametric (Univariate): Wilcoxon signed rank test
        s.statistic=@nanmedian;
        s.statfunc = @signrank;
        s.statfuncname='Wilcoxon signed rank test';
        s.statname='median';
    case 6 % Parametric (Bi-variate): Student unpaired t-test
        s.statistic=@nanmean;
        s.statfunc = @ttest2;
        s.statfuncname='Student unpaired t-test';
        s.statname='mean';
    case 7 % Non-Parametric (Bi-variate):  Wilcoxon rank sum test
        s.statistic=@nanmedian;
        s.statfunc = @ranksum;
        s.statfuncname='Wilcoxon rank sum test';
        s.statname='median';
    case 8 % Non-Parametric (Univariate):  Permutation for difference means or medians
        s.statistic=@nanmean;
        s.statfunc = @nbt_permutationtest;
        s.statfuncname='Permutation for mean difference';
        s.statname='mean';
    case 9 % Non-Parametric (Univariate):  Permutation for paired difference means or medians
        s.statistic=@nanmean;
        s.statfunc = @nbt_permutationtest;
        s.statfuncname='Permutation for paired mean difference';
        s.statname='pairedmean';
 
    case 10 % Non-Parametric (Univariate):  Permutation for difference means or medians
        s.statistic=@nanmedian;
        s.statfunc = @nbt_permutationtest;
        s.statfuncname='Permutation for median difference';
        s.statname='median';
    case 11 % Non-Parametric (Univariate):  Permutation for paired difference means or medians
        s.statistic=@nanmedian;
        s.statfunc = @nbt_permutationtest;
        s.statfuncname='Permutation for paired median difference';
        s.statname='pairedmedian'; 
    case 12 % Non-Parametric (Bi-variate):  Permutation for correlation
        s.statistic= @corr;
        s.statfunc = @nbt_perm_corr;
        s.statfuncname='Permutation for correlation';
        s.statname='correlation';
    case 13 % ANOVA one-way
        s.statistic = @nanmean;
        s.statfun = @anova1;
        s.statfuncname = 'One-way ANOVA';
        s.statname = 'One-way ANOVA';
    case 14 % ANOVA two-way
        s.statistic = @nanmean;
        s.statfun = @anova2;
        s.statfuncname = 'Two-way ANOVA';
        s.statname = 'Two-way ANOVA'; 
    case 15 %Kruskal-Wallis test
        s.statistic = @nanmedian;
        s.statfun = @kruskalwallis;
        s.statfuncname = 'Kruskal-Wallis test';
        s.statname = 'Kruskal-Wallis test';
    case 16 %Friedman test
        s.statistic = @nanmedian;
        s.statfun = @friedman;
        s.statfuncname = 'Friedman test';
        s.statname = 'Friedman test';
    otherwise
        s = [];
end