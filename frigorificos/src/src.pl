:-use_module(library(clpfd)).
:-use_module(library(lists)).
cost([],[],0).
cost([H1|T1],[H2|T2],R):-
        cost(T1,T2,R1),
        R #= H1 * H2 + R1.
costM([],[],0).
costM([H1|T1],[H2|T2],R):-
        cost(H1,H2,R1),
        costM(T1,T2,R2),
        R #= R1 + R2.
restrict([],[],_,_).
restrict([Xh|Xt],[Sh|St],Op,N):-
        length(Xh,N),
        domain(Xh, 0, Sh),
        sum(Xh,Op,Sh),
        restrict(Xt,St,Op,N).
frig(D,S,C,Vars):-
        length(S,Sn),
        length(D,Dn),
        length(Vars,Sn),
        restrict(Vars,S, #=< ,Dn),
        transpose(Vars,VarsT),
        restrict(VarsT,D, #=,Dn),
        transpose(Vars,VarsT),
        append(Vars, L),
        costM(Vars, C, Tc),
        labeling([minimize(Tc)], L).