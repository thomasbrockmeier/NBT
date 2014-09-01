function dataout=nbt_expandCell(celldata)

[Csize1 Csize2] = size(celldata);
if(Csize1 >= Csize2)
    dataout = nan(Csize1,1);
    try
        for counter=1:Csize1
            dataout(counter) = str2num(celldata{counter,1});
        end
    catch
        for counter=1:Csize1
            dataout(counter) = (celldata{counter,1});
        end
    end
else
    dataout = nan(Csize2,1);
    try
        for counter=1:Csize2
            dataout(counter) = str2num(celldata{1,counter});
        end
    catch
        for counter=1:Csize1
            dataout(counter) = (celldata{counter,1});
        end
    end
end
end
