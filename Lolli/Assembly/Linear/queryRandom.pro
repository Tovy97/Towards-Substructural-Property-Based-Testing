:- ['../../Imp/CPS/gen.pro'].
:- ['../../Implementazione/Interprete/2ndOrder/llinterp.pro'].

queryL(0, Gas, Dim, NumOfTests, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    write("***Determinismo asm_evalP --> forall a, asm_evalP(a, v1) -> asm_evalP(a, v2) -> v1 = v2"), nl,
    genNRandProg(Cert, NumOfTests, Dim, P, Gamma), 
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq([], Delta, asm_interpG(Gas, A, Vars, V1)), 
    seq([], Delta, asm_interpG(Gas, A, Vars, V2)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.        
    
queryL(1, Gas, Dim, NumOfTests, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    write("***Compilato come originale (stesso stato) --> forall p, comp(p, a) -> ceval(p, v1) -> asm_evalP(a, v2) -> v1 = v2"), nl,
    GasAsm is Gas * 10,
    genNRandProg(Cert, NumOfTests, Dim, P, Gamma), 
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq([], Delta, interpG(Gas, P, Vars, V1)), 
    seq([], Delta, asm_interpG(GasAsm, A, Vars, V2)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.           

queryL(2, Gas, Dim, NumOfTests, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    write("Compilato come originale --> forall p, comp(p, a) -> ceval(p, v1) -> asm_evalP(a, v1)"), nl,
    GasAsm is Gas * 10,
    genNRandProg(Cert, NumOfTests, Dim, P, Gamma), 
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq([], Delta, interpG(Gas, P, Vars, V1)), 
    updateSuccessfulTest(),    
    seq([], Delta, not(asm_interpG(GasAsm, A, Vars, V1))),    
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,    
    write("V2: "), write(V1), nl, nl.   

queryL(3, Gas, Dim, NumOfTests, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    write("Originale come compilato --> forall p, comp(p, a) -> asm_evalP(a, v1) -> ceval(p, v1)"), nl,
    GasAsm is Gas * 10,
    genNRandProg(Cert, NumOfTests, Dim, P, Gamma), 
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq([], Delta, asm_interpG(GasAsm, A, Vars, V1)),    
    updateSuccessfulTest(),    
    seq([], Delta, not(interpG(Gas, P, Vars, V1))), 
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,    
    write("V2: "), write(V1), nl, nl. 

queryL(4, _, Dim, NumOfTests, Cert, Delta, Vars, Gamma, A, E, exp) :-     
    write("Compilatazione espressioni"), nl,
    genNRandExp(Cert, NumOfTests, Dim, _, E, Gamma), 
    updateGeneratedTest(),  
    compExp(Vars, E, A),
    seq([], Delta, eval(E, V, erase)),      
    updateSuccessfulTest(),   
    seq([], Delta, stack([]) -> not(asm_evalP(A, 0, stack([V]) x erase))),
    nl,
    write("Delta: "), write(Delta), nl,
    write("E: "), write(E), nl,
    write("A: "), write(A), nl,
    write("V: "), write(V), nl, nl.   

queryL(5, _, Dim, NumOfTests, Cert, _, Vars, Gamma, A, E, exp) :-     
    write("***teorema di preservazione --> forall E, has_type(E, T) -> compExp(E, A) -> check_asm_type(A) -> T è in cima allo stack"), nl,
    genNRandExp(Cert, NumOfTests, Dim, _, E, Gamma),   
    updateGeneratedTest(),  
    compExp(Vars, E, A),
    seq(Gamma, [], has_type(E, T)),      
    updateSuccessfulTest(),   
    seq(Gamma, [], type_stack([]) -> not(cod_check_type(A, type_stack([T])))),
    nl,
    write("Gamma: "), write(Gamma), nl,
    write("E: "), write(E), nl,
    write("A: "), write(A), nl,
    write("T: "), write(T), nl, nl.      
%! queryL(+Number, +Gas, +Dimension, +NumOfTests, +Certificate, +Delta, +Vars, +Gamma, -CounterExampleASM, -CounterExampleIMP, -TypeOfQuery)
