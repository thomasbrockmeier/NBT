function [p, mean_difference, N_s, p_low, p_high]=nbt_permutationtest(Data1,Data2,N,PairedSwitch,stat_function_handle)
% permutationtest, permutationtest(X1,X2,NumPermutations) is a two-tail
% permutationtest t-test based on Moore, D. S., G. McCabe, W. Duckworth, and S. Sclove (2003):
% and  M.D. Ernst (2004)
% Simon-Shlomo Poil 2008 - two-tail version

%% Error handling
% check dimesions
Data1 = Data1(:);
Data2 = Data2(:);

%% Remove any NaNs
if (~PairedSwitch)
    Data1 = Data1(~isnan(Data1));
    Data2 = Data2(~isnan(Data2));
else
    if(length(Data1) ~= length(Data2))
    disp('Not paired data or some other error')
    end
    Data1 = Data1(~isnan(Data2));
    Data2 = Data2(~isnan(Data2));
    Data2 = Data2(~isnan(Data1));
    Data1 = Data1(~isnan(Data1));
end



if (~PairedSwitch)
    %% Init
    Data = [Data1;Data2];
    difference = zeros(N,1);
    Data1Size = length(Data1);

    %% Do N permutations
    for i=1:N
        y = randsample(Data,length(Data),false);
        y1 = y(1:Data1Size);
        y2 = y((Data1Size+1):end);
        difference(i) = stat_function_handle(y2) - stat_function_handle(y1);
    end
else
    DataIndex = [1:length(Data1)];
    y1= nan(length(Data1),1);
    y2= nan(length(Data1),1);
    for i=1:N
        y = rand(length(Data1),1);
        y1(1:length(find(y>0.5))) = Data1(y > 0.5);
        y1(length(find(y>0.5))+1:end) = Data2(y<=0.5);
        y2(1:length(find(y>0.5))) = Data2(y > 0.5);
        y2(length(find(y>0.5))+1:end) = Data1(y<=0.5);
        %     y = randsample(DataIndex,length(DataIndex),false);
        %     y1(1:(length(Data1)/2)) = Data1([y(1:(length(y)/2))]);
        %     y1((length(Data1)/2):end) = Data2([y((length(y)/2):end)]);
        %     y2(1:(length(Data1)/2)) = Data2([y(1:(length(y)/2))]);
        %     y2((length(Data1)/2):end) = Data1([y((length(y)/2):end)]);
        difference(i) = stat_function_handle(y2-y1);
    end
end
%% Plot historgram
%hist(difference)

%% Calculate p-value
if(~PairedSwitch)
    mean_difference = stat_function_handle(Data2) - stat_function_handle(Data1);
else
    mean_difference = stat_function_handle(Data2-Data1);
end
N_s = sum(abs(difference) >= abs(mean_difference));
N_shigh = sum(difference >=mean_difference);
N_slow = sum(difference <= mean_difference);
p   = (N_s+1)/(N+1);
p_low = (N_slow+1)/(N+1);
p_high = (N_shigh+1)/(N+1);
%pSIGN = signtest(Data1,Data2) %abr cont dist.
%pSIGNrank = signrank(Data1,Data2) %symmetric around median
%pRANK = ranksum(Data1,Data2) %abr cont not (paired?)
end