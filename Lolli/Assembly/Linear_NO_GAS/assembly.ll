:- ['../../Implementazione/Interprete/2ndOrder-Cert/llinterp.pro'].

:- op(120, xfy, :).

asm_collect([], [])               <-
    true.
asm_collect([X | Vars], [(X, V) | XS]) <- 
    variable(X, V) x
    asm_collect(Vars, XS).
%! asm_collect(+Vars, -State).

get_nth_command(H : _, 0, H) <-
    true.
get_nth_command(halt_cmd, 0, halt_cmd) <-
    true.
get_nth_command(_ : T, N, C) <-
    bang(dec(N, M)) x
    bang(get_nth_command(T, M, C)).
%! get_nth_command(+Program, +ProgramCounter, -Command).

/*
    VERSIONE CON STACK e VARIABILI NEL CONTESTO BOUND (DELTA) SENZA STACK_POINTER.    
*/

asm_evalC(const_cmd(b(N)), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    stack(STK) x
    (stack([vb(N)|STK]) -> K).
asm_evalC(const_cmd(i(N)), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    stack(STK) x
    (stack([vi(N)|STK]) -> K).
asm_evalC(var_cmd(X), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, V) x
    stack(STK) x
    (variable(X, V) -> stack([V|STK]) -> K).
asm_evalC(setvar_cmd(X), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, vi(_)) x
    stack([vi(V)|STK]) x
    (variable(X, vi(V)) -> stack(STK) -> K).
asm_evalC(setvar_cmd(X), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, vb(_)) x
    stack([vb(V)|STK]) x
    (variable(X, vb(V)) -> stack(STK) -> K).
asm_evalC(add_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(B), vi(A) | STK]) x
    bang(addInt(A, B, S)) x    
    (stack([vi(S) | STK]) -> K).
asm_evalC(sub_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(B), vi(A) | STK]) x
    bang(subInt(A, B, S)) x
    (stack([vi(S) | STK]) -> K).
asm_evalC(mul_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(B), vi(A) | STK]) x
    bang(mulInt(A, B, S)) x
    (stack([vi(S) | STK]) -> K).
asm_evalC(and_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(B), vb(A) | STK]) x
    bang(andBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
asm_evalC(or_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(B), vb(A) | STK]) x
    bang(orBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
asm_evalC(not_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(A) | STK]) x
    bang(notBool(A, S)) x
    (stack([vb(S) | STK]) -> K).
asm_evalC(eq_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(B), vb(A) | STK]) x
    bang(eqBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
asm_evalC(eq_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(B), vi(A) | STK]) x
    bang(eqBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
asm_evalC(branch_cmd(Hop), OldPC, NewPC, K) <-
    bang(inc(OldPC, Temp)) x
    bang(addInt(Temp, Hop, NewPC)) x
    K.
asm_evalC(bfl_cmd(_), OldPC, NewPC, K) <-
    stack([vb(true) | STK]) x    
    bang(inc(OldPC, NewPC)) x    
    (stack(STK) -> K).
asm_evalC(bfl_cmd(Hop), OldPC, NewPC, K) <-
    stack([vb(false) | STK]) x
    bang(inc(OldPC, Temp)) x    
    bang(addInt(Temp, Hop, NewPC)) x
    (stack(STK) -> K).
%! asm_evalC(+Command, +OldProgramCounter, -NewProgramCounter, +Continuation).

asm_evalP(P, PC, K) <-    
    bang(get_nth_command(P, PC, halt_cmd)) x
    K.
asm_evalP(P, PC, K) <-    
    bang(get_nth_command(P, PC, C)) x
    asm_evalC(C, PC, NewPC, asm_evalP(P, NewPC, K)).
%! asm_evalP(+Program, +ProgramCounter, +Continuation).

asm_interp(P, Vars, S) <-
    stack([]) -> asm_evalP(P, 0, stack(_) x asm_collect(Vars, S)).
%! asm_interp(+Prog, +Vars, -State).

% P = var_cmd(x):const_cmd(i(1)):add_cmd:setvar_cmd(x):halt_cmd, seq([], [variable(x, vi(0))], asm_interp(P, [x], S)).
