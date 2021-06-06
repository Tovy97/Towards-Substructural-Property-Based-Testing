%%% OPERATORI --> presi da vecchio llinterp.pro

%   true/0	 	a constant (empty tensor, written as 1 or ⊥ in the paper)
%   erase/0		a constant (erasure, written as Top or ⊤ in the paper)
%   bang/1	 	the modal usually written as !
:- op(145, xfy, ->).  %    linear implication, written as -o in the paper
:- op(145, xfy, =>).  %    intuitionistic implication
:- op(140, xfy, x ).  %    multiplicative conjunction (tensor)
:- op(140, xfy, & ).  %    additive conjunction
:- op(150, yfx, <-).  %    the converse of the linear implication

:- multifile (<-)/2.

%     del/0   denotes a deleted bounded formula

%%% or --> preso da tesi Hodas
or(0, 0, 0).
or(0, 1, 1).
or(1, 0, 1).
or(1, 1, 1).

%%% contextIntersection --> estrapolato da definizione 7.6 tesi Hodas
contextIntersection([del | O1], [_ | O2], [del | I]) :-
    contextIntersection(O1, O2, I).
contextIntersection([_ | O1], [del | O2], [del | I]) :-
    contextIntersection(O1, O2, I).
contextIntersection([R | O1], [R | O2], [R | I]) :-
    contextIntersection(O1, O2, I).
contextIntersection([], [], []).

%%% check, check2 --> preso di tesi Hodas
check(0, 0, 0, O, O, O).
check(1, 1, 1, O1, O2, O) :-
    contextIntersection(O1,O2, O).
check(0, 1, 0, O, O1, O) :-
    subcontext(O, O1).
check(1, 0, 0, O1, O ,O) :-
    subcontext(O,O1).

check2(0, _, del).
check2(1, _, del).
check2(1, R, R).

%%% pickR, bc, subcontext --> presi da tesi Hodas
pickR([bang(R) | I], [bang(R) | I], R).
pickR([R | I], [del | I], R).
pickR([S | I], [S | O], R) :-
    pickR(I, O, R).

bc(I, I, A, A, 0).
bc(I, O, A, G -> R, E) :- 
    bc(I, M, A, R, _), 
    prove(M, O, G, E).
bc(I, O, A, G => R, 0) :- 
    bc(I, O, A, R, _), 
    prove(O, O, G, _).
bc(I, O, A, R1 & R2, 0) :- 
    bc(I, O, A, R1, _); 
    bc(I, O, A, R2, _).

subcontext([del | O], [_ | I]) :-
    subcontext(O, I).
subcontext([S | O], [S | I]) :-
    subcontext(O, I).
subcontext([], []).

% prove --> prso da tesi Hodas e in parte da vecchio llinterp.pro
%! prove(+Input, +Output, +Goal, -Slack).

prove(I, I, true, 0)  :- !.
prove(I, I, erase, 1) :- !.
prove(I, I, bang(G), 0) :- 
    !,
    prove(I, I, G, _).           %Qui ignoro la E
prove(I, O, G1 x G2, E0) :-
    !,
    prove(I, M, G1, E1),
    prove(M, O, G2, E2),
    or(E1, E2, E0).
prove(I, O, G1 & G2, E0) :-
    !,
    prove(I, O1, G1, E1),
    prove(I, O2, G2, E2),
    check(E1, E2, E0, O1, O2, O).
prove(I, O, R -> G, E) :-
    !,
    prove([R | I], [OR | O], G, E),
    check2(E, R, OR).
prove(I, O, R => G, E) :-
    !,
    prove([bang(R) | I], [bang(R) | O], G, E).
prove(I, O, not(A), E) :-    
    !,
    ground(A), 
    \+ prove(I, O, A, E).

% BUILT-IN
prove(I, I, write(X), 0) :- 
    !,
    write(X).
prove(I, I, read(X), 0)  :- 
    !,
    read(X).
prove(I, I, nl, 0)       :- 
    !,
    nl.
prove(I, I, random(L, U, R), 0) :- 
    !,
    random(L, U, R).
prove(I, I, inc(B, A), 0) :- 
    integer(B),
    !,
    A is B + 1.
prove(I, I, dec(B, A), 0) :- 
    integer(B),
    !,
    A is B - 1.
prove(I, I, notEq(A, B), 0) :- 
    !,
    A \== B.
prove(I, I, eq(A, B), 0)    :- 
    !,
    A == B.
prove(I, I, leq(A, B), 0) :- 
    integer(A),
    integer(B),
    !,
    A =< B.
prove(I, I, lt(A, B), 0)  :- 
    integer(A),
    integer(B),
    !,
    A < B.
prove(I, I, geq(A, B), 0) :- 
    integer(A),
    integer(B),
    !,
    A >= B.
prove(I, I, gt(A, B), 0)  :- 
    integer(A),
    integer(B),
    !,
    A > B.
prove(I, I, positive(N), 0) :- 
    integer(N),
    !,
    N >= 0.
prove(I, I, positiveDec(N, M), 0) :- 
    integer(N), 
    !,
    N >= 0, 
    M is N - 1.
prove(I, I, addInt(A, B, S), 0) :-
    integer(A),
    integer(B),
    !,
    S is A + B.
prove(I, I, subInt(A, B, S), 0) :- 
    integer(A),
    integer(B),
    !,
    S is A - B.
prove(I, I, mulInt(A, B, S), 0) :- 
    integer(A),
    integer(B),
    !,
    S is A * B.
prove(I, I, andBool(A, B, true), 0) :-
    (A, B), !.
prove(I, I, andBool(A, B, false), 0) :-
    ((\+ A) ; (\+ B)), !.
prove(I, I, orBool(A, B, false), 0) :-
    ((\+ A), (\+ B)), !.
prove(I, I, orBool(A, B, true), 0) :-
    (A ; B), !.
prove(I, I, notBool(A, true), 0) :-
    (\+ A), !.
prove(I, I, notBool(A, false), 0) :-
    A, !.
prove(I, I, eqBool(A, B, true), 0) :-
    A == B, 
    !.
prove(I, I, eqBool(A, B, false), 0) :-
    A \== B, 
    !.

% CASI BASE
prove(I, O, A, E) :-
    pickR(I, M, R),
    bc(M, O, A, R, E). 
prove(I, O, A, E) :-        
    A <- G,
    prove(I, O, G, E).
%---

seq(Unbound, Bound, Goal) :-
    create_context(Unbound, Bound, Goal, GoalWithContext),
    prove([], [], GoalWithContext, _).

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