% perm di una lista genera infinite liste. Questo perché gli elementi vengono caricati nel contesto unbound e quindi la chiamata a 
% item(X), trovandosi un costesto bound vuoto, va a caricare un elemento dal contesto unbound. Solo che questa operazione può essere 
% ripetuta all'infinito dato che dal contesto unbound posso estrarre item tutte le volte che voglio.

:- op(150,xfy,::).  %    non-empty list constructor

%%%%%%%%%%% PERM %%%%%%%%%%%

load(nil, G)   <- G.
load(X::L, G)  <- item(X) => load(L,G).             % <-- ERRORE QUI    => (implica) al posto di -> (lollipop)

unload(nil)    <- true.
unload(X::L)   <- item(X) x unload(L).

perm(L, K)     <- bang(load(L,unload(K))).
