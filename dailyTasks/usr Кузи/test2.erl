-module(test2).
-export([size/1]).

size(File) ->
   {ok,S}=file:read_file_info(File),
   {element(2,S),element(5,S)}.