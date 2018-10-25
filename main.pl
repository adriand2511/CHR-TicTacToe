%% Tic Tac Toe
%%  1 | 2 | 3
%% ---+---+---
%%  4 | 5 | 6
%% ---+---+---
%%  7 | 8 | 9
%% Score: X - 7/7/7 - O

:- use_module(library(chr)).

:- chr_constraint game/1, get_game/1, inc_game/0.
game(G) \ get_game(G1) <=> G1 = G.
game(G), inc_game <=> G1 is G + 1, game(G1).

:- chr_constraint score/3, get_score/3, inc_X/0, inc_O/0, inc_D/0.
score(X, O, D) \ get_score(X1, O1, D1) <=> X1 = X, O1 = O, D1 = D.
score(X, O, D), inc_X <=> X1 is X + 1 | score(X1, O, D).
score(X, O, D), inc_O <=> O1 is O + 1 | score(X, O1, D).
score(X, O, D), inc_D <=> D1 is D + 1 | score(X, O, D1).

:- chr_constraint player/1, switch_player/0, get_player/1.
player('X'), switch_player <=> player('O').
player('O'), switch_player <=> player('X').
player(P) \ get_player(P1) <=> P1 = P.

:- chr_constraint pos/2, get_pos/2, mark_pos/2, clear_board/0.
pos(N, V) \ get_pos(N, V1) <=> V1 = V.
pos(N, _), mark_pos(N, V2) <=> pos(N, V2).
clear_board \ pos(_, _) <=> true.
clear_board <=> true.

print_help_board :-
	writeln('Tic Tac Toe'),
	writeln(' 1 | 2 | 3 '),
	writeln('---+---+---'),
	writeln(' 4 | 5 | 6 '),
	writeln('---+---+---'),
	writeln(' 7 | 8 | 9 '), nl.

print_board :-
	get_pos(1, V1), get_pos(2, V2), get_pos(3, V3),
	get_pos(4, V4), get_pos(5, V5), get_pos(6, V6),
	get_pos(7, V7), get_pos(8, V8), get_pos(9, V9),
	write(' '), write(V1), write(' | '), write(V2), write(' | '), write(V3), write(' '), nl,
	writeln('---+---+---'),
	write(' '), write(V4), write(' | '), write(V5), write(' | '), write(V6), write(' '), nl,
	writeln('---+---+---'),
	write(' '), write(V7), write(' | '), write(V8), write(' | '), write(V9), write(' '), nl.

print_score :-
	get_score(X, O, D),
	write('Score: X - '), write(X), write('/'), write(D), write('/'), write(O), write(' - O'), nl.

inc_score :-
	get_player(P),
	(
		P = 'X', inc_X;
		P = 'O', inc_O
	).

do_player_roll :-
	random_between(0, 1, X),
	(
		X = 0, P = 'X', player(P), !;
		X = 1, P = 'O', player(P)
	),
	write('Player '), write(P), write(' goes first!'), nl, nl.

get_input :-
	get_player(V),
	write(V), flush_output,
	read(X),
	integer(X), X >= 1, X =< 9,
	get_pos(X, ' '),
	mark_pos(X, V);
	get_input.

check3(P, V1, V2, V3) :- P = V1, P = V2, P = V3.

check_board :-
	get_player(P),
	get_pos(1, V1), get_pos(2, V2), get_pos(3, V3),
	get_pos(4, V4), get_pos(5, V5), get_pos(6, V6),
	get_pos(7, V7), get_pos(8, V8), get_pos(9, V9),
	(
		% win
		(
			check3(P, V1, V2, V3); check3(P, V4, V5, V6); check3(P, V7, V8, V9);
			check3(P, V1, V4, V7); check3(P, V2, V5, V8); check3(P, V3, V6, V9);
			check3(P, V1, V5, V9); check3(P, V3, V5, V7)
		),
		inc_score,
		print_board, nl,
		write('Player '), write(P), write(' wins!'), nl,
		print_score,
		clear_board,
		inc_game,
		switch_player, nl,
		start_game;

		% draw
		dif(V1, ' '), dif(V2, ' '), dif(V3, ' '),
		dif(V4, ' '), dif(V5, ' '), dif(V6, ' '),
		dif(V7, ' '), dif(V8, ' '), dif(V9, ' '),
		inc_D,
		print_board, nl,
		write('Draw!'), nl,
		print_score,
		clear_board,
		inc_game,
		switch_player, nl,
		start_game;

		% continue
		true
	).

game_loop :-
	print_board,
	get_input, nl,
	check_board,
	switch_player,
	game_loop.

start_game :-
	pos(1, ' '), pos(2, ' '), pos(3, ' '),
	pos(4, ' '), pos(5, ' '), pos(6, ' '),
	pos(7, ' '), pos(8, ' '), pos(9, ' '),
	get_game(G), write('Game '), write(G), nl,
	game_loop.

main :-
	print_help_board,
	do_player_roll,
	game(1),
	score(0, 0, 0),
	start_game.
