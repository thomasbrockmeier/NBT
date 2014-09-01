function sigs = nbt_extractSignals(filename)

infos = whos('-file',filename);

k = 1;
for i = 1:length(infos)
    if strcmp(infos(i).class, 'nbt_SignalInfo')
        sigs{k} = infos(i).name(1:end-4);
        k = k+1;
    end
end
