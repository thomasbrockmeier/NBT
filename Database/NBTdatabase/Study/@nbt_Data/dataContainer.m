function DataObj = dataContainer(GrpObj)
DataObj = nbt_Data;
DataObj.dataStore = wrapDataContainer(GrpObj);
end


function dataStoreLink = wrapDataContainer(GrpObj)


disp('break')


%nested function
    function dataStore()
        disp('break')
    end

dataStoreLink = @dataStore;

end
