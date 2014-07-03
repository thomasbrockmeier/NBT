function [NBT_version,id] = nbt_GetVersion()
    try
        filepath = fileparts(which('NBT.m'));
        filename = fullfile(filepath, 'Contents.m');
        
        if isempty(filename), throwerro; end;
        
        fid = fopen(filename, 'r');
        fgetl(fid);
        versionline = fgetl(fid);
        NBT_version = [versionline(11:end)];
        fclose(fid);
    catch
        NBT_version= 'NBT www.nbtwiki.net';
    end

import mperl.file.spec.rel2abs;
import safefid.safefid;
import mperl.file.spec.catfile;

FILE_NAME = '.git/refs/heads/master';

dirName = rel2abs([fileparts(mfilename('fullpath')) filesep '..']);
fileName = catfile(dirName, FILE_NAME);
try
    if exist(fileName, 'file')
        fid = safefid.fopen(fileName, 'r');
        id = fid.fgetl;
        id = id(1:7);
        NBT_version = [NBT_version ':' id];
    end
catch
end

NBT_version = [NBT_version ' - www.nbtwiki.net'];


end