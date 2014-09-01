classdef (Sealed) session < handle
    % SESSION Starts a new data analysis session
    %
    %   M = session.getInstance(FOLDER) creates a new session that will
    %   stores all temporary session-related files in the folder FOLDER. 
    %
    %   A session instance can be used to generate temporary file names
    %   which are guaranteed to be unique within a session:
    %
    %   M = session.getInstance('sample_folder');
    %   FILENAME = M.getInstance.tmpFileName
    %
    %   where FILENAME is the generated file name, which will be located
    %   inside folder 'sample_folder'.
    %
    %   This is a singleton class meaning that there can be only one
    %   instance of this class in the MATLAB workspace. Deleting this
    %   instance will cause the related folder to be erased, only if the
    %   folder is empty. 
    properties (SetAccess = private)
        Folder;         % Folder where all session-related temporary files will be stored.         
    end
    
    % Constructor
    methods (Access = private)
        function obj = session(folder)
            if nargin < 1 || isempty(folder),
                ME = MException('','');
                throw(ME);
            end            
            if exist(folder, 'dir') && length(dir(folder))>2,
                error('session:session:invalidFolder',...
                    'Folder %s is invalid or non-empty.', folder);                
            end            
            if ~exist(folder, 'dir')
                mkdir(folder);
            end            
            obj.Folder = folder;    
        end
    end
    methods (Static)
        function singleObj = getInstance(folder, varargin)
            % Creates the session
            
            import MISC.process_varargin;
            THIS_OPTIONS = {'force'};
            force = false;
            eval(process_varargin(THIS_OPTIONS, varargin));                
                        
            if nargin < 1, 
                folder = []; 
            end
                        
            persistent localObj
            if isempty(localObj) || ~isvalid(localObj)
                if isempty(folder)
                    ME = MException('session:Uninitialized', ...
                        'A session object needs to be initialized. Use: session.getInstance(FOLDER).');
                    throw(ME);
                elseif exist(folder, 'file') && length(dir(folder))>2,
                    if force,
                        try %#ok<UNRCH>
                            rmdir(folder,'s'); 
                        catch ME
                            if strcmpi(ME.identifier, 'MATLAB:RMDIR:NoDirectoriesRemoved'),
                                ME = MException('session:UnableToRemoveSession', ...
                                    'Unable to remove previous session. Do ''clear classes'' and retry.');
                                throw(ME);
                            else
                                rethrow(ME);
                            end
                        end
                    else
                        ME = MException('session:NonEmptyFolder', ...
                            'The session folder is not empty.');
                        throw(ME);
                    end
                elseif exist(folder, 'file'),
                    folder = what(folder);
                    folder = folder.path;
                else
                    mkdir(folder);
                    folder = what(folder);
                    folder = folder.path;
                end
                
                localObj = session(folder);
            end
            singleObj = localObj;
        end
    end
    methods
        function file_name = tmpFileName(obj)
            % Returns a unique file name within a session
            persistent fileCounter;
            if isempty(fileCounter),
                fileCounter = 0;
            else
                fileCounter = fileCounter + 1;
            end
            
            file_name = [obj.Folder filesep datestr(now, 'yyyymmddTHHMMSS') ...
                '_' num2str(fileCounter)];           
            
        end           
              
    end
    
    % destructor
    methods
        function delete(obj)
            if exist(obj.Folder, 'file') && length(dir(obj.Folder)) < 3,
                rmdir(obj.Folder);
            end
        end
    end
    
end