dromoi(File, Ans) :-
  open(File, read, Stream),
  read_line(Stream, [N, L, X]),
  read_segs(Stream, N, 1, Segs),
  sort(Segs, Sor),
  (L =< X ->
    Ans = 0
  ;
    binary(N, L, X, 1, N, Sor, -1, P),
    (P = -1 -> !, false ; Ans = P)
  ),
  close(Stream), !.

read_segs(Stream, N, D, Segs) :-
  (N > 0 ->
    Segs = [Seg|Rest],
    read_line(Stream, [S, E]),
    Seg = seg(S, E, D),
    N1 is N - 1,
    D1 is D + 1,
    read_segs(Stream, N1, D1, Rest)
  ;
    N =:= 0 -> Segs = []
  ).

read_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  atom_codes(A, Line),
  atomic_list_concat(As, ' ', A),
  maplist(atom_number, As, List).

check(Length, _, Distance, _, Telos, []) :-
  Length - Telos > Distance -> fail ; true.
check(Length, Stop, Distance, Begin, Telos, [seg(B, E, D)|Xs]) :-
  (D > Stop ->
    check(Length, Stop, Distance, Begin, Telos, Xs)
  ;
    (B > Telos -> Keno is B - Telos ; Keno = 0),
    (Keno > Distance ->
      fail
    ;
      (Keno > 0 -> New_Begin = B ; New_Begin = Begin),
      (E > Telos -> New_End = E ; New_End = Telos),
      (Length - New_End =< Distance ->
        true
      ;
        check(Length, Stop, Distance, New_Begin, New_End, Xs)
      )
    )
  ).

binary(_, _, _, Low, High, _, R, Ans) :-
  (Low > High -> (R = -1 -> Ans = -1 ; Ans = R)).
binary(N, L, X, Low, High, Xs, R, Ans) :-
  Nday is ((Low + High) div 2),
  (check(L, Nday, X, 0, 0, Xs) ->
    Pday is Nday - 1,
    binary(N, L, X, Low, Pday, Xs, Nday, Ans)
  ;
    Pday is Nday + 1,
    binary(N, L, X, Pday, High, Xs, R, Ans)
  ).
