-module(table).
-export[s1/0].

s1() -> s1(1, 1).

s1(11, 10) -> io:format("VSE");

s1(11, D)
->
  io:format("~n"), 
  s1(1, D+1)
;
s1(P, D) ->
    io:format(" ~3w ",[P*D]),
    
    s1(P+1,D).
%%P, K
