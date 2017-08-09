-module(crcr).
-export([crc/2]).

crc(Name,Size) -> {ok, File}=file:open(Name,[read,binary]),
	C=crc2(File,Size),
	F=crc3(C),
	B=file:close(File),
	F.
crc2(F,0) -> 0;
crc2(F,Size) ->  {ok,C}=file:read(F,1),
[S|[]]=binary_to_list(C),
crc2(F,Size-1)+S.
crc3(C) ->
	if C>=65536 -> crc3(C-65536);
	   C<65536 -> C end.