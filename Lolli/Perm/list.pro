:- op(150,xfy,::).  %    non-empty list constructor

%%%%%%%%%%% VERSIONE PROLOG %%%%%%%%%%%
len(nil, 0).
len(_ :: T, L) :-
    len(T, L1),
    L is L1 + 1.
    
ncontains(nil, _).
ncontains(Y :: YS, X) :- 
    Y \==  X, 
    ncontains(YS, X).

distinct(nil).
distinct(X :: XS) :- 
    ncontains(XS, X), 
    distinct(XS). 
    
in_list(X, X :: _).
in_list(X, _ :: Ys) :-	
    in_list(X, Ys).

sorted(nil).
sorted(_ :: nil).
sorted(H1 :: (H2 :: T)) :-
    H1 =< H2,
    sorted(H2 :: T).

count(_, nil, 0).
count(X, X :: T, C) :- 
    !,
    count(X, T, C1),
    C is C1 + 1.
count(X, _ :: T, C) :-    
    count(X, T, C).    
    
%%%%%%%%%%% VERSIONE LOLLI %%%%%%%%%%%
    
len(nil, 0) <- true.
len(_ :: T, L) <-
    len(T, L1) x
    inc(L1, L).

ncontains(nil, _) <- true.
ncontains(Y :: YS, X) <- 
    notEq(Y, X) x
    ncontains(YS, X).

distinct(nil) <- true.
distinct(X :: XS) <- 
    ncontains(XS, X) x
    distinct(XS).     

in_list(X, X :: _) <- true.
in_list(X, _ :: Ys) <-	
    in_list(X, Ys).

sorted(nil)             <- true.
sorted(_ :: nil)        <- true. 
sorted(H1 :: (H2 :: T)) <- leq(H1, H2) x sorted(H2 :: T).    

count(_, nil, 0) <- true.
count(X, X :: T, C) <-
    count(X, T, C1) x
    inc(C1, C).
count(X, Y :: T, C) <-
    notEq(Y, X) x
    count(X, T, C).  
    
partition(_, nil, nil, nil) <- true.
partition(H, K :: L, K :: S1, S2) <-
    leq(K, H) x
    partition(H, L, S1, S2).
partition(H, K :: L, S1, K :: S2) <-
    lt(H, K) x
    partition(H, L, S1, S2).

appendList(nil, L, L) <- true.
appendList(H::T, L, H::S) <-
    appendList(T,L,S).
