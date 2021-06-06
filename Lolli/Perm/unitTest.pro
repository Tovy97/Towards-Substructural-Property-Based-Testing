:- ['../Implementazione/Interprete/2ndOrder/llinterp.pro'].
:- ['perm.ll'].

:- prove(nil, nil, perm(a::b::nil, K)), K = b::a::nil.

:- bagof(K, prove(nil, nil, perm(a::b::nil, K)), Xs), Xs = [b::a::nil, a::b::nil].

:- bagof(K, prove(nil, nil, perm(a::b::c::nil, K)), Xs), 
    Xs = [c::b::a::nil, c::a::b::nil, b::c::a::nil, b::a::c::nil, a::c::b::nil, a::b::c::nil].