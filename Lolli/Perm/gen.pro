:- op(150,xfy,::).  

%%%%%%%%%%% VERSIONE PROLOG %%%%%%%%%%%
%Generatore interi
get(0).
get(1).
get(2).
get(3).
get(4).
get(5).

%GENERATORE CON BENZINA
gen(0, nil).
gen(N, X :: L) :-
    N >= 0,
    M is N - 1,
    get(X),
    gen(M, L).
%-- 
    
%%%%%%%%%%% VERSIONE LOLLI %%%%%%%%%%%

get(0) <- true.
get(1) <- true.
get(2) <- true.
get(3) <- true.
get(4) <- true.
get(5) <- true.

gen(0, nil) <- true.
gen(N, X :: L) <-    
    positive(N) x
    dec(N, M) x
    get(X) x
    gen(M, L).
