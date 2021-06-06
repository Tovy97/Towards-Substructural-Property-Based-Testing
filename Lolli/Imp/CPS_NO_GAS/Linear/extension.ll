:- ['../prettyPrinter.pro'].
:- ['../gen.pro'].
:- ['imp.ll'].
:- ['typeChecker.ll'].
:- ['smallStep.ll'].

/* ---- ESTENSIONE CON LET ---- */

value_to_expr(vi(I), i(I)) <- true.
value_to_expr(vb(B), b(B)) <- true.


/*--ESTENSIONE DI IMP--*/
ceval(let(X, E, C), K) <-          
    eval(E, V, variable(X, VOld) x (variable(X, V) -> ceval(C, variable(X, _) x (variable(X, VOld) -> K)))).

cevalG(N, let(X, E, C), K) <-
    bang(positive(N)) x
    eval(E, V, variable(X, VOld) x (variable(X, V) -> cevalG(N, C, variable(X, _) x (variable(X, VOld) -> K)))). 

/*--ESTENSIONE DI SMALLSTEP--*/
step(let(X, E, C), assign(X, E) : C : assign(X, EOld), K) <-
    variable(X, VOld) x 
    value_to_expr(VOld, EOld) x
    (variable(X, VOld) -> K).

ex_step(let(X, E, C), K) <-
    variable(X, VOld) x 
    value_to_expr(VOld, EOld) x
    (variable(X, VOld) -> ex_step(assign(X, E) : C : assign(X, EOld), K)).

/*--ESTENSIONE DI GEN--*/
is_prog(let(X, E, C), Vars)   :-
    is_var(T, X),    
    is_exp(T, E, Vars),
    is_prog(C, Vars).

/*--ESTENSIONE DI PRETTYPRINTER--*/
writeProg(let(X, E, C), Tab) :- 
    !,
    string_concat(Tab, "\t", Tab1),
    write(Tab),
    write("let "), write(X), write(" := "), writeExp(E), write(" in {\n"), 
    writeProg(C, Tab1),
    write(Tab),
    write("}\n").

/*--ESTENSIONE DI TYPECHECKER*/
com_type(let(X, E, C)) <-
    type(T, X) &
    has_type(E, T) &
    com_type(C).