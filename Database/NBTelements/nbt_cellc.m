function celldata=nbt_cellc(celldata, counter)

[Csize1 Csize2] = size(celldata);
if(counter ==0)
    if(Csize1 < Csize2)
        celldata = celldata'; 
    end
else
    if(Csize1 >= Csize2)
        celldata = celldata{counter,1};
    else
        celldata = celldata{1,counter};
    end
end
end