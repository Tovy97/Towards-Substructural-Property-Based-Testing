#! /usr/bin/swipl -f -q

:- ['query.pro'].
:- ['../helper.pro'].

mutation('0') :-
    ['typeChecker.ll'],
    ['imp.ll'],
    ['smallStep.ll'],
    ['extension.ll'].
mutation(N) :-
    atom_concat('Mutation/mut', N, Temp),
    atom_concat(Temp, '.ll', Ris),
    [Ris],
    ['smallStep.ll'].

:- initialization(main).

main :-                                                 % ./executeQuery.pro M Q D C G - dove M è mutation, Q è la query, D è la dimensione, C è il certificato e G è il gas
    current_prolog_flag(argv, [M, Q1, D1, C1, G1]),
    mutation(M),
    atom_number(Q1, Q),
    atom_number(D1, D),
    atom_number(C1, C),
    atom_number(G1, G),
    execQueryL(Q, D, C, G),
    halt.

execQueryL(Q, D, C, G) :-
    write("Query N°: "),
    write(Q),
    write(" - Dimensione: "),
    write(D), 
    write(" - Certificato: "),
    write(C),
    write(" - Gas: "),
    write(G), nl,
    write("Query: "),
    init_var(true, Delta, VarList, Gamma),
    nb_setval(query, (0, 0, n)), 
    D2 is 2 * D,
    !,      
    (queryL(Q, G, D, D2, C, Delta, VarList, Gamma, P, T) ->  
        (
            write("Test non passato.\nControesempio\n"), 
            write(P),            
            (
                (T == prog) -> 
                    (
                        write("\nPrettyPrinter\n"),
                        writeProg(P, "")
                    ) ; (
                        (T == expr) -> (
                            write("\nPrettyPrinter\n"),
                            writeExp(P)
                        ) ; true
                    )
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

