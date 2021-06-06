:- op(150,xfy,::).  %    non-empty list constructor

%%%%%%%%%%% QUICKSORT %%%%%%%%%%%

quicksort(nil, nil) <- true.
quicksort(H::L, S) <-     
    partition(H, L, LMin, LMax) x
    quicksort(LMin, SMin) x    
    quicksort(LMax, SMax) x
    appendList(SMin, H::SMax, S).
