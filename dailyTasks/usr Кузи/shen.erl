-module(shen).
-export([archive/3]).

archive(F,Size,Na) ->
	{ok,File}=file:open(F,[read,binary]),
	{ok,Fa}=file:open(Na,[write,binary]),
	if	Size=<4*1024*1024 ->	{Text,Dictionary}=stat(File,Size), S=0,	Q=dict(Dictionary, Fa);
		Size>4*1024*1024 ->		{Text,Dictionary}=stat(File,4*1024*1024), S=Size-4096*1024,	Q=dict(Dictionary, Fa) end,
	shennon(Text,list_to_tuple(Dictionary),S,File,Fa),
	file:close(Fa),
	file:close(File).

filter([],D1,[],D3) -> D1;
filter(D,D1,D2,D3) ->
	[D4|D5]=D,
	[D6|D7]=D2,
	if	D4>0 -> filter(D5,[D4|D1],D7,[D6|D3]);
		D4==0 -> filter(D5,D1,D7,D3) end.

dict([],F) -> ok;
dict(D,F) ->
	[D1|D2]=D,
	D3= <<D1>>,
	file:write(F,D3),
	dict(D2,F).

shennon(T,D,Size,File,Fa) ->
	Empty=shennon(T,D,Fa),
	shennon(D,Size,File,Fa).

shennon([],D,Fa) -> [];
shennon(T,D,Fa) -> 
	[C|S]=T,
	%%io:format("~w,  ",[C]),
	W=find(D,C,1),
	O = <<W>>,
	Q=file:write(Fa,O),
	%%io:format("~w, ",[Q]),
	if	C==13 -> [S1|S2]=S, shennon(S2,D,Fa);
		C/=13 -> shennon(S,D,Fa) end.

shennon(D,0,File,Fa) -> "ok";
shennon(D,Size,File,Fa) ->
	{ok,B}=file:read(File,1),
	<<C>> = B,
	O=find(D,C,1),
	%%io:format("~w, ~w; ~n",[O,D]),
	Q=file:write(Fa,O),
	shennon(D,Size-1,File,Fa).

find(D,C,I) -> S=element(I,D),
	%%io:format("complete, ~w, ~w;~n",[S,C]),
	if	S==C -> I;
		S/=C -> find(D,C,I+1) end.

stat(F,Size) ->
	T=list_to_tuple(for(255)),
	{ok,File}=file:read(F,Size),
	Fi=binary_to_list(File),
	E=key(Fi,T),
	%%io:format("~w, ~n",[E]),
	R=list_to_tuple(alpha([],0)),
	%%io:format("~w; ~n",[R]),
	{W,Q}=maxi(R,E),
	ZXC=filter(tuple_to_list(W),[],tuple_to_list(Q),[]),
	%%io:format("~w",[Q]),
	{Fi,ZXC}.

for(0) -> [0];
for(Max) -> [0|for(Max-1)].

key([],T) -> T;
key(List,T) ->   [L|Ist]=List,
	if	L<11 -> I=element(L+1,T);
		L>10 -> I=element(L,T) end,
	T2=setelement(L,T,I+1),
	if	L/=13 -> key(Ist, T2);
		L==13 ->[E|Re]=Ist,
						key(Re,T2) end.

alpha(S,11) -> alpha([11|S],12);
alpha(S,12) -> alpha([12|S], 13);
alpha(S,13) -> alpha([13|S], 14);
alpha(S,256) -> perev(S,[]);
alpha(S,I) -> alpha([I|S],I+1).

perev([],S) -> S;
perev(S,L) -> [S1|S2]=S,
						perev(S2,[S1|L]).

maxi(L,S) -> maxi(L,S,tuple_size(L),1,1).
maxi(L,S,D,D,M) ->if D<tuple_size(L) ->
									S1=element(M,S), L1=element(M,L), 
									S2=element(D,S), L2=element(D,L),
									%%io:format("~w, ~w;	~w, ~w; ~n",[S1,S2,L1,L2]),
									S3=setelement(D,S,S1), L3=setelement(D,L,L1),
									S4=setelement(M,S3,S2), L4=setelement(M,L3,L2),
									maxi(L4,S4,tuple_size(L4),D+1,D+1);
									D>=tuple_size(L) -> {L,S} end;
maxi(L,S,I,D,M) -> 
	S1=element(I,S), M1=element(M,S),
	if	S1>M1 -> maxi(L,S,I-1,D,I);
		S1=<M1 -> maxi(L,S,I-1,D,M) end.