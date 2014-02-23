classdef pset < handle
    % PSET Construct memory-mapped point-set object
    %
    %   M = pset(FILENAME, NDIMS) constructs a pset object associated to
    %   the binary data file FILENAME, which stores points of
    %   dimensionality NDIMS.
    %
    %   M = pset(FILENAME, NDIMS, PROP1, VALUE1, PROP2, VALUE2, ...)
    %   constructs a pset object, and sets the properties of that object
    %   that are named in the argument list (PROP1, PROP2, etc.) to the
    %   given values (VALUE1, VALUE2, etc.). All property name arguments
    %   must be quoted strings (e.g., 'writable'). Any properties that are
    %   not specified are given their default values.
    %
    %   M = pset(PSET_OBJ) where is a pset object returns exactly
    %   the same object, i.e. is equivalent to M = PSET_OBJ.
    %
    %   Property/Value pairs and descriptions:
    %
    %       Precision: Char array (defaults to 'double')
    %           Precision of the numeric values stored in the associated file.%
    %           Supported char arrays are 'int8', 'int16', 'int32', 'int64',
    %           'uint8', 'uint16', 'uint32', 'uint64', 'single', and 'double'.
    %
    %       Writable: True or false (defaults to false).
    %           Access level which determines whether the pset may be assigned
    %           to. That is, whether obj(index) = value assignments are
    %           allowed.
    %
    %       Temporary: True or false (default to false)
    %           Determines whether the associated data file should be erased
    %           after a pset object goes out of scope or is otherwise cleared.
    %
    %       Transposed: True or false (default to false)
    %           Determines whether the subsref should use column-wise
    %           or row-wise points. By default Transposed is false and
    %           obj(:,i) will return the value of the ith point. If
    %           Transposed is set to true, the ith point would be addressed
    %           as obj(i,:).
    %
    %       Header: struct (defaults to an empty struct)
    %           Provides any additional information regarding the pset.
    %           This information will be stored in the public property
    %           'Header' of the generated pset object. Alternatively, this
    %           property value can also be a char array. In the latter
    %           case, the char array will be assumed to be the name of a
    %           .MAT file where the header information struct is stored.
    %
    %
    %   Examples:
    %       % To create a pset associated with the data file 'pointset.dat,
    %       % (which contains 7-dimensional points in single precision), and
    %       % set every other point in the pset object to zero:
    %       %
    %       p = pset('records.dat', 7, 'Precision', 'single', 'Writable', true)
    %       pset(:,1:2:end) = 0;
    %
    % See also: MEMMAPFILE, EEGC/eegset
    
    % Public properties
    % Important: This properties must be in agreement with the properties
    % returned by overloaded method fieldnames()
    properties         
        Temporary = true;    % Should the associated files be erased after the object goes out of scope?
        Transposed = false;  % Are the sample values stored rowwise?
        Precision = 'double';% Numeric precision used in the data file.
        Writable = true;     % Write access.
        Header;              % Header information (a struct).         
    end
    
    properties (SetAccess = private)
        DataFile;           % Binary file where the data values are stored.
        HeaderFile;         % .MAT file where header info is stored.
        Info = struct;      % Miscellaneous information (a struct).
        NbPoints;           % Number of points (samples) in the pset object.
        NbDims;             % Cardinality of the pset.
    end
    
    properties (GetAccess = private, SetAccess = private)
        MapIndices;
        ChunkIndices;
        MemoryMap;        
    end
    
    properties (Dependent)        
        NbMaps;             % Number of memory maps used.
        NbChunks;           % Number of memory chunks needed to load the whole pset.
        ChunkSize;          % Size of a data chunk in number of points.
        MapSize;            % Size of a map size in number of points.
    end
    
    % Set/Get methods
    methods
        function y = get_events(obj)
            y = [];
            if ~isempty(obj.HeaderFile),                
                tmp = load(obj.HeaderFile, 'event_obj');
                if isfield(tmp,'event_obj'),
                    y = tmp.event_obj;
                end
            end                    
        end               
        function y = get.NbMaps(obj)
            % Number of memory maps in the pset object.
            y = length(obj.MapIndices);
        end
        function y = get.NbChunks(obj)
            y = length(obj.ChunkIndices);          
        end        
        function y = get.ChunkSize(obj)
            y = [diff(obj.ChunkIndices) obj.NbPoints-obj.ChunkIndices(end)+1];            
        end
        function set.Temporary(obj, v)
            if ~isscalar(v) || ~isa(v, 'logical')
                error('PSET:pset:illegalTemporarySetting', ...
                    'The Temporary field must contain a scalar logical.');
            end
            obj.Temporary = v;
        end
        function set.Transposed(obj, v)
            if ~isscalar(v) || ~isa(v, 'logical')
                error('PSET:pset:illegalTransposedSetting', ...
                    'The Transposed field must contain a scalar logical.');
            end
            obj.Transposed = v;
        end
        function set.Writable(obj, v)
            if ~isscalar(v) || ~isa(v, 'logical')
                error('PSET:pset:illegalWritableSetting', ...
                    'The Writable field must contain a scalar logical.');
            end
            obj.Writable = v;
            set_writable(obj, v);
        end

        function y = get_orig_header(obj)
            y = [];
            if ~isempty(obj.HeaderFile),                
                tmp = load(obj.HeaderFile, 'hdr');
                if isfield(tmp,'hdr'),
                    y = tmp.hdr;
                end
            end                    
        end
    end
    
    % Immutable methods
    methods
        y = subsref(a, s); % done!
        y = end(a,k,n);    % done!
        y = isempty(a);    % done!
        y = isnumeric(a);  % done!
        y = isfloat(a);    % done!
        y = issparse(a);   % done!
        y = ispset(a);     % done!
        y = ndims(a);      % done!
        varargout = size(a, dim);  % done!
        y = double(a);     % done!
        y = single(a);     % done!
        y = logical(a);    % done!
        y = copy(a, filename1, filename2); % done!       
        [y, p_index] = get_chunk(a, chunk_index); % done!
        y = delay_embed(a, dim, delay, shift); % done!
        y = flipud(x); % done!
        %y = get_misc(a, name); % done!  
        y = get(a, name);
        y = subset(a, row_idx, col_idx);
    end  
    
    % Operators
    methods
        y = plus(a,b); % done!
        y = minus(a,b); % done!
        y = times(a,b); % done!
        y = mtimes(a,b); % done!
        y = rdivide(a,b);
        y = ldivide(a,b);
        y = mrdivide(a,b);
        y = mldivide(a,b);
        y = power(a,b);
        y = nthroot(a,b);
        y = sum(a,dim); % done!
        y = mean(a, dim); % done!
        y = repmat(a, dim1, dim2);
        y = demean(a, dim);
        y = lt(a,b);
        y = gt(a,b);
        y = le(a,b);
        y = ge(a,b);
        y = ne(a,b);
        y = eq(a,b);
        y = conj(a); % done!
        y = ctranspose(a);  % done!
        y = transpose(a);   % done!
        y = horzcat(a,b,varargin);
        y = vertcat(a,b,varargin);
    end
    
    % Mutable methods
    methods
        a = subsasgn(a,s,b);    
        a = rename_file(a, filename);% done!     
        a = set(a, varargin); 
        y = reshape(a, varargin); 
        %a = set_misc(a, name, value); % done!
    end
    
    % Static methods
    methods (Static)
        [n_points, n_bytes] = get_nb_points(fid, ndims, precision);        
    end
    
    % Private methods
    methods (Access = private)
        [m_index, p_index] = get_map_index(obj, p_index);
        set_writable(obj, v);
    end
    
    % Constructor
    methods
        function obj = pset(filename, ndims, varargin)
            import PSET.globals;            
            
            % Constructor
            if nargin < 1, return; end
           
            THIS_PROPERTIES = {'datafile','temporary',...
                'transposed','precision','writable','misc'};  
                        
            
            if nargin < 2,
                error('PSET:pset:invalidInputArg', ...
                    'What is the dimensionality of the points stored in file ''%s''?', filename);
            end
            
            obj.DataFile = filename;
            
            % Additional input arguments
            if mod(length(varargin),2),
                error('PSET:pset:invalidInputArg',...
                    'Additional input arguments must be in pairs (PROP, VALUE)');
            end
            
            i = 1;
            while i<length(varargin),
                switch lower(varargin{i})
                    case 'header',
                        if ischar(varargin{i+1}),
                            % Header information is stored in a .MAT file
                            candidates = {'hdr', 'HDR', 'Header', 'HEADER'};
                            for j = 1:length(candidates)
                                obj.HeaderFile = varargin{i+1};
                                tmp = load(obj.HeaderFile,candidates{j});
                                if ~isempty(tmp),
                                    obj.(varargin{i}) = tmp.(candidates{j});
                                    break;
                                end
                            end
                            if isempty(obj.(varargin{i})),
                                warning('PSET:pset:pset', ...
                                    'Could not load Header information.');
                            end
                        else
                            obj.(varargin{i}) = varargin{i+1};
                        end
                    case THIS_PROPERTIES,
                        obj.(varargin{i}) = varargin{i+1};
                end
                i = i + 2;
            end
            
            % Find out the number of points stored in the file
            fid = fopen(filename);
            [n_points, n_bytes] = PSET.pset.get_nb_points(fid, ndims, obj.Precision);
            fclose(fid);
            
            % Number of points that fit into a single memory map
            n_points_map = floor(globals.evaluate.MapSize/n_bytes);
            n_maps = ceil(n_points/n_points_map);
            offset = 0;
            obj.MemoryMap = cell(n_maps,1);
            obj.MapIndices = nan(1,n_maps);
            for i = 1:n_maps
                this_map_n_points = min(n_points_map, n_points-round(offset/n_bytes));
                obj.MapIndices(i) = round(offset/n_bytes)+1;
                obj.MemoryMap{i} = memmapfile(obj.DataFile,...
                    'Format', {obj.Precision [ndims this_map_n_points] 'Data'},...
                    'Writable', obj.Writable,...
                    'Repeat', 1,...
                    'Offset', offset);
                offset = offset + this_map_n_points * n_bytes;
            end
            
            % Dimensions of the dataset
            obj.NbDims = size(obj.MemoryMap{1}.Data.Data,1);
            obj.NbPoints = 0;
            for i = 1:length(obj.MemoryMap)
                obj.NbPoints = obj.NbPoints + size(obj.MemoryMap{i}.Data.Data,2);
            end
            
            % Number of points in each memory chunk
            chunk_size = globals.evaluate.LargestMemoryChunk;
            n_points_chunk = floor(chunk_size/n_bytes);
            obj.ChunkIndices = 1:n_points_chunk:n_points;
            if obj.ChunkIndices(end) == n_points,
                obj.ChunkIndices(end) = [];
            end
            
        end
        
    end
    
    % Destructor
    methods
        function delete(obj)
            % Deletes the associated file, if the pset was 'temporary'
            fclose('all');
            if obj.Temporary,
                obj.MemoryMap = []; % to unlock the file
                try 
                    % If they file is referred to by another pset object we
                    % will not be allowed to erase it
                    warning('off', 'MATLAB:DELETE:Permission');
                    delete(obj.DataFile);
                    delete(obj.HeaderFile);
                catch %#ok<CTCH>
                    % do nothing;
                end
            end
        end
    end
    
end