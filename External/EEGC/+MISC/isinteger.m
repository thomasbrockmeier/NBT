function y = isinteger(x)
% ISINTEGER True for arrays of integer data type or for arrays of float
% data type which contain "almost" integer numbers. 

y = isinteger(x);
if y,
    return;
end


y = all(isnumeric(x) & abs(x-round(x))<eps);


end