function dataout=nbt_expandCell(celldata)

[Csize1 Csize2] = size(celldata);
    if(Csize1 >= Csize2)
        dataout = nan(Csize1,1);
        for counter=1:Csize1
            dataout(counter) = str2num(celldata{counter,1});
        end
    else
        dataout = nan(Csize2,1);
        for counter=1:Csize2
            dataout(counter) = str2num(celldata{1,counter});
        end
    end
end
