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


for gp = 1:length(S.groups)
    for i = 1:length(bioms_ind)
        [S.group{gp}.biomarkers{i}, S.group{gp}.biomarkerIdentifiers{i}, S.group{gp}.subBiomarkers{i}, S.group{gp}.classes{i}] = nbt_parseBiomarkerIdentifiers(bioms_name{bioms_ind(i)});
    end
end

S = S.calculate(NBTstudy);

NBTstudy.statAnalysis{length(NBTstudy.statAnalysis)+1} = S;
end