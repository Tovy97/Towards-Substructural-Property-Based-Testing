:- ['../prettyPrinter.pro'].
:- ['../helper.pro'].
:- ['imp.ll'].
:- ['typeChecker.ll'].
:- ['smallStep.ll'].

:- ['extension.ll'].

testP(N) :- 
    write("%%%%%%%%%%\n\nTest "), 
    write(N), 
    query(N, P, F1),
    sort(F1, F),    
    init_var(Delta, Vars, Gamma),
    seq(Gamma, Delta, styping(Vars)),
    ( 
        (seq(Gamma, [], com_type(P)), seq([], Delta, interp(P, Vars, S1)), sort(S1, S), F == S) -> 
            write(" passato\n\n") ; 
            write(" non passato\n\n")
    ),
    write("---PROGRAMMA---\n"),
    writeProg(P, ""), nl,
    write("---STATO FINALE---\n"),
    write(S), nl, nl.
%! testP(+TestNumber).  

testP_SS(N) :- 
    write("%%%%%%%%%%\n\nTest "), 
    write(N), 
    query(N, P, F1),
    sort(F1, F),    
    init_var(Delta, Vars, Gamma),
    seq(Gamma, Delta, styping(Vars)),
    ( 
        (seq(Gamma, [], com_type(P)), seq([], Delta, interpSS(P, Vars, S1)), sort(S1, S), F == S) -> 
            write(" passato\n\n") ; 
            write(" non passato\n\n")
    ),
    write("---PROGRAMMA---\n"),
    writeProg(P, ""), nl,
    write("---STATO FINALE---\n"),
    write(S), nl, nl.
%! testP_SS(+TestNumber).  

testN(N) :- 
    write("%%%%%%%%%%\n\nTest Fail "), 
    write(N), 
    query(N, P, G, E),
    init_var(Delta, Vars, Gamma),
    seq(Gamma, Delta, styping(Vars)),
    (
        (E == loop) ->
        (
            (seq([], Delta, interpG(G, P, Vars, S))) -> 
            write(" non passato\n\n") ; 
            write(" passato\n\n")
        ) ; (
            (E == noVar) ->
            (
                (seq([], Delta, interp(P, Vars, S))) -> 
                write(" non passato\n\n") ; 
                write(" passato\n\n")
            ) ;
            (
                (E == typeError) ->
                (
                    (seq(Gamma, [], com_type(P))) -> 
                    write(" non passato\n\n") ; 
                    write(" passato\n\n")
                )
            )
        )
    ),
    write("---PROGRAMMA---\n"),
    writeProg(P, ""), nl,
    write("---STATO FINALE---\n"),
    write(S), nl, nl.
%! testN(+TestNumber).    

testN_SS(N) :- 
    write("%%%%%%%%%%\n\nTest Fail "), 
    write(N), 
    query(N, P, G, E),
    init_var(Delta, Vars, Gamma),
    seq(Gamma, Delta, styping(Vars)),
    (
        (E == loop) ->
        (
            (seq([], Delta, interpSSG(G, P, Vars, S))) -> 
            write(" non passato\n\n") ; 
            write(" passato\n\n")
        ) ; (
            (E == noVar) ->
            (
                (seq([], Delta, interpSS(P, Vars, S))) -> 
                write(" non passato\n\n") ; 
                write(" passato\n\n")
            ) ;
            (
                (E == typeError) ->
                (
                    (seq(Gamma, [], com_type(P))) -> 
                    write(" non passato\n\n") ; 
                    write(" passato\n\n")
                )
            )
        )
    ),
    write("---PROGRAMMA---\n"),
    writeProg(P, ""), nl,
    write("---STATO FINALE---\n"),
    write(S), nl, nl.
%! testN_SS(+TestNumber).    

query(0, P, S) :- 
    P = assign(x, b(true)) : assign(y, b(true)),
    S = [(x, vb(true)), (y, vb(true)), (z, vi(0)), (w, vi(0))].
query(1, P, S) :- 
    P = assign(x, b(true)) : assign(y, x),
    S = [(x, vb(true)), (y, vb(true)), (z, vi(0)), (w, vi(0))].
query(2, P, S) :- 
    P = assign(x, andV(b(true), b(true))),
    S = [(x, vb(true)), (y, vb(false)), (z, vi(0)), (w, vi(0))].
query(3, P, S) :- 
    P = assign(x, andV(b(false), b(true))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(0)), (w, vi(0))].
query(4, P, S) :- 
    P = assign(x, orV(b(false), b(false))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(0)), (w, vi(0))].
query(5, P, S) :- 
    P = assign(x, orV(b(false), b(true))),
    S = [(x, vb(true)), (y, vb(false)), (z, vi(0)), (w, vi(0))].
query(6, P, S) :- 
    P = assign(x, b(true)) : if(eqV(x, b(true)), assign(y, x), assign(y, notV(x))),
    S = [(x, vb(true)), (y, vb(true)), (z, vi(0)), (w, vi(0))].
query(7, P, S) :- 
    P = assign(x, b(false)) : if(eqV(x, b(true)), assign(y, x), assign(y, notV(x))),
    S = [(x, vb(false)), (y, vb(true)), (z, vi(0)), (w, vi(0))].
query(8, P, S) :- 
    P = assign(x, b(false)) : while(eqV(x, b(false)), assign(x, b(true))),
    S = [(x, vb(true)), (y, vb(false)), (z, vi(0)), (w, vi(0))].
