-module(rle).
-export([rle/3]).

rle(F,S,Tmp) -> {ok,T}=file:open(Tmp,[write,binary]),
	rle(F,S,T,Tmp).
rle(File,0,Arc,Na) -> file:close(Arc),
								{ok,B}=file:read_file_info(Na),
								element(2,B);
rle(File,Size,Arc,Na) ->
	if Size>=2048 -> {ok,Ft}=file:read(File, 2048);
		Size<2048 -> {ok,Ft}=file:read(File,Size) end,
	L=binary_to_list(Ft),
	rlest(L,0,0,Arc),
    if Size>=2048 -> rle(File,Size-2048,Arc,Na);
	   Size<2048 -> rle(File, 0,Arc,Na) end.
rlest([],I,C,Ar) -> file:write(Ar, <<I, C>>);
rlest(List,I,C,Ar) ->
	[L|Ist]=List,
	if	L==C -> rlest(Ist,I+1,C,Ar);
		L/=C -> file:write(Ar, <<I, C>>),
					rlest(Ist,1,L,Ar) end.