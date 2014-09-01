
function Signal=nbt_RemoveIntervals(Signal,SignalInfo)

if isfield(SignalInfo.interface,'noisey_intervals')
    intervals = SignalInfo.interface.noisey_intervals;
    good=1:size(Signal,1);
    for i=1:size(intervals,1)
        good =setdiff(good, intervals(i,1):intervals(i,2));
    end
    Signal=Signal(good,:);
end
end