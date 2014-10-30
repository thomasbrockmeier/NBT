function A = subsasgn(A, S, B)
A.(S.subs) = B;
A.DateLastUpdate = datestr(now);

end