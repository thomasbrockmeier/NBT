function negative=nbt_negSearchVector(vector, positive)
%negative in vector but not in positive
negative = [];
for i=1:length(vector)
   if(isempty(nbt_searchvector(positive,vector(i))))
       negative = [negative vector(i)];
   end
end

end