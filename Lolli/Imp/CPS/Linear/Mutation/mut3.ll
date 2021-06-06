:- ['../typeChecker.ll'].

:- op(120, xfy, :).

%--- OPERAZIONI
% Add/Sub/Mul
add(A, B, S, K) <-
    bang(addInt(A, B, S)) x
    K.
sub(A, B, S, K) <-
    bang(subInt(A, B, S)) x
    K.
mul(A, B, S, K) <-
    bang(mulInt(A, B, S)) x
    K.

% And/Or/Not/Eq
andB(A, B, S, K) <-
    bang(andBool(A, B, S)) x
    K.
orB(A, B, S, K) <-
    bang(orBool(A, B, S)) x
    K.
notB(A, S, K) <-
    bang(notBool(A, S)) x
    K.
eqB(A, B, S, K) <-
    bang(eqBool(A, B, S)) x
    K.

%---

%--- EVAL ---
eval(b(B), vb(B), K)              <-
    K.
eval(i(N), vi(N), K)              <-
   K.
eval(plusV(E1, E2), vi(V), K)  <-
    eval(E1, vi(V1), eval(E2, vi(V2), add(V1, V2, V, K))).    
eval(minusV(E1, E2), vi(V), K) <- 
    eval(E1, vi(V1), eval(E2, vi(V2), sub(V1, V2, V, K))).
eval(timesV(E1, E2), vi(V), K) <- 
    eval(E1, vi(V1), eval(E2, vi(V2), sub(V1, V2, V, K))).              % <- BUG: sub al posto di mul
eval(eqV(E1, E2), vb(V), K)    <- 
    eval(E1, vb(V1), eval(E2, vb(V2), eqB(V1, V2, V, K))).
eval(eqV(E1, E2), vb(V), K)    <- 
    eval(E1, vi(V1), eval(E2, vi(V2), eqB(V1, V2, V, K))).
eval(andV(E1, E2), vb(V), K)   <- 
    eval(E1, vb(V1), eval(E2, vb(V2), andB(V1, V2, V, K))).
eval(orV(E1, E2), vb(V), K)    <- 
    eval(E1, vb(V1), eval(E2, vb(V2), orB(V1, V2, V, K))).
eval(notV(E1), vb(V), K)       <- 
    eval(E1, vb(V1), notB(V1, V, K)).
eval(X, V, K)              <-
    variable(X, V) x (
        variable(X, V) -> K
    ).
%! eval(+Expression, ±Value, +Continuation).

%--- EX_EVAL ---
ex_eval(b(_), K) <-
    K.
ex_eval(i(_), K) <-
    K.
ex_eval(X, K) <-
    variable(X, V) x (
        variable(X, V) -> K
    ).
ex_eval(plusV(E1, E2), K) <-
    ex_eval(E1, ex_eval(E2, K)).
ex_eval(minusV(E1, E2), K) <-
    ex_eval(E1, ex_eval(E2, K)).
ex_eval(timesV(E1, E2), K) <-
    ex_eval(E1, ex_eval(E2, K)).
ex_eval(eqV(E1, E2), K) <-
    ex_eval(E1, ex_eval(E2, K)).
ex_eval(andV(E1, E2), K) <-
    ex_eval(E1, ex_eval(E2, K)).
ex_eval(orV(E1, E2), K) <-
    ex_eval(E1, ex_eval(E2, K)).
ex_eval(notV(E1), K) <-
    ex_eval(E1, K).
%! ex_eval(+Expression, +Continuation).

%--- CEVAL ---
ceval(skip, K)                <- 
    K.
ceval(A : B, K)                <- 
    ceval(A, ceval(B, K)).      
ceval(assign(X, E), K) <-        
    eval(E, V, variable(X, _) x (variable(X, V) -> K)).
ceval(if(C, B1, _), K) <- 
    eval(C, vb(true), ceval(B1, K)). 
ceval(if(C, _, B2), K) <- 
    eval(C, vb(false), ceval(B2, K)).
ceval(while(C, B), K)  <- 
    eval(C, vb(true), ceval(B, ceval(while(C, B), K))).
ceval(while(C, _), K)  <- 
    eval(C, vb(false), K).
%! ceval(+Prog, +Continuation).

%--- CEVALG ---
cevalG(N, skip, K)                <- 
    bang(positive(N)) x 
    K.
cevalG(N, A : B, K)               <- 
    bang(positive(N)) x 
    cevalG(N, A, cevalG(N, B, K)).      
cevalG(N, assign(X, E), K) <-        
    bang(positive(N)) x 
    eval(E, V, variable(X, _) x (variable(X, V) -> K)).
cevalG(N, if(C, B1, _), K) <- 
    bang(positive(N)) x 
    eval(C, vb(true), cevalG(N, B1, K)). 
cevalG(N, if(C, _, B2), K) <- 
    bang(positive(N)) x 
    eval(C, vb(false), cevalG(N, B2, K)).
cevalG(N, while(C, B), K)  <- 
    bang(positiveDec(N, M)) x 
    eval(C, vb(true), cevalG(N, B, cevalG(M, while(C, B), K))).
cevalG(N, while(C, _), K)  <- 
    bang(positive(N)) x 
    eval(C, vb(false), K).
%! cevalG(+Gas, +Prog, +Continuation).

%--- COLLECT ---
collect([], [])               <-
    true.
collect([X | Vars], [(X, V) | XS]) <- 
    variable(X, V) x
    collect(Vars, XS).
%! collect(+Vars, -State).

%--- INTERP ---
interp(P, Vars, S) <-
    ceval(P, collect(Vars, S)).
%! interp(+Prog, +Vars, -State).

%--- INTERPG ---
interpG(N, P, Vars, S) <-
    cevalG(N, P, collect(Vars, S)).
%! interpG(+Gas, +Prog, +Vars, -State).
