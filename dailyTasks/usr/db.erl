%%Александр Баянов, Смирнов Павел 2010.
-module(db).
-export([destroy/1]).
-export([delete/2]).
-export([write/3]).
-export([read/2]).
-export([new/0]).
-export([match/2]).

new() -> [].

destroy(DB) -> [].

delete(HAA,DB) -> 
    UUU = fun([A|B]) -> 
	    if  A == HAA 
		        -> false;
            A /= HAA 
			    -> true
		end
    end,
    lists:filter(UUU, DB). 

match(HAA,DB) -> 
    UUU = fun([A|B]) -> 
	    if  B == [HAA] 
		        -> true;
            B /= [HAA] 
			    -> false
		end
    end,
    lists:filter(UUU, DB). 

write(HAHA,HOHO,DB)
    -> [[HAHA,HOHO]|DB].

read(A,DB) -> read(A,DB,1).
	
read(A,[],N) -> io:format("I don't want to read THIS");
read(A,[[B|UU]|S],N) -> if B == A -> UU;
                            B /= A -> read(A,S,N+1) end.