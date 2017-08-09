%% Упорядочивает строки по числу элементов
-module(long).
-export([start/1]).

start(S1) -> len1(S1,[]).

len1([],S2) -> S2;
len1(S1,S2)
 -> AA = len2(S1,[]),
	len1(lenrev(lendel(S1,AA,[]),[]),[AA|S2]).

len2([],Max) -> Max;
len2([A|S1],Max)
 -> if length(A) > length(Max) -> len2(S1,A); length(A) =< length(Max) -> len2(S1,Max) end.

lendel([],A,S2) -> S2;
lendel([B|S1],A,S2)
 -> if  B == A -> lendel(S1,A,S2);
		B /= A -> lendel(S1,A,[B|S2])end.

lenrev([],S2) -> S2;		
lenrev([A|S1],S2)
 -> lenrev(S1,[A|S2]).