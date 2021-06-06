:- ['../../../Implementazione/Interprete/Classic/interp.pro'].
:- ['classicHelper.pro'].

:- op(120, xfy, :).

/*
    NOTA: la semantica di imp è small step, ma quella di eval è big step
*/

%--- STEP ---
step(State, skip : C, C, K, State) <-
    K.
step(StateIn, C1 : C3, C2 : C3, K, StateOut) <- 
    step(StateIn, C1, C2, K, StateOut).
step(StateIn, assign(X, E), skip, K, StateOut) <-        
    eval(StateIn, E, V, replace(variable(X, _), StateIn, variable(X, V), StateOut) & K).
step(State, if(B, C1, _), C1, K, State) <-
    eval(State, B, vb(true), K).
step(State, if(B, _, C2), C2, K, State) <-
    eval(State, B, vb(false), K).
step(State, while(B, C), if(B, C : while(B, C), skip), K, State) <-
    K.
%! step(+StateIn, +CommandIn, -CommandOut, +Continuation, -StateOut).

star(State, C, C, K, State) <- 
    K.
star(StateIn, C, Cf, K, StateOut) <- 
    step(StateIn, C, C1, star(StateOutS, C1, Cf, K, StateOut), StateOutS).
%! star(+StateIn, +Command1, +Command2, +Continuation, -StateOut).

starG(N, State, C, C, K, State) <- 
    positive(N) &
    K.
starG(N, StateIn, C, Cf, K, StateOut) <- 
    positiveDec(N, M) &
    step(StateIn, C, C1, starG(M, StateOutS, C1, Cf, K, StateOut), StateOutS).
%! starG(+Gas, +StateIn, +Command1, +Command2, +Continuation, -StateOut).

%--- INTERPSS ---
interpSS(StateIn, Prog, StateOut) <-
    star(StateIn, Prog, skip, collect(StateOutS, StateOut), StateOutS).
%! interpSS(+State, +Prog, -StateOut).

%--- INTERPSSG ---
interpSSG(N, StateIn, Prog, StateOut) <-
    starG(N, StateIn, Prog, skip, collect(StateOutS, StateOut), StateOutS).
%! interpSSG(+Gas, +State, +Prog, -StateOut).

%--- EX_STEP ---
ex_step(_, _ : _, K) <-
    K.
ex_step(State, assign(X, E), K) <-        
    ex_eval(State, E, member(variable(X, _), State) & K).
ex_step(State, if(B, _, _), K) <-
    ex_eval(State, B, K).
ex_step(State, while(B, C), K) <-
    ex_step(State, if(B, C : while(B, C), skip), K).
%! ex_step(+State, +Program, +Continuation).

%--- EX_STEP_OR_SKIP ---
ex_step_or_skip(_, skip, K) <- 
    K.
ex_step_or_skip(State, P, K) <- 
    ex_step(State, P, K).
%! ex_step_or_skip(+State, +Program, +Continuation).