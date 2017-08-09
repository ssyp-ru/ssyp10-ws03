-module(bin).
-export([bin/1]).

bin(A) -> bin(A,[]).
bin(0,S) -> S;
bin(A,S) -> 
	L=A div 2,
	W=A rem 2,
	bin(L,[W+$0|S]).