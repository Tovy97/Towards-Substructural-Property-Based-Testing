:- ['../gen.pro'].
:- ['../helper.pro'].
:- ['../../../Implementazione/Interprete/2ndOrder-Cert/llinterp.pro'].

%BIG STEP
queryL(0, Gas, Dim, Dim2, Cert, Delta, _, Gamma, E, expr) :- 
    CertSeq = qheight(Gas),
    write("Determinismo eval --> forall e:t, eval(e, v1) -> eval(e, v2) -> v1 = v2"), nl,
    genExp(Cert, Dim, Dim2, _, E, Gamma),   
    updateGeneratedTest(),
    seq(CertSeq, [], Delta, eval(E, V1, erase)), 
    seq(CertSeq, [], Delta, eval(E, V2, erase)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("e: "), write(E), nl, 
    write("v1: "), write(V1), nl, 
    write("v2: "), write(V2), nl, nl.

queryL(1, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Determinismo ceval --> forall p, ceval(p, v1) -> ceval(p, v2) -> v1 = v2"), nl,
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),  
    seq(CertSeq, [], Delta, interp(P, Vars, V1)), 
    seq(CertSeq, [], Delta, interp(P, Vars, V2)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.

queryL(2, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Consistenza stato ceval --> forall p, ceval(p, st) -> styping(st)"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, Gamma, Delta, styping(Vars)),
    seq(CertSeq, [], Delta, interp(P, Vars, V)),
    convert_list(V, Delta1),
    updateSuccessfulTest(),
    seq(CertSeq, Gamma, Delta1, not(styping(Vars))),
    nl,
    write("Delta: "), write(Delta), nl,
    write("V: "), write(V), nl,
    write("Gamma: "), write(Gamma), nl,
    write("Delta1: "), write(Delta1), nl, nl.
    
queryL(3, Gas, Dim, Dim2, Cert, _, _, Gamma, E, expr) :- 
    CertSeq = qheight(Gas),
    write("Check has_type"), nl,
    genExp(Cert, Dim, Dim2, T, E, Gamma),     
    updateGeneratedTest(),    
    updateSuccessfulTest(), 
    seq(CertSeq, Gamma, [], not(has_type(E, T))),
    nl,    
    write("E: "), write(E), nl, 
    write("T: "), write(T), nl, nl.
    
queryL(4, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, E, expr) :- 
    CertSeq = qheight(Gas),
    write("Preservazione eval --> forall e, has_type(E, T) -> eval(E, V) -> styping() -> typef(V, T)"), nl,
    genExp(Cert, Dim, Dim2, T, E, Gamma), 
    updateGeneratedTest(),    
    seq(CertSeq, Gamma, [], has_type(E, T)),
    seq(CertSeq, [], Delta, eval(E, V, erase)),    
    seq(CertSeq, Gamma, Delta, styping(Vars)),
    updateSuccessfulTest(), 
    seq(CertSeq, [], [], not(typef(V, T))),
    nl,
    write("E: "), write(E), nl,
    write("T: "), write(T), nl,
    write("V: "), write(V), nl, nl.  

queryL(5, Gas, _, _, _, _, _, _, V, other) :- 
    CertSeq = qheight(Gas),
    write("Check typef"), nl,
    genValue(T, V),
    updateGeneratedTest(), 
    updateSuccessfulTest(), 
    seq(CertSeq, [], [], not(typef(V, T))),
    nl,
    write("V: "), write(V), nl, 
    write("T: "), write(T), nl, nl.  

queryL(6, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, E, expr) :- 
    CertSeq = qheight(Gas),
    write("Totalità eval --> forall e, has_type(E, T) -> styping() -> ex_eval(E)"), nl,
    genExp(Cert, Dim, Dim2, T, E, Gamma), 
    updateGeneratedTest(),    
    seq(CertSeq, Gamma, [], has_type(E, T)),
    seq(CertSeq, Gamma, Delta, styping(Vars)),
    updateSuccessfulTest(), 
    seq(CertSeq, [], Delta, not(ex_eval(E, erase))),
    nl,
    write("E: "), write(E), nl,
    write("T: "), write(T), nl, nl.  

% SMALL STEP
queryL(7, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Determinismo star --> forall p, star(p, skip, v1) -> star(p, skip, v2) -> v1 = v2"), nl,
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),      
    seq(CertSeq, [], Delta, interpSS(P, Vars, V1)), 
    seq(CertSeq, [], Delta, interpSS(P, Vars, V2)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.

queryL(8, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Consistenza stato star --> forall p, star(p, skip, st) -> styping(st)"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, [], Delta, interpSS(P, Vars, V)),
    convert_list(V, Delta1),
    updateSuccessfulTest(),
    seq(CertSeq, Gamma, Delta1, not(styping(Vars))),
    nl,
    write("Delta: "), write(Delta), nl,
    write("V: "), write(V), nl,
    write("Gamma: "), write(Gamma), nl,
    write("Delta1: "), write(Delta1), nl, nl.

queryL(9, Gas, Dim, Dim2, Cert, Delta, _, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Preservazione star 1 (cpres)  --> forall p, step(p, p') -> com_type(p) -> com_type(p')"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, Gamma, [], com_type(P)),
    seq(CertSeq, [], Delta, step(P, P1, erase)),
    updateSuccessfulTest(),
    seq(CertSeq, Gamma, [], not(com_type(P1))),
    nl,
    write("P1: "), write(P1), nl,
    write("Gamma: "), write(Gamma), nl,
    write("Delta: "), write(Delta), nl, nl.

queryL(10, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Preservazione star 2 (spres)  --> forall p st, step(p, p', st') -> com_type(p) -> styping(st) -> styping(st')"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, Gamma, Delta, styping(Vars)),
    seq(CertSeq, Gamma, [], com_type(P)),
    seq(CertSeq, [], Delta, step(P, _, collect(Vars, S))),
    convert_list(S, Delta1),
    updateSuccessfulTest(),
    seq(CertSeq, Gamma, Delta1, not(styping(Vars))),
    nl,    
    write("Gamma: "), write(Gamma), nl,
    write("Delta: "), write(Delta), nl,
    write("Delta1: "), write(Delta1), nl,
    write("S: "), write(S), nl, nl.    

queryL(11, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Progresso star (cprogess)  --> forall p st, com_type(p) -> styping(st) -> p = skip \\/ exists p' s', step(p, p' ,s')"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, Gamma, [], com_type(P)),
    seq(CertSeq, Gamma, Delta, styping(Vars)),
    updateSuccessfulTest(),
    seq(CertSeq, [], Delta, not(ex_step_or_skip(P, erase))),    
    nl,    
    write("Gamma: "), write(Gamma), nl,
    write("Delta: "), write(Delta), nl, nl.      

% BIG STEP & SMALL STEP
queryL(12, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    !,
    write("ceval(p, s1) -> star(p, s2) -> s1 = s2"), nl,        
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, [], Delta, interp(P, Vars, V1)),    
    seq(CertSeq, [], Delta, interpSS(P, Vars, V2)),    
    updateSuccessfulTest(),
    V1 \== V2,
    nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl,    
    write("Delta: "), write(Delta), nl, nl.

queryL(13, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    CertSeq = qheight(Gas),
    Gas1 is Gas - 1,
    CertSeq1 = qheight(Gas1),
    !,
    write("step(p1, p1) -> ceval(p2, s1) -> ceval(p1, s2) -> s1 = s2"), nl,        
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(CertSeq, [], Delta, step(P, P2, collect(Vars, ST))),
    convert_list(ST, Delta1),
    seq(CertSeq1, [], Delta1, interp(P2, Vars, V1)),
    seq(CertSeq, [], Delta, interp(P, Vars, V2)),    
    updateSuccessfulTest(),
    V1 \== V2,
    nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl,    
    write("ST: "), write(ST), nl,    
    write("Delta1: "), write(Delta1), nl,
    write("P2: "), write(P2), nl,    
    write("Delta: "), write(Delta), nl, nl.
%! queryL(+Number, +Gas, +Dimension, +Dimension2, +Certificate, +Delta, +Vars, +Gamma, -CounterExample, -TypeOfQuery)
