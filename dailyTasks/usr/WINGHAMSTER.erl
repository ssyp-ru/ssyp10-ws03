%%WINGHAMSTER_v1_0
-module(winghamster).
-export([ham/1]).
-export([unham/1]).
		
ham(FILENAME)
    -> {ok,F} = file:open('HAMZIP.txt',[write,binary]),
	{ok, F2} = file:open(FILENAME,[read,binary]),
	{ok, A} = file:read(F2,524288*8),
	file:write(F,<<"WINGHAMSTER_v1_0":(16*8),"##":(2*8),"##":(6*8)>>),
	file:write(F,A),
	{ok,{_,RAZM,_,RW,_,_,{DATA,TIME},_,_,_,_,_,_,_}} = file:read_file_info(FILENAME),
	io:format([FILENAME,"##",RAZM,"##",DATA,TIME]).
	
unham(FILENAME)
    -> [].