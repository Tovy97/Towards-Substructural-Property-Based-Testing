:- op(150,xfy,::).  %    non-empty list constructor

%%%%%%%%%%% SLOWSORT %%%%%%%%%%%

slowsort(L, S) <- perm(L, S) x sorted(S).
