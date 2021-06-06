:- multifile (<-)/2.

%  Non-logical constants
%     del/0   denotes a deleted bounded formula

%  The logic being interpreted contains the following logical connectives:
%   true/0	 	a constant (empty tensor, written as 1 in the paper)
%   erase/0		a constant (erasure, written as Top in the paper)
%   bang/1	 	the modal usually written as !
:- op(145, xfy, ->).  %    linear implication, written as -o in the paper
:- op(145, xfy, =>).  %    intuitionistic implication
:- op(140, xfy, x ).  %    multiplicative conjunction (tensor)
:- op(140, xfy, & ).  %    additive conjunction
:- op(150, yfx, <-).  %     the converse of the linear implication

pickR([bang(R) | I], [bang(R) | I], R).
pickR([R | I], [del | I],  R). 
pickR([S | I], [S | O], R)    :- 
    pickR(I, O, R).

subcontext([del | O], [_ | I]) :- 
    subcontext(O, I).
subcontext([S | O], [S | I])   :- 
    subcontext(O,I). 
subcontext([], []).

prove(I, I, true) :- 
    !.
prove(I, O, erase)   :-
    !, 
    subcontext(O, I).
prove(I, O, G1 & G2) :-
    !, 
    prove(I, O, G1),
    prove(I, O, G2).
prove(I, O, R -> G)  :- 
    !,
    prove([R | I], [del | O], G).
prove(I, O, R => G)  :- 
    !,
    prove([bang(R) | I], [bang(R) | O], G).
prove(I, O, G1 x G2) :- 
    !,
    prove(I, M, G1), 
    prove(M, O, G2).
prove(I, I, bang(G)) :- 
    !,
    prove(I, I, G).
prove(I, O, not(A)) :-
    !, 
    ground(A), 
    \+ prove(I, O, A).

% BUILT-IN
prove(I, I, write(X)) :- 
    !,
    write(X).
prove(I, I, read(X))  :- 
    !,
    read(X).
prove(I, I, nl)       :- 
    !,
    nl.
prove(I, I, random(L, U, R)) :- 
    !,
    random(L, U, R).
prove(I, I, inc(B, A)) :- 
    integer(B),
    !,
    A is B + 1.
prove(I, I, dec(B, A)) :- 
    integer(B),
    !,
    A is B - 1.
prove(I, I, notEq(A, B)) :- 
    !,
    A \== B.
prove(I, I, eq(A, B))    :- 
    !,
    A == B.
prove(I, I, leq(A, B)) :-     
    integer(A),
    integer(B),
    !,
    A =< B.
prove(I, I, lt(A, B))  :- 
    integer(A),
    integer(B),
    !,
    A < B.
prove(I, I, geq(A, B)) :- 
    integer(A),
    integer(B),
    !,
    A >= B.
prove(I, I, gt(A, B))  :- 
    integer(A),
    integer(B),
    !,
    A > B.
prove(I, I, positive(N)) :- 
    integer(N),
    !,
    N >= 0.
prove(I, I, positiveDec(N, M)) :- 
    integer(N), 
    !,
    N >= 0, 
    M is N - 1.
prove(I, I, addInt(A, B, S)) :-
    integer(A),
    integer(B),
    !,
    S is A + B.
prove(I, I, subInt(A, B, S)) :- 
    integer(A),
    integer(B),
    !,
    S is A - B.
prove(I, I, mulInt(A, B, S)) :- 
    integer(A),
    integer(B),
    !,
    S is A * B.
prove(I, I, andBool(A, B, true)) :-
    (A, B), !.
prove(I, I, andBool(A, B, false)) :-
    ((\+ A) ; (\+ B)), !.
prove(I, I, orBool(A, B, false)) :-
    ((\+ A), (\+ B)), !.
prove(I, I, orBool(A, B, true)) :-
    (A ; B), !.
prove(I, I, notBool(A, true)) :-
    (\+ A), !.
prove(I, I, notBool(A, false)) :-
    A, !.
prove(I, I, eqBool(A, B, true)) :-
    A == B, 
    !.
prove(I, I, eqBool(A, B, false)) :-
    A \== B, 
    !.
% CASO BASE
prove(I, O, A)       :-
    pickR(I, O, A);
    ( 
        A <- G,
        prove(I, O, G)
    ). 
%--

seq(Unbound, Bound, Goal) :-
    create_context(Unbound, Bound, Goal, GoalWithContext),
    prove([], [], GoalWithContext).

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
