-module(anti_rle0).
-export[exe/1].

exe([F,N|R]) ->	
	wrt(R,F,N).
exe([],_,_) -> "".
wrt(L,_,0) -> 
	io:format("~n"),
	exe(L);
wrt(L,F,N) ->
	io:format("~w ",[F]),
	wrt(L,F,N-1).