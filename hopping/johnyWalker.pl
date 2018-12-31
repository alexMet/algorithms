:- use_module(library(readutil)).
:- use_module(library(rbtrees)).
:- use_module(library(lists)).
:- use_module(library(pairs)).
:- use_module(library(apply_macros)).


read_input(File, N, K, B, Steps, Broken) :-
  open(File, read, Stream),
  read_line(Stream, [N, K, B]),
  read_line(Stream, Steps),
  read_line(Stream, Broken),
  close(Stream), !.


read_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  (Line = [] ->
    List = []
  ;
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List)
  ).


johny_walker(N, N, _, _, Rb, Ans) :-
  NewN is N - 1,
  rb_lookup(NewN, Ans, Rb), !.
johny_walker(I, N, Steps, Broken,  Rb, Ans) :-
  count_ways(I, Steps, Broken, Rb, NewRb),
  NewI is I + 1,
  johny_walker(NewI, N, Steps, Broken, NewRb, Ans), !.


count_ways(_, [], _, Ans, Ans).
count_ways(I, [S|Steps], Broken,  Rb, Ans) :-
  J is I - S,
  (J > 0 ->
    (rb_in(J, 0, Broken) ->
      count_ways(I, Steps, Broken, Rb, Ans), !
    ;
      rb_lookup(I, ResI, Rb),
      rb_lookup(J, ResJ, Rb),
      NewRes is ((ResI + ResJ) mod 1000000009),
      rb_update(Rb, I, NewRes, KattyRb),
      count_ways(I, Steps, Broken, KattyRb, Ans), !
    )
  ;
    Ans = Rb, !
  ).


listToKey([], Acc, Acc).
listToKey([X|Xs], Acc, Ans) :-
  listToKey(Xs, [X-0|Acc], Ans), !.


stairsKey(1, Acc, [0-1,1-1|Acc]).
stairsKey(N, Acc, Ans) :-
  NewN is N - 1,
  stairsKey(NewN, [N-0|Acc], Ans), !.


hopping(FileName, Ans) :-
  read_input(FileName, N, _, _, Steps, Broken),
  sort(Steps, NewSteps),
  listToKey(Broken, [], BrokenKeyValue),
  list_to_rbtree(BrokenKeyValue, BrokenRb),
  Nplusone is N + 1,
  stairsKey(Nplusone, [], StairsKeyValue),
  ord_list_to_rbtree(StairsKeyValue, StairsRb),
  johny_walker(2, Nplusone, NewSteps, BrokenRb, StairsRb, Ans), !.
