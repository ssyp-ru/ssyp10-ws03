%% Архиватор "This Is Erlang"
%% версия 0.5
%% Авторы - Алексей Шумаков, Кирилл Смиренко
%% июль 2010 г.

-module(tie0_5).
-export[pack/2,pack/3,unpack/2,info/1].
-import(tie_rle8, [rle8_pack/1,rle8_unpack/1]).
-import(tie_lzw_mess, [lzw_pack/1,lzw_unpack/1]).
-include_lib("kernel/include/file.hrl").

%%%%%%%%%%%%%%%%%%%%%%%PACK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pack(IFileName,OFileName) -> pack(IFileName,OFileName,zero).
pack(IFileName,OFileName,Method) ->
	Version = "0.5",
	OFileName1 = string:concat(OFileName,".tie"),
	{ok,IF} = file:open(IFileName, [read,binary,{encoding,latin1}]),
	{ok,OF} = file:open(OFileName1, [read,write,binary]),
	{ok,{_,SB,_,_,_,_,_,_,_,_,_,_,_,_}} = file:read_file_info(IFileName),
	{ok,{_,S,_,_,_,_,_,_,_,_,_,_,_,_}} = file:read_file_info(OFileName1),
	case S>0 of
		true ->
			{_,IData} = file:read_file(IFileName),
			file:position(OF,{eof,-3}),
			{_,<<Pp:24>>} = file:read(OF,3),
			file:position(OF,{bof,Pp}),
			{_,PList} = file:read(OF,(S-Pp-4)),
			file:position(OF,{bof,Pp}),
			FilePosition = Pp,
			OData = dopack(binary_to_list(IData),Method),
			SA = length(OData),
			file:write(OF,OData),
			{ok,PropPosition} = file:position(OF, cur),
			Prop = lists:append(binary_to_term(PList),[w_properties(IFileName,OF,SA,Method,FilePosition)]),
			file:write(OF,term_to_binary(Prop)),
			w_counters(OF,PropPosition);
		false ->
			{_,IData} = file:read_file(IFileName),
			w_message(OF,Version),
			OData = dopack(binary_to_list(IData),Method),
			{ok,FilePosition} = file:position(OF, cur),
			SA = length(OData),
			file:write(OF,OData),
			{ok,PropPosition} = file:position(OF, cur),
			Prop = [w_properties(IFileName,OF,SA,Method,FilePosition)],
			file:write(OF,term_to_binary(Prop)),
			w_counters(OF,PropPosition)
	end,
	file:close(IF),
	file:close(OF),
	io:format("File name = ~s~n",[IFileName]),
	io:format("Archive name = ~s~n",[OFileName1]),
	io:format("Original size = ~w bytes~n",[SB]),
	io:format("Compressed size = ~w bytes~n",[SA]),
	case SB==0 of
		true -> io:format("Size after/before = 100%~n");
		false -> io:format("Size after/before = ~w%~n",[round(SA*100/SB)])
	end,
	pack_ok.

w_message(OF,Version) -> file:write(OF,["ThisIsErlang",Version]).

dopack(Data,zero) -> Data;
dopack(Data,rle8) -> rle8_pack(Data);
dopack(Data,lzw) -> lzw_pack(Data).
	
w_properties(IFileName,_,SA,Method,FilePosition) ->
	{ok,{_,SB,_,_,_,_,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},_,_,_,_,_,_,_}} = file:read_file_info(IFileName),
	[IFileName,SB,SA,Method,[YEAR,MON,DAT,HOUR,MIN,SEC],FilePosition].

w_counters(OF,FilePosition) ->
	file:write(OF,<<15:8>>),
	file:write(OF,<<FilePosition:24>>).
	
%%p(A)-> io:format("~w~n",[A]).

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
						false -> io:format("The file you request isn't packed in the archive.~n"), error;
						_ ->
							{ok,OF} = file:open(File, [write,{encoding,latin1}]),
							unpack1(IF,OF,match(File,Properties))
					end;
				_ -> io:format("This version of TIE is not supported.~n"), error
			end;
		_ -> io:format("The file you request is not an TIE archive.~n"), error
	end.

unpack1(IF,OF,[_,_,SA,Method,_,FilePos]) ->
	file:position(IF,FilePos),
	{ok,IData} = file:read(IF,SA),
	file:write(OF,dounpack(binary_to_list(IData),Method)),
	file:close(IF),
	file:close(OF),
	unpack_ok.

dounpack(Data,zero) -> Data;
dounpack(Data,rle8) -> rle8_unpack(Data);
dounpack(Data,lzw) -> lzw_unpack(Data).

match(_,[]) -> false;
match(File,[[Name|R1]|R]) ->
	case  Name == File of
		true ->	[Name|R1];
		false -> match(File,R)
	end.

%%%%%%%%%%%%%%%%%%%%%%%INFO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

info(ArchFile) ->
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
					showProp(binary_to_term(PList));
				_ -> io:format("This version of TIE is not supported.~n"), error
			end;
		_ -> io:format("The file you request is not an TIE archive.~n"), error
	end.

showProp(PList) -> showProp(PList,1).
showProp([],_) -> info_ok;
showProp([[IFileName,SB,SA,Method,_,_]|R],N) ->
	io:format("File #~w~n",[N]),
	io:format("File name = ~s~n",[IFileName]),
	io:format("Compression method = ~w~n",[Method]),
	io:format("Original size = ~w bytes~n",[SB]),
	io:format("Compressed size = ~w bytes~n",[SA]),
	io:format("Size after/before = ~w%~n",[round(SA*100/SB)]),
	io:format("~n"),
	showProp(R,N+1).