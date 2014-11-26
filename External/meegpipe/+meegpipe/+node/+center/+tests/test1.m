function [status, MEh] = test1()
% TEST1 - Tests basic node functionality

import mperl.file.spec.*;
import meegpipe.node.center.*;
import test.simple.*;
import pset.session;
import safefid.safefid;
import datahash.DataHash;
import misc.rmdir;
import oge.has_oge;
import misc.get_username;


MEh     = [];

initialize(7);

%% Create a new session
try
    
    name = 'create new session';
    warning('off', 'session:NewSession');
    session.instance;
    warning('on', 'session:NewSession');
    hashStr = DataHash(randn(1,100));
    session.subsession(hashStr(1:5));
    ok(true, name);
    
catch ME
    
    ok(ME, name);
    status = finalize();
    return;
    
end


%% default constructor
try
    
    name = 'constructor';
    myNode = center; %#ok<NASGU>
    ok(true, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% process sample data
try
    
    name = 'process sample data';
    myNode = center;
    
    X = 3+randn(10, 1000);
    data = import(physioset.import.matrix, X);
    run(myNode, data);
    
    ok(max(abs(X(:)-data(:)-3)) < .15, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% save node output
try
    
    name = 'save node output';
    
    myNode = center('Save', true);
    
    X = 3+randn(10, 1000);
    data = import(physioset.import.matrix, X);
    outputFileName = get_output_filename(myNode, data);
    run(myNode, data);
    
    ok(exist(outputFileName, 'file')>0, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% process multiple files
try
    
    name = 'process multiple datasets';
    
    data = cell(1, 3);
    for i = 1:3,
        data{i} = import(physioset.import.matrix, 2+randn(10, 1000));
    end
    myNode = center('OGE', false);
    run(myNode, data{:});
    ok(max(abs(mean(data{1},2))) < 1e-3, name);
    
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% oge
try
    
    name = 'oge';
    
    if has_oge,
        
        data = cell(1, 3);
        for i = 1:3,
            data{i} = import(physioset.import.matrix, 2+randn(10, 1000));
        end
        
        myNode = center('OGE', true, 'Save', true);
        dataFiles = run(myNode, data{:});
        
        pause(5); % give time for OGE to do its magic
        MAX_TRIES = 50;
        tries = 0;
        while tries < MAX_TRIES && ~exist(dataFiles{3}, 'file'),
            pause(5);
            tries = tries + 1;
        end
        
        [~, ~] = system(sprintf('qdel -u %s', get_username));
        
        ok(exist(dataFiles{3}, 'file') > 0, name);
        
    else
        ok(NaN, name, 'OGE is not available');
    end
    
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% Cleanup
try
    
    name = 'cleanup';
    % just in case
    [~, ~] = system(sprintf('qdel -u %s', get_username));
    clear data dataCopy ans myCfg myNode;
    rmdir(session.instance.Folder, 's');
    session.clear_subsession();
    ok(true, name);
    
catch ME
    ok(ME, name);
end

%% Testing summary
status = finalize();