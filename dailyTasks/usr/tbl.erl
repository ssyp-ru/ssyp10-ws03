-module(tbl).
-export([tbl/0]).
-export([tbl/2]).

tbl() -> tbl(1,1).

tbl(11,N) -> io:format("~n");
tbl(N,11) -> io:format("~n"),tbl(N+1,1);
tbl(N,M) -> io:format("~3w ",[N*M]), tbl(N,M+1).