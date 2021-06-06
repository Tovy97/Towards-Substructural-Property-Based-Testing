#! /usr/bin/swipl -f -q

:- ['generator.pro'].
:- ['ljt.ll'].
:- ['ljb.ll'].

:- initialization(main).

main :-                                                 % query Q D   dove Q è la query e D è la dimensione dell'implicazione
    current_prolog_flag(argv, [Q1, D1]),
    atom_number(Q1, Q),
    atom_number(D1, D),    
    (query(Q, D, I) ->  
        (write("Test non passato. Controesempio: "), write(I), nl) ;
        write("Test passato\n") 
    ),
    halt.

%%%%%%%%%%%%%QUERY%%%%%%%%%%%%%%%
query(0, D, I) :-                                                   % DIMOSTRATO DA LJT MA NON DA LJB (FALSO NEGATIVO)
    genImp(D, I), 
    seq([], [], pv(I)), 
    \+ seq([], [], pvb(I)).
query(1, D, I) :-                                                   % NO FALSO POSITIVO --> OK
    genImp(D, I), 
    seq([], [], pvb(I)), 
    \+ seq([], [], pv(I)).    

%%%%%%%%%
%TODO: ./query 0 4 genera un falso negativo
%               (A implies ((A implies (A implies B)) implies B))   

% In generale ho notato che generando formule con D >= 4 si creano falsi negativi

