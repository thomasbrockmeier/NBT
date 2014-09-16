%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2012), see NBT website for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2012  Simon-Shlomo Poil  
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
% ---------------------------------------------------------------------------------------

function [s] = nbt_TrainClassifier(DataMatrix,outcome, s)
%% still missing in this function:
% check for case of multi-class classification!

%% STATISTICAL SWINDLE (remove unimportant predictors)

%% select metod from s.statfunc structure.
switch lower(s.statfunc)
    case 'logit'
        s.ModelVar = glmfit(DataMatrix,outcome,'binomial','link','logit','constant','on');
    case 'elasticlogit' %work in progress
        % Alpha controls how the alg. handles
        % correlated biomarkers. Currently using 0.5. For lower values the
        % algorithm retains more correlated biomarkers, at higher values,
        % the algorithm removes one of the correlated biomarkers, usually
        % picking the one with the highest eigenvalue (i.e. beta).
        
        % Parameters to tweak:
        
        % CV, no. of crossvalidations. Increases precision of the estimated
        %   parameters at the expense of a linear increase in computation.
        
        % Reltol: the algorithm uses cyclic coordiante descent (CCD) to calculate
        %   the path. RelTol is the relative tolerance of CCD algorithm and
        %   affects how long the algorithm tries to converge.
        
        [B,FitInfo] = lassoglm(DataMatrix, outcome,'binomial','Alpha',0.8,'RelTol',1e-6,...
            'CV',3,'NumLambda',100,'Standardize',1);
        try
            lam=FitInfo.IndexMinDeviance;
        catch
            [~,lam]=min(FitInfo.Deviance);
        end
        s.ModelVar=[FitInfo.Intercept(lam); B(:,lam)];
    case 'aenet'
      
%         b=ones(length(BiomsToUse),1);
        %% estimation of beta's for adaptive elastic net
        % By default, we use marginal estimates, due to collinearity
        % issues. However, any other consistent estimate of beta's is
        % permitted.
        % Alternatively, we could use and elastic net to do a
        % pre-screening. Then, for the 1st lasso we select the minimal
        % deviance lambda instead of minimal deviance + 1 standard error.
        %This is akin to Meinshausen's relaxed lasso (2007).
        Alpha=0.5;
        
        %%
        tic
        exponents_array = [0,0.5,1,2];
        opts = statset('UseParallel','always','UseSubstreams','always','Streams',RandStream.create('mrg32k3a'));
%         matlabpool open 3
        B = cell(numel(exponents_array),1);
%         tic
        FitInfo = cell(numel(exponents_array),1);
        [B{1},FitInfo{1}] = lassoglm(DataMatrix, outcome,'binomial','Alpha',0.5,'RelTol',1e-6,...
            'DFmax',length(DataMatrix),'CV',10,'NumLambda',100,'Options',opts,'Standardize',1);
%         toc
        b =abs(B{1}(:,FitInfo{1}.IndexMinDeviance)+1/size(DataMatrix,1));
%         [Z,MU,SIGMA] = zscore(DataMatrix,1,1);

        for counter=2:numel(exponents_array)
%             disp('Standard Code');
%             tic
            iotta = exponents_array(counter);
%             [B{counter,1},FitInfo{counter,1}] = lassoglm((Z.*repmat((b.^(iotta))',size(Z,1),1)), outcome,'binomial','Alpha',Alpha,'DFmax',length(DataMatrix),'RelTol',1e-6,...
%                 'CV',10,'NumLambda',100,'Standardize',0,'Options',opts);
%             B{counter,1} = B{counter,1}.*repmat((b.^iotta)./SIGMA',1,size(B{counter},2));
%             toc
%             disp('Modified code');
%             tic
            [B{counter,1},FitInfo{counter,1}] = aenetglm(DataMatrix, outcome,'binomial',(b.^(-iotta)),'Alpha',Alpha,'DFmax',length(DataMatrix),'RelTol',1e-6,...
                'CV',10,'NumLambda',100,'Standardize',1,'Options',opts);
%             toc
        end
%         matlabpool close
        temp_min_deviance = zeros(4,1);
        temp_deviance = zeros(4,100);
        for counter = 1:4
            temp_min_deviance(counter)= FitInfo{counter}.Deviance(FitInfo{counter}.IndexMinDeviance);
            temp_deviance(counter,1:numel(FitInfo{counter}.Deviance(:))) = FitInfo{counter}.Deviance(:);
        end
        
        min_idy = find(temp_min_deviance==min(temp_min_deviance));
        min_idx= FitInfo{min_idy}.IndexMinDeviance;
        
%         minplus1 = FitInfo{min_idy}.Deviance(min_idx)+FitInfo{min_idy}.SE(min_idx);
%         [y,x] = find((temp_deviance <= minplus1),1,'first');
        exponent_val = exponents_array(min_idy);
        lam=min_idx;
        %       OR
        lam=FitInfo{min_idy}.Index1SE;
        s.ModelVar=[FitInfo{min_idy}.Intercept(lam); (B{min_idy}(:,lam))];

        
    case 'lssvm'
        % LSSVM - Least-square support vector machine
        [pp,alpha,b,gam,sig2,s.ModelVar] = lssvm(DataMatrix,outcome,'c');
    case 'lssvmbay'
        [pp,alpha,b,gam,sig2,model] = lssvm(DataMatrix,outcome,'c');
        [gam, sig2] = bay_initlssvm({DataMatrix,outcome,'c',gam,sig2,'RBF_kernel'});
        [model, gam] = bay_optimize({DataMatrix,outcome,'c',gam,sig2,'RBF_kernel'},2);
        [cost, sig2] = bay_optimize({DataMatrix,outcome,'c',gam,sig2,'RBF_kernel'},3);
        s.ModelVar = trainlssvm({DataMatrix,outcome,'c',gam,sig2});
        % many other classification algorithm: linear regression, SVM from
        % bioinfotoolbox, glm with other link functions, etc see matlab help
    case 'neuralnet'
        net = patternnet([size(DataMatrix,2)]);
      %  net.trainFcn = 'trainbr';
     %  DataMatrix = mapminmax(DataMatrix);
        net = train(net, DataMatrix',outcome');
        s.ModelVar = net;
end
end