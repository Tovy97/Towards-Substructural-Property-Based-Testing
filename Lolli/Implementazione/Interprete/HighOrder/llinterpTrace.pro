:- multifile (<-)/2.

%% An interpreter for the fragment of propositional, intuitutionistic
%% linear logic described in the paper
%%  "Logic Programming in a Fragment of Intuitionistic Linear Logic" 
%%   by Joshua S. Hodas and Dale Miller, to appear in the
%%   Journal of Information and Computation.

%  The logic being interpreted contains the following logical connectives:
%   true/0	 	a constant (empty tensor, written as 1 in the paper)
%   erase/0		a constant (erasure, written as Top in the paper)
%   bang/1	 	the modal usually written as !
:- op(145,xfy,->).  %    linear implication, written as -o in the paper
:- op(145,xfy,=>).  %    intuitionistic implication
:- op(140,xfy,x ).  %    multiplicative conjunction (tensor)
:- op(140,xfy,& ).  %    additive conjunction
:- op(150,yfx,<-). %     the converse of the linear implication

%  Non-logical constants
%     del/0   denotes a deleted bounded formula
   
bc(I, I, A, A).
bc(I, O, A, G -> R)  :-
    bc(I, M, A, R),
    prove_track(M, O, G).
bc(I, O, A, G => R)  :-
    bc(I, O, A, R),
    prove_track(O, O, G).
bc(I, O, A, R1 & R2) :-
    bc(I, O, A, R1);
    bc(I, O, A, R2).

pickR([bang(R) | I], [bang(R) | I], R).
pickR([R | I], [del | I], R).
pickR([S | I], [S | O], R) :- 
   pickR(I, O, R).

subcontext([del | O], [_ | I]) :- 
   subcontext(O, I).
subcontext([S | O], [S | I])  :- 
   subcontext(O,I). 
subcontext([], []).

%---

prove(I, I, true) :-
    !.
prove(I, O, erase)   :-
    !,
    subcontext(O, I).
prove(I, O, G1 & G2) :-	
    !,	
    prove_track(I, O, G1),
    prove_track(I, O, G2).
prove(I, O, R -> G)  :-
    !,
    prove_track([R | I], [del | O], G).
prove(I, O, R => G)  :- 
    !,
    prove_track([bang(R) | I], [bang(R) | O], G).
prove(I, O, G1 x G2) :-
    !,
    prove_track(I, M, G1),
    prove_track(M, O, G2).
prove(I, I, bang(G)) :-
    !,
    prove_track(I, I, G). 
prove(I,O, not(A)) :-
    !,
    ground(A), 
    \+ prove_track(I,O,A).

%BUILT IN
prove(I, I, write(X)) :- 
    !,
    write(X).
prove(I, I, read(X)) :- 
    !,
    read(X).
prove(I, I, nl) :- 
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
    pickR(I, M, R),
    bc(M, O, A, R).
prove(I, O, A) :-
    A <- G,
    prove_track(I, O, G).

%---

seq(Unbound, Bound, Goal) :-
    create_context(Unbound, Bound, Goal, GoalWithContext),
    prove_track([], [], GoalWithContext).

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

%---

checkChar(99).                      % char 'c'
checkChar(115) :- stop_traking.     % char 's'
    
clean([], [], [], []).
clean([bang(H) | I], [bang(H) | O], [H | U], B) :-
    clean(I, O, U, B).
clean([del | I], [del | O], U, B) :-
    clean(I, O, U, B).
clean([H | I], [del | O], U, [H | B]) :-
    H \== del,
    clean(I, O, U, B).

prove_track(I, O, G) :-
    var(O),
    nb_getval(track, yes),
    write("?; ? => "),
    write(G),
    nl,
    get_single_char(C),
    checkChar(C),
    (
        prove(I, O, G) -> (
            true
        ) ; (
            write("\t FAIL\n"), 
            prove(I, O, G)
        )
    ).
prove_track(I, O, G) :-
    nb_getval(track, yes),
    clean(I, O, U, B),
    write(U),
    write("; "),
    write(B),
    write(" => "),
    write(G),
    nl,
    get_single_char(C),
    checkChar(C),
    (
        prove(I, O, G) -> (
            true
        ) ; (
            write("\t FAIL\n"),
            prove(I, O, G)
        )
    ).
prove_track(I, O, G) :-
    nb_getval(track, no),
    prove(I, O, G).

:- nb_setval(track, no).

tracking :-
    nb_setval(track, yes).
stop_traking :-
    nb_setval(track, no).
