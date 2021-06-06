#! /usr/bin/swipl -f -q

:- ['../../Implementazione/Interprete/2ndOrder/llinterp.pro'].
:- ['../../Implementazione/Certificati/kernel.pro'].

:- ['genClark.pro'].
:- ['../list.pro'].
:- ['../slowsort.ll'].
:- ['../quicksort.ll'].

import_version(0) :- write("Versione: perm.ll - "), ['../perm.ll'].
import_version(1) :- write("Versione: perm-bug.ll - "), ['../perm-bug.ll'].
import_version(2) :- write("Versione: perm-bug2.ll - "), ['../perm-bug2.ll'].

:- initialization(main).

main :-                                                 % query V T Q D   dove V è la versione di perm, T è il numero di test, Q è la query e D è la dimensione della lista
    current_prolog_flag(argv, [V1, T1, I1, S1]),
    atom_number(V1, V),
    atom_number(T1, T),
    atom_number(I1, I),
    atom_number(S1, S),
    import_version(V),    
    write("Dimensione: "),
    write(S),
    nl,
    write("Query "),
    write(I),
    write(": "),
    (query(I, T, S, L, P) ->  
        (write("Test non passato. Controesempio: "), write(L), write(" --> "), write(P), nl) ;
        write("Test passato\n") 
    ),
    halt.

%%% SAMPLE DEI PRIMI N TEST GENERATI RANDOM

get_N_test(S) :- 
    vacr(isNatList(S, L)),
    nb_getval(num_test, N),    
    (
        (N == 0) -> (
            fail
        ) ; (        
            M is N - 1,
            nb_setval(num_test, M),
            nb_getval(tests, T),
            nb_setval(tests, [L | T]), 
            fail
        )
    ).
get_N_test(_).

getTest(N, S, L) :-
    nb_setval(num_test, N),
    nb_setval(tests, []),
    get_N_test(S),
    nb_getval(tests, L),
    nb_delete(num_test),
    nb_delete(tests).

genList(N, S, L) :-
    getTest(N, S, T),
    !,
    member(L, T).

genAllList(N, S) :-
    genList(N, S, L),
    write(L), nl,
    fail.

%%%%%%%%%%% PERM - PBT PROLOG + LOLLI %%%%%%%%%%%

query(0, T, S, L, P) :-
    write("Forall L, len(L) = len(perm(L))?"), nl,
    genList(T, S, L),
    len(L, B), 
    seq([], [], perm(L, P)), 
    \+len(P, B).                         
query(1, T, S, L, P) :-
    write("Forall L such that distinct(L), distinct(perm(L))?"), nl,
    genList(T, S, L),  
    distinct(L), 
    seq([], [], perm(L, P)), 
    \+distinct(P).                    
query(2, T, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, perm(L))?"), nl,
    genList(T, S, L),  
    in_list(X, L), 
    seq([], [], perm(L, P)), 
    \+in_list(X, P).                

%%%%%%%%%%% SLOWSORT - PBT PROLOG + LOLLI %%%%%%%%%%%

query(3, T, S, L, P) :-
    write("Forall L, len(L) = len(slowsort(L))?"), nl,
    genList(T, S, L),  
    len(L, B), 
    seq([], [], slowsort(L, P)), 
    \+len(P, B).                         
query(4, T, S, L, P) :-
    write("Forall L such that distinct(L), distinct(slowsort(L))?"), nl,
    genList(T, S, L),  
    distinct(L), 
    seq([], [], slowsort(L, P)), 
    \+distinct(P).                    
query(5, T, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, slowsort(L))?"), nl,
    genList(T, S, L),  
    in_list(X, L), 
    seq([], [], slowsort(L, P)), 
    \+in_list(X, P).    
query(6, T, S, L, P) :- 
    write("Forall L, sorted(slowsort(L))?"), nl,
    genList(T, S, L),  
    seq([], [], slowsort(L, P)), 
    \+sorted(P).                      % LOOP su perm-bug.ll --> non trova controesempio e vengono generate infinite liste. [vedi sotto-am]
query(7, T, S, L, P) :- 
    write("Forall L, if count(X, L) = C then count(X, slowsort(L)) = C?"), nl,
    genList(T, S, L),  
    count(X, L, C), 
    seq([], [], slowsort(L, P)), 
    \+count(X, P, C).    

%%%%%%%%%%% QUICKSORT - PBT PROLOG + LOLLI %%%%%%%%%%%

query(8, T, S, L, P) :-
    write("Forall L, len(L) = len(quicksort(L))?"), nl,
    genList(T, S, L),  
    len(L, B), 
    seq([], [], quicksort(L, P)), 
    \+len(P, B). 
query(9, T, S, L, P) :-
    write("Forall L such that distinct(L), distinct(quicksort(L))?"), nl,
    genList(T, S, L),  
    distinct(L), 
    seq([], [], quicksort(L, P)), 
    \+distinct(P).                    
query(10, T, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, quicksort(L))?"), nl,
    genList(T, S, L),  
    in_list(X, L), 
    seq([], [], quicksort(L, P)), 
    \+in_list(X, P).    
query(11, T, S, L, P) :- 
    write("Forall L, sorted(quicksort(L))?"), nl,
    genList(T, S, L),  
    seq([], [], quicksort(L, P)), 
    \+ sorted(P).
query(12, T, S, L, P) :- 
    write("Forall L, if count(X, L) = C then count(X, quicksort(L)) = C?"), nl,
    genList(T, S, L),  
    count(X, L, C), 
    seq([], [], quicksort(L, P)), 
    \+count(X, P, C). 
