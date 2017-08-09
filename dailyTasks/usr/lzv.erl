-module(lzv).
-export([lzv/1]).
-export([poiskGO/2]).
-export([lzv3/2]).


lzv(S1)
 -> lzv2(S1,[],6).

%%lzv2(S1,S2,N)
%% -> if  N == length(S1)
%%			->  S2;
%%		N < length(S1)
%%			->  E = (length(S1)) - N,
%%				if  E >= 8 -> EE = 8;
%%					E < 8 -> EE = E end,
%%				[UU,AA] = lzv3(
%%				lists:reverse(lists:nthtail(N,lists:reverse(S1))),
%%				lists:reverse(lists:nthtail((length(lists:nthtail(N-1,S1)))-EE,lists:reverse(lists:nthtail(N-1,S1))))),
%%				if  AA /= false
%%						-> lzv2(S1,[AA|S2],N+UU);
%%					AA == false
%%						-> lzv2(S1,[["!",lists:nth(N,S1)]|S2],N+1)end end.

lzv2(S1,S2,N)
 -> if  N > length(S1)
			->  lists:reverse(S2);
		N =< length(S1)
			->  E = (length(S1)) - N+1,
				if  E >= 8 -> EE = 8;
					E < 8 -> EE = E end,
				[UU,[AA,BB]] = lzv3(lists:reverse(lists:nthtail(length(S1)-N+1,lists:reverse(S1))),
				lists:reverse(lists:nthtail((length(lists:nthtail(N-1,S1)))-EE,lists:reverse(lists:nthtail(N-1,S1)))))end.
%%				if  AA /= false
%%						-> io:format("o"),lzv2(S1,[BB|[AA|S2]],N+UU);
%%					AA == false
%%						-> io:format("p"),lzv2(S1,[lists:nth(N,S1)|[0|S2]],N+1)end end.
						
lzv3(S1,S2)
 -> poiskGO(lists:reverse(S1),lists:reverse(S2)).

poiskGO(_,[])
 -> [0,[false,0]];
poiskGO(S1,S2)
 -> AA = poisk(S1,S1,S2,S2,1),                 
	U = lists:reverse(lists:nthtail(1,lists:reverse(S2))),
	if  AA == false
			-> poiskGO(S1,U);
		AA /= false
			-> [length(S2),[AA,length(S2)]]end.
	
poisk(_,_,[],_,N) 
 -> N;
poisk([],_,_,_,_) 
 -> false;
poisk([A|S1],S4,[B|S2],S3,N)
 -> if  A == B 
			-> poisk(S1,S4,S2,S3,N);
		A /= B
			-> poisk(lists:nthtail(N,S4),S4,S3,S3,N+1) end.