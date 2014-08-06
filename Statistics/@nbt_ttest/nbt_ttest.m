classdef nbt_ttest < nbt_PairedStat
    properties
    end
    
    methods
        function obj = nbt_ttest(obj)
            obj.testOptions.tail = 'both';
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj); %with parameters);
            %add test of same subjects
            
            
            %Perform test
            for bID=1:size(Data1.dataStore,1)   
                [D1, D2]=nbt_MatchVectors(Data1{bID,1}, Data2{bID,1}, getSubjectList(Data1,bID), getSubjectList(Data2,bID), 0, 1);
                [~, obj.pValues(:,bID), ~, obj.statStruct{bID,1}] = ttest(D1',D2','tail',  obj.testOptions.tail);
            end
            %options
            
        end
    end
    
end

