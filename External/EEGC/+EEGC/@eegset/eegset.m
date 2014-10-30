classdef eegset < PSET.pset
    % EEGSET Construct a memory-mapped EEG dataset object
    %
    %   Documentation to be done...
    %
    % See also: PSET/pset, PSET/event
    
    % Public properties
    properties
        Event;              % A list of PSET.event objects.
        SamplingRate;       % Sampling rate in Hz.
        SensorLocation;     % Sensors locations in cartesian coordinates.
        SensorLabel;        % Label for each sensor.
        SamplingTime;       % Absolute time of each sampling instant relative to StartDate/StartTime
        StartDate;          % Start date of the EEG recording.
        StartTime;          % Start time of the EEG recording.
        Continuous = true;  % Is the data continuous or discontinuous?
    end   
    
    properties (SetAccess = private, GetAccess = private)
        EventEEGLAB;        % Events in EEGLAB format.        
    end    
    
    % Constructor
    methods
        function obj = eegset(varargin)
            % Supeclass constructor
            obj = obj@PSET.pset(varargin{:}); 
            import EEGC.globals;
            import MISC.process_varargin;
            
            % List of properties that can be set during construction
            THIS_PROPERTIES = {'samplingrate','sensorlocation',...
                'sensorlabel','samplingtime','startdate','starttime', ...
                'event'};     
            
            % Default properties
            samplingrate = globals.evaluate.SamplingRate;
            sensorlocation = [];
            sensorlabel = [];
            event = [];
            if obj.NbPoints,
                samplingtime = 0:1/samplingrate:obj.NbPoints/samplingrate - 1/samplingrate;
            else
                samplingtime = [];
            end                
            date_format = globals.evaluate.DateFormat;
            time_format = globals.evaluate.TimeFormat;
            startdate = datestr(now, date_format);
            starttime = datestr(now, time_format);            
            eval(process_varargin(THIS_PROPERTIES, varargin));
            
            % Properties especific of class eegset
            obj.SamplingRate = samplingrate;
            obj.SensorLocation = sensorlocation;
            obj.SensorLabel = sensorlabel;
            obj.SamplingTime = samplingtime;
            % Find out the time and date format            
            obj.StartDate = datestr(startdate, date_format);
            obj.StartTime = datestr(starttime, time_format);
            obj.Event = event;
        end       
    end
    
    % Set/Get methods
    methods
        function set.Event(obj, v)
            if ~all(isempty(v)) && ~isa(v, 'PSET.event'),
                error('EEGC:eegset:eegset:invalidInput', ...
                    'The Event property can only contain PSET.event objects.');
            end   
            if ~any(isempty(v)),
                obj.Event = sort(v);
            else
                obj.Event = v;
            end
        end
        function set.SamplingRate(obj, v)
            if ~isempty(v) && ~isinteger(v) && v<0,
                error('EEGC:eegset:eegset:invalidInput', ...
                    'The SamplingRate property must be a natural number.');
            end
            obj.SamplingRate = v;            
        end
        function set.SensorLocation(obj, v)
            %  IMPORTANT: CONSISTENCY CHECKS HERE!
            obj.SensorLocation = v;                        
        end
        function set.SensorLabel(obj, v)
            if ~isempty(v) && (~iscell(v) || ~ischar(v{1})),
                error('EEGC:eegset:eegset:invalidInput', ...
                    'The SensorLabel property must be a cell array of strings.');               
            end
            obj.SensorLabel = v;            
        end
        function set.SamplingTime(obj, v)
            if ~isempty(v) && (~isnumeric(v) || any(v<0)),
                error('EEGC:eegset:eegset:invalidInput', ...
                    'The SamplingTime property must be an array of positive scalars.');      
            end
            if ~isempty(v) && length(v) ~= obj.NbPoints,
                warning('EEGC:eegset:eegset:invalidInput', ...
                    'The number of entries in the SamplingTime property do not match the number of points in the dataset.');                      
            end
            obj.SamplingTime = v;
        end
        function set.StartDate(obj, v)
            % MORE CONSISTENCY CHECKS HERE!!!!
            % Check consistency of date format
            if ~isempty(v) && ~ischar(v),
                error('EEGC:eegset:eegset:invalidInput', ...
                    'Invalid Date string.');      
            end
            obj.StartDate = v;          
        end
        function set.StartTime(obj, v)
            % MORE CONSISTENCY CHECKS HERE!!!!
            % Check consistency of time format
            if ~isempty(v) && ~ischar(v),
                error('EEGC:eegset:eegset:invalidInput', ...
                    'Invalid Time string.');      
            end
            obj.StartTime = v;          
        end
        
        
    end
    
    % Immutable methods
    methods
        h = plot(a, varargin);        
    end
    
    
    
    
end