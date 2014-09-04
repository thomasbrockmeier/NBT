function [pp, s ]=nbt_UseClassifier(DataMatrix, s)

%Create test matrix and outcome vector (or if only one group> classify
%without outcome)

% Select method
switch s.statfunc
   case {'elasticlogit','logit'}
               pp = glmval(s.ModelVar,DataMatrix,'logit','constant','on');
    case 'aenet'
        % Logistic regression
        pp = glmval(s.ModelVar,DataMatrix,'logit','constant','on');
   case {'lssvm','lssvmbay'}
        % LSSVM - Least-square support vector machine
         pp = simlssvm(s.ModelVar,DataMatrix);
    case 'neuralnet'
        net = s.ModelVar;
        pp = net(DataMatrix')';
end



% Insure pp is nan if DataMatrix contains nan for a subject. The
% classification is otherwise not well defined.
pp(isnan(mean(DataMatrix,2))) = nan;
end