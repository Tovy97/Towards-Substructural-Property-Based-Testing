:- ['../../Imp/CPS_NO_GAS/gen.pro'].
:- ['../../Implementazione/Interprete/2ndOrder-Cert/llinterp.pro'].

queryL(0, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    CertSeq = qheight(Gas),
    write("Determinismo asm_evalP --> forall a, asm_evalP(a, v1) -> asm_evalP(a, v2) -> v1 = v2"), nl,
    !,
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq(CertSeq, [], Delta, asm_interp(A, Vars, V1)), 
    seq(CertSeq, [], Delta, asm_interp(A, Vars, V2)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.        

queryL(1, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    GasAsm is Gas * 10,
    CertSeq = qheight(Gas),
    CertSeqAsm = qheight(GasAsm),
    write("Compilato come originale (stesso stato) --> forall p, comp(p, a) -> ceval(p, v1) -> asm_evalP(a, v2) -> v1 = v2"), nl,
    !,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq(CertSeq, [], Delta, interp(P, Vars, V1)), 
    seq(CertSeqAsm, [], Delta, asm_interp(A, Vars, V2)),
    updateSuccessfulTest(),    
    V1 \== V2,
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl,
    write("V2: "), write(V2), nl, nl.     

queryL(2, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    GasAsm is Gas * 10,
    CertSeq = qheight(Gas),
    CertSeqAsm = qheight(GasAsm),
    write("Compilato come originale --> forall p, comp(p, a) -> ceval(p, v1) -> asm_evalP(a, v1)"), nl,
    !,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq(CertSeq, [], Delta, interp(P, Vars, V1)), 
    updateSuccessfulTest(),    
    seq(CertSeqAsm, [], Delta, not(asm_interp(A, Vars, V1))),
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl, nl.  

queryL(3, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, A, P, prog) :- 
    GasAsm is Gas * 10,
    CertSeq = qheight(Gas),
    CertSeqAsm = qheight(GasAsm),
    write("Originale come compilato --> forall p, comp(p, a) -> asm_evalP(a, v1) -> ceval(p, v1)"), nl,
    !,    
    genProg(Cert, Dim, Dim2, P, Gamma),   
    updateGeneratedTest(),  
    comp(Vars, P, A),
    seq(CertSeqAsm, [], Delta, asm_interp(A, Vars, V1)),
    updateSuccessfulTest(),    
    seq(CertSeq, [], Delta, not(interp(P, Vars, V1))), 
    nl,
    write("P: "), write(P), nl,
    write("A: "), write(A), nl,
    write("V1: "), write(V1), nl, nl.  

queryL(4, Gas, Dim, Dim2, Cert, Delta, Vars, Gamma, A, E, exp) :- 
    CertSeq = qheight(Gas),
    write("Compilatazione espressioni"), nl,
    !,
    genExp(Cert, Dim, Dim2, _, E, Gamma),  
    updateGeneratedTest(),  
    compExp(Vars, E, A),
    seq(CertSeq,[], Delta, eval(E, V, erase)),      
    updateSuccessfulTest(),   
    seq(CertSeq, [], Delta, stack([]) -> not(asm_evalP(A, 0, stack([V]) x erase))),
    nl,
    write("E: "), write(E), nl,
    write("A: "), write(A), nl,
    write("V: "), write(V), nl, nl. 
%! queryL(+Number, +Gas, +Dimension, +Dimension2, +Certificate, +Delta, +VarList, +Gamma, -CounterExampleAsm, -CounterExampleImp, +Type)