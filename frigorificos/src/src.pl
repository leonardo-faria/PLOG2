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
        restrict(VarsT,D, #=,Sn),
        transpose(Vars,VarsT),
        append(Vars, L),
        costM(Vars,C, Tc),
        reset_timer,
        labeling([bisect,minimize(Tc)], L),
        print_end(S, D,Vars),
        print_time,
        fd_statistics.

reset_timer :- statistics(walltime,_).  
print_time :-
        statistics(walltime,[_,T]),
        TS is ((T//10)*10)/1000,
        nl, write('Time: '), write(TS), write('s'), nl, nl.


print_end(L1,L2,Vars):-
        write('\t\t-------------------------------------------------'),nl,
        write('\tS\\D'),
        print_bar(L2),
        write('\t|'),
        nl,
        write('-----------------------------------------------------------------'),nl,
        print_tab(Vars,L1).
print_bar([]).
print_bar([H|T]) :-
        write('\t|\t'),
        write(H),
        print_bar(T).
print_line([]).
print_line([H|T]) :-
        write('\t|\t'),
        write(H),
        print_line(T).
print_tab([],[]).
print_tab([H|T],[L1|R1]) :-
        write('|\t'),
        write(L1),
        print_line(H), write('\t|'), 
        nl,write('-----------------------------------------------------------------'),
        nl,
        print_tab(T,R1).
