#! /usr/bin/swipl -f -q

:- ['../../Implementazione/Interprete/2ndOrder/llinterp.pro'].

:- ['../list.pro'].
:- ['gen.pro'].
:- ['../slowsort.ll'].
:- ['../quicksort.ll'].

import_version(0) :- write("Versione: perm.ll - "), ['../perm.ll'].
import_version(1) :- write("Versione: perm-bug.ll - "), ['../perm-bug.ll'].
import_version(2) :- write("Versione: perm-bug2.ll - "), ['../perm-bug2.ll'].

:- initialization(main).

main :-                                                 % query V Q D   dove V è la versione di perm, Q è la query e D è la dimensione della lista
    current_prolog_flag(argv, [V1, I1, S1]),
    atom_number(V1, V),
    atom_number(I1, I),
    atom_number(S1, S),
    import_version(V),    
    write("Dimensione: "),
    write(S),
    nl,
    write("Query "),
    write(I),
    write(": "),
    (query(I, S, L, P) ->  
        (write("Test non passato. Controesempio: "), write(L), write(" --> "), write(P), nl) ;
        write("Test passato\n") 
    ),
    halt.

%%%%%%%%%%% PERM - PBT PROLOG + LOLLI %%%%%%%%%%%

query(0, S, L, P) :-
    write("Forall L, len(L) = len(perm(L))?"), nl,
    gen_natlist(S, L), len(L, B), seq([], [], perm(L, P)), \+len(P, B).                         
query(1, S, L, P) :-
    write("Forall L such that distinct(L), distinct(perm(L))?"), nl,
    gen_natlist(S, L), distinct(L), seq([], [], perm(L, P)), \+distinct(P).                    
query(2, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, perm(L))?"), nl,
    gen_natlist(S, L), in_list(X, L), seq([], [], perm(L, P)), \+in_list(X, P).                

%%%%%%%%%%% SLOWSORT - PBT PROLOG + LOLLI %%%%%%%%%%%

query(3, S, L, P) :-
    write("Forall L, len(L) = len(slowsort(L))?"), nl,
    gen_natlist(S, L), len(L, B), seq([], [], slowsort(L, P)), \+len(P, B).                         
query(4, S, L, P) :-
    write("Forall L such that distinct(L), distinct(slowsort(L))?"), nl,
    gen_natlist(S, L), distinct(L), seq([], [], slowsort(L, P)), \+distinct(P).                    
query(5, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, slowsort(L))?"), nl,
    gen_natlist(S, L), in_list(X, L), seq([], [], slowsort(L, P)), \+in_list(X, P).    
query(6, S, L, P) :- 
    write("Forall L, sorted(slowsort(L))?"), nl,
    gen_natlist(S, L), seq([], [], slowsort(L, P)), \+sorted(P).                      % LOOP su perm-bug.ll --> non trova controesempio e vengono generate infinite liste. [vedi sotto-am]
query(7, S, L, P) :- 
    write("Forall L, if count(X, L) = C then count(X, slowsort(L)) = C?"), nl,
    gen_natlist(S, L), count(X, L, C), seq([], [], slowsort(L, P)), \+count(X, P, C).    

%%%%%%%%%%% QUICKSORT - PBT PROLOG + LOLLI %%%%%%%%%%%

query(8, S, L, P) :-
    write("Forall L, len(L) = len(quicksort(L))?"), nl,
    gen_natlist(S, L), len(L, B), seq([], [], quicksort(L, P)), \+len(P, B). 
query(9, S, L, P) :-
    write("Forall L such that distinct(L), distinct(quicksort(L))?"), nl,
    gen_natlist(S, L), distinct(L), seq([], [], quicksort(L, P)), \+distinct(P).                    
query(10, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, quicksort(L))?"), nl,
    gen_natlist(S, L), in_list(X, L), seq([], [], quicksort(L, P)), \+in_list(X, P).    
query(11, S, L, P) :- 
    write("Forall L, sorted(quicksort(L))?"), nl,
    gen_natlist(S, L), seq([], [], quicksort(L, P)), \+ sorted(P).
query(12, S, L, P) :- 
    write("Forall L, if count(X, L) = C then count(X, quicksort(L)) = C?"), nl,
    gen_natlist(S, L), count(X, L, C), seq([], [], quicksort(L, P)), \+count(X, P, C). 
