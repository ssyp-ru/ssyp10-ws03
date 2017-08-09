-module(rle).
-export([rleGO/1]).
-export([antirleGO/1]).

rleGO(STR) 
 -> rle(STR,1,[]).
 
antirleGO([A|[B|STR]])
 -> powt(STR,B,A,[]).

powt([],_,0,STR2)
 -> lists:reverse(STR2);
powt([B|[C|STR]],_,0,STR2)
 -> powt(STR,C,B,STR2);
powt(STR,A,N,STR2)
 -> powt(STR,A,N-1,[A|STR2]).

rle([],_,STR2) -> lists:reverse(STR2);
rle([A|[]],N,STR2) -> rle([],N+1,[A|[N|STR2]]);
rle([A|[B|STR]],N,STR2)
 -> if 
 %%(A /= B) and (STR == []) -> rle([],N+1,[A|[N|[B|[1|STR2]]]]);
	   (A /= B) 
	   %%and (STR /= []) 
	   -> rle([B|STR],1,[A|[N|STR2]]); 
       (A == B) and (STR /= []) -> rle([B|STR],N+1,STR2);
	   (A == B) and (STR == []) -> rle([],1,[A|[N+1|STR2]])end.