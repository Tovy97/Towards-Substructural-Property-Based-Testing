% perm non ritorna solo le permutazioni della lista in input, ma anche le permurazioni di tutte le sue sottoliste.
% questo perché con erase  va a buon fine l'estazioni degli elementi dal contesto bounded quando ancora esso non è vuoto.

:- op(150,xfy,::).  %    non-empty list constructor

%%%%%%%%%%% PERM %%%%%%%%%%%

load(nil, G)   <- G.
load(X::L, G)  <- item(X) -> load(L,G).             

unload(nil)    <- erase.                        % <-- ERRORE QUI    erase al posto di true.
unload(X::L)   <- item(X) x unload(L).

perm(L, K)     <- bang(load(L,unload(K))).
