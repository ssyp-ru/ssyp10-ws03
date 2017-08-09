%%repmrorbyrjd cthutq 09.07.2010
-module(db).
-export([new/0]).
-export([destroy/0]).
-export([write/3]).
-export([delete/2]).
-export([read/2]).
-export([match/2]).

new() -> [].

destroy() -> [].

write(Db, El1, El2) -> [{El1,El2}|Db].

delete(Db,Key) ->   L=fun(A) ->    N=element(2,A),
    if N==Key -> false;
	   N/=Key -> true	 end 	end,
   lists:filter(L,Db).
   
read(Db,Key) ->   L=fun(A) ->     N=element(1,A),
	 if N==Key -> true;
	    N/=Key -> false	 end 	end,
   lists:filter(L,Db).

match(Db,Key) ->   L=fun(A) ->     N=element(2,A),
	 if N==Key -> true;
	    N/=Key -> false	 end 	end,
   lists:filter(L,Db).