#! /usr/bin/swipl -f -q

:- ['queryRandom.pro'].
:- ['../../Imp/CPS/helper.pro'].
:- ['../prettyPrinter.pro'].
:- ['../../Imp/CPS/prettyPrinter.pro'].

mutation('0') :-
    ['../../Imp/CPS/Classic/typeChecker.pro'],
    ['../../Imp/CPS/Classic/imp.pro'],
    ['assembly.pro'],
    ['../compiler.pro'].
mutation(N) :-
    atom_concat('../MutCompiler/mut', N, Temp),
    atom_concat(Temp, '.pro', Ris),    
    ['../../Imp/CPS/Classic/typeChecker.pro'],
    ['../../Imp/CPS/Classic/imp.pro'],
    ['assembly.pro'],
    [Ris].

:- initialization(main).

main :-                                                 % ./executeQueryRandom.pro M Q N D C G - dove M è mutation, Q è la query, N è il numero di test D è la dimensione, C è il certificato e G è il gas
    current_prolog_flag(argv, [M, Q1, N1, D1, C1, G1]),
    mutation(M),
    atom_number(Q1, Q),
    atom_number(N1, N),
    atom_number(D1, D),
    atom_number(C1, C),
    atom_number(G1, G),
    execQueryC(Q, N, D, C, G),
    halt.

execQueryC(Q, N, D, C, G) :-
    write("Query N°: "),
    write(Q),
    write(" - Dimensione: "),
    write(D), 
    write(" - Certificato: "),
    write(C),
    write(" - Gas: "),
    write(G), nl,
    write("Query: "),
    init_var(true, State, VarList, VarType),
    nb_setval(query, (0, 0, n)),     
    !,      
    (time(queryC(Q, G, D, N, C, State, VarList, VarType, A, P, T)) ->  
        (
            write("Test non passato.\nControesempio\nAsm:\n"),             
            write(A),            
            write("\nIMP:\n"),
            write(P), nl,            
            write("\nPrettyPrinter\nAsm:\n"),
            writeAssembly(0, A),                                
            write("\nIMP:\n"),
            (
                (T == prog) ->
                    writeProg(P, "");
                    writeExp(P)
            ),
            nl
        ) ;
        (
            nb_getval(query, (Gen, Succ, _)),
            Fail is Gen - Succ,
            write("Test passato\nGenerati "),
            write(Gen),
            write(" test, completati "),
            write(Succ),
            write(" test, tralasciati "),
            write(Fail),
            write(" test\n")
        )
    ),
    nl,
    nb_delete(query).

