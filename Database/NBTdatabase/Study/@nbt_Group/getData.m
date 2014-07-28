function  DataObj = getData(GrpObj,StatObj)
%Get data loads the data from a Database depending on the settings in the
%Group Object and the Statistics Object.

switch GrpObj.databaseType
    %switch database type
    case 'NBTelement'
        %In this case we load the data directly from the NBTelements in base.
        %We loop over StatObj.biomarkers and generate a cell
        for bID=1:length(StatObj.biomarkers)
            [biomarker subBiomarker] = strtok(StatObj.biomarkers{bID,1},'.');
            %then we generate the NBTelement call.
            NBTelementCall = ['nbt_GetData(' biomarker ',{'] ;
            %loop over Group parameters
            groupParameters = fields(GrpObj.parameters);
            for gP = 1:length(groupParameters)
                NBTelementCall = [NBTelementCall groupParameters(gP) ...
                    '''' GrpObj.parameters.(groupParameters(gP)) '''' ';'];
            end
            %then we loop over biomarker identifiers -
            % should be stored as a cell in a cell
            bIdentifiers = StatObj.biomarkerIdentifiers{bID,1};
            if(~isempty(bIdentifiers))
                % we need to add biomarker identifiers
                for bIdent = 1:2:length(bIdentifiers)
                    NBTelementCall = [NBTelementCall  bIdentifiers{bIdent,1} ',' bIdentifiers{bIdent,2} ';'];
                end
            end
            NBTelementCall = NBTelementcall(end-1); % to remove ';'
            NBTelementCall = [NBTelementCall '},'  subBiomarker ');'];
            DataObj{bID,1} = evalin('base', NBTelementCall);
        end
    case 'File'
end

% Call outputformating here >

end