:- ['../gen.pro'].
:- ['../helper.pro'].

%BIG STEP
queryC(0, _, Dim, NumOfTests, Cert, State, _, Type, E, expr) :- 
    write("Determinismo eval --> forall e:t, eval(e, v1) -> eval(e, v2) -> v1 = v2"), nl,
    genNRandExp(Cert, NumOfTests, Dim, _, E, Type),   
    updateGeneratedTest(),     
    prove(eval(State, E, V1, true)), 
    prove(eval(State, E, V2, true)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("e: "), write(E), nl, 
    write("v1: "), write(V1), nl, 
    write("v2: "), write(V2), nl, nl.

queryC(1, Gas, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Determinismo ceval --> forall p, ceval(p, v1) -> ceval(p, v2) -> v1 = v2"), nl,
    genNRandProg(Cert, NumOfTests, Dim, P, Type),   
    updateGeneratedTest(),    
    prove(interpG(Gas, State, P, V1)), 
    prove(interpG(Gas, State, P, V2)),
    sort(V1, S1),
    sort(V2, S2),
    updateSuccessfulTest(),    
    S1 \== S2,
    nl,
    write("P: "), write(P), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.

queryC(2, Gas, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Consistenza stato ceval --> forall p, ceval(p, st) -> styping(st)"), nl,    
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(), 
    prove(styping(State, Type)),
    prove(interpG(Gas, State, P, V)),    
    convert_list(V, State2),
    updateSuccessfulTest(),    
    prove(not(styping(State2, Type))),
    nl,
    write("State: "), write(State), nl,
    write("V: "), write(V), nl,
    write("Type: "), write(Type), nl,
    write("State2: "), write(State2), nl, nl.
    
queryC(3, _, Dim, NumOfTests, Cert, _, _, Type, E, expr) :- 
    write("Check has_type"), nl,  
    genNRandExp(Cert, NumOfTests, Dim, T, E, Type),   
    updateGeneratedTest(),  
    updateSuccessfulTest(), 
    prove(not(has_type(E, T, Type))),
    nl,    
    write("E: "), write(E), nl, 
    write("T: "), write(T), nl, nl.

queryC(4, _, Dim, NumOfTests, Cert, State, _, Type, E, expr) :- 
    write("Preservazione eval --> forall e, has_type(E, T) -> eval(E, V) -> styping() -> typef(V, T)"), nl,
    genNRandExp(Cert, NumOfTests, Dim, T, E, Type), 
    updateGeneratedTest(),    
    prove(has_type(E, T, Type)),
    prove(eval(State, E, V, true)),    
    prove(styping(State, Type)),
    updateSuccessfulTest(), 
    prove(not(typef(V, T))),
    nl,
    write("E: "), write(E), nl,
    write("T: "), write(T), nl,
    write("V: "), write(V), nl, nl.   

queryC(5, _, _, _, _, _, _, _, V, other) :- 
    write("Check typef"), nl,
    genValue(T, V),
    updateGeneratedTest(), 
    updateSuccessfulTest(), 
    prove(not(typef(V, T))),
    nl,
    write("V: "), write(V), nl, 
    write("T: "), write(T), nl, nl. 

queryC(6, _, Dim, NumOfTests, Cert, State, _, Type, E, expr) :- 
    write("Totalità eval --> forall e, has_type(E, T) -> styping() -> ex_eval(E)"), nl,
    genNRandExp(Cert, NumOfTests, Dim, T, E, Type),   
    updateGeneratedTest(),    
    prove(has_type(E, T, Type)),
    prove(styping(State, Type)),
    updateSuccessfulTest(), 
    prove(not(ex_eval(State, E, true))),
    nl,
    write("E: "), write(E), nl,
    write("T: "), write(T), nl, nl.

% SMALL STEP
queryC(7, Gas, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Determinismo star --> forall p, star(p, skip, v1) -> star(p, skip, v2) -> v1 = v2"), nl,
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(),    
    prove(interpSSG(Gas, State, P, V1)), 
    prove(interpSSG(Gas, State, P, V2)),
    sort(V1, S1),
    sort(V2, S2),
    updateSuccessfulTest(),    
    S1 \== S2,
    nl,
    write("P: "), write(P), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.

queryC(8, Gas, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Consistenza stato star --> forall p, star(p, skip, st) -> styping(st)"), nl,   
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(), 
    prove(interpSSG(Gas, State, P, V)),    
    convert_list(V, State2),
    updateSuccessfulTest(),    
    prove(not(styping(State2, Type))),
    nl,
    write("State: "), write(State), nl,
    write("V: "), write(V), nl,
    write("Type: "), write(Type), nl,
    write("State2: "), write(State2), nl, nl.

queryC(9, _, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Preservazione star 1 (cpres)  --> forall p, step(p, p') -> com_type(p) -> com_type(p')"), nl,    
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(),     
    prove(com_type(P, Type)),
    prove(step(State, P, P1, true, _)),
    updateSuccessfulTest(),
    prove(not(com_type(P1, Type))),
    nl,
    write("P1: "), write(P1), nl,
    write("Type: "), write(Type), nl,
    write("State: "), write(State), nl, nl.

queryC(10, _, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Preservazione star 2 (spres)  --> forall p st, step(p, p', st') -> com_type(p) -> styping(st) -> styping(st')"), nl,    
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(),     
    prove(styping(State, Type)),
    prove(com_type(P, Type)),
    prove(step(State, P, _, true, State1)),    
    updateSuccessfulTest(),
    prove(not(styping(State1, Type))),
    nl,    
    write("Type: "), write(Type), nl,
    write("State: "), write(State), nl,
    write("State1: "), write(State1), nl, nl. 

queryC(11, _, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("Progresso star (cprogess)  --> forall p st, com_type(p) -> styping(st) -> p = skip \\/ exists p' s', step(p, p' ,s')"), nl,    
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(),     
    prove(com_type(P, Type)),
    prove(styping(State, Type)),
    updateSuccessfulTest(),
    prove(not(ex_step_or_skip(State, P, true))),    
    nl,    
    write("Type: "), write(Type), nl,
    write("State: "), write(State), nl, nl.      

% BIG STEP & SMALL STEP
queryC(12, Gas, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("ceval(p, s1) -> star(p, s2) -> s1 = s2"), nl,    
    GasSS is Gas * 10,
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(),     
    prove(interpG(Gas, State, P, V1)),    
    prove(interpSSG(GasSS, State, P, V2)),    
    updateSuccessfulTest(),
    V1 \== V2,
    nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl,    
    write("State: "), write(State), nl, nl.

queryC(13, Gas, Dim, NumOfTests, Cert, State, _, Type, P, prog) :- 
    write("step(p1, p1) -> ceval(p2, s1) -> ceval(p1, s2) -> s1 = s2"), nl,    
    Gas1 is Gas - 1,
    genNRandProg(Cert, NumOfTests, Dim, P, Type), 
    updateGeneratedTest(),     
    prove(step(State, P, P2, collect(StateOut, ST), StateOut)),
    convert_list(ST, State1),
    prove(interpG(Gas1, State1, P2, V1)),   
    prove(interpG(Gas, State, P, V2)),       
    updateSuccessfulTest(),
    V1 \== V2,
    nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl,    
    write("ST: "), write(ST), nl,    
    write("State1: "), write(State1), nl,
    write("P2: "), write(P2), nl,    
    write("State: "), write(State), nl, nl.
%! queryC(+Number, +Gas, +Dimension, +Dimension2, +Certificate, +Delta, +VarList, +VarType, -CounterExample, -TypeOfQuery)
