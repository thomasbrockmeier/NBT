function  DataObj = getData(GrpObj,StatObj)
%Get data loads the data from a Database depending on the settings in the
%Group Object and the Statistics Object.
DataObj             = nbt_Data;
DataObj.biomarkers  = StatObj.biomarkers;
numBiomarkers       = length(StatObj.biomarkers);
DataObj.dataStore   = cell(numBiomarkers,1);
DataObj.pool        = cell(numBiomarkers,1);
DataObj.poolKey     = cell(numBiomarkers,1);

switch GrpObj.databaseType
    %switch database type
    case 'NBTelement'
        %In this case we load the data directly from the NBTelements in base.
        %We loop over StatObj.biomarkers and generate a cell
        for bID=1:numBiomarkers
            [biomarker, subBiomarker] = strtok(StatObj.biomarkers{bID,1},'.');
            subBiomarker = subBiomarker(2:end);
            %then we generate the NBTelement call.
            NBTelementCall = ['nbt_GetData(' biomarker ',{'] ;
            %loop over Group parameters
            groupParameters = fields(GrpObj.parameters);
            for gP = 1:length(groupParameters)
                NBTelementCall = [NBTelementCall groupParameters{gP} ...
                    ',''' GrpObj.parameters.(groupParameters{gP}){1,1} '''' ';'];
            end
            %then we loop over biomarker identifiers -
            % should be stored as a cell in a cell
            bIdentifiers = StatObj.biomarkerIdentifiers{bID,1};
            if(~isempty(bIdentifiers))
                % we need to add biomarker identifiers
                for bIdent = 1:size(bIdentifiers,1)
                   if(ischar(bIdentifiers{bIdent,2} ))
                       NBTelementCall = [NBTelementCall  bIdentifiers{bIdent,1} ',' '''' bIdentifiers{bIdent,2} '''' ';'];
                   else
                       NBTelementCall = [NBTelementCall  bIdentifiers{bIdent,1} ',' num2str(bIdentifiers{bIdent,2}) ';'];
                   end
                end
            end
            NBTelementCall = NBTelementCall(1:end-1); % to remove ';'
            NBTelementCall = [NBTelementCall '},' ''''  subBiomarker '''' ');'];
            [DataObj.dataStore{bID,1}, DataObj.pool{bID,1},  DataObj.poolKey{bID,1}] = evalin('base', NBTelementCall);
        end
    case 'File'
end

% Call outputformating here >

end