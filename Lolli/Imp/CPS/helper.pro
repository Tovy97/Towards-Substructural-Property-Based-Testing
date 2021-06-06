mem(X, [X | _]).
mem(E, [_ | L]) :-
    mem(E, L).


genVars(_, [], [], []) :- !.
genVars(false, [type(bool, X) | Gamma], [variable(X, vb(false)) | Delta], [X | VarList]) :-
    !,
    genVars(false, Gamma, Delta, VarList).
genVars(true, [type(bool, X) | Gamma], [variable(X, vb(RandBool)) | Delta], [X | VarList]) :-
    !,    
    (
        (maybe()) ->
            (RandBool = true);
            (RandBool = false)
    ),
    genVars(true, Gamma, Delta, VarList).
genVars(false, [type(int, X) | Gamma], [variable(X, vi(0)) | Delta], [X | VarList]) :-
    !, 
    genVars(false, Gamma, Delta, VarList).
genVars(true, [type(int, X) | Gamma], [variable(X, vi(RandInt)) | Delta], [X | VarList]) :-
    !, 
    random_between(-3, 3, RandInt),     
    genVars(true, Gamma, Delta, VarList).
%! genVars(+Rand, +Gamma, -Delta, -VarsList).

init_var(Rand, Delta, VarsList, Gamma) :-    
    Gamma = [type(bool, x), type(bool, y), type(int, w), type(int, z)],
    genVars(Rand, Gamma, Delta, VarsList).
%! init_var(+Rand, -Delta, -VarsList, -Gamma).

init_var(Delta, VarsList, Gamma) :-    
    Gamma = [type(bool, x), type(bool, y), type(int, w), type(int, z)],
    genVars(false, Gamma, Delta, VarsList).
%! init_var(-Delta, -VarsList, -Gamma).

convert_list([], []).
convert_list([(X, V) | L1], [variable(X, V)| L2]) :-
    convert_list(L1, L2).


updateGeneratedTest() :-
    nb_getval(query, (Q, S, _)),
    Q1 is Q + 1,
    nb_setval(query, (Q1, S, n)).
updateSuccessfulTest() :-
    nb_current(query, (Q1, S, n)) ->
        (
            S1 is S + 1,
            nb_setval(query, (Q1, S1, y))
        ) ; 
        true. 