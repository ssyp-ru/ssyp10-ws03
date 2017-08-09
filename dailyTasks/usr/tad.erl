-module(tad).
-export[str/0].

str() -> tab(1,1).
tab(10,10) -> io:format("100~n");
tab(11,B) -> io:format("~n"),
			tab(1,B+1);
tab(A,B) ->
	io:format("~3w ",[A*B]),
	tab(A+1,B).