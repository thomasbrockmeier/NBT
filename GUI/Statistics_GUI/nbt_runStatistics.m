function nbt_runStatistics
        disp('Waiting for statistics ...')
        HrunStat = findobj( 'Tag', 'NBTstatRunButton');
        set(HrunStat, 'String', 'Calculating..')
        drawnow
        %%----------------------
        %% get settings
        %%----------------------
        % --- get statistics test (one)
        statTest = get(findobj('Tag','ListStat'),'Value');
        nameTest = get(findobj('Tag','ListStat'),'String');
        nameTest = nameTest(statTest);
        % --- get channels or regions (one)
        regs_or_chans_index = get(ListRegion,'Value');
        regs_or_chans_name = get(ListRegion,'String');
        regs_or_chans_name = regs_or_chans_name(regs_or_chans_index);
        % --- get biomarkers (one or more)
        bioms_ind = get(ListBiom,'Value');
        bioms_name = get(ListBiom,'String');
        bioms_name = bioms_name(bioms_ind);
        % --- get group (one or more)
        group_ind = get(ListGroup,'Value');
        group_name = get(ListGroup,'String');
        group_name = group_name(group_ind);

disp('gg')





end