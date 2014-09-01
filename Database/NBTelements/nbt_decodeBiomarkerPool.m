function [Data, BiomarkerName] = nbt_decodeBiomarkerPool(Data, Token, NBTelementName, biomarker)
%decode BiomarkerPool
[A Token] = strtok(Token, '/');
if(isempty(Token))
    BiomarkerName = [NBTelementName];
else
    [B, Token] = strtok(Token, '/');
    A=str2double(A);
    B=str2double(B);
    
    if(isnan(B))
        for SubID = 1:size(Data,2)
            try
                tmp(:,SubID) = Data{A,SubID};
            catch
                tmp(:,SubID) = Data(A,SubID);
            end
        end
        
        try
            BiomarkerName = [NBTelementName(5:end) '  ' biomarker.Biomarkers{A,1}];
        catch
            BiomarkerName = [NBTelementName(5:end)];
        end
    else
        C = strtok(Token, '/');
        C=str2double(C);
        if(isnan(C))
            for SubID=1:size(Data,2)
                DD = Data{B,SubID};
                try
                    tmp(:,SubID) = DD{A,1};
                catch
                    tmp(:,SubID) = nan(size(tmp,1),1);
                end
            end
            
            try
                BiomarkerName = [NBTelementName(5:end) '  ' biomarker.Biomarkers{B,1}];
            catch
                BiomarkerName = [NBTelementName(5:end)];
            end
        else
            for SubID=1:size(Data,2)
                DD = Data{C,SubID};
                DD = DD{B,1};
                try
                    tmp(:,SubID) = DD{A,1};
                catch
                    tmp(:,SubID) = nan(size(tmp1,1),1);
                end
            end
            
            try
                BiomarkerName = [NBTelementName(5:end) '  ' biomarker.Biomarkers{C,1}];
            catch
                BiomarkerName = [NBTelementName(5:end)];
            end
        end
    end
    Data = tmp;
    clear tmp;
end
end