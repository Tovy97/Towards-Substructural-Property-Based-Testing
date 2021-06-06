:- ['ljt.ll'].
:- ['ljb.ll'].

%%%%%% LJT 

:- prove([hyp(at(p))], [del], pv(at(p))).                                                   % .; p |- p

:- prove([], [], pv(imp(at(p), at(p)))).                                                    % .; . |- (p -> p) 

:- prove([hyp(at(p))], [del], pv(imp(at(q),at(p)))).                                        % .; p |- (q -> p)

:- \+ prove([hyp(at(p))], [del], pv(imp(at(p),at(q)))).                                     % .; p |- (p -> q)

:- prove([hyp(at(p)), hyp(at(q))], [del,del], pv(imp(at(p),at(q)))).                        % .; p, q |- (p -> q)

:- prove([hyp(at(p)), hyp(imp(at(p), at(q)))], [del, del], pv(imp(at(p),at(q)))).           % .; p, (p -> q) |- (p -> q)

:- prove([hyp(at(p)), hyp(imp(at(p), at(q)))], [del, del], pv(at(q))).                      % .; p, (p -> q) |- q

:- prove([bang(hyp(at(p)))], [bang(hyp(at(p)))], pv(at(p))).                                % !p; . |- p

%%%%%% LJB 

:- prove([hypb(at(p))], [del], pvb(at(p))).                                                 % .; p |- p

:- prove([], [], pvb(imp(at(p), at(p)))).                                                   % .; . |- (p -> p) 

:- prove([hypb(at(p))], [del], pvb(imp(at(q),at(p)))).                                      % .; p |- (q -> p)

:- \+ prove([hypb(at(p))], [del], pvb(imp(at(p),at(q)))).                                   % .; p |- (p -> q)

:- prove([hypb(at(p)), hypb(at(q))], [del, del], pvb(imp(at(p),at(q)))).                    % .; p, q |- (p -> q)

:- prove([hypb(at(p)), hypb(imp(at(p), at(q)))], [del, del], pvb(imp(at(p),at(q)))).        % .; p, (p -> q) |- (p -> q)

:- prove([hypb(at(p)), hypb(imp(at(p), at(q)))], [del, del], pvb(at(q))).                   % .; p, (p -> q) |- q

:- prove([bang(hypb(at(p)))], [bang(hypb(at(p)))], pvb(at(p))).                             % !p; . |- p

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% LJT 

:- seq([], [hyp(at(p))], pv(at(p))).                                                        % .; p |- p

:- seq([], [], pv(imp(at(p), at(p)))).                                                      % .; . |- (p -> p) 

:- seq([], [hyp(at(p))], pv(imp(at(q),at(p)))).                                             % .; p |- (q -> p)

:- \+ seq([], [hyp(at(p))], pv(imp(at(p),at(q)))).                                          % .; p |- (p -> q)

:- seq([], [hyp(at(p)), hyp(at(q))], pv(imp(at(p),at(q)))).                                 % .; p, q |- (p -> q)

:- seq([], [hyp(at(p)), hyp(imp(at(p), at(q)))], pv(imp(at(p),at(q)))).                     % .; p, (p -> q) |- (p -> q)

:- seq([], [hyp(at(p)), hyp(imp(at(p), at(q)))], pv(at(q))).                                % .; p, (p -> q) |- q

:- seq([hyp(at(p))], [], pv(at(p))).                                                        % !p; . |- p

:- seq([hyp(at(p))], [hyp(at(q))], pv(imp(at(q), at(p)))).                                  % !p; q |- (q -> p)

:- seq([hyp(at(p))], [hyp(at(q))], pv(imp(at(p), imp(at(q), at(p))))).                      % !p; q |- (p -> (q -> p))

%%%%%% LJB 

:- seq([], [hypb(at(p))], pvb(at(p))).                                                      % .; p |- p

:- seq([], [], pvb(imp(at(p), at(p)))).                                                     % .; . |- (p -> p) 

:- seq([], [hypb(at(p))], pvb(imp(at(q),at(p)))).                                           % .; p |- (q -> p)

:- \+ seq([], [hypb(at(p))], pvb(imp(at(p),at(q)))).                                        % .; p |- (p -> q)

:- seq([], [hypb(at(p)), hypb(at(q))], pvb(imp(at(p),at(q)))).                              % .; p, q |- (p -> q)

:- seq([], [hypb(at(p)), hypb(imp(at(p), at(q)))], pvb(imp(at(p),at(q)))).                  % .; p, (p -> q) |- (p -> q)

:- seq([], [hypb(at(p)), hypb(imp(at(p), at(q)))], pvb(at(q))).                             % .; p, (p -> q) |- q

:- seq([(hypb(at(p)))], [], pvb(at(p))).                                                    % !p; . |- p

:- seq([(hypb(at(p)))], [hypb(at(q))], pvb(imp(at(q), at(p)))).                             % !p; q |- (q -> p)

:- seq([(hypb(at(p)))], [hypb(at(q))], pvb(imp(at(p), imp(at(q), at(p))))).                 % !p; q |- (p -> (q -> p))
