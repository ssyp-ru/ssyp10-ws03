-module arc.
-export([arc/1])

arc(S) -> arc(S,[]).
arc([],P) -> io:format("");
arc(S,P) ->
   arc(arc)
arc2(S,C,D) ->
   [N|Sost]=S;
   if 
     N==D ->
        arc2(S,C+1,D);      