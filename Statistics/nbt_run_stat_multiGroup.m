

function s=nbt_run_stat_multiGroup(B_values,s,MaxGroupSize,NCHANNELS, bioms_name,unit)
%  We first create a Matrix for the multiple group statistical function
pvalues = nan(1,NCHANNELS);
DataCell = cell(NCHANNELS, 1);
MultiStats = cell(NCHANNELS, 1);
for BId = 1:length(bioms_name)
    for ChId = 1:NCHANNELS
        DataMatrix = nan(MaxGroupSize,length(B_values));
        for GrpId = 1:length(B_values)
            B_Data = B_values{GrpId,1}(ChId,:,BId)';
            DataMatrix(1:length(B_Data), GrpId) = B_Data;
        end
        DataCell{ChId,1} = DataMatrix;
        %run statistics
        if (strcmp(s(1).statfuncname, 'One-way ANOVA'))
            [pvalues(ChId), table, MultiStats{ChId, 1}] = anova1(DataMatrix,[],'off');
        elseif(strcmp(s(1).statfuncname, 'Two-way ANOVA'))
            if(any(isnan(DataMatrix)))
                DataMatrix=removeNANsubjects(DataMatrix);
            end
            [dummy, table, MultiStats{ChId, 1}] = anova2(DataMatrix,[],'off');
            F = table(2,5);
            pvalues(ChId) = adjPF(DataMatrix,F{1,1});
        elseif(strcmp(s(1).statfuncname, 'Kruskal-Wallis test'))
            [pvalues(ChId), t, MultiStats{ChId, 1}] = kruskalwallis(DataMatrix,[],'off');
        elseif(strcmp(s(1).statfuncname, 'Friedman test'))
            if(any(isnan(DataMatrix)))
                DataMatrix=removeNANsubjects(DataMatrix);
            end
            [dummy Table MultiStats{ChId, 1},F]=friedmanGG(DataMatrix,[],'off');
            % yes correct to use F stat.. see Conover 1981
            pvalues(ChId) = adjPF(DataMatrix,F{1,1});
        else
            error('This test is not supported for multiple groups designs');
        end
    end
    s(BId).statistic = s(1).statistic;
    s(BId).statfun = s(1).statfun;
    s(BId).statfuncname  = s(1).statfuncname;
    s(BId).statname = s(1).statname;
    s(BId).p = pvalues;
    s(BId).DataCell = DataCell;
    s(BId).MultiStats = MultiStats;
    s(BId).biom_name = bioms_name{BId};
    s(BId).unit = unit;
end


end

function Data2 = removeNANsubjects(Data)
%removes subjects with any missing values
NaNswitch = sum(isnan(Data'));
Data2 = [];
for i=1:length(NaNswitch)
    if (NaNswitch(i) == 0)
        Data2 = [Data2; Data(i,interval)];
    end
end
warning('Missing values detected. Subjects with missing values have been removed from the statistical test');
end