:- ['fpcs.pro'].

% Certificate checker for vanilla: true | A | A builtin | A lib | G , G | G ; G
% anche con random, uniforme
check(Cert, true) :- 
    !,
    ttE(Cert).
check(Cert, (T = T)) :- 
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
% diff between builtin and lib
check(_, A) :-
	builtin(A),
	!,
	 call(A).


check(Cert, A) :-
	lib(A),
	!,
	 unfoldElib(Cert, Cert1,A,G), 
	 check(Cert1, G).
check(Cert, A) :-
	!,
	unfoldE(Cert, Cert1,A, G), 
	check(Cert1, G).



/*

  */

% nota: random_member, random_select NON fanno backtracking e quindi usiamo random_permutation



rva(true) :- !.
rva((A,B)) :-!, rva(A),rva(B).
rva(A) :-
	builtin(A),
	!,
	call(A).

rva(A) :-
	lib(A),
	!,
	clause(A,G),
	rva(G).

rva(A) :-
	findall(A :- G,clause(A,G),L),
	 random_permutation(L,P),
	 member(A :- RG,P),
%	 write('chosen:'), write(A :- RG),nl,
	 rva(RG).

% -- esempi
:- op(150,xfy,::).  %    non-empty list constructor


nat(0).
nat(1).
nat(2).
nat(3).
nat(4).
nat(5).

natlist(nil).
natlist(H :: T) :-
	nat(H),natlist(T).

% GENERATORE CON BENZINA -- da non usare, usare invece il pairing
gen(0, nil).
gen(N, X :: L) :-
    N >= 0,
    M is N - 1,
    nat(X),
    gen(M, L).

builtin(_ >= _).
builtin(_ is _).
lib(mem(_, _)).
lib(is_var(_ ,_)).
lib(is_bool(_)).
lib(is_int(_)).
%lib(member_(_, _,_)).

% end stuff
% ora inutile, alla Clark,

:- discontiguous myclause/2.

myclause(is_nat(X), (X = 0; X = 1 ; X = 2)).
myclause(is_list(L) ,
	 ( L = nil
	 ;
	   (is_nat(X), L = X :: nil))
	;
           (is_nat(X), is_nat(Y), L = (Y :: (X :: nil)))).

% vanilla con la completion
vac(true) :-!.
vac(A = A) :- !.
vac((A,B)) :-
	!,
	vac(A),vac(B).
vac((A;B)) :-
	vac(A);vac(B).
vac(A) :-
	myclause(A,B),
	vac(B).

% vanilla con la completion e random backtracking
% con distribuzione uniforme

vacr((A,B)) :-
	!,
	vacr(A),vacr(B).
vacr((A;B)) :-
	(maybe -> 
	 (vacr(A);vacr(B))
	;
	 (vacr(B);vacr(A))).
vacr(A) :-
	myclause(A,B),
	vacr(B).
vacr(A) :-
	builtin(A),
	!,
	call(A).
vacr(true) :-!.
vacr(A = A) :- !.

myclause(genc(K,L),
	 (
	  (L = nil, K = 0)
	 ;
	  ( K >= 0,
	    L = X :: Lx,
	  M is K - 1,
	    is_nat(X),
	    genc(M, Lx)))) .



  

