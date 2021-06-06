				% 2 interprete con Cert in prove
				% prove(Cert,I,O,G).

:- multifile (<-)/2.

:- consult("../../Certificati/fpcs.pro").

:- op(145, xfy, ->).  %    linear implication, written as -o in the paper
:- op(145, xfy, =>).  %    intuitionistic implication
:- op(140, xfy, x ).  %    multiplicative conjunction (tensor)
:- op(140, xfy, & ).  %    additive conjunction
:- op(150, yfx, <-).  %     the converse of the linear implication

pickR(Cert,[bang(R) | I], [bang(R) | I], R) :-
	pickRE(Cert).

pickR(Cert,[R | I], [del | I],  R) :-
	pickRE(Cert).
pickR(Cert,[S | I], [S | O], R)    :- 
    pickR(Cert,I, O, R).

subcontext([del | O], [_ | I]) :- 
    subcontext(O, I).
subcontext([S | O], [S | I])   :- 
    subcontext(O,I). 
subcontext([], []).

prove(Cert,I, I, true) :- 
	!,
	 ttE(Cert).
prove(Cert, I, O, erase)   :-
	!,
	 eraseE(Cert),
    subcontext(O, I).
prove(Cert,I, O, G1 & G2) :-
	!,
	andE(Cert, Cert1, Cert2),
    prove(Cert1,I, O, G1),
    prove(Cert2, I, O, G2).
prove(Cert, I, O, R -> G)  :- 
	!,
	lolliE(Cert,Cert1),
	prove(Cert1, [R | I], [del | O], G).
prove(Cert,I, O, R => G)  :- 
	!,
	impE(Cert, Cert1),
	prove(Cert1, [bang(R) | I], [bang(R) | O], G).
prove(Cert,I, O, G1 x G2) :- 
	!,
	  tensorE(Cert, Cert1, Cert2),
	  prove(Cert1,I, M, G1), 
	  prove(Cert2,M, O, G2).
prove(Cert,I, I, bang(G)) :- 
	!,
	bangE(Cert,Cert1),
	prove(Cert1, I, I, G).
prove(Cert,I, O, not(A)) :-
    !, 
    ground(A), 
    \+ prove(Cert, I, O, A). % transparent as the builtin (may be a problem ...)

% BUILT-IN
prove(_,I, I, write(X)) :- 
    !,
    write(X).
prove(_,I, I, read(X))  :- 
    !,
    read(X).
prove(_,I, I, nl)       :- 
    !,
    nl.
prove(_,I, I, random(L, U, R)) :- 
    !,
    random(L, U, R).
prove(_,I, I, inc(B, A)) :- 
    integer(B),
    !,
    A is B + 1.
prove(_,I, I, dec(B, A)) :- 
    integer(B),
    !,
    A is B - 1.
prove(_,I, I, notEq(A, B)) :- 
    !,
    A \== B.
prove(_,I, I, eq(A, B))    :- 
    !,
    A == B.
prove(_,I, I, leq(A, B)) :-     
    integer(A),
    integer(B),
    !,
    A =< B.
prove(_,I, I, lt(A, B))  :- 
    integer(A),
    integer(B),
    !,
    A < B.
prove(_,I, I, geq(A, B)) :- 
    integer(A),
    integer(B),
    !,
    A >= B.
prove(_,I, I, gt(A, B))  :- 
    integer(A),
    integer(B),
    !,
    A > B.
prove(_,I, I, positive(N)) :- 
    integer(N),
    !,
    N >= 0.
prove(_,I, I, positiveDec(N, M)) :- 
    integer(N), 
    !,
    N >= 0, 
    M is N - 1.
prove(_,I, I, addInt(A, B, S)) :-
    integer(A),
    integer(B),
    !,
    S is A + B.
prove(_,I, I, subInt(A, B, S)) :- 
    integer(A),
    integer(B),
    !,
    S is A - B.
prove(_,I, I, mulInt(A, B, S)) :- 
    integer(A),
    integer(B),
    !,
    S is A * B.
prove(_,I, I, andBool(A, B, true)) :-
    (A, B), !.
prove(_,I, I, andBool(A, B, false)) :-
    ((\+ A) ; (\+ B)), !.
prove(_,I, I, orBool(A, B, false)) :-
    ((\+ A), (\+ B)), !.
prove(_,I, I, orBool(A, B, true)) :-
    (A ; B), !.
prove(_,I, I, notBool(A, true)) :-
    (\+ A), !.
prove(_,I, I, notBool(A, false)) :-
    A, !.
prove(_,I, I, eqBool(A, B, true)) :-
    A == B, 
    !.
prove(_,I, I, eqBool(A, B, false)) :-
    A \== B, 
    !.
% CASO BASE
prove(Cert, I, O, A)       :-
    pickR(Cert,I, O, A);
    ( 
      unfoldE(Cert, Cert1,A,G),
      prove(Cert1, I, O, G)
    ). 
%-- aggungere unfoldbuiltin ?

seq(Cert,Unbound, Bound, Goal) :-
    create_context(Unbound, Bound, Goal, GoalWithContext),
    prove(Cert,[], [], GoalWithContext).

create_context([], [], Goal, Goal) :-
    !.
create_context([Unbound], [], Goal, Unbound => Goal) :-
    !.
create_context([Unbound | Gamma], Delta, Goal, Unbound => GoalWithContext) :-
    !,
    create_context(Gamma, Delta, Goal, GoalWithContext).
create_context([], [Bound], Goal, Bound -> Goal) :- 
    !.
create_context([], [Bound | Delta], Goal, Bound -> GoalWithContext) :-
    !, 
    create_context([], Delta, Goal, GoalWithContext).
