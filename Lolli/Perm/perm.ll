:- op(150,xfy,::).  %    non-empty list constructor

%%%%%%%%%%% PERM %%%%%%%%%%%

load(nil, G)   <- G.
load(X::L, G)  <- item(X) -> load(L,G).

unload(nil)    <- true.
unload(X::L)   <- item(X) x unload(L).

perm(L, K)     <- bang(load(L,unload(K))).
