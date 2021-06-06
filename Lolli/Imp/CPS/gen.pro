:- ['../../Implementazione/Certificati/kernel.pro'].
:- ['prettyPrinter.pro'].

:- multifile is_prog/2.

varList([type(int, w), type(int, z), type(bool, x), type(bool, y)]).

%--- IS_VAR ---
is_var(int, w).
is_var(bool, x).
is_var(bool, y).
is_var(int, z).
%! is_var(+Type, -Var).

%---

%--- IS_INT ---
% is_int(-3).
% is_int(-2).
%is_int(-1).
is_int(0).
is_int(1).
% is_int(2).
% is_int(3).
%! is_int(-Int).

%--- IS_BOOL ---
is_bool(true).
is_bool(false).
%! is_bool(-Bool).

%---

%--- IS_GUARD ---

is_guard(andV(E1, E2), Vars)  :-     
    is_guard(E1, Vars), 
    is_guard(E2, Vars).
is_guard(orV(E1, E2), Vars)   :-     
    is_guard(E1, Vars), 
    is_guard(E2, Vars).
is_guard(eqV(E1, E2), Vars)   :-     
    mem(type(T, E1), Vars), 
    mem(type(T, E2), Vars).    
is_guard(notV(E), Vars)       :- 
    is_guard(E, Vars).
%! is_guard(-Guard, +Vars).    

%--

%--- IS_EXP ---
is_exp(bool, b(B), _)     :- 
    is_bool(B).
is_exp(int, i(N), _)              :- 
    is_int(N).
is_exp(T, X, Vars)                :- 
    mem(type(T, X), Vars).
is_exp(bool, andV(E1, E2), Vars)  :-     
    is_exp(bool, E1, Vars), 
    is_exp(bool, E2, Vars).
is_exp(bool, orV(E1, E2), Vars)   :-     
    is_exp(bool, E1, Vars), 
    is_exp(bool, E2, Vars).
is_exp(bool, eqV(E1, E2), Vars)   :-     
    is_exp(T, E1, Vars), 
    is_exp(T, E2, Vars).
is_exp(bool, notV(E), Vars)       :- 
    is_exp(bool, E, Vars).
is_exp(int, plusV(E1, E2), Vars)  :-     
    is_exp(int, E1, Vars), 
    is_exp(int, E2, Vars).
is_exp(int, minusV(E1, E2), Vars) :-     
    is_exp(int, E1, Vars), 
    is_exp(int, E2, Vars).
is_exp(int, timesV(E1, E2), Vars) :-
    is_exp(int, E1, Vars), 
    is_exp(int, E2, Vars).
%! is_exp(±Type, -Expression, +Vars).    

%---
      
%--- IS_PROG ---
is_prog(A : B, Vars) :-
    is_prog(A, Vars),
    is_prog(B, Vars).
is_prog(assign(X, E), Vars)  :-
    is_var(T, X),
    is_exp(T, E, Vars).
is_prog(if(C, B1, B2), Vars) :-
    is_guard(C, Vars),
    is_prog(B1, Vars),
    is_prog(B2, Vars).
is_prog(while(C, B), Vars)   :-
    is_guard(C, Vars),
    is_prog(B, Vars).
%! is_prog(-Program, +VarsIn).

%---

%--- GEN_VALUE ---
genValue(int, vi(V)) :-
    is_int(V).
genValue(bool, vb(V)) :-
    is_bool(V).
%! genValue(±Type, -Value).

%--- GEN_EXP ---

genExp(0, N, _, T, E, Vars) :-
    check(qheight(N), is_exp(T, E, Vars)).
genExp(1, N, _, T, E, Vars) :-
    check(qsize(N, _), is_exp(T, E, Vars)).
genExp(2, N, M, T, E, Vars) :-
    check(qheight(N) <> qsize(M, _), is_exp(T, E, Vars)).
%! genExp(+Certificate, +Dimension1, +Dimension2, ±Type, -Expression, +Vars).

