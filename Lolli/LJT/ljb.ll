:- ['../Implementazione/Interprete/2ndOrder/llinterp.pro'].

isAtomic(at(_)) <- true.

pvb(C) <- 
    hypb(C)
    x erase.
pvb(imp(A, B)) <- 
    (hypb(A) -> pvb(B)).
pvb(C) <-
     hypb(imp(A, B))                                           
     x pvb_imp(A, B)                                                   
     x (hypb(B) -> pvb(C)).
     

pvb_imp(imp(C, D), B) <-
      (hypb(imp(D, B)) -> pvb(imp(C, D))). 
pvb_imp(A, _) <-
      isAtomic(A)
      x hypb(A).
% TODO: A è tolta dal contesto, ma non è necessaria? Nella regola classica A è nel contesto      
