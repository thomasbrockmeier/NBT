function status = make_test(userSelection)
% MAKE_TEST - Tests EEGPIPE
%
% meegpipe.make_test
%
%
% See also: eegpipe


import meegpipe.tests.*;
import mperl.join;
import test.simple.make_test;

%clear fun; clear functions; %clear classes;
close all;
clc;

meegpipe.initialize;

if nargin < 1, userSelection = {}; end

verboseLabel = '(eegpipe) ';

%% List of modules that will be tested
moduleList = {...
    'aar', ...
    'filter', ...
    'filter.plotter.fvtool2', ...
    'goo', ...
    'mjava', ...
    'mperl.config.inifiles', ...
    'plotter.eegplot', ...
    'plotter.fvtool2', ...
    'plotter.psd', ...
    'plotter.topography', ...
    'meegpipe.node.bad_channels', ...
    'meegpipe.node.bad_epochs', ...
    'meegpipe.node.bss', ...
    'meegpipe.node.center', ...
    'meegpipe.node.chopper', ...
    'meegpipe.node.copy', ...
    'meegpipe.node.ecg_annotate', ...
    'meegpipe.node.erp', ...
    'meegpipe.node.ev_gen', ...
    'meegpipe.node.ev_features', ...
    'meegpipe.node.obs', ...
    'meegpipe.node.merge', ...
    'meegpipe.node.parallel_node_array', ...
    'meegpipe.node.physioset_import', ...
    'meegpipe.node.pipeline', ...
    'meegpipe.node.qrs_detect', ...
    'meegpipe.node.reref', ...
    'meegpipe.node.resample', ...
    'meegpipe.node.smoother', ...
    'meegpipe.node.spectra', ...
    'meegpipe.node.split', ...
    'meegpipe.node.subset', ...
    'meegpipe.node.filter', ...
    'oge', ...
    'physioset', ...
    'physioset.event', ...
    'physioset.export', ...
    'physioset.import', ...
    'physioset.plotter.psd', ...
    'physioset.plotter.snapshots', ...
    'pset', ...
    'pset.selector', ...
    'report.gallery', ...
    'report.object', ...
    'report.plotter', ...
    'report.table', ...
    'sensors', ...
    'spt.bss', ...
    'spt.criterion', ...
    'spt.feature', ...
    'spt', ...
    'surrogates' ...
    };

if ischar(userSelection), userSelection = {userSelection}; end

if ~isempty(userSelection),
    
    moduleList = intersect(moduleList, userSelection);
    
end

if isempty(moduleList),
    error('Module ''%s'' does not feature automated testing', ...
        userSelection{1});
end

% just in case
moduleList = unique(moduleList);

nbTests = numel(moduleList);

tinit = tic;

status = make_test(moduleList{:});

%% Summary

nbFailed = numel(find(status));

if nbFailed > 0,
    
    fprintf([verboseLabel '%d of %d module(s) had errors\n\n'], ...
        nbFailed, nbTests);
    
    fprintf([verboseLabel 'Below the list of the modules that failed:\n\n']);
    
    fprintf(join(char(10), moduleList(status)));
    
    fprintf('\n\n');
    
else
    
    fprintf([verboseLabel ...
        'Great! All tests (%d modules) were successful\n\n'], nbTests);
    
end

toc(tinit);


end