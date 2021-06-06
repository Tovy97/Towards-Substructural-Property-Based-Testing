:- ['../classicHelper.pro'].
:- ['../typeChecker.pro'].

:- op(120, xfy, :).

%--- OPERAZIONI
% Add/Sub/Mul
add(A, B, S, K) <-
    addInt(A, B, S) &
    K.
sub(A, B, S, K) <-
    subInt(A, B, S) &
    K.
mul(A, B, S, K) <-
    mulInt(A, B, S) &
    K.

% And/Or/Not/Eq
andB(A, B, S, K) <-
    andBool(A, B, S) &
    K.
orB(A, B, S, K) <-
    orBool(A, B, S) &
    K.
notB(A, S, K) <-
    notBool(A, S) &
    K.
eqB(A, B, S, K) <-
    eqBool(A, B, S) &
    K.

%---

%--- CEVAL ---
ceval(State, skip, K, State)                <- 
    K.
ceval(StateInA, A : B, K, StateOutB)                <- 
    ceval(StateInA, A, ceval(StateOutA, B, K, StateOutB), StateOutA).      
ceval(StateIn, assign(X, E), K, StateOut) <-        
    eval(StateIn, E, V, replace(variable(X, V), StateIn, variable(X, V), StateOut) & K).                    % <- BUG: Aggiunto V al posto di _ nel primo variable
ceval(StateIn, if(C, B1, _), K, StateOut) <- 
    eval(StateIn, C, vb(true), ceval(StateIn, B1, K, StateOut)). 
ceval(StateIn, if(C, _, B2), K, StateOut) <- 
    eval(StateIn, C, vb(false), ceval(StateIn, B2, K, StateOut)).
ceval(StateIn, while(C, B), K, StateOut)  <- 
    eval(StateIn, C, vb(true), ceval(StateIn, B, ceval(StateOutB, while(C, B), K, StateOut), StateOutB)).
ceval(State, while(C, _), K, State)  <- 
    eval(State, C, vb(false), K).
%! ceval(+StateIn, +Prog, +Continuation, -StateOut).


%--- CEVALG ---
cevalG(N, State, skip, K, State)                <- 
    positive(N) &
    K.
cevalG(N, StateInA, A : B, K, StateOutB)                <- 
    positive(N) &
    cevalG(N, StateInA, A, cevalG(N, StateOutA, B, K, StateOutB), StateOutA).      
cevalG(N, StateIn, assign(X, E), K, StateOut) <-  
    positive(N) &      
    eval(StateIn, E, V, replace(variable(X, V), StateIn, variable(X, V), StateOut) & K).                % <- BUG: Aggiunto V al posto di _ nel primo variable
cevalG(N, StateIn, if(C, B1, _), K, StateOut) <- 
    positive(N) &
    eval(StateIn, C, vb(true), cevalG(N, StateIn, B1, K, StateOut)). 
cevalG(N, StateIn, if(C, _, B2), K, StateOut) <- 
    positive(N) &
    eval(StateIn, C, vb(false), cevalG(N, StateIn, B2, K, StateOut)).
cevalG(N, StateIn, while(C, B), K, StateOut)  <- 
    positiveDec(N, M) & 
    eval(StateIn, C, vb(true), cevalG(M, StateIn, B, cevalG(M, StateOutB, while(C, B), K, StateOut), StateOutB)).
cevalG(N, State, while(C, _), K, State)  <- 
    positive(N) &
    eval(State, C, vb(false), K).
%! cevalG(+Gas, +StateIn, +Prog, +Continuation, -StateOut).

%---

%--- EVAL ---
eval(_, b(B), vb(B), K)              <-
    K.
eval(_, i(N), vi(N), K)              <-
    K.
eval(State, X, V, K)                <-
    member(variable(X, V), State) & 
    K.
eval(State, plusV(E1, E2), vi(V), K)  <-
    eval(State, E1, vi(V1), eval(State, E2, vi(V2), add(V1, V2, V, K))).    
eval(State, minusV(E1, E2), vi(V), K) <- 
    eval(State, E1, vi(V1), eval(State, E2, vi(V2), sub(V1, V2, V, K))).
eval(State, timesV(E1, E2), vi(V), K) <- 
    eval(State, E1, vi(V1), eval(State, E2, vi(V2), mul(V1, V2, V, K))).
eval(State, eqV(E1, E2), vb(V), K)    <- 
    eval(State, E1, vb(V1), eval(State, E2, vb(V2), eqB(V1, V2, V, K))).
eval(State, eqV(E1, E2), vb(V), K)    <- 
    eval(State, E1, vi(V1), eval(State, E2, vi(V2), eqB(V1, V2, V, K))).
eval(State, andV(E1, E2), vb(V), K)   <- 
    eval(State, E1, vb(V1), eval(State, E2, vb(V2), andB(V1, V2, V, K))).
eval(State, orV(E1, E2), vb(V), K)    <- 
    eval(State, E1, vb(V1), eval(State, E2, vb(V2), orB(V1, V2, V, K))).
eval(State, notV(E1), vb(V), K)       <- 
    eval(State, E1, vb(V1), notB(V1, V, K)).
%! eval(+State, +Expression, ±Value, +Continuation).

%--- EX_EVAL ---
ex_eval(_, (_), K) <-
    K.
ex_eval(_, i(_), K) <-
    K.
ex_eval(State, X, K) <-
    member(variable(X, _), State) & 
    K.
ex_eval(State, plusV(E1, E2), K) <-
    ex_eval(State, E1, ex_eval(State, E2, K)).
ex_eval(State, minusV(E1, E2), K) <-
    ex_eval(State, E1, ex_eval(State, E2, K)).
ex_eval(State, timesV(E1, E2), K) <-
    ex_eval(State, E1, ex_eval(State, E2, K)).
ex_eval(State, eqV(E1, E2), K) <-
    ex_eval(State, E1, ex_eval(State, E2, K)).
ex_eval(State, andV(E1, E2), K) <-
    ex_eval(State, E1, ex_eval(State, E2, K)).
ex_eval(State, orV(E1, E2), K) <-
    ex_eval(State, E1, ex_eval(State, E2, K)).
ex_eval(State, notV(E1), K) <-
    ex_eval(State, E1, K).
%! ex_eval(+State, +Expression, +Continuation).

%--- COLLECT ---
collect([], [])         <-
    true.
collect([variable(X, V) | XS1], [(X, V) | XS2]) <-     
    collect(XS1, XS2).
%! collect(-State).

%--- INTERP ---
interp(StateIn, Prog, Vars) <-
    ceval(StateIn, Prog, collect(StateOut, Vars), StateOut).
%! interp(+StateIn, +Prog, -Variables).

%--- INTERPG ---
interpG(N, StateIn, Prog, Vars) <-
    cevalG(N, StateIn, Prog, collect(StateOut, Vars), StateOut).
%! interpG(+Gas, +StateIn, +Prog, -Variables).
