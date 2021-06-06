:- ['../../../Implementazione/Interprete/Classic/interp.pro'].

replace(EOld, [EOld | L], ENew, [ENew | L]) <- true.
replace(EOld, [H | L], ENew, [H | R]) <- 
    notEq(EOld, H) &
    replace(EOld, L, ENew, R).
%! replace(+OldElement, +OldList, +NewElement, -NewList).

member(E, [E | _]) <- true.
member(E, [H | L]) <- 
    notEq(E, H) &
    member(E, L).
%! member(+Element, +List).

select(E, [E | L], L) <- true.
select(E, [H | L], [H | R]) <- 
    notEq(E, H) &
    select(E, L, R).
%! select(+Element, +ListIn, - ListWithoutElement).
