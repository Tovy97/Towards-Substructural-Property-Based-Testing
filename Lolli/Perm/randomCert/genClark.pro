:- op(150,xfy,::).  %    non-empty list constructor

myclause(isNat(X), (
    X = 0; 
    X = 1 ; 
    X = 2
)).

myclause(isNatList(K,L), (
	(L = nil, K = 0)
	;
	( 
        K >= 0,
	    L = X :: Lx,
	    M is K - 1,
        isNat(X),
        isNatList(M, Lx)
    )
)).