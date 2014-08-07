classdef nbt_ranksum < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_ranksum(obj)
            obj.testOptions.tail = 'both';
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj); %with parameters);
            %add test of same subjects
            
            
            %Perform test
            for bID=1:size(Data1.dataStore,1)   
                  [obj.pValues(chID,bID)] = signrank(D1(chID,:)', D2(chID,:)','tail',  obj.testOptions.tail);
                
            end
            %options
            
        end
    end
    
end

