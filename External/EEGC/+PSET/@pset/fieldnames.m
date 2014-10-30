function [all_names,get_names, set_names] = fieldnames(x)


mco = metaclass(x);
get_names = {};
set_names = {};
all_names = cell(length(mco.Properties),1);
for i = 1:length(mco.Properties)
   all_names{i} = mco.Properties{i}.Name;
   if ~mco.Properties{i}.Dependent && ...
           strcmpi(mco.Properties{i}.GetAccess, 'public'),
       get_names = [get_names {mco.Properties{i}.Name}];        %#ok<*AGROW>
   end
   if ~mco.Properties{i}.Dependent && ...
           (strcmpi(mco.Properties{i}.SetAccess, 'public') || ...
           ~isempty(mco.Properties{i}.SetMethod)),
       set_names = [set_names {mco.Properties{i}.Name}];       
   end
end

get_names = [get_names(:); fieldnames(x.Info)];
set_names = [set_names(:); fieldnames(x.Info)];
all_names = [setdiff(all_names(:),'Info'); fieldnames(x.Info)];

    
end