query(9, P, S) :- 
    P = assign(x, b(true)) : if(eqV(x, b(true)), skip, assign(y, notV(x))),
    S = [(x, vb(true)), (y, vb(false)), (z, vi(0)), (w, vi(0))].
query(10, P, S) :- 
    P = (assign(x, b(true)) : assign(y, x)),
    S = [(x, vb(true)), (y, vb(true)), (z, vi(0)), (w, vi(0))].
query(11, P, S) :- 
    P = (assign(x, b(true)) : ((assign(y, x) : assign(y, x)))),
    S = [(x, vb(true)), (y, vb(true)), (z, vi(0)), (w, vi(0))].
query(13, P, S) :- 
    P = assign(z, i(1)) : assign(w, i(-1)),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(-1))].   
query(14, P, S) :- 
    P = assign(z, i(1)) : assign(w, z),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(1))]. 
query(15, P, S) :- 
    P = assign(z, plusV(i(1), i(2))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(3)), (w, vi(0))]. 
query(16, P, S) :- 
    P = assign(z, plusV(i(1), i(-2))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(-1)), (w, vi(0))]. 
query(17, P, S) :- 
    P = assign(z, minusV(i(1), i(2))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(-1)), (w, vi(0))]. 
query(18, P, S) :- 
    P = assign(z, minusV(i(1), i(-2))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(3)), (w, vi(0))]. 
query(19, P, S) :- 
    P = assign(z, timesV(i(1), i(2))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(2)), (w, vi(0))]. 
query(20, P, S) :- 
    P = assign(z, timesV(i(1), i(-2))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(-2)), (w, vi(0))]. 
query(21, P, S) :- 
    P = assign(z, i(1)) : if(eqV(z, i(1)), assign(w, z), assign(w, minusV(i(0), z))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(1))]. 
query(22, P, S) :-
    P = assign(z, i(-1)) : if(eqV(z, i(1)), assign(w, z), assign(w, minusV(i(0), z))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(-1)), (w, vi(1))].
query(23, P, S) :- 
    P = assign(z, i(-1)) : while(eqV(z, i(-1)), assign(z, i(1))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(0))].
query(24, P, S) :- 
    P = assign(z, i(1)) : if(eqV(z, i(1)), skip, assign(w, minusV(i(0), z))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(0))].
query(25, P, S) :- 
    P = (assign(z, i(1)) : assign(w, z)),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(1))].
query(26, P, S) :- 
    P = (assign(z, i(1)) : ((assign(w, z) : assign(w, z)))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(1)), (w, vi(1))].   
query(32, P, S) :- 
    P = let(z, i(5), assign(w, z) : assign(z, w)) : assign(w, plusV(w, i(1))),
    S = [(x, vb(false)), (y, vb(false)), (z, vi(0)), (w, vi(6))].        
%! query(+QueryNumber, -Program, -State).

query(12, P, _, noVar) :- 
    P = assign(x, t).
    % FAIL
query(27, P, _, noVar) :- 
    P = assign(z, t).
    % FAIL
query(28, P, _, typeError) :- 
    P = assign(x, z).
    % FAIL 
query(29, P, _, typeError) :- 
    P = assign(x, i(1)).
    % FAIL        
query(30, P, _, typeError) :- 
    P = assign(z, b(true)).
    % FAIL  
query(31, P, 10, loop) :- 
    P = while(b(true), skip).
    % FAIL       
%! query(+QueryNumber, -Program, -Gas, -Error).

%BIG STEP
:- write("---------- Unit Test - Versione BIG step ----------\n\n").
:- testP(0).
:- testP(1).
:- testP(2).
:- testP(3).
:- testP(4).
:- testP(5).
:- testP(6).
:- testP(7).
:- testP(8).
:- testP(9).
:- testP(10).
:- testP(11).
:- testP(13).
:- testP(14).
:- testP(15).
:- testP(16).
:- testP(17).
:- testP(18).
:- testP(19).
:- testP(20).
:- testP(21).
:- testP(22).
:- testP(23).
:- testP(24).
:- testP(25).
:- testP(26). 
:- testP(32).

:- testN(12).
:- testN(27).
:- testN(28).
:- testN(29).
:- testN(30).
:- testN(31).

%SMALL STEP
:- write("\n\n---------- Unit Test - Versione SMALL step ----------\n\n").
:- testP_SS(0).
:- testP_SS(1).
:- testP_SS(2).
:- testP_SS(3).
:- testP_SS(4).
:- testP_SS(5).
:- testP_SS(6).
:- testP_SS(7).
:- testP_SS(8).
:- testP_SS(9).
:- testP_SS(10).
:- testP_SS(11).
:- testP_SS(13).
:- testP_SS(14).
:- testP_SS(15).
:- testP_SS(16).
:- testP_SS(17).
:- testP_SS(18).
:- testP_SS(19).
:- testP_SS(20).
:- testP_SS(21).
:- testP_SS(22).
:- testP_SS(23).
:- testP_SS(24).
:- testP_SS(25).
:- testP_SS(26). 
:- testP_SS(32).

:- testN_SS(12).
:- testN_SS(27).
:- testN_SS(28).
:- testN_SS(29).
:- testN_SS(30).
:- testN_SS(31).