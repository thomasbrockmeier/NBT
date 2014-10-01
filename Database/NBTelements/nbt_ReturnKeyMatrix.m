% Copyright (C) 2010 Simon-Shlomo Poil
function [DataVector, PoolMatrix] = nbt_ReturnKeyMatrix(Data, DataPoolKey)
DataVector = cell(0,0);
if(iscell(Data))
    VID = 0;
    for i=1:size(Data,1)
        if(~iscell(Data{i,1}))
            VID = VID +1;
            DataVector{VID,1} = [];
            for SubID =1:size(Data,2)
                DD = Data{i,SubID};
                DataVector{VID,1} = [DataVector{VID,1} DD(:)];
            end
            PoolMatrix{VID,1} = [int2str(i) '/' DataPoolKey];
        else
            DataTmp = Data{i,1};
            for mm=1:length(DataTmp)
                %testing if cell cell cell
                DD = Data{i,1};
                DD = DD{mm,1};
                if(iscell(DD))
                    for tt = 1:size(DD,1)
                        VID = VID + 1;
                        DataVector{VID,1} = [];
                        for SubID = 1:size(Data,2)
                            DD = Data{i,SubID};
                            DD = DD{mm,1};
                            DD = DD{tt,1};
                            if(~isempty(DD))
                                try
                                    DataVector{VID,1} = [DataVector{VID,1},  DD(:)];
                                catch
                                    DD = DD(:);
                                    DDtmp =  nan(size(DataVector{VID,1},1),1);
                                    for ddcounter=1:length(DD)
                                        DDtmp(ddcounter) = DD(ddcounter);
                                    end
                                    for ddcounter=length(DD):size(DataVector{VID,1},1)
                                        DDtmp(ddcounter) = nan;
                                    end
                                    DD = DDtmp;
                                    try
                                        DataVector{VID,1} = [DataVector{VID,1}  DD(:)];
                                    catch %ok it was the rare case of not complete DataVector
                                        DVtmp = DataVector{VID,1};
                                        DVtmp((length(DVtmp)+1):length(DD),:) = nan;
                                        DataVector{VID,1} = DVtmp;
                                        clear DVtmp;
                                        DataVector{VID,1} = [DataVector{VID,1}  DD(:)];
                                    end
                                end
                            end
                        end
                        PoolMatrix{VID,1} = [int2str(tt) '/' int2str(mm) '/' int2str(i) '/' DataPoolKey];
                    end
                else
                    VID = VID + 1;
                    DataVector{VID,1} = [];
                    for SubID=1:size(Data,2)
                        DD = Data{i,SubID};
                        DD = DD{mm,1};
                        try
                            DataVector{VID,1} = [DataVector{VID,1}  DD(:)];
                        catch
                            DD = DD(:);
                            DDtmp =  nan(size(DataVector{VID,1},1),1);
                            for ddcounter=1:length(DD)
                                DDtmp(ddcounter) = DD(ddcounter);
                            end
                            for ddcounter=length(DD):size(DataVector{VID,1},1)
                                DDtmp(ddcounter) = nan;
                            end
                            DD = DDtmp;
                            try
                                DataVector{VID,1} = [DataVector{VID,1}  DD(:)];
                            catch %ok it was the rare case of not complete DataVector
                                DVtmp = DataVector{VID,1};
                                DVtmp((length(DVtmp)+1):length(DD),:) = nan;
                                DataVector{VID,1} = DVtmp;
                                clear DVtmp;
                                DataVector{VID,1} = [DataVector{VID,1}  DD(:)];
                            end
                        end
                    end
                    PoolMatrix{VID,1} = [int2str(mm) '/' int2str(i) '/' DataPoolKey];
                end
            end
        end
    end
else
    DataVector{1,1} = Data;
    PoolMatrix{1,1} = DataPoolKey;
end
end