%% Архиватор "This Is Erlang"
%% версия 0.3
%% Авторы - Алексей Шумаков, Кирилл Смиренко
%% июль 2010 г.

%% возможен выбор метода архивации
%% добавлена возможность архивации нескольких файлов в один архив

-module(tie0_3).
-export[pack/3,unpack/2,properties/1].
-import(tie_rle8sm, [rle8_pack/1,rle8_unpack/1]).
-import(tie_lzw, [lzw_pack/1,lzw_unpack/1]).

%%%%%%PACK%%%%%%

pack(IFile,OFile,Method) ->
	{ok,IF} = file:open(IFile, [read,binary,{encoding,latin1}]),
	{ok,OF} = file:open(OFile, [read,write,binary]),
	w_message(OF,{"ThisIsErlang 0.3","01"}),
	dopack(file:read_file(OF),IF,OF,Method,IFile),
	properties(IFile).
	
dopack([],IF,OF,Method,IFile) ->
	{_,IData} = (file:read_file(IFile)),
	w_archives(OF,IData,Method),
	file:close(IF),
	file:close(OF).

w_message(OF,A) -> 
	file:write(OF,term_to_binary(A)),
	file:position(OF, eof).
	
w_archives(OF,IData,[]) ->
	PackedData = rle8_pack(binary_to_list(IData)),
	file:write(OF, term_to_binary(PackedData)),
	file:position(OF, eof);
w_archives(OF,IData,zero) ->
	file:write(OF, term_to_binary(IData)),
	file:position(OF, eof);
w_archives(OF,IData,rle8) ->
	PackedData = rle8_pack(binary:bin_to_list(IData)),
	file:write(OF, term_to_binary(PackedData)),
	file:position(OF, eof);
w_archives(OF,IData,lzw) ->
	PackedData = lzw_pack(binary:bin_to_list(IData)),
	file:write(OF, term_to_binary(PackedData)),
	file:position(OF, eof).
		
properties(IFile) ->
	{ok,{_,_,_,_,_,_,{{YEAR,MON,DAT},{HOUR,MIN,SEC}},_,_,_,_,_,_,_}} = file:read_file_info(IFile),
	[YEAR,MON,DAT,HOUR,MIN,SEC].  

%%%%%UNPACK%%%%%

unpack(IFile,OFile) ->
	{ok,IF} = file:open(IFile, [read,binary,{encoding,latin1}]),
	{ok,OF} = file:open(OFile, [write,binary]),
	_ = r_message(IF),
	r_archives(IF),
	file:write_file(OFile,r_archives(IF)),
	file:close(IF),
	file:close(OF).
	
r_message(IF) ->
	{_,A} = file:read(IF, 27),
	binary_to_term(A).
r_archives(IF) ->
	{_,N} = file:position(IF,eof),
	file:position(IF, {bof,33}),
	{_,Data} = file:read(IF, N-44),
	rle8_unpack(binary_to_list(Data)).