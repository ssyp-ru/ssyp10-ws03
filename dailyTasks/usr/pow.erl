-module(pow).
-export[tab/1].

tab(11) -> io:format(" ");
tab(A) ->
	io:format("~w ",[math:pow(A,2)]),
	tab(A+1).