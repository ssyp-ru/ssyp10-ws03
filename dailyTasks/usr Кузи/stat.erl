-module(stat).
-export([stat/2]).

stat(F,Size) ->
	T=list_to_tuple(for(256)),
	{ok,File}=file:read(F,Size),
	Fi=binary_to_list(File),
	S=filter(tuple_to_list(key(Fi,T)),alpha([]),[],[]),
	[Q,W|[]]=S,
	E=list_to_tuple(Q),
	R=list_to_tuple(W),
	%%io:format("")
	file:close(F),
	maxi(R,E).

for(1) -> [0];
for(Max) -> [0|for(Max-1)].

key([],T) -> T;
key(List,T) ->   [L|Ist]=List,
	I=element(L,T),
	T2=setelement(L,T,I+1),
	key(Ist, T2).

alpha(S) -> if	length(S)<256 -> alpha([length(S)-1|S]);
						length(S)>=256 -> S end.

filter([],[],T2,S2) ->[T2,S2];
filter(T1,S1,T2,S2) ->
	[Et|Et1]=T1,
	[Es|Es1]=S1,
	if	Et/=0 -> filter(Et1,Es1,[Et|T2],[Es|S2]);
		Et==0 -> filter(Et1,Es1,T2,S2) end.

maxi(L,S) -> maxi(L,S,tuple_size(L),1,1).
maxi(L,S,D,D,M) ->if D<tuple_size(L) ->
									S1=element(M,S), L1=element(M,L),
									S2=element(D,S), L2=element(D,L),
									S3=setelement(D,S,S1), L3=setelement(D,L,L1),
									S4=setelement(M,S3,S2), L4=setelement(M,L3,L2),
									maxi(L4,S4,tuple_size(L4),D+1,D+1);
									D>=tuple_size(L) -> L end;
maxi(L,S,I,D,M) -> 
	S1=element(I,S), M1=element(M,S),
	if	S1>M1 -> maxi(L,S,I-1,D,I);
		S1=<M1 -> maxi(L,S,I-1,D,M) end.