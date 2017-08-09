-module(crc).
-export([crcGO/1]).

crcGO(S1)
	-> schet(S1,0).

schet([],X) -> X;
schet([A|S1],X)
	-> if X >= 256*256 -> schet(S1,X+A-(256*256));
		X < 256*256 -> schet(S1,X+A)end.