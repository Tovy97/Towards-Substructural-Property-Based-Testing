:- op(120, yfx, <>).
:- discontiguous eqE/1.
:- discontiguous ttE/1.
:- discontiguous orE/3.
:- discontiguous andE/3.
:- discontiguous unfoldE/2. 
:- discontiguous unfoldEBuiltIn/2. 

% Certificate 'qheight'
ttE(qheight(_)).
eqE(qheight(_)).
orE(qheight(H), qheight(H), _).
andE(qheight(H), qheight(H), qheight(H)).
unfoldE(qheight(H), qheight(H1)) :- 
        H  > 0, 
        H1 is H  - 1.
unfoldEBuiltIn(qheight(H), qheight(H)).

% Certificate 'qsize'
eqE(qsize(In, In)).
ttE(qsize(In, In)).
orE(qsize(In, Out), qsize(In, Out), _).
andE(qsize(In, Out), qsize(In, Mid), qsize(Mid, Out)).
unfoldE(qsize(In, Out), qsize(In1, Out)) :- 
        In > 0, 
        In1 is In - 1.
unfoldEBuiltIn(qsize(In, Out), qsize(In, Out)).

% Certificate 'max'
ttE(max(empty)).
eqE(max(empty)).
orE(max(choose(C, M)), max(M), C).
andE(max(binary(M, N)), max(M), max(N)).
unfoldE(max(M), max(M)).
unfoldEBuiltIn(max(M), max(M)).

% Certificate pairing
ttE(A <> B) :- 
    ttE(A), 
    ttE(B).
eqE(A <> B) :- 
    eqE(A), 
    eqE(B).
orE(A <> B, C <> D, E) :-
    orE(A, C, E), 
    orE(B, D, E). 
andE(A <> B, C <> D, E <> F) :-
    andE(A, C, E), 
    andE(B, D, F). 
unfoldE(A <> B, C <> D) :- 
    unfoldE(A, C),
    unfoldE(B, D).
unfoldEBuiltIn(A <> B, C <> D) :- 
    unfoldEBuiltIn(A, C),
    unfoldEBuiltIn(B, D).