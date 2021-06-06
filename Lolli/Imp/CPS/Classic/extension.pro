:- ['../gen.pro'].
%:- ['../gen-classic.pro'].
:- ['../prettyPrinter.pro'].
:- ['imp.pro'].
:- ['typeChecker.pro'].
:- ['smallStep.pro'].

/* ---- ESTENSIONE CON LET ---- */

value_to_expr(vi(I), i(I)) <- true.
value_to_expr(vb(B), b(B)) <- true.

/*--ESTENSIONE DI IMP--*/

ceval(StateIn, let(X, E, C), K, StateOut) <-          
    eval(StateIn, E, V, 
        replace(variable(X, VOld), StateIn, variable(X, V), StateInC) & 
        ceval(StateInC, C, 
            replace(variable(X, _), StateOutC, variable(X, VOld), StateOut) & K, 
            StateOutC)
    ).

cevalG(N, StateIn, let(X, E, C), K, StateOut) <-          
    positive(N) &
    eval(StateIn, E, V, 
        replace(variable(X, VOld), StateIn, variable(X, V), StateInC) & 
        cevalG(N, StateInC, C, 
            replace(variable(X, _), StateOutC, variable(X, VOld), StateOut) & K, 
            StateOutC)
    ).

/*--ESTENSIONE DI SMALLSTEP--*/
step(State, let(X, E, C), assign(X, E) : C : assign(X, EOld), K, State) <-
    member(variable(X, VOld), State) &
    value_to_expr(VOld, EOld) &
    K.

ex_step(State, let(X, E, C), K) <-
    member(variable(X, VOld), State) &
    value_to_expr(VOld, EOld) &
    ex_step(State, assign(X, E) : C : assign(X, EOld), K).

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
com_type(let(X, E, C), Type) <-
    member(type(T, X), Type) &        
    has_type(E, T, Type) &
    com_type(C, Type).