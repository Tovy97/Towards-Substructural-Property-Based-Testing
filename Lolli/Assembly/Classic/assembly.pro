:- ['../../Implementazione/Interprete/Classic/interp.pro'].
:- ['../../Imp/CPS/Classic/classicHelper.pro'].

:- op(120, xfy, :).

asm_collect([], [])               <-
    true.
asm_collect([variable(X, V) | Vars], [(X, V) | XS]) <-     
    asm_collect(Vars, XS).
%! asm_collect(+State, -Variables).

get_nth_command(H : _, 0, H) <-
    true.
get_nth_command(halt_cmd, 0, halt_cmd) <-
    true.
get_nth_command(_ : T, N, C) <-
    dec(N, M) &
    get_nth_command(T, M, C).
%! get_nth_command(+Program, +ProgramCounter, -Command).

asm_evalC(State, STK, const_cmd(b(N)), OldPC, NewPC, K, State, [vb(N)|STK]) <-    
    inc(OldPC, NewPC) &    
    K.
asm_evalC(State, STK, const_cmd(i(N)), OldPC, NewPC, K, State, [vi(N)|STK]) <-    
    inc(OldPC, NewPC) &    
    K.
asm_evalC(State, STK, var_cmd(X), OldPC, NewPC, K, State, [V|STK]) <-    
    inc(OldPC, NewPC) &
    member(variable(X, V), State) &         
    K.
asm_evalC(StateIn, [vi(V)|STK], setvar_cmd(X), OldPC, NewPC, K, StateOut, STK) <-    
    inc(OldPC, NewPC) &
    replace(variable(X, vi(_)), StateIn, variable(X, vi(V)), StateOut) &     
    K.
asm_evalC(StateIn, [vb(V)|STK], setvar_cmd(X), OldPC, NewPC, K, StateOut, STK) <-    
    inc(OldPC, NewPC) &
    replace(variable(X, vb(_)), StateIn, variable(X, vb(V)), StateOut) &
    K.
asm_evalC(State, [vi(B), vi(A) | STK], add_cmd, OldPC, NewPC, K, State, [vi(S) | STK]) <-
    inc(OldPC, NewPC) &    
    addInt(A, B, S) &
    K.
asm_evalC(State, [vi(B), vi(A) | STK], sub_cmd, OldPC, NewPC, K, State, [vi(S) | STK]) <-
    inc(OldPC, NewPC) &    
    subInt(A, B, S) &
    K.
asm_evalC(State, [vi(B), vi(A) | STK], mul_cmd, OldPC, NewPC, K, State, [vi(S) | STK]) <-
    inc(OldPC, NewPC) &    
    mulInt(A, B, S) &
    K.
asm_evalC(State, [vb(B), vb(A) | STK], and_cmd, OldPC, NewPC, K, State, [vb(S) | STK]) <-
    inc(OldPC, NewPC) &    
    andBool(A, B, S) &
    K.
asm_evalC(State, [vb(B), vb(A) | STK], or_cmd, OldPC, NewPC, K, State, [vb(S) | STK]) <-
    inc(OldPC, NewPC) &    
    orBool(A, B, S) &
    K.
asm_evalC(State, [vb(A) | STK], not_cmd, OldPC, NewPC, K, State, [vb(S) | STK]) <-
    inc(OldPC, NewPC) &   
    notBool(A, S) &
    K.
asm_evalC(State, [vb(B), vb(A) | STK], eq_cmd, OldPC, NewPC, K, State, [vb(S) | STK]) <-
    inc(OldPC, NewPC) &    
    eqBool(A, B, S) &
    K.
asm_evalC(State, [vi(B), vi(A) | STK], eq_cmd, OldPC, NewPC, K, State, [vb(S) | STK]) <-
    inc(OldPC, NewPC) &    
    eqBool(A, B, S) &
    K.
asm_evalC(State, STK, branch_cmd(Hop), OldPC, NewPC, K, State, STK) <-
    inc(OldPC, Temp) &
    addInt(Temp, Hop, NewPC) &
    K.
asm_evalC(State, [vb(true) | STK], bfl_cmd(_), OldPC, NewPC, K, State, STK) <-    
    inc(OldPC, NewPC) &    
    K.
asm_evalC(State, [vb(false) | STK], bfl_cmd(Hop), OldPC, NewPC, K, State, STK) <-    
    inc(OldPC, Temp) &
    addInt(Temp, Hop, NewPC) &
    K.
%! asm_evalC(+StateIn, +StackIn, +Command, +OldProgramCounter, -NewProgramCounter, +Continuation, -StateOut, -StackOut).

asm_evalP(State, _, P, PC, K, State) <-    
    get_nth_command(P, PC, halt_cmd) &
    K.
asm_evalP(StateIn, StackIn, P, PC, K, StateOut) <-    
    get_nth_command(P, PC, C) &
    asm_evalC(StateIn, StackIn, C, PC, NewPC, asm_evalP(StateOutEvalC, StackOutEvalC, P, NewPC, K, StateOut), StateOutEvalC, StackOutEvalC).
%! asm_evalP(+StateIn, +StackIn, +Program, +ProgramCounter, +Continuation, -StateOut).

asm_evalPG(N, State, _, P, PC, K, State) <-    
    positive(N) &
    get_nth_command(P, PC, halt_cmd) &
    K.
asm_evalPG(N, StateIn, StackIn, P, PC, K, StateOut) <-    
    positiveDec(N, M) &
    get_nth_command(P, PC, C) &
    asm_evalC(StateIn, StackIn, C, PC, NewPC, asm_evalPG(M, StateOutEvalC, StackOutEvalC, P, NewPC, K, StateOut), StateOutEvalC, StackOutEvalC).
%! asm_evalP(+Gas, +StateIn, +StackIn, +Program, +ProgramCounter, +Continuation, -StateOut).

asm_interp(StateIn, Prog, StateOut) <-
    asm_evalP(StateIn, [], Prog, 0, asm_collect(StateOutEvalP, StateOut), StateOutEvalP).
%! asm_interp(+StateIn, +Prog, -StateOut).

asm_interpG(N, StateIn, Prog, StateOut) <-
    asm_evalPG(N, StateIn, [], Prog, 0, asm_collect(StateOutEvalP, StateOut), StateOutEvalP).
%! asm_interpG(+Gas, +StateIn, +Prog, -StateOut).

% P = var_cmd(x):const_cmd(i(1)):add_cmd:setvar_cmd(x):halt_cmd, prove(asm_interp([variable(x, vi(0))], P, S)).