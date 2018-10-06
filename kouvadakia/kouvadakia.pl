gcd(X, Y, Z):- X =:= Y, Z is X.
gcd(X, Y, D):- X < Y, NewY is Y - X, gcd(X, NewY, D).
gcd(X, Y, D):- X > Y, NewX is X - Y, gcd(NewX, Y, D).

expandLeft(0, Cur2, '21', X, Y, V1, _) :- Cur2 >= V1, X is V1, Y is Cur2 - V1.
expandLeft(0, Cur2, '21', X, Y, V1, _) :- Cur2 < V1, X is Cur2, Y is 0.
expandLeft(Cur1, 0, '02', X, Y, _, V2) :- X is Cur1, Y is V2.
expandLeft(V1, Cur2, '10', X, Y, V1, _) :- X is 0, Y is Cur2.
expandLeft(Cur1, Cur2, '21', X, Y, V1, _) :- Cur1 + Cur2 > V1, X is V1, Y is Cur2 - V1 + Cur1.
expandLeft(Cur1, Cur2, '21', X, Y, _, _) :- X is Cur1 + Cur2, Y is 0.

expandRight(Cur1, 0, '12', X, Y, _, V2) :- V2 > Cur1, X is 0, Y is Cur1.
expandRight(Cur1, 0, '12', X, Y, _, V2) :- V2 =< Cur1, X is Cur1 - V2, Y is V2.
expandRight(0, Cur2, '01', X, Y, V1, _) :- X is V1, Y is Cur2.
expandRight(Cur1, V2, '20', X, Y, _, V2) :- X is Cur1, Y is 0 .
expandRight(Cur1, Cur2, '12', X, Y, _, V2) :- Cur1 + Cur2 > V2, X is Cur1 - V2 + Cur2, Y is V2.
expandRight(Cur1, Cur2, '12', X, Y, _, _) :- X is 0, Y is Cur2 + Cur1.

loop(Vg, _, [], _, _, _, Vg, 1, _, _).
loop(_, Vg, [], _, _, _, Vg, 1, _, _).
loop(_, _, _, Vg, _, [], Vg, 2, _, _).
loop(_, _, _, _, Vg, [], Vg, 2, _, _).

loop(X1, Y1, [Moves1|Rest1], X2, Y2, [Moves2|Rest2], Vg, Sol, V1, V2):-
  expandLeft(X1, Y1, Moves1, X11, Y11, V1, V2),
  expandRight(X2, Y2, Moves2, X22, Y22, V1, V2),
loop(X11, Y11, Rest1, X22, Y22, Rest2, Vg, Sol, V1, V2).

kouvadakia(V1, V2, Vg, _) :- Vg > V1, Vg > V2, !, false.
kouvadakia(V1, V2, Vg, _) :- gcd(V1, V2, D), Vg mod D =\= 0, !, false.
kouvadakia(V1, V2, Vg, X) :-
  loop(0, V2, Move1, V1, 0, Move2, Vg, Y, V1, V2),
  (Y =:= 2 ->
    X = ['01'|Move2], !
  ;
    X = ['02'|Move1], !
  ).
