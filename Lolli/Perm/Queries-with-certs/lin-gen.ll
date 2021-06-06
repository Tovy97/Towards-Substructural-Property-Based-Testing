:- ['../../Implementazione/Certificati/fpcs.pro'].

:- op(150,xfy,::).  

is_nat(0) <- true.
is_nat(1) <- true .
is_nat(2) <- true .
is_nat(3) <- true .
is_nat(4) <- true .
is_nat(5) <- true .

is_natlist(nil) <- true .
is_natlist(Hd::Tl) <- 
    bang(is_nat(Hd)) x 
    bang(is_natlist(Tl)).

/*

gen(N, L) :-
    check(qheight(N), is_natlist(L)).
  gen(N, L) :-
    check(qsize(N, _), is_natlist(L)).
gen(N, L) :-
    M is N * 2,
    check(qheight(N)<>qsize(M, _), is_natlist(L)).*/
