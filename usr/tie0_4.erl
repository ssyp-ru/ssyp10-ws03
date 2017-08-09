%% Архиватор "This Is Erlang"
%% версия 0.4, с нуля!
%% Авторы - Алексей Шумаков, Кирилл Смиренко
%% июль 2010 г.

-module(tie0_4).
-export[pack/2,pack/3,w_message/2,writeAZ/1,unpack/2].
-import(tie_rle8sm, [rle8_pack/1,rle8_unpack/1]).
-import(tie_lzw, [lzw_pack/1,lzw_unpack/1]).

%%%%%%%%%%%%%%%%%%%%%%%PACK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pack(IFileName,OFileName) -> pack(IFileName,OFileName,zero).
pack(IFileName,OFileName,Method) ->
	Version = "0.4",
	OFileName1 = string:concat(OFileName,".tie"),
	{ok,IF} = file:open(IFileName, [read,binary,{encoding,latin1}]),
	{ok,OF} = file:open(OFileName1, [read,write,binary]),
	{ok,{_,S,_,_,_,_,_,_,_,_,_,_,_,_}} = file:read_file_info(OFileName1),
	case S>0 of
		true ->
			file:position(OF,{eof,-3}),
			{_,<<Pp:24>>} = file:read(OF,3),
			file:position(OF,{bof,Pp}),
			{_,PList} = file:read(OF,(S-Pp-4)),
			file:position(OF,{bof,Pp}),
			[FilePosition,SA] = w_file(IFileName,OF,Method),
			file:write(OF,PList),
			w_properties(IFileName,OF,SA,Method,FilePosition),
			file:write(OF,<<"F":32>>),
			w_counters(OF,FilePosition);
		false ->
			w_message(OF,Version),
			[FilePosition,SA] = w_file(IFileName,OF,Method),
			w_properties(IFileName,OF,SA,Method,FilePosition),
			file:write(OF,<<"F":32>>),
			w_counters(OF,FilePosition)
	end,
	file:close(IF),
	file:close(OF).
w_message(OF,Version) -> file:write(OF,["ThisIsErlang",Version]).

w_file(IFileName,OF,zero) ->
	p("w_file zero"),
	{_,IData} = file:read_file(IFileName),
	OData = binary_to_list(IData),
	SA = length(OData),
	file:write(OF,OData),
	{ok,FilePosition} = file:position(OF, cur),
	[FilePosition,SA];
	
w_file(IFileName,OF,rle8) ->
	{_,IData} = file:read_file(IFileName),
	OData = rle8_pack(binary_to_list(IData)),
	SA = length(OData),
	file:write(OF,OData),
	{ok,FilePosition} = file:position(OF, cur),
	[FilePosition,SA];
	
w_file(IFileName,OF,lzw) ->
	{_,IData} = file:read_file(IFileName),
	OData = lzw_pack(binary_to_list(IData)),
	SA = length(OData),
	file:write(OF,OData),
	{ok,FilePosition} = file:position(OF, cur),
	[FilePosition,SA].
	
w_properties(IFileName,OF,SA,Method,FilePosition) ->
	{ok,{_,SB,_,_,_,_,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},_,_,_,_,_,_,_}}
	= file:read_file_info(IFileName),
	file:write(OF,term_to_binary([IFileName,SB,SA,Method,[YEAR,MON,DAT,HOUR,MIN,SEC],FilePosition])).

w_counters(OF,FilePosition) ->
	file:position(OF,{eof, -4}),
	file:write(OF,<<15:8>>),
	file:write(OF,<<FilePosition:24>>).
	
p(A)-> io:format("~w~n",[A]).

%%%%%%%%%%%%%%%%%%%UNPACK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

unpack(ArchFile,File)->
	{ok,IF} = file:open(ArchFile, [read,binary,{encoding,latin1}]),
	{ok,Header} = file:read(IF,12),
	case binary_to_list(Header) of
		"ThisIsErlang" ->
			{ok,Version} = file:read(IF,3),
			case binary_to_list(Version) of
				"0.4" ->
					{ok,{_,S,_,_,_,_,_,_,_,_,_,_,_,_}} = file:read_file_info(ArchFile),
					file:position(IF,{eof,-3}),
					{_,<<Pp:24>>} = file:read(IF,3),
					file:position(IF,Pp),
					{ok,TF} = file:open("test23.txt", [write,read,{encoding,latin1}]),
					{_,PList} = file:read(IF,(S-Pp-4)),
					file:write(TF,PList),
					p(123),
					{_,PPP} = file:read_file("test23.txt"),
					p(123),
					p(binary_to_term(PPP));
%%					unpack(IF,File,binary_to_term(PList));
				_ -> "This version of TIE is not supported."
			end;
		_ -> "The file is not an TIE archive."
	end.
unpack(IF,all,PList) ->"ALL";
unpack(IF,File,PList) ->
	{ok,OF} = file:open(File, [read,binary,{encoding,latin1}]),
	Prop = matchP(PList,File),
	[DataFile,Method] = matchFile(IF,Prop),
	w_Archfile(OF,Method,DataFile),
	w_properties(File,Prop).

matchFile(IF,Prop) -> 
	[_,_,Size,Method,_,FilePosition] = Prop,
	file:position(IF,{bof,FilePosition}),
	{_,DataFile} = file:read(IF,Size),
	[DataFile,Method].

w_Archfile(OF,zero,DataFile) ->
	file:position(OF,eof),
	NewData = list_to_binary(DataFile),
	file:write(OF,NewData);

w_Archfile(OF,rle8,DataFile) ->
	file:position(OF,eof),
	NewData = list_to_binary(rle8_unpack(DataFile)),
	file:write(OF,NewData);

w_Archfile(OF,lzw,DataFile) ->
	file:position(OF,eof),
	NewData = list_to_binary(lzw_unpack(DataFile)),
	file:write(OF,NewData).
	
w_properties(File,Prop) ->
	[_,_,Size,_,Date,_] = binary_to_list(Prop),
	[YEAR,MON,DAT,HOUR,MIN,SEC] = Date,
	file:write_file_info(File,[ok,{file_info,Size,regular,read_write,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},{{YEAR,MON,DAT},{HOUR,MIN,SEC}},{{YEAR,MON,DAT},{HOUR,MIN,SEC}},33206,1,3,0,0,0,0}]).
	
	
match(_,[]) -> false;
match([[Name|_]|R],L) ->
	case  Name == L of
		true ->	true; 
		false -> [_|R] = L, match(R,L)
	end.

matchP(_,[]) -> false;
matchP([Name|R1],L) ->
	case  Name == L of
		true ->	[Name|R1]; 
		false -> [_|R] = L, matchP(R,L)
	end.

writeAZ([]) -> io:format("~n");
writeAZ([F|R]) ->
	case (F>=10) and (F=<127) of
		true -> io:format("~c",[F]), writeAZ(R);
		false -> writeAZ(R)
	end.