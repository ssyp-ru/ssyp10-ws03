-module(tests).
-export([tfa1/3]).
-export([write/2]).
-export([write/4]).

tfa1(Filename1,Filename2,Filename3) ->
   {ok,F3}=file:open(Filename3,[write,binary]),
   %%Мы читаем файлы пачками по 2*1024 бита
   write(F3,Filename1),
   write(F3,Filename2),
   file:close(F3).

write(Fa,Name) ->
   {ok,F}=file:open(Name,[read,binary]), 
   {ok,S}=file:read_file_info(Name),
   Size=element(2,S),
   N=trunc(Size/1024/2),
   write(F,N,Fa,Size).
   
write(File,0,F3,Size) -> {ok,S}=file:read(File, Size-trunc(Size/1024.2)),
   file:write(F3,S), file:close(File);
write(File, Steps,F3,Size) ->   {ok,S}=file:read(File, 2*1024),
   file:write(F3,S), write(File,Steps-1,F3,Size). 