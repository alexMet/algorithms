read_input(File, N, Heights) :-
  open(File, read, Stream),
  read_line(Stream, [N]),
  read_line(Stream, Heights),
  close(Stream), !.


read_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  atom_codes(A, Line),
  atomic_list_concat(As, ' ', A),
  maplist(atom_number, As, List).


heightsLeft(_, [], Ans, Ans, Ans2, Ans2).
heightsLeft(I, [H|Hs], [(Ai, A)|Acc], Ans, Acc2, Ans2) :-
  NewI is I + 1,
  (H < A ->
    heightsLeft(NewI, Hs, [(I, H),(Ai, A)|Acc], Ans, [H|Acc2], Ans2), !
  ;
    heightsLeft(NewI, Hs, [(Ai, A)|Acc], Ans, [H|Acc2], Ans2), !
  ).


heightsRight(_, [], Ans, Ans).
heightsRight(I, [H|Hs], [(Ai, A)|Acc], Ans) :-
  NewI is I - 1,
  (H > A ->
    heightsRight(NewI, Hs, [(I, H),(Ai, A)|Acc], Ans), !
  ;
    heightsRight(NewI, Hs, [(Ai, A)|Acc], Ans), !
  ).


maxSlope(_, [], Ans, Ans).
maxSlope([], _, Ans, Ans).
maxSlope([(I, Li)|Ls], [(J, Rj)|Rs], Max, Ans) :-
  ( Li =< Rj ->
    NewMax is J - I,
    (NewMax > Max ->
      maxSlope([(I, Li)|Ls], Rs, NewMax, Ans), !
    ;
      maxSlope([(I, Li)|Ls], Rs, Max, Ans), !
    )
  ;
    maxSlope(Ls, [(J, Rj)|Rs], Max, Ans), !
  ).


skitrip(Filename, Ans) :-
  read_input(Filename, N, [H|Hs]),
  heightsLeft(2, Hs, [(1, H)], AnsL, [H], [RH|RHs]),
  NewN is N - 1,
  heightsRight(NewN, RHs, [(N, RH)], AnsR),
  reverse(AnsL, RL),
  maxSlope(RL, AnsR, 0, Ans), !.
