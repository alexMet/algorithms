bfs([], C1, Hash1, [], C2, Hash2, Ans) :-
  reverse(C1, C12),
  reverse(C2, C21),
  bfs(C12, [], Hash1, C21, [], Hash2, Ans).
bfs([], C1, Hash1, [(Cur2, Moves)|Rest2], C2, Hash2, Ans) :-
	(get_assoc(Cur2, Hash1, Val1) ->
		append(Val1, Moves, Ans), !
	;
		move1l(Cur2, Moves, Hash2, New1, Hash21),
		append(New1, C2, C21),
		move2l(Cur2, Moves, Hash21, New2, Hash22),
		append(New2, C21, C22),
		move3l(Cur2, Moves, Hash22, New3, Hash23),
		append(New3, C22, C23),
		move4l(Cur2, Moves, Hash23, New4, Hash24),
		append(New4, C23, C24),
		bfs([], C1, Hash1, Rest2, C24, Hash24, Ans), !
  ).
bfs([(Cur1, Moves)|Rest1], C1, Hash1, [], C2, Hash2, Ans) :-
	(get_assoc(Cur1, Hash2, Val2) ->
		append(Moves, Val2, Ans), !
	;
		move1r(Cur1, Moves, Hash1, New1, Hash11),
		append(New1, C1, C11),
		move2r(Cur1, Moves, Hash11, New2, Hash12),
		append(New2, C11, C12),
		move3r(Cur1, Moves, Hash12, New3, Hash13),
		append(New3, C12, C13),
		move4r(Cur1, Moves, Hash13, New4, Hash14),
		append(New4, C13, C14),
		bfs(Rest1, C14, Hash14, [], C2, Hash2, Ans), !
  ).
bfs([(Cur1, Moves1)|Rest1], C1, Hash1, [(Cur2, Moves2)|Rest2], C2, Hash2, Ans) :-
	(get_assoc(Cur1, Hash2, Val2) ->
		append(Moves1, Val2, Ans), !
	;
		get_assoc(Cur2, Hash1, Val1) ->
			append(Val1, Moves2, Ans), !
		;
			move1r(Cur1, Moves1, Hash1, New1, Hash11),
			append(New1, C1, C11),
			move2r(Cur1, Moves1, Hash11, New2, Hash12),
			append(New2, C11, C12),
			move3r(Cur1, Moves1, Hash12, New3, Hash13),
			append(New3, C12, C13),
			move4r(Cur1, Moves1, Hash13, New4, Hash14),
			append(New4, C13, C14),
			move1l(Cur2, Moves2, Hash2, New5, Hash21),
			append(New5, C2, C21),
			move2l(Cur2, Moves2, Hash21, New6, Hash22),
			append(New6, C21, C22),
			move3l(Cur2, Moves2, Hash22, New7, Hash23),
			append(New7, C22, C23),
			move4l(Cur2, Moves2, Hash23, New8, Hash24),
			append(New8, C23, C24),
			bfs(Rest1, C14, Hash14, Rest2, C24, Hash24, Ans), !
  ).


move1r([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([C,B,F,A,E,D,G,H,I,J,K,L], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append(Moves, [49], NewMoves),
		put_assoc([C,B,F,A,E,D,G,H,I,J,K,L], Hash, NewMoves, NewHash),
		Child = [([C,B,F,A,E,D,G,H,I,J,K,L], NewMoves)], !
  ).


move2r([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([A,D,C,G,B,F,E,H,I,J,K,L], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append(Moves, [50], NewMoves),
		put_assoc([A,D,C,G,B,F,E,H,I,J,K,L], Hash, NewMoves, NewHash),
		Child = [([A,D,C,G,B,F,E,H,I,J,K,L], NewMoves)], !
  ).


move3r([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([A,B,C,D,E,H,G,K,F,J,I,L], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append(Moves, [51], NewMoves),
		put_assoc([A,B,C,D,E,H,G,K,F,J,I,L], Hash, NewMoves, NewHash),
		Child = [([A,B,C,D,E,H,G,K,F,J,I,L], NewMoves)], !
  ).


move4r([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([A,B,C,D,E,F,I,H,L,G,K,J], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append(Moves, [52], NewMoves),
		put_assoc([A,B,C,D,E,F,I,H,L,G,K,J], Hash, NewMoves, NewHash),
		Child = [([A,B,C,D,E,F,I,H,L,G,K,J], NewMoves)], !
  ).


move1l([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([D,B,A,F,E,C,G,H,I,J,K,L], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append([49], Moves, NewMoves),
		put_assoc([D,B,A,F,E,C,G,H,I,J,K,L], Hash, NewMoves, NewHash),
		Child = [([D,B,A,F,E,C,G,H,I,J,K,L], NewMoves)], !
  ).


move2l([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([A,E,C,B,G,F,D,H,I,J,K,L], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append([50], Moves, NewMoves),
		put_assoc([A,E,C,B,G,F,D,H,I,J,K,L], Hash, NewMoves, NewHash),
		Child = [([A,E,C,B,G,F,D,H,I,J,K,L], NewMoves)], !
  ).


move3l([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([A,B,C,D,E,I,G,F,K,J,H,L], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append([51], Moves, NewMoves),
		put_assoc([A,B,C,D,E,I,G,F,K,J,H,L], Hash, NewMoves, NewHash),
		Child = [([A,B,C,D,E,I,G,F,K,J,H,L], NewMoves)], !
  ).


move4l([A,B,C,D,E,F,G,H,I,J,K,L], Moves, Hash, Child, NewHash) :-
	(get_assoc([A,B,C,D,E,F,J,H,G,L,K,I], Hash, _) ->
		Child = [], NewHash = Hash, !
	;
		append([52], Moves, NewMoves),
		put_assoc([A,B,C,D,E,F,J,H,G,L,K,I], Hash, NewMoves, NewHash),
		Child = [([A,B,C,D,E,F,J,H,G,L,K,I], NewMoves)], !
  ).


diapragmateysi(State, Answer) :-
	empty_assoc(HashF),
	empty_assoc(HashB),
	string_to_list(State, Start),
	put_assoc(Start, HashF, [], HashF1),
	string_to_list("bgbGgGGrGyry", Stop),
	put_assoc(Stop, HashB, [], HashB1),
	bfs([(Start,[])], [], HashF1, [(Stop,[])], [], HashB1, Moves),
	string_codes(Answer, Moves), !.
