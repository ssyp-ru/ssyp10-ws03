-module(name2).
-export([fact/1]).

fact(0) -> 1;
fact(N) -> N * fact(N - 1).