:- ['../../Imp/CPS/gen.pro'].
:- ['../../Implementazione/Interprete/2ndOrder/llinterp.pro'].

queryC(0, Gas, Dim, NumOfTests, Cert, State, Vars, Type, A, P, prog) :- 
    write("Determinismo asm_evalP --> forall a, asm_evalP(a, v1) -> asm_evalP(a, v2) -> v1 = v2"), nl,
    genNRandProg(Cert, NumOfTests, Dim, P, Type),    
    updateGeneratedTest(),  
    comp(Vars, P, A),
    prove(asm_interpG(Gas, State, A, V1T)),
    prove(asm_interpG(Gas, State, A, V2T)),
    sort(V1T, V1),    
    sort(V2T, V2),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.        
    
queryC(1, Gas, Dim, NumOfTests, Cert, State, Vars, Type, A, P, prog) :- 
    write("Compilato come originale --> forall p, comp(p, a) -> ceval(p, v1) -> asm_evalP(a, v2) -> v1 = v2"), nl,
    GasAsm is Gas * 10,
    genNRandProg(Cert, NumOfTests, Dim, P, Type),    
    updateGeneratedTest(),  
    comp(Vars, P, A),
    prove(interpG(Gas, State, P, V1T)),
    prove(asm_interpG(GasAsm, State, A, V2T)),
    sort(V1T, V1),    
    sort(V2T, V2),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.        
%! queryC(+Number, +Gas, +Dimension, +NumOfTests, +Certificate, +State, +VarList, +Type, -CounterExampleAsm, -CounterExampleImp, -TypeOfQuery)