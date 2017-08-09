-module(sort).
-export([do/1]).
-export([len/2]).
-export([max/4]).

do(Lists) ->
	L=list_to_tuple(len(Lists,[])),
	S=max(L,list_to_tuple(Lists),1,length(Lists)),
	tuple_to_list(S).
	
len([],Leng) -> Leng;
len(Lists,Leng) -> [L|Ists]=Lists,
	len(Ists,[length(L)|Leng]).

max(L,S,I,1) -> if	I/=tuple_size(L) -> max(L,S,I+1,length(tuple_to_list(L)));
							I==tuple_size(L) -> S end;
max(L,S,I,D) ->
	L1 = element	(I,L),
	S1 = element	(I,S),
	L2 = element	(D,L),
	S2 = element	(D,S),
	if	L2>L1 ->	S3=setelement(I, S, S2),	
							S4=setelement(D, S3, S1),
							L3=setelement(I, L, L2),	
							L4=setelement(D, L3, L1);
		L2=<L1 ->  S4=S, L4=L
	end,
	max(L4,S4,I,D-1).