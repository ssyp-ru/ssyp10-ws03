-module(tables).
-export([start/0]).

start()->squ(2,2).
squ(11,10) -> io:format("");
squ(11,N) -> io:format("~n"),
    squ(2,N+1);
squ(C,N) -> io:format("~w ", [N*C]),
    squ(C+1,N).