genExpRand(0, N, T, E, Vars) :-
    check(qr <> qheight(N), is_exp(T, E, Vars)).
genExpRand(1, N, T, E, Vars) :-
    check(qr <> qsize(N, _), is_exp(T, E, Vars)).
%! genExpRand(+Certificate, +Dimension, ±Type, -Expression, +Vars).

%--- GEN_PROG ---
genProg(0, N, _, P, Vars)      :-
    check(qheight(N), is_prog(P, Vars)).
genProg(1, N, _, P, Vars)      :-
    check(qsize(N, _), is_prog(P, Vars)).
genProg(2, N, M, P, Vars)      :-    
    check(qheight(N) <> qsize(M, _), is_prog(P, Vars)).
%! genProg(+Certificate, +Dimension1, +Dimension2, -Program, +Vars).

genProgRand(0, N, P, Vars)      :-    
    check(qr <> qheight(N), is_prog(P, Vars)).
genProgRand(1, N, P, Vars)      :-    
    check(qr <> qsize(N, _), is_prog(P, Vars)).
%! genProgRand(+Certificate, +Dimension, -Program, +Vars).

%--- RANDOM SAMPLING ---

searchProg(C, S, P, Vars, Gs) :-
    genProgRand(C, S, P, Vars),
    \+member(P, Gs).

searchExp(C, S, T, E, Vars, Gs) :-
    genExpRand(C, S, T, E, Vars),    
    \+member((T, E), Gs).

getTest(_, _, 0, _, _, [], _) :- !.
getTest(prog, C, N, S, _, Ris, Vars) :-
    N > 0,
    M is N - 1,
    getTest(prog, C, M, S, _, Gs, Vars),   
    !, 
    (
        (searchProg(C, S, P, Vars, Gs)) -> (
            Ris = [P | Gs] 
        ) ; (
            Ris = Gs
        )
    ).
getTest(exp, C, N, S, T, Ris, Vars) :-
    N > 0,
    M is N - 1,
    getTest(exp, C, M, S, T, Gs, Vars),
    !,
    (
        (searchExp(C, S, T, E, Vars, Gs)) -> (
            Ris = [(T, E) | Gs]
        ) ; (
            Ris = Gs
        )
    ).
%! getTest(+WhatGenerate, +Certificate, +NumberOfTest, +Dimension, +TypeOfExpression, -GeneratedTests, +Vars).

genNRandProg(C, N, S, G, Vars) :-
    getTest(prog, C, N, S, _, Gs, Vars),
    !,
    member(G, Gs).
%! genNRandProg(+Certificate, +NumberOfTest, +Dimension, +GeneratedProgram, +Vars).

genNRandExp(C, N, S, T, G, Vars) :-
    getTest(exp, C, N, S, T, Gs, Vars),
    !,
    member((T, G), Gs).
%! genNRandExp(+Certificate, +NumberOfTest, +Dimension, +TypeOfExpression, +GeneratedExpression, +Vars).

%--- GEN_ALL_EXP ---

genAllExp(C, N) :-
    varList(VarList),     
    M is N * 2,    
    genExp(C, N, M, _, E, VarList),
    writeExp(E),
    nl,    
    fail.
genAllExp(_,_).
    
%--- GEN_ALL_PROG ---

genAllProg(C, N) :-
    varList(VarList),   
    M is N * 2,
    genProg(C, N, M, P, VarList),
    write(P), nl,
    writeProg(P, ""),
    (
        (nb_current(genProg, Count)) -> 
            (                
                Count1 is Count + 1,
                nb_setval(genProg, Count1)
            ); (
                nb_setval(genProg, 1)
            )
    ),    
    nl,    
    fail.
genAllProg(_, _) :-
    !,
    nl,
    (
        (nb_current(genProg, Count)) -> 
            (
                write("Generati "), 
                write(Count),
                write(" programmi"),
                nb_delete(genProg)
            ) ; (
                write("Generati 0 programmi")
            )
            
    ),
    nl.

