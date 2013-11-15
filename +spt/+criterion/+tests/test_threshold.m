function [status, MEh] = test_threshold()
% TEST_THRESHOLD - Tests threshold criterion

import test.simple.*;
import pset.session;
import misc.rmdir;
import datahash.DataHash;

MEh     = [];

initialize(8);

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


%% default constructors
try
    
    name = 'default constructor';
    spt.criterion.threshold; 
    ok(true, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% MinCard
try
    
    name = 'MinCard selection';
    
    myCrit = spt.criterion.threshold(...
        'Feature', spt.feature.tkurtosis, ...
        'MinCard', 2);
   
    selected = select(myCrit, [], rand(4, 1000));
    
    ok( numel(find(selected)) == 2, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% MaxCard
try
    
    name = 'MinCard selection';
    
    myCrit = spt.criterion.threshold(...
        'Feature', spt.feature.tkurtosis, ...
        'MaxCard', 2);
   
    selected = select(myCrit, [], rand(4, 1000));
    
    ok( ~any(selected), name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% MaxCard overrides Max
try
    
    name = 'MaxCard overrides Max';
    
    myCrit = spt.criterion.threshold(...
        'Feature',  spt.feature.tkurtosis, ...
        'MaxCard',  2, ...
        'Max',      0);
   
    selected = select(myCrit, [], rand(4, 1000));
    
    ok( numel(find(selected)) == 2, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% MaxCard overrides MinCard
try
    
    name = 'MaxCard overrides Max';
    
    myCrit = spt.criterion.threshold(...
        'Feature',  spt.feature.tkurtosis, ...
        'MaxCard',  2, ...
        'MinCard',  3);
   
    selected = select(myCrit, [], rand(4, 1000));
    
    ok( numel(find(selected)) == 2, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% negated
try
    
    name = 'negated';
    
    myCrit = spt.criterion.threshold('Feature',  spt.feature.tkurtosis);
   
    selected = select(~myCrit, [], rand(4, 1000));
    
    ok( all(selected), name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end


%% Cleanup
try
    
    name = 'cleanup';
    clear data X;
    rmdir(session.instance.Folder, 's');
    session.clear_subsession();
    ok(true, name);
    
catch ME
    ok(ME, name);
end

%% Testing summary
status = finalize();

end

