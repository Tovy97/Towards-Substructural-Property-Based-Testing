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
% cex di Marco  c], [a,b], c x a x (a -> b x erase), 
formula(27,  c => a -> b ->  c x (a -> b x erase)). 

test(N, Slack) :- formula(N,F), prove([], [], F, Slack).

% To use these examples, load both llinterp.pro and this file.
% The query    ?- test(N).   will show that the formulas
% 20, 21, 22, 23, 24 are not provable, that 17 has eight proofs,
% and that 25 has two proofs.

:- test(1, 0).             % TRUE
:- test(2, 0).             % TRUE
:- test(3, 0).             % TRUE
:- test(4, 0).             % TRUE, senza bc FALSE
:- test(5, 0).             % FALSE
:- test(6, 0).             % TRUE
:- test(7, 0).             % TRUE, senza bc FALSE
:- test(8, 0).             % TRUE
:- test(9, 0).             % FALSE
:- test(10, 0).            % TRUE, senza bc FALSE
:- test(11, 0).            % TRUE, senza bc FALSE
:- test(12, 0).            % TRUE, senza bc FALSE
:- test(13, 1).            % TRUE
:- test(14, 1).            % TRUE
:- test(15, 1).            % TRUE
:- test(16, 1).            % TRUE
:- test(17, 0).            % TRUE, senza bc FALSE
:- test(18, 0).            % TRUE
:- test(19, 0).            % TRUE
:- \+ test(20, 0).         % TRUE [NOT FALSE]
:- \+ test(21, 0).         % TRUE [NOT FALSE]
:- \+ test(22, 0).         % TRUE [NOT FALSE]
:- \+ test(23, 0).         % TRUE [NOT FALSE]
:- \+ test(24, 0).         % TRUE [NOT FALSE]
:- test(25, 0).            % TRUE, senza bc FALSE
:- test(26, 1).            % TRUE
:- test(27, 1).            % TRUE
:- test(99, 0).            % TRUE
:- test(999, 0).           % TRUE