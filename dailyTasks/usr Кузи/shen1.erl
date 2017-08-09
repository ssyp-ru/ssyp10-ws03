-module(shen1).
-export([archive/2]).
-export([unarchive/2]).

unarchive(Archive,File) ->
	{ok, S}=file:read_file_info(Archive),
	Size=element(2,S),
	{ok, F}=file:open(Archive,[read,binary]),
	{ok,A}=file:open(File,[write,binary]),
	{ok,In}=file:read(F, Size),
	Info=binary_to_list(In),
	[C|Inf]=Info,
	D=undict(Inf,C,[]),
	unshennon(Inf,list_to_tuple(D), A),
	file:close(A),
	file:close(F).

archive(File,Archive) ->
	{ok, S}=file:read_file_info(File),
	Size=element(2,S),
	{ok, F}=file:open(File,[read,binary]),
	{ok,A}=file:open(Archive,[write,binary]),
	{ok,In}=file:read(F, Size),
	Info=binary_to_list(In),
	D=list_to_tuple(stat(Info)),
	%%io:format("~w;  ",[D]),
	Ld=tuple_size(D),
	LD= <<Ld>>,
	file:write(A,LD),
	dict(tuple_to_list(D),A),
	shennon(Info,D, A),
	file:close(A),
	file:close(F).

unshennon([],D,Fn) -> [];
unshennon(T,D,Fn) ->
	[C|S]=T,
	io:format("~w,  ~w,	",[C,tuple_size(D)]),
	W=element(C, D),
	io:format("~w;  ",[W]),
	O = <<W>>,
	file:write(Fn,O),
	if	C==13 -> file:write(Fn,<<10>>), shennon(S,D,Fn);
		C/=13 -> shennon(S,D,Fn) end.
shennon([],D,Fa) -> [];
shennon(T,D,Fa) -> 
	%%io:format("comp;  "),
	[C|S]=T,
	%%io:format("comp;  ~w;  ",[C]),
	W=find(D,C,1),
	%%io:format("comp;  ~w;	",[W]),
	O = <<W>>,
	%%io:format("comp;  "),
	file:write(Fa,O),
	%%io:format("comp;  ~n"),
	if	C==10 -> [13|S1]=S, shennon(S1,D,Fa);
		C/=10 -> shennon(S,D,Fa) end.

undict(Info,0,D) -> perev(D,[]);
undict(Info,Size,D) ->
	[I|Nfo]=Info,
	undict(Nfo, Size-1, [I|D]).

perev([],C) -> C;
perev(D,C) -> [D1|D2]=D, perev(D2, [D1|C]).

dict([],A) -> [];
dict(D,A) ->
	%%io:format("~w,	",[D]),
	[D1|D2]=D,
	D3= <<D1>>,
	file:write(A,D3),
	dict(D2,A).

find(D,C,I) -> S=element(I,D),
	%%io:format("~w,	~w;~n",[S,C]),
	if	S==C -> I;
		S/=C -> find(D,C,I+1) end.
stat(Info) ->
	T=list_to_tuple(for(255)),
	E=key(Info,T),
	R=list_to_tuple(alpha([],0)),
	{W,Q}=maxi(R,E),
	ZXC=filter(tuple_to_list(W),[],tuple_to_list(Q)),
	ZXC.
for(0) -> [0];
for(Max) -> [0|for(Max-1)].
alpha(S,256) -> S;
alpha(S,I) -> alpha([255-I|S],I+1).
maxi(L,S) -> maxi(L,S,tuple_size(L),1,1).
maxi(L,S,D,D,M) ->if D<tuple_size(L) ->
									S1=element(M,S), L1=element(M,L), 
									S2=element(D,S), L2=element(D,L),
									S3=setelement(D,S,S1), L3=setelement(D,L,L1),
									S4=setelement(M,S3,S2), L4=setelement(M,L3,L2),
									maxi(L4,S4,tuple_size(L4),D+1,D+1);
									D>=tuple_size(L) -> {L,S} end;
maxi(L,S,I,D,M) -> 
	S1=element(I,S), M1=element(M,S),
	if	S1>M1 -> maxi(L,S,I-1,D,I);
		S1=<M1 -> maxi(L,S,I-1,D,M) end.
key([],T) -> T;
key(List,T) ->   [L|Ist]=List,
	I=element(L+1,T),
	T1=setelement(L+1, T, I+1),
	key(Ist, T1).
filter([],S,[]) -> S;
filter(L1,S1,I)->
	[E1|O1]=L1,
	[E|O]=I,
	if	E>0 -> filter(O1,[E1|S1],O);
		E==0 -> filter(O1,S1,O) end.