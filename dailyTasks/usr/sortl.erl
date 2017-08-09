-module(sortl).
-export([maxx/1]).
-export([sortl/1]).
maxx(SL) -> max.

sortl(SL) ->
[S1|SL]=SL, 
length(S1),
sortl(SL)
.