%% Архиватор "This Is Erlang"
%% версия 0.4, с нуля!
%% Авторы - Алексей Шумаков, Кирилл Смиренко
%% июль 2010 г.

-module(tie0_4).
-export[pack/2,pack/3,w_message/2].
-import(tie_rle8sm, [rle8_pack/1,rle8_unpack/1]).
-import(tie_lzw, [lzw_pack/1,lzw_unpack/1]).

pack(IFileName,OFileName) -> pack(IFileName,OFileName,zero).
pack(IFileName,OFileName,Method) ->
	Version = "0.4",
	OFileName1 = string:concat(OFileName,".tie"),
	{ok,_} = file:open(IFileName, [read,binary,{encoding,latin1}]),
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
			w_counters(OF,FilePosition);
		false ->
			w_message(OF,Version),
			[FilePosition,SA] = w_file(IFileName,OF,Method),
			file:write(OF,<<"free":32>>),
			w_properties(IFileName,OF,SA,Method,FilePosition),
			w_counters(OF,FilePosition)
	end.

w_message(OF,Version) -> file:write(OF,["ThisIsErlang",Version]).

w_file(IFileName,OF,zero) ->
	p("w_file zero"),
	{_,IData} = file:read_file(IFileName),
	OData = binary_to_list(IData),
	{ok,FilePosition} = file:position(OF, cur),
	SA = length(OData),
	file:write(OF,OData),
	[FilePosition,SA];
	
w_file(IFileName,OF,rle8) ->
	{_,IData} = file:read_file(IFileName),
	OData = rle8_pack(binary_to_list(IData)),
	{ok,FilePosition} = file:position(OF, cur),
	SA = length(OData),
	file:write(OF,OData),
	[FilePosition,SA];
	
w_file(IFileName,OF,lzw) ->
	{_,IData} = file:read_file(IFileName),
	OData = lzw_pack(binary_to_list(IData)),
	{ok,FilePosition} = file:position(OF, cur),
	SA = length(OData),
	file:write(OF,OData),
	[FilePosition,SA].
	
w_properties(IFileName,OF,SA,Method,FilePosition) ->
	{ok,{_,SB,_,_,_,_,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},_,_,_,_,_,_,_}}
	= file:read_file_info(IFileName),
	file:position(OF,{eof, -4}),  
	file:write(OF,term_to_binary([IFileName,SB,SA,Method,{YEAR,MON,DAT,HOUR,MIN,SEC},FilePosition])).

w_counters(OF,FilePosition) ->
	file:write(OF,<<15:8>>),
	file:write(OF,<<FilePosition:24>>).
	
p(A)-> io:format("~n~w",[A]).