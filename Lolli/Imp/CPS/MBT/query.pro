:- ['../gen.pro'].
:- ['../helper.pro'].

queryL(0, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    write("MBT ceval classic linear --> forall p, classic(p, st) -> linear(p, st)"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    prove(interpG(Gas, Delta, P, V1)),    
    updateSuccessfulTest(),
    seq([], Delta, not(interpG(Gas, P, Vars, V1))),
    nl,
    write("Delta: "), write(Delta), nl,
    write("V1: "), write(V1), nl, nl.

queryL(1, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, P, prog) :- 
    write("MBT ceval linear classic --> forall p, linear(p, st) -> classic(p, st)"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq([], Delta, interpG(Gas, P, Vars, V1)),
    updateSuccessfulTest(),
    prove(not(interpG(Gas, Delta, P, V1))),    
    nl,
    write("Delta: "), write(Delta), nl,
    write("V1: "), write(V1), nl, nl.

queryL(2, _, Dim, Dim2, Cert, Delta, _, Gamma, P, prog) :- 
    write("MBT comtype classic linear --> forall p, classic(p) -> linear(p)"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    prove(com_type(P, Gamma)),
    updateSuccessfulTest(),
    seq(Gamma, [], not(com_type(P))),
    nl,
    write("Delta: "), write(Delta), nl,
    write("Gamma: "), write(Gamma), nl, nl.

queryL(3, _, Dim, Dim2, Cert, Delta, _, Gamma, P, prog) :- 
    write("MBT comtype linear classic --> forall p, linear(p) -> classic(p)"), nl,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),     
    seq(Gamma, [], com_type(P)),
    updateSuccessfulTest(),
    prove(not(com_type(P, Gamma))),
    nl,
    write("Delta: "), write(Delta), nl,
    write("Gamma: "), write(Gamma), nl, nl.