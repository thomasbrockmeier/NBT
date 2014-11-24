function [biomName,identifiers, biomarker, biomarkerClass] = nbt_parseBiomarkerIdentifiers(biom)
%parses a biomarker from the nbt_statistics, into the name, identifiers and
%biomarker


identStart = strfind(biom,'{');

if isempty(identStart)
    %no Identifiers
    identifiers = [];
    fndDot = strfind(biom,'.');
    biomName = biom(1:fndDot-1);
    biomarker = biom(fndDot+1:end);
    biomarkerClass = evalin('base',[biomName '.Class;']);
else
    identEnd = strfind(biom,'}');
    identString = biom(identStart(1)+1:identEnd(end)-1);
    k = 1;
    [a,b] = strtok(identString,'_');
    identifiers{k,1} = a;
    [a,b] = strtok(b,'_');
    identifiers{k,2} = a;
    k = k+1;
    while ~isempty(b)
        [a,b] = strtok(b,'_');
        identifiers{k,1} = a;
        [a,b] = strtok(b,'_');
        identifiers{k,2} = a;
        k = k+1;
    end
    
    fndDot = strfind(biom,'.');
    biomarker = biom(fndDot(end)+1:end);
    biomName = biom(1:identStart(1)-1);
    biomarkerClass = evalin('base',[biomName '.Class;']);
end


