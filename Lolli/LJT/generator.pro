genAt(at(a)).
genAt(at(b)).

genImp(0, A) :-
    genAt(A).
genImp(N, imp(A, B)) :-
    N > 0,
    N1 is N - 1,
    genAt(A),
    genImp(N1, B).
genImp(N, imp(A, B)) :-
    N > 0,
    N1 is N - 1,
    genAt(B),
    genImp(N1, A).    
genImp(N, imp(A, B)) :-
    N > 2,
    N1 is N - 2,
    genImp(N1, A),
    genImp(N1, B).    

genI(0, A) :-
	   genAt(A).
genI(N, imp(A,L)) :-
    N >= 0,
    M is N - 1,
    genAt(A),
    genI(M, L).
    
%%%%%%%%%%%%%%%%%%%%%%%

test(N) :-
    setof(I, genImp(N,I), XI1),
    setof(I, genI(N,I), XI2),
    subtract(XI1, XI2, R),
    printAll(R).

printAll([]).
printAll([H|T]) :-
    write(H),
    nl,printAll(T).
