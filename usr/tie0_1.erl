%% Архиватор "This Is Erlang"
%% версия 0.1 alpha
%% Авторы - Алексей Шумаков, Кирилл Смиренко
%% июль 2010 г.

-module(tie0_1).
-export[pack/2,unpack/2].
-import(tie_rle8sm, [pack/1,unpack/1]).

%%%%%%PACK%%%%%%

pack(IFile,OFile) ->
	{ok,_} = file:open(IFile, [read,binary,{encoding,latin1}]),
	{ok,OF} = file:open(OFile, [write,binary]),
	{_,IData} = (file:read_file(IFile)),
	w_message(OF,{"ThisIsErlang 0.1","01"}),
	w_archives(OF,IData).

w_message(OF,A) -> file:write(OF,term_to_binary(A)),file:position(OF, eof).
w_archives(OF,IData) ->
	PackedData = tie_rle8sm:pack(binary:bin_to_list(IData)),
	file:write(OF, term_to_binary(PackedData)),
	file:position(OF, eof).

%%%%%UNPACK%%%%%

unpack(IFile,OFile) ->
	{ok,IF} = file:open(IFile, [read,binary,{encoding,latin1}]),
	{ok,_} = file:open(OFile, [write,binary]),
	_ = r_message(IF),
	r_archives(IF),
	file:write_file(OFile,r_archives(IF)).
	
r_message(IF) ->
	{_,A} = file:read(IF, 27),
	binary_to_term(A).
r_archives(IF) ->
	{_,N} = file:position(IF,eof),
	file:position(IF, {bof,27}),
	{_,Data} = file:read(IF, N-27),
	unpack(binary_to_term(Data)).