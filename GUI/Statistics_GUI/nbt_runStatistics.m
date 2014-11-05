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



%Let's generate the statistics object
S = NBTstudy.getStatisticsTests(get(findobj('Tag','ListStat'),'Value'));
S.groups = get(findobj('Tag', 'ListGroup'),'Value');
bioms_ind = get(findobj('Tag','ListBiomarker'),'Value');
bioms_name = get(findobj('Tag','ListBiomarker'),'String');
S.channelsRegionsSwitch = get(findobj('Tag', 'ListRegion'),'Value');
S.biomarkers = bioms_name(bioms_ind);
%HACK: to make this work before the GUI is ready!
for i=1:length(bioms_ind)
    tmp{i,1} = [];
end
S.biomarkerIdentifiers =   tmp;
%end HACK

S = S.calculate(NBTstudy);


end