-module(testpack).
-export[exe/3].
-import(tie_rle8sm, [pack/1,unpack/1]).

exe(File,OFile,NFile) ->
	{ok,_} = file:open(File, [read,binary,{encoding,latin1}]),
	{ok,OF} = file:open(OFile, [write,binary]),
	{ok,NF} = file:open(NFile, [write,binary,{encoding,latin1}]),
	{_,Data} = (file:read_file(File)),
	PackedData = tie_rle8sm:pack(binary:bin_to_list(Data)),
	file:write(OF,binary:list_to_bin(PackedData)),
	{_,NewData} = (file:read_file(OFile)),
	NewPackedData = tie_rle8sm:unpack(binary:bin_to_list(NewData)),
	file:write(NF,binary:list_to_bin(NewPackedData)).