function xmlstring=nbt_exportclass2xml(inputclass)
xmlstring=spcharout(mat2xml(struct(inputclass),class(inputclass)));
end