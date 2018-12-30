:- use_module(library(readutil)).
:- use_module(library(heaps)).
:- use_module(library(assoc)).
:- use_module(library(lists)).


read_input(File, Ans) :-
  open(File, read, Stream),
  read_segs(Stream, Ans),
  close(Stream), !.


read_segs(Stream, [Line|Rest]) :-
  read_line(Stream, Line),
	(Line = [] ->
    !, Rest = []
  ;
    read_segs(Stream, Rest)
  ).


read_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  (Line = end_of_file ->
    List = []
  ;
    List = Line
  ).


% '.' = 46, 'S' = 83, 'E' = 69, 'X' = 88
row_to_assoc([], _, _, Ans, Ans, _, _).
row_to_assoc([46|Xs], I, J, Acc, Ans, Start, End) :-
  NewJ is J + 1,
  row_to_assoc(Xs, I, NewJ, [(I, J)-(0, 1000000, [])|Acc], Ans, Start, End), !.
row_to_assoc([88|Xs], I, J, Acc, Ans, Start, End) :-
  NewJ is J + 1,
  row_to_assoc(Xs, I, NewJ, Acc, Ans, Start, End), !.
row_to_assoc([83|Xs], I, J, Acc, Ans, (I, J), End) :-
  NewJ is J + 1,
  row_to_assoc(Xs, I, NewJ, [(I, J)-(0, 1000000, [])|Acc], Ans, (I, J), End), !.
row_to_assoc([69|Xs], I, J, Acc, Ans, Start, (I, J)) :-
  NewJ is J + 1,
  row_to_assoc(Xs, I, NewJ, [(I, J)-(0, 1000000, [])|Acc], Ans, Start, (I, J)), !.


create_assoc([[]|_], _, Ans, Ans, _, _).
create_assoc([Row|Rs], N, Acc, Ans, Start, End) :-
  NewN is N + 1,
  row_to_assoc(Row, N, 1, Acc, NewAcc, Start, End),
  create_assoc(Rs, NewN, NewAcc, Ans, Start, End), !.


move_up(Hash, Heap, (I, J), Cost, Moves, NewHash, NewHeap) :-
  NewI is I - 1,
  NewCost is Cost + 3,
  (NewI > 0, get_assoc((NewI, J), Hash, (0, OldCost, _)), NewCost < OldCost ->
    put_assoc((NewI, J), Hash, (0, NewCost, [u|Moves]), NewHash),
    add_to_heap(Heap, NewCost, (NewI, J), NewHeap), !
  ;
    NewHash = Hash, NewHeap = Heap, !
  ).


move_down(N, Hash, Heap, (I, J), Cost, Moves, NewHash, NewHeap) :-
  NewI is I + 1,
  NewCost is Cost + 1,
  (NewI =< N, get_assoc((NewI, J), Hash, (0, OldCost, _)), NewCost < OldCost ->
    put_assoc((NewI, J), Hash, (0, NewCost, [d|Moves]), NewHash),
    add_to_heap(Heap, NewCost, (NewI, J), NewHeap), !
  ;
    NewHash = Hash, NewHeap = Heap, !
  ).


move_left(Hash, Heap, (I, J), Cost, Moves, NewHash, NewHeap) :-
  NewJ is J - 1,
  NewCost is Cost + 2,
  (NewJ > 0, get_assoc((I, NewJ), Hash, (0, OldCost, _)), NewCost < OldCost ->
    put_assoc((I, NewJ), Hash, (0, NewCost, [l|Moves]), NewHash),
    add_to_heap(Heap, NewCost, (I, NewJ), NewHeap), !
  ;
    NewHash = Hash, NewHeap = Heap, !
  ).


move_right(M, Hash, Heap, (I, J), Cost, Moves, NewHash, NewHeap) :-
  NewJ is J + 1,
  NewCost is Cost + 1,
  (NewJ =< M, get_assoc((I, NewJ), Hash, (0, OldCost, _)), NewCost < OldCost ->
    put_assoc((I, NewJ), Hash, (0, NewCost, [r|Moves]), NewHash),
    add_to_heap(Heap, NewCost, (I, NewJ), NewHeap), !
  ;
    NewHash = Hash, NewHeap = Heap, !
  ).


dijkstra(N, M, Hash, Heap, End, AnsC, AnsM) :-
  get_from_heap(Heap, Cost, Cur, Heap1),
  (\+ Cur = End ->
    (get_assoc(Cur, Hash, (0, D, Moves)) ->
      put_assoc(Cur, Hash, (1, D, Moves), Hash1),
      move_up(Hash1, Heap1, Cur, Cost, Moves, Hash2, Heap2),
      move_down(N, Hash2, Heap2, Cur, Cost, Moves, Hash3, Heap3),
      move_left(Hash3, Heap3, Cur, Cost, Moves, Hash4, Heap4),
      move_right(M, Hash4, Heap4, Cur, Cost, Moves, NewHash, NewHeap),
      dijkstra(N, M, NewHash, NewHeap, End, AnsC, AnsM), !
    ;
      dijkstra(N, M, Hash, Heap1, End, AnsC, AnsM), !
    )
  ;
    get_assoc(Cur, Hash, (_, AnsC, Moves)),
    reverse(Moves, AnsM), !
  ).


moredeli(File, Cost, Ans) :-
  read_input(File, Map),
  create_assoc(Map, 1, [], [(N, M)-(X, Y, Z)|KeyValueList], Start, End),
  reverse([(N, M)-(X, Y, Z)|KeyValueList], RevKeyValueList),
  ord_list_to_assoc(RevKeyValueList, Hash),
  empty_heap(H),
  add_to_heap(H, 0, Start, Heap),
  dijkstra(N, M, Hash, Heap, End, Cost, Ans), !.
