-module(wh).    %%propishi: esli ne nachodit faila to WTF(What THe File) eof
-export([ham/1]).
%%-export([unham/1]).
-c(rle).
-c(crc).

ham(FILENAME)
	-> hamfiles(listfind([FILENAME],[])).

listfind([],LISTOFALLFILES) -> LISTOFALLFILES;
listfind([A|QUEUE],LISTOFALLFILES)
	-> B = filelib:is_dir(A),
	if  B == true
			-> listfind(lists:append(filelib:wildcard(lists:append(A,"/*")),QUEUE),LISTOFALLFILES);
		B == false
			-> listfind(QUEUE,[A|LISTOFALLFILES]) end.

hamfiles(LISTOFFILES)
	-> {ok,F} = file:open("HAMZIP.txt",[write,binary,{encoding,latin1}]),
	LL = length(LISTOFFILES),
	file:write(F,<<"WINGHAMSTER_v1_0":(8),LL:(2*8)>>),
	fileinf(F,LISTOFFILES),
	file:close(F).
	
fileinf(F,[]) 
	-> [];
fileinf(F,[A|LISTOFFILES])
	->{ok,{_,_,_,_,_,_,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},_,_,_,_,_,_,_}} = file:read_file_info(A),
	{ok,F2} = file:open(A,[read]), 
	{ok,UUU} = file:read(F2,2000),
	G = rle:rleGO(UUU),
	UU = <<(length(G)):(6*8),YEAR:(4*8),MON:(2*8),DAT:(2*8),HOUR:(2*8),MIN:(2*8),SEC:(2*8),(crc:crcGO(UUU))>>,
	file:write(F,UU),
	file:write(F,G),
	fileinf(F,LISTOFFILES).

%%unham(FILENAME)
%%	-> {ok,F} = file:open(FILENAME,[read]),
%%	{ok,AA} = file:read(F,(16)),
%%	if  AA /= "WINGHAMSTER_v1_0" 
%%			-> io:format("It's not my archive, I can't unpack it.");
%%		AA == "WINGHAMSTER_v1_0" 
%%			-> {ok,LEN} = file:read(F,(2*8))end.