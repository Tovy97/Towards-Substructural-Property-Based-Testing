:- op(120, xfy, :).

writeCommand(Line, const_cmd(N)) :-
    !,
    write(Line),
    write(": CONST "),
    write(N),
    nl.
writeCommand(Line, var_cmd(X)) :-
    !,
    write(Line),
    write(": LOAD "),
    write(X),
    nl.
writeCommand(Line, setvar_cmd(X)) :-
    !,
    write(Line),
    write(": STORE "),
    write(X),
    nl.
writeCommand(Line, add_cmd) :-
    !,
    write(Line),
    write(": ADD"),    
    nl.
writeCommand(Line, sub_cmd) :-
    !,
    write(Line),
    write(": SUB"),    
    nl.
writeCommand(Line, mul_cmd) :-
    !,
    write(Line),
    write(": MUL"),    
    nl.
writeCommand(Line, and_cmd) :-
    !,
    write(Line),
    write(": AND"),    
    nl.
writeCommand(Line, or_cmd) :-
    !,
    write(Line),
    write(": OR"),    
    nl.
writeCommand(Line, not_cmd) :-
    !,
    write(Line),
    write(": NOT"),    
    nl.
writeCommand(Line, eq_cmd) :-
    !,
    write(Line),
    write(": EQ"),    
    nl.
writeCommand(Line, branch_cmd(Hop)) :-
    !,
    write(Line),
    write(": JUMP "),
    RealHop is Line + Hop + 1,
    write(RealHop),    
    nl.
writeCommand(Line, bfl_cmd(Hop)) :-
    !,
    write(Line),
    write(": BFL "),
    RealHop is Line + Hop + 1,
    write(RealHop),    
    nl.

writeAssembly(Line, halt_cmd) :-
    !,
    write(Line),
    write(": HALT"),      
    nl.
writeAssembly(Line1, A1 : A2) :-    
    writeCommand(Line1, A1),        
    Line2 is Line1 + 1,
    !,
    writeAssembly(Line2, A2).