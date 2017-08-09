%%Repmrjrbyrjd Cthutq 9 b.kz
-module(data).
-export([new/0]).
-export([destroy/0]).
-export([write/3]).
-export([delete/2]).
-export([match/2]).
-export([return/2]).
-export([match/3]).
-export([read/2]).
-export([read/3]).
new() -> [].

destroy() -> [].

write(Db,El1,El2) ->
[{El1,El2}|Db].


return([],Db) -> 
    io:format("Completed");
return(Dbost,Db) ->
   [D|Dbast]=Dbost,
   return(Dbast,[D|Db]).

delete(Db,Id) ->
L=fun ->
    if Id==Key -> false;
	   Id/=Key -> true
	end
	end,
	lists:filter(L,Id).


match(Db,Id) ->
match(Db,Id,[]).

match([],Id,Db) ->
   io:format("Not found."),
   Db;
match(Db,Id,Dbost) ->
   [H|Dbast]=Db,
   C=tuple_to_list(H),
   [A|B]=C,
    if B==Id ->
       H;
	else ->
      match(Dbast, [H|Dbost])
    end.

	
read(Db,Id) ->
read(Db,Id,[]).

read([],Id,Db) ->
   io:format("Not found."),
   Db;
read(Db,Id,Dbost) ->
   [H|Dbast]=Db,
   C=tuple_to_list(H),
   [A|B]=C,
    if A==Id ->
       H;
	else ->
      read(Dbast, [H|Dbost])
    end.	