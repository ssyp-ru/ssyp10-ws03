-module(max).
-export([max/1]).
-export([max/2]).

max([A|S1]) -> S2 = [A|0], max(S2,S1).

max([A|S2],[]) -> io:format("~w",[A]);
max([A|S2],[B|S1])-> if A >= B -> max([A|S2],S1);
                        B > A -> max([B|S2],S1)
                       end.