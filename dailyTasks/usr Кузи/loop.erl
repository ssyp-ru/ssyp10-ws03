-module(loop).
-export([for/3]).
-export([write/2]).

for(F, Max, Max) -> F(Max);
for(F, Min, Max) -> F(Min), for(F,Min+1,Max).

write(Min, Max) ->
L = fun(X) -> io:format("~w, ", [X]) end,
for(L, Min, Max).