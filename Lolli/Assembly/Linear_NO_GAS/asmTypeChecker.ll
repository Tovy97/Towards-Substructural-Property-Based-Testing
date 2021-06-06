:- ['../../Implementazione/Interprete/2ndOrder/llinterp.pro'].

:- op(120, xfy, :).

istr_check_type(const_cmd(b(_)), K) <-
    type_stack(STK) x
    (type_stack([bool | STK]) -> K).
istr_check_type(const_cmd(i(_)), K) <-
    type_stack(STK) x
    (type_stack([int | STK]) -> K).
istr_check_type(var_cmd(X), K) <-
    type_stack(STK) x
    type(T, X) x
    (type_stack([T | STK]) -> K).
istr_check_type(setvar_cmd(X), K) <-
    type_stack([T | STK]) x
    type(T, X) x
    (type_stack(STK) -> K).
istr_check_type(add_cmd, K) <-
    type_stack([int, int | STK]) x    
    (type_stack([int | STK]) -> K).
istr_check_type(sub_cmd, K) <-
    type_stack([int, int | STK]) x    
    (type_stack([int | STK]) -> K).
istr_check_type(mul_cmd, K) <-
    type_stack([int, int | STK]) x    
    (type_stack([int | STK]) -> K).
istr_check_type(and_cmd, K) <-
    type_stack([bool, bool | STK]) x    
    (type_stack([bool | STK]) -> K).
istr_check_type(or_cmd, K) <-
    type_stack([bool, bool | STK]) x    
    (type_stack([bool | STK]) -> K).
istr_check_type(not_cmd, K) <-
    type_stack([bool | STK]) x    
    (type_stack([bool | STK]) -> K).
istr_check_type(eq_cmd, K) <-
    type_stack([bool, bool | STK]) x    
    (type_stack([bool | STK]) -> K).
istr_check_type(eq_cmd, K) <-
    type_stack([int, int | STK]) x    
    (type_stack([bool | STK]) -> K).
istr_check_type(branch_cmd(_), K) <-
    K.
istr_check_type(bfl_cmd(_), K) <-
    type_stack([bool | STK]) x 
    (type_stack(STK) -> K).

cod_check_type(halt, K) <-
    K.
cod_check_type(H : T, K) <-
    istr_check_type(H, cod_check_type(T, K)).

check_asm_type(A) <-
    type_stack([]) -> cod_check_type(A, type_stack(_)).