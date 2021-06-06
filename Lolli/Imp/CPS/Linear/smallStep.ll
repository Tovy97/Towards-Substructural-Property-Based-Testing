:- ['../../../Implementazione/Interprete/2ndOrder/llinterp.pro'].

:- op(120, xfy, :).

/*
    NOTA: la semantica di imp è small step, ma quella di eval è big step
*/

%--- STEP ---
step(skip : C, C, K) <-
    K.
step(C1 : C3, C2 : C3, K) <- 
    step(C1, C2, K).
step(assign(X, E), skip, K) <-        
    eval(E, V, variable(X, _) x (variable(X, V) -> K)).
step(if(B, C1, _), C1, K) <-
    eval(B, vb(true), K).
step(if(B, _, C2), C2, K) <-
    eval(B, vb(false), K).
step(while(B, C), if(B, C : while(B, C), skip), K) <-
    K.
%! step(+CommandIn, -CommandOut, +Continuation).

star(C, C, K) <- 
    K.
star(C, Cf, K) <- 
    step(C, C1, star(C1, Cf, K)).
%! star(+Command1, -Command2, +Continuation).

starG(N, C, C, K) <- 
    bang(positive(N)) x 
    K.
starG(N, C, Cf, K) <- 
    bang(positiveDec(N, M)) x 
    step(C, C1, starG(M, C1, Cf, K)).
%! starG(+Gas, +Command1, -Command2, +Continuation).

%--- INTERPSS ---
interpSS(P, Vars, S) <-
    star(P, skip, collect(Vars, S)).
%! interpSS(+Prog, +Vars, -State).

%--- INTERPSSG ---
interpSSG(N, P, Vars, S) <-
    starG(N, P, skip, collect(Vars, S)).
%! interpSSG(+Gas, +Prog, +Vars, -State).

%--- EX_STEP ---
ex_step(_ : _, K) <-
    K.
ex_step(assign(X, E), K) <-        
    ex_eval(E, variable(X, V) x (variable(X, V) -> K)).
ex_step(if(B, _, _), K) <-
    ex_eval(B, K).
ex_step(while(B, C), K) <-
    ex_step(if(B, C : while(B, C), skip), K).
%! ex_step(+Expression, +Continuation).

%--- EX_STEP_OR_SKIP ---
ex_step_or_skip(skip, K) <- 
    K.
ex_step_or_skip(P, K) <- 
    ex_step(P, K).
%! ex_step_or_skip(+Program, +Continuation).
