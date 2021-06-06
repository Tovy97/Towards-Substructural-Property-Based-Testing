:- ['../../Implementazione/Certificati/kernel.pro'].

:- op(150,xfy,::).  

is_nat(0).
is_nat(1).
is_nat(2).
is_nat(3).
is_nat(4).
is_nat(5).

is_natlist(nil).
is_natlist(Hd::Tl) :- 
    is_nat(Hd), 
    is_natlist(Tl).

/*
gen_natlist(N, L) :-
    check(qheight(N), is_natlist(L)).

gen_natlist(N, L) :-
    check(qsize(N, _), is_natlist(L)).
gen_natlist(N, L) :-
    M is N * 2,
    check(qheight(N)<>qsize(M, _), is_natlist(L)).
*/
