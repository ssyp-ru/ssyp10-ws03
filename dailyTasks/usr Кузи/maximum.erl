-module(maximum).
-export([maxi/1]).
-export([search/2]).
-export([for/1]).
-export([gogo/1]).
-export([gog/1]).

maxi(String) -> T=list_to_tuple(for(256)),
   search(String,T).
   
search("",T) -> T;
search(String,T) -> [S|Tring]=String,
   search(Tring,setelement($S-1,T,element($S-1,T)+1)).   

for(1) -> [0];
for(Max) -> [0|for(Max-1)].

gogo(T) -> L=tuple_to_list(T),
   gog(L).
gog([]) -> ok;
gog(L) -> [E|List]=L,
   A=255-length(List),
   io:format("~w, ~w; ~n",[A,E]),
   gog(List).
