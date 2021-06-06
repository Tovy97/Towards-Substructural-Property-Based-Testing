:- ['../imp.ll'].

:- op(120, xfy, :).

has_type(b(_), bool) <-
    true.
has_type(i(_), int) <-
    true.
has_type(X, T) <-
    type(T, X).
has_type(andV(E1, E2), bool) <-            
    has_type(E1, bool) &
    has_type(E2, bool).
has_type(orV(E1, E2), bool) <-            
    has_type(E1, bool) &
    has_type(E2, bool).    
has_type(notV(E1), bool) <-            
    has_type(E1, bool).        
has_type(eqV(E1, E2), bool) <-            
    has_type(E1, T) &
    has_type(E2, T).  
has_type(plusV(E1, E2), bool) <-                        % <- BUG: bool al posto di int
    has_type(E1, int) &
    has_type(E2, int).        
has_type(minusV(E1, E2), int) <-            
    has_type(E1, int) &
    has_type(E2, int).      
has_type(timesV(E1, E2), int) <-            
    has_type(E1, int) &
    has_type(E2, int).      
%! has_type(+Expression, ±Type).

com_type(skip) <-
    true.
com_type(C1 : C2) <-      
    com_type(C1) &
    com_type(C2).
com_type(assign(X, E)) <-
    type(T, X) &
    has_type(E, T).
com_type(if(C, B1, B2)) <-
    has_type(C, bool) &
    com_type(B1) &
    com_type(B2).
com_type(while(C, B)) <-
    has_type(C, bool) &
    com_type(B).
%! com_type(+Prog).

typef(vi(_), int) <-
    true.    
typef(vb(_), bool) <-
    true.    
%! typef(+Value, -Type).

styping([]) <- 
    true.
styping([X | XS]) <-
    variable(X, V) x
    bang(type(T, X)) x
    bang(typef(V, T)) x
    styping(XS).
%! styping(+Vars).
