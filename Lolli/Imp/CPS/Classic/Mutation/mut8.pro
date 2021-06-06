:- ['../classicHelper.pro'].
:- ['../imp.pro'].

:- op(120, xfy, :).

has_type(b(_), bool, _) <-
    true.
has_type(i(_), int, _) <-
    true.
has_type(X, T, Type) <-
    member(type(T, X), Type).
has_type(andV(E1, E2), bool, Type) <-            
    has_type(E1, bool, Type) &
    has_type(E2, bool, Type).
has_type(orV(E1, E2), bool, Type) <-            
    has_type(E1, bool, Type) &
    has_type(E2, bool, Type).    
has_type(notV(E1), bool, Type) <-            
    has_type(E1, bool, Type).        
has_type(eqV(E1, E2), bool, Type) <-            
    has_type(E1, T, Type) &
    has_type(E2, T, Type).  
has_type(plusV(E1, E2), bool, Type) <-                   % <- BUG: bool al posto di int      
    has_type(E1, int, Type) &
    has_type(E2, int, Type).    
has_type(minusV(E1, E2), int, Type) <-            
    has_type(E1, int, Type) &
    has_type(E2, int, Type).      
has_type(timesV(E1, E2), int, Type) <-            
    has_type(E1, int, Type) &
    has_type(E2, int, Type).      
%! has_type(+Expression, ±Type, +Types).

com_type(skip, _) <-
    true.
com_type(C1 : C2, Type) <-      
    com_type(C1, Type) &
    com_type(C2, Type).
com_type(assign(X, E), Type) <-
    member(type(T, X), Type) &
    has_type(E, T, Type).
com_type(if(C, B1, B2), Type) <-
    has_type(C, bool, Type) &
    com_type(B1, Type) &
    com_type(B2, Type).
com_type(while(C, B), Type) <-
    has_type(C, bool, Type) &
    com_type(B, Type).
%! com_type(+Prog, +Type).

typef(vi(_), int) <-
    true.    
typef(vb(_), bool) <-
    true.    
%! typef(+Value, -Type).

styping([], []) <- 
    true.
styping([variable(X, V) | State] , Type) <-
    select(type(T, X), Type, Type2) &
    typef(V, T) &
    styping(State, Type2).
%! styping(+State, +Type).
