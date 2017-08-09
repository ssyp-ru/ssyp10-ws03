-module(new).
-export[fac/1].

fac([]) -> 0;
fac([_|CH]) ->

	1+fac(CH).
