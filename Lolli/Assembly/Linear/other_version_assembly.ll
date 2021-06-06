:- ['../../Implementazione/Interprete/2ndOrder/llinterp.pro'].

:- op(120, xfy, :).

/*
    Assembly evaluation (aeval)
*/

acollect([], [])               <-
    true.
acollect([X | Vars], [(X, V) | XS]) <- 
    variable(X, V) x
    acollect(Vars, XS).
%! acollect(+Vars, -State).

get_nth_command(H : _, 0, H) <-
    true.
get_nth_command(halt_cmd, 0, halt_cmd) <-
    true.
get_nth_command(_ : T, N, C) <-
    bang(dec(N, M)) x
    bang(get_nth_command(T, M, C)).
% get_nth_command(+Program, +ProgramCounter, -Command).

%---

/*
    VERSIONE CON SOLO LE VARIABILI NEL CONTESTO BOUND (DELTA).
*/

aevalC_all(const_cmd(b(N)), OldPC, NewPC, STK, [vb(N)|STK], K) <-
    bang(inc(OldPC, NewPC)) x
    K.
aevalC_all(const_cmd(i(N)), OldPC, NewPC, STK, [vi(N)|STK], K) <-
    bang(inc(OldPC, NewPC)) x
    K.
aevalC_all(var_cmd(X), OldPC, NewPC, STK, [V|STK], K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, V) x
    (variable(X, V) -> K).
aevalC_all(setvar_cmd(X), OldPC, NewPC, [V|STK], STK, K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, _) x
    (variable(X, V) -> K).
