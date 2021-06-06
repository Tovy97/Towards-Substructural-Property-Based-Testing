% modifica unfold/2 -> unfold/4
:- op(120, yfx, <>).
:- discontiguous eqE/1.
:- discontiguous eraseE/1.
:- discontiguous pickRE/1.
:- discontiguous ttE/1.
:- discontiguous orE/3.
:- discontiguous andE/3.
:- discontiguous tensorE/3.
:- discontiguous unfoldE/4.
:- discontiguous lolliE/2.
:- discontiguous bangE/2.
:- discontiguous impE/2. 
:- discontiguous unfoldElib/4. 

% Certificate 'qheight'
ttE(qheight(_)).
eraseE(qheight(_)).
pickRE(qheight(_)).
eqE(qheight(_)).
orE(qheight(H), qheight(H), _).
lolliE(qheight(H), qheight(H)).
impE(qheight(H), qheight(H)).
bangE(qheight(H), qheight(H)).
andE(qheight(H), qheight(H), qheight(H)).
tensorE(qheight(H), qheight(H), qheight(H)).
unfoldE(qheight(H), qheight(H1), A, G) :-
	clause(A,G),
    H  > 0, 
    H1 is H  - 1.
unfoldElib(qheight(H), qheight(H), A, G) :-
    clause(A, G).

% Certificate 'qsize'

generateList(Last, Last, [Last]) :- 
        !.
generateList(N, Last, [N | T]) :-
        !,
        M is N + 1,
        generateList(M, Last, T).

eqE(qsize(In, In)).
ttE(qsize(In, In)).
eraseE(qsize(In, In)).
pickRE(qsize(In, In)).
orE(qsize(In, Out), qsize(In, Out), _).
impE(qsize(In, Out), qsize(In, Out)).
lolliE(qsize(In, Out), qsize(In, Out)).
bangE(qsize(In, Out), qsize(In, Out)).
andE(qsize(In, Out), qsize(In, Mid), qsize(Mid, Out)).
tensorE(qsize(In, Out), qsize(In, Mid), qsize(Mid, Out)).
        % generateList(0, In, List),
        % member(Mid, List).        
unfoldE(qsize(In, Out), qsize(In1, Out), A, G) :-
	clause(A,G),
    In > 0, 
    In1 is In - 1.
unfoldElib(qsize(In, Out), qsize(In, Out), A, G) :-
	clause(A, G).

				% with computation of leftovers



% Certificate pairing
ttE(A <> B) :- 
    ttE(A), 
    ttE(B).
eraseE(A <> B) :- 
    eraseE(A), 
    eraseE(B).
pickRE(A <> B) :- 
    pickRE(A), 
    pickRE(B).

eqE(A <> B) :- 
    eqE(A), 
    eqE(B).
orE(A <> B, C <> D, E) :-
    orE(A, C, E), 
    orE(B, D, E). 
andE(A <> B, C <> D, E <> F) :-
    andE(A, C, E), 
    andE(B, D, F).
tensorE(A <> B, C <> D, E <> F) :-
    tensorE(A, C, E), 
    tensorE(B, D, F).
lolliE(A <> B, C <> D) :- 
    lolliE(A, C),
    lolliE(B, D).
impE(A <> B, C <> D) :- 
    impE(A, C),
    impE(B, D).
bangE(A <> B, C <> D) :- 
    bangE(A, C),
    bangE(B, D).
unfoldE(A <> B, C <> D, At, G) :- 
    unfoldE(A, C, At, G),
    unfoldE(B, D, At, G).
unfoldElib(A <> B, C <> D, At, G) :- 
    unfoldElib(A, C, At, G),
    unfoldElib(B, D, At, G).

% random in unfold *e* in disgiunzione
/* 
ttE(qr(_)).
eraseE(qr(_)).
eqE(qr(_)).
orE(qr(A), qr(A), I) :-
	(maybe -> I = left ; I = right).
lolliE(qr(A), qr(A)).
impE(qr(A), qr(A)).
bangE(qr(A), qr(A)).
andE(qr(A), qr(A), qr(A)).
tensorE(qr(A), qr(A), qr(A)).
unfoldE(qr(A), qr(RG),A, RG) :-
	findall(A :- G,clause(A,G),L),
	random_permutation(L,P),
	member(A :- RG,P).
*/

ttE(qr).
eraseE(qr).
pickRE(qr).
eqE(qr).
orE(qr, qr, I) :-
	(maybe -> I = left ; I = right).
lolliE(qr, qr).
impE(qr, qr).
bangE(qr, qr).
andE(qr, qr, qr).
tensorE(qr, qr, qr).
% unfold +Cert -Cert1 +A -RG
unfoldE(qr, qr,A, RG) :-
	findall(A :- G,clause(A,G),L),
	random_permutation(L,P),
	member(A :- RG, P).
unfoldElib(qr, qr, A, G):-
	clause(A, G).
  
% -------------------------------------
% random a la Clark (nella disgiunzione)
% INUTILE
ttE(qrC).
eraseE(qrC).
pickRE(qrC).
eqE(qrC).
orE(qrC, qrC, I) :-
	(maybe -> I = left ; I = right).
lolliE(qrC, qrC).
impE(qrC, qrC).
bangE(qrC, qrC).
andE(qrC, qrC, qrC).
tensorE(qrC, qrC, qrC).
unfoldE(qrC, qrC,_,_).
unfoldElib(qrC, qrC,_,_).