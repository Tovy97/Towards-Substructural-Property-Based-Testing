:- ['../Implementazione/Interprete/2ndOrder/llinterp.pro'].

isAtomic(at(_)) <- true.

pv(imp(A, B)) <- 
    (hyp(A) -> pv(B)).
pv(C) <- 
    hyp(C)
    x erase.
pv(C) <-
     hyp(imp(A, B))                                           
     x hyp(A)                                                   
     x isAtomic(A)
     x (hyp(B) -> hyp(A) -> pv(C)).
pv(C) <-
    hyp(imp(imp(A1, A2), B))
    x ((hyp(imp(A2, B)) -> 
        pv(imp(A1, A2))) 
        & (hyp(B) -> pv(C))).     
