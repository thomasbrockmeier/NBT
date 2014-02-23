function nbt_runDFA(Signal, SignalInfo, SaveDir,varinput)
[hp, lp, filter_order, FitInterval, CalcInterval, DFA_Overlap, DFA_Plot, ChannelToPlot, res_logbin] = nbt_vararginHandler(varinput);
[Signal, SignalInfo] = nbt_GetAmplitudeEnvelope(Signal, SignalInfo, hp, lp, filter_order);
tic
DFAObject = nbt_doDFA(Signal,SignalInfo,FitInterval, CalcInterval, DFA_Overlap, DFA_Plot, ChannelToPlot, res_logbin);
toc
nbt_SaveClearObject('DFAObject',SignalInfo,SaveDir);
end