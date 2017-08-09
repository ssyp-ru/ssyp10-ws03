%% Архиватор "This Is Erlang"
%% версия 0.5
%% Авторы - Алексей Шумаков, Кирилл Смиренко
%% июль 2010 г.

-module(tie0_5).
-export[pack/2,pack/3,unpack/2].
-import(tie_rle8sm, [rle8_pack/1,rle8_unpack/1]).
-import(tie_lzw, [lzw_pack/1,lzw_unpack/1]).
-include_lib("kernel/include/file.hrl").

%%%%%%%%%%%%%%%%%%%%%%%PACK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pack(IFileName,OFileName) -> pack(IFileName,OFileName,zero).
pack(IFileName,OFileName,Method) ->
	Version = "0.5",
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
			NewPList = binary_to_term(PList),
			[FilePosition,SA] = w_file(IFileName,OF,Method),
			Prop = lists:append([NewPList],[w_properties(IFileName,OF,SA,Method,FilePosition)]),
			file:write(OF,term_to_binary(Prop)),
			file:write(OF,<<"F":32>>),
			w_counters(OF,FilePosition);
		false ->
			w_message(OF,Version),
			[FilePosition,SA] = w_file(IFileName,OF,Method),
			file:write(OF,term_to_binary(w_properties(IFileName,OF,SA,Method,FilePosition))),
			file:write(OF,<<"F":32>>),
			w_counters(OF,FilePosition)
	end,
	file:close(IF),
	file:close(OF).
w_message(OF,Version) -> file:write(OF,["ThisIsErlang",Version]).

w_file(IFileName,OF,zero) ->
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
	
w_properties(IFileName,_,SA,Method,FilePosition) ->
	{ok,{_,SB,_,_,_,_,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},_,_,_,_,_,_,_}}
	= file:read_file_info(IFileName),
	[IFileName,SB,SA,Method,[YEAR,MON,DAT,HOUR,MIN,SEC],FilePosition].

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
				"0.5" ->
					{ok,{_,S,_,_,_,_,_,_,_,_,_,_,_,_}} = file:read_file_info(ArchFile),
					file:position(IF,{eof,-3}),
					{_,<<Pp:24>>} = file:read(IF,3),
					file:position(IF,Pp),
					{_,PList} = file:read(IF,(S-Pp-4)),
					Properties = binary_to_term(PList),
					case match(File,Properties) of
						false -> "The file you request isn't packed in the archive.";
						_ ->
							{ok,OF} = file:open(File, [write,{encoding,latin1}]),
							unpack1(IF,OF,match(File,Properties))
					end;
				_ -> "This version of TIE is not supported."
			end;
		_ -> "The file is not an TIE archive."
	end.

unpack1(IF,OF,[_,_,SA,Method,[YEAR,MON,DAT,HOUR,MIN,SEC],FilePos]) ->
	file:position(IF,FilePos),
	{ok,IData} = file:read(IF,SA),
	file:write(OF,dounpack(binary_to_list(IData),Method)).

dounpack(Data,zero) -> Data;
dounpack(Data,rle8) -> rle8_unpack(Data);
dounpack(Data,lzw) -> lzw_unpack(Data).

match(_,[]) -> false;
match(File,[[Name|R1]|R]) ->
	case  Name == File of
		true ->	[Name|R1];
		false -> match(File,R)
	end.