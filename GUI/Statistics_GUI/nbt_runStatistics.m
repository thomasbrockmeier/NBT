function nbt_runStatistics
global NBTstudy
disp('Waiting for statistics ...')
HrunStat = findobj( 'Tag', 'NBTstatRunButton');
set(HrunStat, 'String', 'Calculating..')
drawnow
%%----------------------
%% get settings
%%----------------------

% --- get channels or regions (one)
regs_or_chans_index = get(findobj('Tag', 'ListRegion'),'Value');
regs_or_chans_name = get(findobj('Tag', 'ListRegion'),'String');
regs_or_chans_name = regs_or_chans_name(regs_or_chans_index);


%Let's generate the statistics object
S = NBTstudy.getStatisticsTests(get(findobj('Tag','ListStat'),'Value'));
S.groups = get(findobj('Tag', 'ListGroup'),'Value');
bioms_ind = get(findobj('Tag','ListBiomarker'),'Value');
bioms_name = get(findobj('Tag','ListBiomarker'),'String');
S.biomarkers = bioms_name(bioms_ind);

end