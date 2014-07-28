classdef nbt_ttest < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_ttest(); end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj) %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData %with parameters);
            %Perform test
            obj.results = ttest2(Data1,Data2);
            
            %options
            
        end
    end
    
end

