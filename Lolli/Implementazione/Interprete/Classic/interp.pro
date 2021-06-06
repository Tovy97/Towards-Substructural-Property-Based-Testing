:- multifile (<-)/2.

:- op(140, xfy, <- ).  %    :- 
:- op(140, xfy, & ).  %    conjunction 

prove(true).
prove(G1 & G2) :-	
    !,	
    prove(G1),    
    prove(G2).
prove(not(A)) :- 
    !,
    ground(A), 
    \+ prove(A).    

% BUILT-IN
prove(write(X)) :- 
    !,
    write(X).
prove(read(X))  :- 
    !,
    read(X).
prove(nl)       :- 
    !,
    nl.
prove(random(L, U, R)) :- 
    !,
    random(L, U, R).
prove(inc(B, A)) :- 
    integer(B),
    !,
    A is B + 1.
prove(dec(B, A)) :- 
    integer(B),
    !,
    A is B - 1.
prove(notEq(A, B)) :- 
    !,
    A \== B.
prove(eq(A, B))    :- 
    !,
    A == B.
prove(leq(A, B)) :- 
    integer(A),
    integer(B),
    !,
    A =< B.
prove(lt(A, B))  :- 
    integer(A),
    integer(B),
    !,
    A < B.
prove(geq(A, B)) :- 
    integer(A),
    integer(B),
    !,
    A >= B.
prove(gt(A, B))  :- 
    integer(A),
    integer(B),
    !,
    A > B.
prove(positive(N)) :- 
    integer(N),
    !,
    N >= 0.
prove(positiveDec(N, M)) :- 
    integer(N), 
    !,
    N >= 0, 
    M is N - 1.
prove(addInt(A, B, S)) :-
    integer(A),
    integer(B),
    !,
    S is A + B.
prove(subInt(A, B, S)) :- 
    integer(A),
    integer(B),
    !,
    S is A - B.
prove(mulInt(A, B, S)) :- 
    integer(A),
    integer(B),
    !,
    S is A * B.
prove(andBool(A, B, true)) :-
    (A, B), !.
prove(andBool(A, B, false)) :-
    ((\+ A) ; (\+ B)), !.
prove(orBool(A, B, false)) :-
    ((\+ A), (\+ B)), !.
prove(orBool(A, B, true)) :-
    (A ; B), !.
prove(notBool(A, true)) :-
    (\+ A), !.
prove(notBool(A, false)) :-
    A, !.
prove(eqBool(A, B, true)) :-
    A == B, 
    !.
prove(eqBool(A, B, false)) :-
    A \== B, 
    !.

% CASO BASE
prove(A)       :-                           
    A <- G,
    prove(G).   
%--
