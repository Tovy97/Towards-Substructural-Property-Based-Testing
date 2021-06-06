:- ['../compiler.pro'].
:- ['../prettyPrinter.pro'].
:- ['assembly.ll'].
:- ['../../Imp/CPS_NO_GAS/helper.pro'].

testP(N) :- 
    write("%%%%%%%%%%\n\nTest "), 
    write(N), 
    query(N, P, F1),
    sort(F1, F),    
    init_var(Delta, Vars, _),  
    comp(Vars, P, A),  
    CertSeq = qheight(100),
    ( 
        (seq(CertSeq, [], Delta, asm_interp(A, Vars, S1)), sort(S1, S), F == S) -> 
            write(" passato\n\n") ; 
            write(" non passato\n\n")
    ),
    write("---PROGRAMMA---\n"),
    writeAssembly(0, A), nl,
    write("---STATO FINALE---\n"),
    write(S), nl, nl.
%! testP(+TestNumber).  

testN(N) :- 
    write("%%%%%%%%%%\n\nTest Fail "), 
    write(N), 
    queryF(N, P, E),
    init_var(Delta, Vars, _),    
    CertSeq = qheight(100),
    (
        (E == loop) ->
        (
            comp(Vars, P, A),
            (seq(CertSeq, [], Delta, asm_interp(A, Vars, S))) -> 
            write(" non passato\n\n") ; 
            write(" passato\n\n")
        ) ; (
            (E == noVar) ->
            (
                (comp(Vars, P, A)) -> 
                write(" non passato\n\n") ; 
                write(" passato\n\n")
            ) ;
            (
                (E == typeError) ->
                (
                    comp(Vars, P, A),
                    (seq(CertSeq, [], Delta, asm_interp(A, Vars, S))) -> 
                    write(" non passato\n\n") ; 
                    write(" passato\n\n")
                )
            )
        )
    ),
    write("---PROGRAMMA---\n"),
    writeAssembly(0, A), nl,
    write("---STATO FINALE---\n"),
    write(S), nl, nl.
%! testN(+TestNumber). 

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
%! query(+QueryNumber, -Program, -State).

queryF(12, P, noVar) :- 
    P = assign(x, t).
    % FAIL
queryF(27, P, noVar) :- 
    P = assign(z, t).
    % FAIL
queryF(28, P, typeError) :- 
    P = assign(x, z).
    % FAIL 
queryF(29, P, typeError) :- 
    P = assign(x, i(1)).
    % FAIL        
queryF(30, P, typeError) :- 
    P = assign(z, b(true)).
    % FAIL  
queryF(31, P, loop) :- 
    P = while(b(true), skip).
    % FAIL       
%! queryF(+QueryNumber, -Program, -Gas, -Error).

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

:- testN(12).
:- testN(27).
:- testN(28).
:- testN(29).
:- testN(30).
:- testN(31).