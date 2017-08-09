-module(fac).
-export([fac/1]).

fac(0) -> 1;
fac(A) ->
    fac(A-1)*A.