:- ['llinterp.pro'].

%% Some simple propositional linear logic formulas. 
formula(1,  a -> a).
formula(2,  a -> b -> a x b).
formula(3,  a => bang(a)).
formula(4,  a & b -> a & b).
formula(5,  a => a & a).
formula(6,  a => a x a).
formula(7,  a & b -> a).
formula(8,  a -> a & a).
formula(9,  a => b => bang(a & b)).
formula(99,  a => b => a & a).
formula(999,  a => b => a x a).
formula(10, a & b => bang(a) x bang(b)).
formula(11, (a -> b -> c) -> (a => b => c)).
formula(12, (a x b -> c) -> (a -> b -> c)).
formula(13, a -> b -> a x erase).
formula(14, a -> b -> erase x a).
formula(15, a -> b -> b x erase x a).
formula(16, a -> b => b x erase x a).
formula(17, (a & b) -> (a & b) -> (a x a) & (a x b) & (b x b)).
formula(18, a => b -> b x bang(a)).
formula(19, a => b -> bang(a) x b).
formula(20, a -> a x a). %false
formula(21, a -> a -> a). %false
formula(22, a -> b -> a & b). %false
formula(23, a & b -> a x b). %false
formula(24, (a -> b -> c) -> (a -> b) -> a -> c). %false
formula(25, (a -> b -> c) -> (a -> b) -> (a -> a -> c)).
formula(26, a -> b -> c -> erase).
formula(27,  c => a -> b ->  c x (a -> b x erase)). 

test(N) :-
	formula(N,F),
	Cert = (qheight(3)  <> qsize(5, _)),
	seq(Cert,[], [], F).

% The query    ?- test(N).   will show that the formulas
% 20, 21, 22, 23, 24 are not provable, that 17 has eight proofs,
% and that 25 has two proofs.

:- test(1).             % TRUE
:- test(2).             % TRUE
:- test(3).             % TRUE
:- \+ test(4).          % FALSE (MANCA BC)
:- test(5).             % TRUE
:- test(6).             % TRUE
:- \+ test(7).          % FALSE (MANCA BC)
:- test(8).             % TRUE
:- test(9).             % TRUE
:- \+ test(10).         % FALSE (MANCA BC)
:- \+ test(11).         % FALSE (MANCA BC)
:- \+ test(12).         % FALSE (MANCA BC)
:- test(13).            % TRUE
:- test(14).            % TRUE
:- test(15).            % TRUE
:- test(16).            % TRUE
:- \+ test(17).         % FALSE (MANCA BC)
:- test(18).            % TRUE
:- test(19).            % TRUE
:- \+ test(20).         % FALSE
:- \+ test(21).         % FALSE
:- \+ test(22).         % FALSE
:- \+ test(23).         % FALSE
:- \+ test(24).         % FALSE
:- \+ test(25).         % FALSE (MANCA BC)
:- test(26).            % TRUE
:- test(27).            % TRUE
:- test(99).            % TRUE
:- test(999).           % TRUE
