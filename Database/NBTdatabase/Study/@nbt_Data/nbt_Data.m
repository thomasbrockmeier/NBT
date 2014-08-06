classdef nbt_Data
    %nbt_Data contains collections of biomarker data and is mainly produced
    %by the getData method of the nbt_Group object
    
    properties
        dataStore %cell or function handle
        pool
        poolKey  
        biomarkers
        %Further parameters..
        outputFormat %output format - remove nans, etc. cell vs matrix vs struct
    end 
    
    methods
      function DataObject = nbt_Data  
      end
      
      
       listOfSubjects = getSubjectList(nbt_DataObject, BiomarkerIndex) 
        
       Biomarker = getBiomarker(nbt_DataObject, Parameters, OutputFormat);   
       
       function B = subsref(A,S)
           if(strcmp(S(1).type,'.'))
               B = eval(['A' S.type S.subs]);    
           elseif(strcmp(S(1).type,'{}'))
               B = A.dataStore{S.subs{1,1},S.subs{1,2}};
               if(iscell(B))
                   tmp = B{1,1}(:);
                   for sID = 2:length(B)
                       tmp = [tmp, B{sID,1}(:)];
                   end
                   B = tmp';
               end
           end
           
       end 
       
       
    end
    
    methods (Static = true)
     DataObject = dataContainer(GrpObj);
    end
    
     methods (Hidden = true)
       DataObj = outputFormating(DataObj) %called by GetData before returning Data 
    end
    
end

