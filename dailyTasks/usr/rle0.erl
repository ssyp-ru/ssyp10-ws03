-module(rle0).
-export[exe/1].

exe(L) ->
	exe(L,1).
exe([],_) -> "";
exe([F|[]],N) -> io:format("~w~n",[{F,N}]);
exe([F,S|R],N) ->
	if
		F==S -> exe([S|R],N+1);
		F/=S -> 
			io:format("~w~n",[{F,N}]),
			exe([S|R],1)
	end.