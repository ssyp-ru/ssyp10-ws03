-module (arc).
-export (arc/1).
-export (arc/4).
arc(S) ->
arc(S,[],[],[]).
arc([],P,C,D) -> "";
arc(S,P,C,D) ->
[N|Sos]=S,
if 
   N==D ->
      arc(Sos,P,C+1,D);
   N/=D ->
      arc(Sos,[{C,D}|P],1,N)
   end.