aevalC_all(add_cmd, OldPC, NewPC, [vi(A), vi(B) | STK], [vi(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(addInt(A, B, S)) x
    K.
aevalC_all(sub_cmd, OldPC, NewPC, [vi(A), vi(B) | STK], [vi(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(subInt(A, B, S)) x
    K.
aevalC_all(mul_cmd, OldPC, NewPC, [vi(A), vi(B) | STK], [vi(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(mulInt(A, B, S)) x
    K.
aevalC_all(and_cmd, OldPC, NewPC, [vb(A), vb(B) | STK], [vb(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(andBool(A, B, S)) x
    K.
aevalC_all(or_cmd, OldPC, NewPC, [vb(A), vb(B) | STK], [vb(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(orBool(A, B, S)) x
    K.
aevalC_all(not_cmd, OldPC, NewPC, [vb(A) | STK], [vb(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(notBool(A, S)) x
    K.
aevalC_all(eq_cmd, OldPC, NewPC, [vb(A), vb(B) | STK], [vb(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(eqBool(A, B, S)) x
    K.
aevalC_all(eq_cmd, OldPC, NewPC, [vi(A), vi(B) | STK], [vb(S) | STK], K) <-
    bang(inc(OldPC, NewPC)) x
    bang(eqBool(A, B, S)) x
    K.
aevalC_all(branch_cmd(Hop), OldPC, NewPC, STK, STK, K) <-
    bang(inc(OldPC, Temp)) x
    bang(addInt(Temp, Hop, NewPC)) x
    K.
aevalC_all(bfl_cmd(_), OldPC, NewPC, [vb(true) | STK], STK, K) <-    
    bang(inc(OldPC, NewPC)) x    
    K.
aevalC_all(bfl_cmd(Hop), OldPC, NewPC, [vb(true) | STK], STK, K) <-    
    bang(inc(OldPC, Temp)) x    
    bang(addInt(Temp, Hop, NewPC)) x
    K.
% aevalC_all(+Command, +OldProgramCounter, -NewProgramCounter, +OldStack, -NewStack, +Continuation).

aevalP_all(P, PC, _, K) <-    
    bang(get_nth_command(P, PC, halt_cmd)) x    
    K.
aevalP_all(P, PC, STK, K) <-    
    bang(get_nth_command(P, PC, C)) x    
    aevalC_all(C, PC, NewPC, STK, NewSTK, aevalP_all(P, NewPC, NewSTK, K)).
%aevalP_all(+Program, +ProgramCounter, +Stack, +Continuation).

ainterp_all(P, Vars, S) <-
    aevalP_all(P, 0, [], acollect(Vars, S)).
%! ainterp_all(+Prog, +Vars, -State).


% P = var_cmd(x):const_cmd(i(1)):add_cmd:setvar_cmd(x):halt_cmd, seq([], [variable(x, vi(0))], ainterp_all(P, [x], S)).



/*
    VERSIONE CON STACK e VARIABILI NEL CONTESTO BOUND (DELTA) SENZA STACK_POINTER.
    ---SECONDO ME è LA MIGLIORE---
*/

aevalC_stk_lst(const_cmd(b(N)), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    stack(STK) x
    (stack([vb(N)|STK]) -> K).
aevalC_stk_lst(const_cmd(i(N)), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    stack(STK) x
    (stack([vi(N)|STK]) -> K).
aevalC_stk_lst(var_cmd(X), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, V) x
    stack(STK) x
    (variable(X, V) -> stack([V|STK]) -> K).
aevalC_stk_lst(setvar_cmd(X), OldPC, NewPC, K) <-    
    bang(inc(OldPC, NewPC)) x
    variable(X, _) x
    stack([V|STK]) x
    (variable(X, V) -> stack(STK) -> K).
aevalC_stk_lst(add_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(A), vi(B) | STK]) x
    bang(addInt(A, B, S)) x    
    (stack([vi(S) | STK]) -> K).
aevalC_stk_lst(sub_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(A), vi(B) | STK]) x
    bang(subInt(A, B, S)) x
    (stack([vi(S) | STK]) -> K).
aevalC_stk_lst(mul_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(A), vi(B) | STK]) x
    bang(mulInt(A, B, S)) x
    (stack([vi(S) | STK]) -> K).
aevalC_stk_lst(and_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(A), vb(B) | STK]) x
    bang(andBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
aevalC_stk_lst(or_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(A), vb(B) | STK]) x
    bang(orBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
aevalC_stk_lst(not_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(A) | STK]) x
    bang(notBool(A, S)) x
    (stack([vb(S) | STK]) -> K).
aevalC_stk_lst(eq_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vb(A), vb(B) | STK]) x
    bang(eqBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
aevalC_stk_lst(eq_cmd, OldPC, NewPC, K) <-
    bang(inc(OldPC, NewPC)) x
    stack([vi(A), vi(B) | STK]) x
    bang(eqBool(A, B, S)) x
    (stack([vb(S) | STK]) -> K).
aevalC_stk_lst(branch_cmd(Hop), OldPC, NewPC, K) <-
    bang(inc(OldPC, Temp)) x
    bang(addInt(Temp, Hop, NewPC)) x
    K.
aevalC_stk_lst(bfl_cmd(_), OldPC, NewPC, K) <-
    stack([vb(true) | STK]) x    
    bang(inc(OldPC, NewPC)) x    
    (stack(STK) -> K).
aevalC_stk_lst(bfl_cmd(Hop), OldPC, NewPC, K) <-
    stack([vb(false) | STK]) x
    bang(inc(OldPC, Temp)) x    
    bang(addInt(Temp, Hop, NewPC)) x
    (stack(STK) -> K).
% aevalC_stk_lst(+Command, +OldProgramCounter, -NewProgramCounter, +Continuation).

aevalP_stk_lst(P, PC, K) <-    
    bang(get_nth_command(P, PC, halt_cmd)) x
    K.
aevalP_stk_lst(P, PC, K) <-    
    bang(get_nth_command(P, PC, C)) x
    aevalC_stk_lst(C, PC, NewPC, aevalP_stk_lst(P, NewPC, K)).
%aevalP_stk_lst(+Program, +ProgramCounter, +Continuation).

ainterp_stk_lst(P, Vars, S) <-
    stack([]) -> aevalP_stk_lst(P, 0, stack(_) x acollect(Vars, S)).
%! ainterp_stk_lst(+Prog, +Vars, -State).


% P = var_cmd(x):const_cmd(i(1)):add_cmd:setvar_cmd(x):halt_cmd, seq([], [variable(x, vi(0))], ainterp_stk_lst(P, [x], S)).



/*
    VERSIONE CON STACK e VARIABILI NEL CONTESTO BOUND (DELTA) CON STACK_POINTER.
*/

operand_for_binary_operation_stk(SP, A, B, NewSP) <-    
    bang(dec(SP, NewSP)) x
    stack(SP, A) x
    stack(NewSP, B).

aevalC_stk(const_cmd(b(N)), OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    bang(inc(OldSP, NewSP)) x
    (stack(NewSP, vb(N)) -> K).
aevalC_stk(const_cmd(i(N)), OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    bang(inc(OldSP, NewSP)) x
    (stack(NewSP, vi(N)) -> K).
aevalC_stk(var_cmd(X), OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    bang(inc(OldSP, NewSP)) x
    variable(X, V) x
    (variable(X, V) -> stack(NewSP, V) -> K).
aevalC_stk(setvar_cmd(X), OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    bang(dec(OldSP, NewSP)) x
    variable(X, _) x
    stack(OldSP, V) x
    (variable(X, V) -> K).
aevalC_stk(add_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vi(A), vi(B), NewSP) x
    bang(addInt(A, B, S)) x    
    (stack(NewSP, vi(S)) -> K).
aevalC_stk(sub_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vi(A), vi(B), NewSP) x
    bang(subInt(A, B, S)) x    
    (stack(NewSP, vi(S)) -> K).
aevalC_stk(mul_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vi(A), vi(B), NewSP) x
    bang(mulInt(A, B, S)) x    
    (stack(NewSP, vi(S)) -> K).
aevalC_stk(and_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vb(A), vb(B), NewSP) x
    bang(andBool(A, B, S)) x    
    (stack(NewSP, vb(S)) -> K).
aevalC_stk(or_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vb(A), vb(B), NewSP) x
    bang(orBool(A, B, S)) x    
    (stack(NewSP, vb(S)) -> K).
aevalC_stk(not_cmd, OldPC, NewPC, OldSP, OldSP, K) <-
    bang(inc(OldPC, NewPC)) x
    stack(OldSP, vb(A)) x
    bang(notBool(A, S)) x
    (stack(OldSP, vb(S)) -> K).
aevalC_stk(eq_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vb(A), vb(B), NewSP) x
    bang(eqBool(A, B, S)) x    
    (stack(NewSP, vb(S)) -> K).
aevalC_stk(eq_cmd, OldPC, NewPC, OldSP, NewSP, K) <-
    bang(inc(OldPC, NewPC)) x
    operand_for_binary_operation_stk(OldSP, vi(A), vi(B), NewSP) x
    bang(eqBool(A, B, S)) x    
    (stack(NewSP, vb(S)) -> K).
aevalC_stk(branch_cmd(Hop), OldPC, NewPC, SP, SP, K) <-
    bang(inc(OldPC, Temp)) x
    bang(addInt(Temp, Hop, NewPC)) x
    K.
aevalC_stk(bfl_cmd(_), OldPC, NewPC, OldSP, NewSP, K) <-
    bang(dec(OldSP, NewSP)) x
    stack(OldSP, vb(true)) x
    bang(inc(OldPC, NewPC)) x        
    K.
aevalC_stk(bfl_cmd(Hop), OldPC, NewPC, OldSP, NewSP, K) <-
    bang(dec(OldSP, NewSP)) x
    stack(OldSP, vb(false)) x
    bang(inc(OldPC, Temp)) x    
    bang(addInt(Temp, Hop, NewPC)) x    
    K.
% aevalC_stk(+Command, +OldProgramCounter, -NewProgramCounter, +OldStackPointer, -newStackPointer, +Continuation).

aevalP_stk(P, PC, _, K) <-    
    bang(get_nth_command(P, PC, halt_cmd)) x
    K.
aevalP_stk(P, PC, SP, K) <-    
    bang(get_nth_command(P, PC, C)) x
    aevalC_stk(C, PC, NewPC, SP, NewSP, aevalP_stk(P, NewPC, NewSP, K)).
%aevalP_stk(+Program, +ProgramCounter, +StackPointer, +Continuation).

ainterp_stk(P, Vars, S) <-
    aevalP_stk(P, 0, -1, acollect(Vars, S)).  %RICHIEDE CHE LO STACK SIA STATO TUTTO CONSUMATO
%! ainterp_stk(+Prog, +Vars, -State).

% P = var_cmd(x):const_cmd(i(1)):add_cmd:setvar_cmd(x):halt_cmd, seq([], [variable(x, vi(0))], ainterp_stk(P, [x], S)).



/*
    VERSIONE CON TUTTO LO STATO (STACK, VARIABILI, SP, PC) NEL CONTESTO BOUND (DELTA).
*/

operand_for_binary_operation(A, B, SP_B_S) <-
    stack_pointer(SP_A) x
    bang(dec(SP_A, SP_B_S)) x
    stack(SP_A, A) x
    stack(SP_B_S, B).

inc_PC(NewPC) <-
    program_counter(OldPC) x    
    bang(inc(OldPC,NewPC)).

aevalC(const_cmd(b(N)), K) <-
    inc_PC(PC) x
    stack_pointer(OldSP) x
    bang(inc(OldSP, NewSP)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vb(N)) -> K).
aevalC(const_cmd(i(N)), K) <-
    inc_PC(PC) x
    stack_pointer(OldSP) x
    bang(inc(OldSP, NewSP)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vi(N)) -> K).
aevalC(var_cmd(X), K) <-
    inc_PC(PC) x
    stack_pointer(OldSP) x
    bang(inc(OldSP, NewSP)) x
    variable(X, V) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, V) -> variable(X, V) -> K).
aevalC(setvar_cmd(X), K) <-
    inc_PC(PC) x
    stack_pointer(OldSP) x
    bang(dec(OldSP, NewSP)) x
    stack(OldSP, V) x
    variable(X, _) x
    (program_counter(PC) -> stack_pointer(NewSP) -> variable(X, V) -> K).
aevalC(add_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vi(A), vi(B), NewSP) x    
    bang(addInt(A, B, S)) x    
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vi(S)) -> K).
aevalC(sub_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vi(A), vi(B), NewSP) x
    bang(subInt(A, B, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vi(S)) -> K).
aevalC(mul_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vi(A), vi(B), NewSP) x
    bang(mulInt(A, B, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vi(S)) -> K).
aevalC(and_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vb(A), vb(B), NewSP) x
    bang(andBool(A, B, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vb(S)) -> K).
aevalC(or_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vb(A), vb(B), NewSP) x
    bang(orBool(A, B, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vb(S)) -> K).
aevalC(not_cmd, K) <-
    inc_PC(PC) x
    stack_pointer(NewSP) x    
    stack(NewSP, vb(A)) x    
    bang(notBool(A, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vb(S)) -> K).
aevalC(eq_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vb(A), vb(B), NewSP) x
    bang(eqBool(A, B, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vb(S)) -> K).
aevalC(eq_cmd, K) <-
    inc_PC(PC) x
    operand_for_binary_operation(vi(A), vi(B), NewSP) x
    bang(eqBool(A, B, S)) x
    (program_counter(PC) -> stack_pointer(NewSP) -> stack(NewSP, vb(S)) -> K).
aevalC(branch_cmd(Hop), K) <-
    inc_PC(Temp) x
    bang(addInt(Temp, Hop, PC)) x
    (program_counter(PC) -> K).
aevalC(bfl_cmd(_), K) <-
    stack_pointer(OldSP) x
    bang(dec(OldSP, NewSP)) x
    stack(OldSP, vb(true)) x
    inc_PC(PC) x    
    (program_counter(PC) -> stack_pointer(NewSP) -> K).
aevalC(bfl_cmd(Hop), K) <-
    stack_pointer(OldSP) x
    bang(dec(OldSP, NewSP)) x
    stack(OldSP, vb(false)) x
    inc_PC(Temp) x
    bang(addInt(Temp, Hop, PC)) x    
    (program_counter(PC) -> stack_pointer(NewSP) -> K).
%aevalC(+Command, +Continuation).

aevalP(P, K) <-
    program_counter(PC) x   
    bang(get_nth_command(P, PC, halt_cmd)) x
    K.
aevalP(P, K) <-
    program_counter(PC) x   
    bang(get_nth_command(P, PC, C)) x    
    (program_counter(PC) -> aevalC(C, aevalP(P, K))).
%aevalP(+Program, +Continuation).

ainterp(P, Vars, S) <-
    program_counter(0) -> 
    stack_pointer(-1) -> 
    aevalP(P, stack_pointer(_) x acollect(Vars, S)). %RICHIEDE CHE LO STACK SIA STATO TUTTO CONSUMATO
%! ainterp(+Prog, +Vars, -State).

% P = var_cmd(x):const_cmd(i(1)):add_cmd:setvar_cmd(x):halt_cmd, seq([], [variable(x, vi(0))], ainterp(P, [x], S)).