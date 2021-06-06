#! /usr/bin/swipl -f -q

:- ['../../Implementazione/Interprete/2ndOrder-Cert/llinterp.pro'].

:- ['../list.pro'].
:- ['lin-gen.ll'].
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

%%%%%%%%%%% PERM - PBT LOLLI %%%%%%%%%%%

query(0, S, L, P) :-
	write("Forall L, len(L) = len(perm(L))?"), nl,
	Cert = qheight(S),
	prove(Cert, [], [], is_natlist(L) & perm(L, P) & len(L, B) & not(len(P, B))).

query(1, S, L, P) :-
    write("Forall L such that distinct(L), distinct(perm(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & distinct(L) & perm(L, P) & not(distinct(P))).
query(2, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, perm(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & in_list(X, L) & perm(L, P) & not(in_list(X, P))).                

%%%%%%%%%%% SLOWSORT - PBT LOLLI %%%%%%%%%%%

query(3, S, L, P) :-
    write("Forall L, len(L) = len(slowsort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & len(L, B) & slowsort(L, P) & not(len(P, B))).                         
query(4, S, L, P) :-
    write("Forall L such that distinct(L), distinct(slowsort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & distinct(L) & slowsort(L, P) & not(distinct(P))).
query(5, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, slowsort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & in_list(X, L) & slowsort(L, P) & not(in_list(X, P))).
query(6, S, L, P) :- 
    write("Forall L, sorted(slowsort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & slowsort(L, P) & not(sorted(P))).
query(7, S, L, P) :- 
    write("Forall L, if count(X, L) = C then count(X, slowsort(L)) = C?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & is_nat(X) & count(X, L, C) & slowsort(L, P) & not(count(X, P, C))).

%%%%%%%%%%% QUICKSORT - PBT LOLLI %%%%%%%%%%%

query(8, S, L, P) :-
    write("Forall L, len(L) = len(quicksort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & len(L, B) & quicksort(L, P) & not(len(P, B))). 
query(9, S, L, P) :-
    write("Forall L such that distinct(L), distinct(quicksort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & distinct(L) & quicksort(L, P) & not(distinct(P))).                    
query(10, S, L, P) :- 
    write("Forall L, if member(X, L) then member(X, quicksort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & in_list(X, L) & quicksort(L, P) & not(in_list(X, P))).    
query(11, S, L, P) :- 
    write("Forall L, sorted(quicksort(L))?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & quicksort(L, P) & not(sorted(P))).
query(12, S, L, P) :- 
    write("Forall L, if count(X, L) = C then count(X, quicksort(L)) = C?"), nl,
    Cert = qheight(S),
    seq(Cert, [], [], is_natlist(L) & is_nat(X) & count(X, L, C) & quicksort(L, P) & not(count(X, P, C))). 
