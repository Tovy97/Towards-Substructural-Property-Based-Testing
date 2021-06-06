:- multifile writeProg/2.

:- op(120, xfy, :).

%--- WRITE_EXP ---
writeExp(b(true)) :-  
    !,
    write("(true)").
writeExp(b(false)) :-  
    !,
    write("(false)").
writeExp(i(N)) :- 
    integer(N), 
    !,
    write("("),
    write(N),
    write(")").    
writeExp(eqV(E1, E2)) :-  
    !,
    write("("),
    writeExp(E1),
    write(" = "),
    writeExp(E2),
    write(")").
writeExp(andV(E1, E2)) :-  
    !,
    write("("),
    writeExp(E1),
    write(" && "),
    writeExp(E2),
    write(")").
writeExp(plusV(E1, E2)) :-  
    !,
    write("("),
    writeExp(E1),
    write(" + "),
    writeExp(E2),
    write(")").  
writeExp(minusV(E1, E2)) :-  
    !,
    write("("),
    writeExp(E1),
    write(" - "),
    writeExp(E2),
    write(")").
writeExp(timesV(E1, E2)) :-  
    !,
    write("("),
    writeExp(E1),
    write(" * "),
    writeExp(E2),
    write(")").            
writeExp(orV(E1, E2)) :-  
    !,
    write("("),
    writeExp(E1),
    write(" || "),
    writeExp(E2),
    write(")").    
writeExp(notV(E)) :- 
    !,
    write("!("),
    writeExp(E),
    write(")").        
writeExp(X) :- 
    !,
    write("("),
    write(X),
    write(")").
%! writeExp(+Expression).

%---

% WRITE_PROG
writeProg(skip, _) :- !.    
writeProg(C1 : C2, Tab) :-
    writeProg(C1, Tab),
    writeProg(C2, Tab).
writeProg(assign(X, E), Tab) :-
    !, 
    write(Tab),
    write(X), write(" := "), writeExp(E), write(";\n").
writeProg(if(C, B1, B2), Tab) :- 
    !,
    string_concat(Tab, "\t", Tab1),
    write(Tab),
    write("if "), writeExp(C), write(" then {\n"), 
    writeProg(B1, Tab1),
    write(Tab),
    write("} else {\n"),
    writeProg(B2, Tab1),
    write(Tab),
    write("}\n").
writeProg(while(C, B), Tab) :- 
    !,
    string_concat(Tab, "\t", Tab1),
    write(Tab),
    write("while "), writeExp(C), write(" do {\n"), 
    writeProg(B, Tab1),
    write(Tab),
    write("}\n").
%! writeProg(+Prog, +Tabs).
