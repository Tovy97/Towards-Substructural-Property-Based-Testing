:- op(120, xfy, :).


evalComp(_, b(B), [const_cmd(b(B))]) :- 
    !.
evalComp(_, i(I), [const_cmd(i(I))]) :-
    !.
evalComp(Vars, X, [var_cmd(X)]) :-
    member(X, Vars),
    !.
evalComp(Vars, plusV(E1, E2), Ris) :-
    !,
    evalComp(Vars, E1, A1),    
    evalComp(Vars, E2, A2),
    append(A1, A2, Temp),
    append(Temp, [add_cmd], Ris).
evalComp(Vars, minusV(E1, E2), Ris) :-
    !,
    evalComp(Vars, E1, A1),    
    evalComp(Vars, E2, A2),
    append(A1, A2, Temp),
    append(Temp, [sub_cmd], Ris).
evalComp(Vars, timesV(E1, E2), Ris) :-
    !,
    evalComp(Vars, E1, A1),    
    evalComp(Vars, E2, A2),
    append(A1, A2, Temp),
    append(Temp, [mul_cmd], Ris).
evalComp(Vars, andV(E1, E2), Ris) :-
    !,
    evalComp(Vars, E1, A1),    
    evalComp(Vars, E2, A2),
    append(A1, A2, Temp),
    append(Temp, [and_cmd], Ris).
evalComp(Vars, orV(E1, E2), Ris) :-
    !,
    evalComp(Vars, E1, A1),    
    evalComp(Vars, E2, A2),
    append(A1, A2, Temp),
    append(Temp, [or_cmd], Ris).
evalComp(Vars, notV(E1), Ris) :-
    !,
    evalComp(Vars, E1, Temp),
    append(Temp, [not_cmd], Ris).
evalComp(Vars, eqV(E1, E2), Ris) :-
    !,
    evalComp(Vars, E1, A1),
    evalComp(Vars, E2, A2),
    append(A1, A2, Temp),
    append(Temp, [eq_cmd], Ris).
%evalComp(+Vars, +Expr, -AssemblyList).

lenAdd(List, V, H) :-
    length(List, Temp),
    H is Temp + V.
% lenAdd(+AssemblyList, +Inc, -LenWithInc).

cevalComp(_, skip, []) :-           
    !.
cevalComp(Vars, assign(X, E), Ris) :-
    member(X, Vars),
    !,
    evalComp(Vars, E, Temp),
    append(Temp, [setvar_cmd(X)], Ris).
cevalComp(Vars, C1 : C2, Ris) :-
    !,
    cevalComp(Vars, C1, A1),
    cevalComp(Vars, C2, A2),
    append(A1, A2, Ris).
cevalComp(Vars, if(B, C1, C2), Ris) :-
    !,
    evalComp(Vars, B, A1),
    cevalComp(Vars, C1, A3),
    lenAdd(A3, 1, Hop1),    
    cevalComp(Vars, C2, A4),
    lenAdd(A4, 0, Hop2),
    append(A1, [branch_cmd(Hop1)], Temp1),         % <- branch_cmd al posto di bfl_cmd
    append(Temp1, A3, Temp2),
    append(Temp2, [branch_cmd(Hop2)], Temp3),
    append(Temp3, A4, Ris).
cevalComp(Vars, while(B, C), Ris) :-
    !,
    evalComp(Vars, B, A1),
    cevalComp(Vars, C, A3),
    lenAdd(A3, 1, Hop1),
    lenAdd(A1, 1, HopTemp1),    
    Hop2 is -1 * (HopTemp1 + Hop1),
    append(A1, [bfl_cmd(Hop1)], Temp1),
    append(Temp1, A3, Temp2),
    append(Temp2, [branch_cmd(Hop2)], Ris).
%cevalComp(+Vars, +ImpProgram, -AssemblyList).

list_to_assembly([], halt_cmd).
list_to_assembly([H | T], H : A) :-
	!,
    list_to_assembly(T, A).
%list_to_assembly(+AssemblyList, -AssemblyProgram).

compExp(Vars, E, A) :-    
    evalComp(Vars, E, L),
    list_to_assembly(L, A).
% comp(+Vars, +ImpProgram, -AssemblyProgram).

comp(Vars, P, A) :-    
    cevalComp(Vars, P, L),
    list_to_assembly(L, A).
% comp(+Vars, +ImpProgram, -AssemblyProgram).

% comp([x,y], assign(x, i(0)):assign(y, i(3)):while(notV(eqV(x, y)), assign(x, plusV(x, i(1)))), A), write(A), nl, writeAssembly(0, A), seq([], [variable(x, vi(0)), variable(y, vi(0))], asm_interp(A, [x, y], S)).
% comp([x,y], assign(x, i(0)):assign(y, i(3)):while(notV(eqV(x, y)), if(eqV(x, i(0)), assign(x, plusV(x, i(2))), assign(x, plusV(x, i(1))))), A), write(A), nl, writeAssembly(0, A), seq([], [variable(x, vi(0)), variable(y, vi(0))], asm_interp(A, [x, y], S)).