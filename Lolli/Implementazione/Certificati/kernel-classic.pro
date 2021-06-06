:- ['fpcs-classic.pro'].
% Certificate checker
check(Cert, true) :- 
    !,
    ttE(Cert).
check(Cert, eq(T, T)) :- 
    !, 
    eqE(Cert).
check(Cert, (G1, G2)) :-
    !, 
   andE(Cert, Cert1, Cert2),
   check(Cert1, G1), 
   check(Cert2, G2).
check(Cert, (G1; G2)) :-
    !, 
   orE(Cert, Cert1, LR), 
   (
    (
        LR = left,  
        check(Cert1, G1)
    ) ; (
        LR = right, 
        check(Cert1, G2)
    )
   ).
check(Cert, A) :-
    builtin(A),
    !,
    unfoldEBuiltIn(Cert, Cert1), 
    clause(A, G),
    check(Cert1, G).
check(Cert, A) :-
    !,  
    unfoldE(Cert, Cert1), 
    clause(A, G),
    check(Cert1, G).

builtin(memberVar(_, _)).