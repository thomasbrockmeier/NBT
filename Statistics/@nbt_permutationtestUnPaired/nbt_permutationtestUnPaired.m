classdef nbt_permutationtestUnPaired < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_permutationtestUnpaired(obj)
            obj.testOptions.numPermutations = 5000;
            obj.testOptions.statFunction = @mean;
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj); %with parameters);
            
            
            %Perform test
            for bID=1:size(Data1.dataStore,1)   
                [obj.pValues{bID,1}, obj.statStruct{bID,1}.mean_difference, obj.statStruct{bID,1}.N_s, obj.statStruct{bID,1}.p_low, obj.statStrcut{bID,1}.p_high] = nbt_permutationtest(Data1{bID,1}',Data2{bID,1}',obj.testOptions.numPermutations,0,obj.testOptions.statFunction);
            end
        end
    end
    
end

