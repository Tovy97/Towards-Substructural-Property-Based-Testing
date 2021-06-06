:- ['../../Implementazione/Interprete/Classic/interp.pro'].
:- ['../../Imp/CPS/Classic/classicHelper.pro'].

:- op(120, xfy, :).

istr_check_type(const_cmd(b(_)), _, STK, [bool | STK], K) <-
    K.
istr_check_type(const_cmd(i(_)), _, STK, [int | STK],K) <-
    K.
istr_check_type(var_cmd(X), Type, STK, [T | STK], K) <-
    member(type(T, X), Type) &
    K.
istr_check_type(setvar_cmd(X), Type, [T | STK], STK, K) <-    
    member(type(T, X), Type) &
    K.
istr_check_type(add_cmd, _, [int, int | STK], [int | STK], K) <-
    K.
istr_check_type(sub_cmd, _, [int, int | STK], [int | STK], K) <-
    K.
istr_check_type(mul_cmd, _, [int, int | STK], [int | STK], K) <-
    K.
istr_check_type(and_cmd, _, [bool, bool | STK], [bool | STK], K) <-
    K.
istr_check_type(or_cmd, _, [bool, bool | STK], [bool | STK], K) <-
    K.
istr_check_type(not_cmd, _, [bool | STK], [bool | STK], K) <-
    K.
istr_check_type(eq_cmd, _, [bool, bool | STK], [bool | STK], K) <-
    K.
istr_check_type(eq_cmd, _, [int, int | STK], [bool | STK], K) <-
    K.
istr_check_type(branch_cmd(_), _, _, _, K) <-
    K.
istr_check_type(bfl_cmd(_), _, [bool | STK], STK, K) <-
    K.

cod_check_type(halt, _, _, K) <-
    K.
cod_check_type(H : T, Type, STK_IN, K) <-
    istr_check_type(H, Type, STK_IN, STK_OUT, cod_check_type(T, Type, STK_OUT, K)).

check_asm_type(A, Type) <-
    cod_check_type(A, Type, [], true).