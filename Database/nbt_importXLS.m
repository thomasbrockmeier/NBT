%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2012), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2012 Simon-Shlomo Poil
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
% ---------------------------------------------------------------------------------------

function DataMatrix = nbt_importXLS(fileName, NBTelementBase, HeaderSize, range,SubjectColumn, ConditionColumn, DataColumns, DataName)

%Load NBTelementBase or create a new.
if(isempty(NBTelementBase))
    Subject = nbt_NBTelement(1, '1', []);
    if(~isempty(ConditionColumn))
        Condition = nbt_NBTelement(2,'2.1',1);
    end
    NextID = 4;
else
    load(NBTelementBase)
    NextID = length(whos)-7;
end

%First we load the xls file
[dummy, dummy, raw] = xlsread(fileName);

for DataIndex = 1:length(DataColumns)
    %Header
    if(isempty(DataName))
        DataName{DataIndex,1} = raw{HeaderSize,DataColumns(DataIndex)};
    end
        
    %Create NBTelement
    if(~isempty(ConditionColumn))
        eval([DataName{DataIndex,1}  ' = nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.2.1''' ', 2);'])
    else
        eval([DataName{DataIndex,1}  ' = nbt_NBTelement(' int2str(NextID) ',''' int2str(NextID) '.1''' ', 1);'])
    end
end

DataMatrixR = 0;
DataMatrix = nan(range-1,length(DataColumns));
%Then we step through the columns and add data to the database
for Index = (HeaderSize+1):range
    DataMatrixR = DataMatrixR +1; 
    %Subject
    SubjectID = raw{Index,SubjectColumn};
    Subject = nbt_SetData(Subject,{SubjectID},[]);
    %Condition
    if(~isempty(ConditionColumn))
        ConditionID = raw{Index,ConditionColumn};
        Condition = nbt_SetData(Condition, {ConditionID},{Subject, SubjectID});
    end
     
    for DataIndex = 1:length(DataColumns)
        %eval data type
        Data = nbt_evalstr(raw{Index,DataColumns(DataIndex)});
        %Insert Data
        if(~isempty(ConditionColumn))
             eval([ DataName{DataIndex,1} '= nbt_SetData(' DataName{DataIndex,1} ',' Data ',{Subject,' nbt_evalstr(SubjectID) '; Condition,' nbt_evalstr(ConditionID) '})'])
        else
               eval([ DataName{DataIndex,1} '= nbt_SetData(' DataName{DataIndex,1} ',' Data ',{Subject,' nbt_evalstr(SubjectID) '})'])
        end
        if(strcmpi(raw{Index,DataColumns(DataIndex)},'nan'))
        DataMatrix(DataMatrixR, DataIndex) = nan;
        else
          DataMatrix(DataMatrixR, DataIndex) = raw{Index,DataColumns(DataIndex)};
        end
    end
end
s = whos;
        for ii=1:length(s)
            if(~strcmp(s(ii).class,'nbt_NBTelement') && ~strcmp(s(ii).name,'s') && ~strcmp(s(ii).name,'DataMatrix'))
                clear([s(ii).name])
            end
        end
        clear s
        clear ii

save NBTelementBase.mat
end

function data = nbt_evalstr(data)
if(~isstr( data))
    data = num2str(data);
else
    if(strcmpi(data, 'nan'))
        data = num2str(nan);
    else
        data = ['{' '''' data '''' '}' ];
    end
end
end