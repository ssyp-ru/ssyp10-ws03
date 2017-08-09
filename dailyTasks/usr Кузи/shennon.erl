-module(shennon).
-export([archive/3]).

archive(File,Size,Tmp) -> 
	{ok,Archive}=file:open(Tmp,[write,binary]),
	if	Size<4*1024*1024 -> E=stat(File);
		Size>=4*1024*1024 -> E=smallstat(File,Size) end,
	file:position(File,bof),
	shennon(File,E,Archive,Size),

shennon(File,S,Archive,Size) ->
	file:write(Archive,list_to_bin(S)),
	shen(File,S,Size,Size).

shen(F,L,A,S) ->
	if	S>4096*1024 -> {ok,File}=file:read(F,4096*1024);
		S=<4096*1024 -> {ok,File}=file:read(F,4096*1024) end,
	S=shennon(bin_to_list(File),L,[]),

shennon(File,L,S) ->
	

maxi(L,S) -> tuple_to_list(maxi(L,S,tuple_size(L),1,1)).
maxi(L,S,D,D,M) ->if D<tuple_size(L) ->
									S1=element(M,S),L1=element(M,L),
									S2=element(D,S),L2=element(D,L),
									S3=setelement(D,S,S1),L3=setelement(D,L,L1),
									S4=setelement(M,S3,S2),L4=setelement(M,L3,L2),
									maxi(L4,S4,tuple_size(L4),D+1,D+1);
									D>=tuple_size(L) -> L end;
maxi(L,S,I,D,M) -> 
	S1=element(I,S),
	M1=element(M,S),
	if	S1>M1 -> maxi(L,S,I-1,D,I);
		S1=<M1 -> maxi(L,S,I-1,D,M) end.

stat(F) ->
	T=list_to_tuple(for(255)),
	{ok,File}=file:read(F,4*1024*1024),
	Fi=binary_to_list(File),
	tuple_to_list(maxi(key(Fi,T),)).

smallstat(F,Size) ->
	T=list_to_tuple(for(255)),
	{ok,File}=file:read(F,Size),
	Fi=binary_to_list(File),
	perev(filter(tuple_to_list(maxi(key(Fi,T),S)),tuple_to_list(S),[],[])).

for(1) -> [0];
for(Max) -> [0|for(Max-1)].

key([],T) -> T;
key(List,T) ->   [L|Ist]=List,
	I=element(L,T),
	T2=setelement(L,T,I+1),
	key(Ist, T2).

perev([],S) -> S;
perev(L,S) -> [I|O]=L, perev(O,[I|S]).

filter([],[],T2,S2) ->[T2,S2];
filter(T1,S1,T2,S2) ->
	[Et|Et1]=T1,
	[Es|Es1]=S1,
	if	Et/=0 -> filter(Et1,Es1,[Et|T2],[Es|S2]);
		Et==0 -> filter(Et1,Es1,T2,S2) end.