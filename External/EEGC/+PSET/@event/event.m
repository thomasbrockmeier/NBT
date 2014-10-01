classdef event
    % EVENT Constructs an event object
    %
    %   EV = event(SAMPLE [,PROP1,VAL1,...,PROPN,VALN]) constructs an event
    %   which is located at the time instant POS and that has the
    %   properties specified as pairs (PROP_NAME, PROP_VALUE). An event
    %   object follows a similar format as the event structures in
    %   Fieldtrip: http://fieldtrip.fcdonders.nl/.
    %
    %   EV = event(STRUCT_ARRAY) builds an array of event objects using as
    %   input argument an array of structs having fields with names that
    %   match the properties of event objects. This constructor can be used
    %   to convert an array of Fieldtrip event structs into an array of event
    %   objects.
    %
    %   EV = event(TAL_CELL) builds and array of event objects using a cell
    %   array containing Time Annotated Lists (TALs). Such TALs are
    %   typically obtained when reading an EDF+ file using EDFPLUS/read.
    %
    %   Property/Value pairs and descriptions:
    %
    %       Type: Char array or Scalar
    %           The type of the event.
    %
    %       Sample: Scalar
    %           Time instant at which the event occurs.
    %
    %       Value: Scalar
    %           A numeric property of the event. Alternatively, this
    %           property might be the value of the associated signal at the
    %           event time.
    %
    %       Duration: Scalar
    %           In the case of events with duration that define trials,
    %           the Sample property is the first sample of a trial and the
    %           Offset property is the offset of the trigger with respect
    %           to the trial. An offset of 0 means that the first sample of
    %           the trial corresponds to the trigger. A positive offset
    %           indicates that the first sample is later than the trigger,
    %           a negative offset indicates that the trial begins before
    %           the trigger.
    %
    %       Offset: Scalar
    %           See the explanation above for the Duration property.
    %
    %       Dims: Scalar array
    %           The specific data dimensions (e.g. sensors) at which the
    %           event is present. By default this property is empty,
    %           meaning that the event is present in all data channels.
    %
    %   All the properties above are public and can therefore be modified
    %   after the object has been created.
    %
    %   Note:
    %   Contrary to Fieldtrip, an event object considers that a
    %   single-sample event has a duration of 1 sample and an offset of 0.
    %   On the other hand Fieldtrip sets those properties to empty in such
    %   a case.
    %
    %   Examples:
    %       % To create a 'QRS' event that spans the whole duration of a
    %       % QRS complex and that is located around the position of the
    %       % R-peak:
    %       %
    %       ev = event(1000, 'Type', 'QRS', 'Offset', -40, 'Duration', 100)
    %       %
    %       % which assumes that the QRS complex was located at sample
    %       1000, and that spanned from sample 1000-Offset = 960 until
    %       sample (1000-Offset)+Duration-1 = 1059.
    %
    %
    %
    % See also: EDFPLUS/read
    
    properties
        Type;          % Type of the event (a scalar or a char array).
        Sample;        % Sample at which the event occurs.
        Time;          % Time instant at which the event occurs.
        Value;         % A numeric property of the event.
        Offset = 0;    % A scalar indicating the beginning of the event relative to Sample.
        Duration = 1;  % The duration of the event (used to specify trials).
        TimeSpan = 0;  % Time span of the event.
        Dims;          % The data dimensions to which the event applies.
        Info;          % Additional (user-defined) properties.
    end
    
    
    % Set/Get methods
    methods
        function obj = set.Type(obj, v)
            if ~isscalar(v) && ~isa(v, 'char'),
                error('PSET:event:illegalTypeSetting', ...
                    'The Type property must be a char array or a scalar.');
            end
            obj.Type = v;
        end
        function obj = set.Sample(obj, v)
            import MISC.isinteger;
            import PSET.globals;
            if ~isinteger(v) || v < 0 || v > globals.evaluate.MaxNbPoints,
                error('PSET:event:illegalSampleSetting', ...
                    'The Sample property must be a natural number less than %d.',...
                    globals.evaluate.MaxNbPoints);
            end
            obj.Sample = v;
        end
        function obj = set.Value(obj, v)
            if length(v) > 1,
                ME = MException('MultAssgn:NotAllowed','Assignment to a multiple values not allowed');
                throw(ME);
            end
            if ~isnumeric(v),
                error('PSET:event:illegalValueSetting', ...
                    'The Value property must be a scalar.');
            end
            obj.Value = v;
        end
        function obj = set.Offset(obj, v)
            import MISC.isinteger;
            import PSET.globals;
            if length(v) > 1,
                ME = MException('MultAssgn:NotAllowed','Assignment to a multiple values not allowed');
                throw(ME);
            end
            if ~isinteger(v) || v < 0 || abs(v) > globals.evaluate.MaxNbPoints,
                error('PSET:event:illegalOffsetSetting', ...
                    'The Offset property must be an integer scalar with an absolute value less than %d.',...
                    globals.evaluate.MaxNbPoints);
            end
            obj.Offset = v;
        end
        function obj = set.Duration(obj, v)
            import MISC.isinteger;
            import PSET.globals;
            if length(v) > 1,
                ME = MException('MultAssgn:NotAllowed','Assignment to a multiple values not allowed');
                throw(ME);
            end
            if ~isinteger(v) || v < 0 || v > globals.evaluate.MaxNbPoints,
                error('PSET:event:illegalDurationSetting', ...
                    'The Duration property must be a natural number less than %d.',...
                    globals.evaluate.MaxNbPoints);
            end
            obj.Duration = v;
        end
        function obj = set.Dims(obj, v)
            import MISC.isinteger;
            import PSET.globals;
            if ~isinteger(v) || any(v < 0) || max(v) > globals.evaluate.MaxNbDims,
                error('PSET:event:illegalDimsSetting', ...
                    'The Dims property must be a natural number less than %d.',...
                    globals.evaluate.MaxNbDims);
            end
            obj.Dims = v;
        end
    end
    
    % Conversion methods
    methods
        b = struct(a);
        b = ftEvent(a);
        [ev, ur_ev] = eeglabEvent(a);
    end
    
    % Inmutable methods
    methods
        y = isempty(obj);
    end
    
    % Operators
    methods
        y = eq(a,b);
    end
    
    % Constructor
    methods
        function obj = event(pos, varargin)
            if nargin < 1, return; end
            
            import PSET.event;
            import PSET.globals;
            import MISC.process_varargin;
            
            % Additional input arguments
            if mod(length(varargin),2),
                error('PSET:event:invalidInputArg',...
                    'Additional input arguments must be in pairs (PROP, VALUE)');
            end
            
            % Optional input arguments (not including prop. values)
            THIS_OPTIONS = {'groupindexedtypes','sorted'};
            groupindexedtypes = globals.evaluate.GroupIndexedEvents;
            sorted = globals.evaluate.SortedEvents;
            % Process input arguments, which are not object property values
            [cmd_str, remove_flag] = process_varargin(THIS_OPTIONS, varargin);
            eval(cmd_str);
            varargin(remove_flag)= [];
            
            if isstruct(pos) && nargin < 2,
                % Constructor using a struct
                obj = repmat(event, size(pos));
                fnames = fieldnames(pos(1));
                for i = 1:length(fnames)
                    this_fname = [upper(fnames{i}(1)) fnames{i}(2:end)];
                    
                    switch lower(fnames{i}),
                        case 'type',
                            if ischar(pos(1).(fnames{1})),
                                for j = 1:length(pos)
                                    obj(j).Type = pos(j).(fnames{i});
                                end
                            elseif isnumeric(pos(1).(fnames{1}))
                                for j = 1:length(pos)
                                    obj(j).Type = num2str(pos(j).(fnames{i}));
                                end                                
                            else
                                error('PSET:event:invalidType', ...
                                    'The Type property of event objects must be a string or a number.');                                
                            end
                        case 'latency',
                            for j = 1:length(pos)
                                obj(j).Sample = round(pos(j).(fnames{i}));
                            end
                        otherwise,                            
                            for j = 1:length(pos)
                                obj(j) = set(obj(j), this_fname, pos(j).(fnames{i}));
                            end
                    end
                end
                
                
            elseif isnumeric(pos) && ~isempty(pos),
                obj.Sample = pos(1);
                % Apply input properties
                i = 1;
                idx = [];
                idx_cell = [];
                while i<length(varargin),
                    try
                        obj.(varargin{i}) = varargin{i+1};
                    catch ME
                        if strcmpi(ME.identifier,'MultAssgn:NotAllowed')
                            if length(varargin{i+1}) == length(pos)
                                if iscell(varargin{i+1})
                                    idx_cell = [idx_cell i]; %#ok<AGROW>
                                else
                                    idx = [idx i];  %#ok<AGROW>
                                end
                            else
                                error('PSET:event:event:invalidInput', ...
                                    'Argument ''%s'' has an unexpected value', ...
                                    varargin{i});
                            end
                        end                                                                                                
                    end
                    i = i + 2;
                end
                obj = repmat(obj,size(pos));
                for i = 1:numel(obj)
                    obj(i).Sample = pos(i);
                    for j = 1:length(idx)                       
                       obj(i).(varargin{idx(j)}) = varargin{idx(j)+1}(i); 
                    end
                    for j = 1:length(idx_cell)
                       obj(i).(varargin{idx_cell(j)}) = varargin{idx(j)+1}{i}; 
                    end
                end
                
            elseif iscell(pos) && nargin < 2,
                % Constructor using a cell array with TALs
                tal_cell = pos;
                % Initialize the output,
                n_cell = numel(tal_cell);
                obj = repmat(PSET.event, n_cell, 1);
                sample = nan(n_cell, 1);
                event_count = 0;
                for i = 1:n_cell
                    for j = 1:length(tal_cell{i})
                        if ~isempty(tal_cell{i}(j).annotations)
                            for k = 1:length(tal_cell{i}(j).annotations)
                                if isnan(tal_cell{i}(j).onset_samples), continue; end
                                event_count = event_count + 1;
                                obj(event_count).Type = tal_cell{i}(j).annotations{k};
                                obj(event_count).Sample = tal_cell{i}(j).onset_samples;
                                sample(event_count) = tal_cell{i}(j).onset_samples;
                                obj(event_count).Time = tal_cell{i}(j).onset;
                                obj(event_count).Duration = tal_cell{i}(j).duration_samples;
                                obj(event_count).TimeSpan = tal_cell{i}(j).duration;
                            end
                            
                        end
                    end
                end
                obj(event_count+1:end)=[];                                
                 
                
            elseif (isstruct(pos) || iscell(pos)) && nargin < 2,
                error('PSET:event:invalidInputArg', ...
                    'Property values cannot be modified when constructing from FieldTrip events or from a cell of TALs.');
            else
                error('PSET:event:invalidInputArg', ...
                    'First input argument must be a scalar array or a struct array.');
            end
            
            if groupindexedtypes,
                obj = group_types(obj);
            end
            
            if sorted && ~any(isempty(obj)),
                obj = sort(obj);
            end
            
        end
        
    end
    
    
end


