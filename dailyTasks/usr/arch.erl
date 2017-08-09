-module(arch).
-export([hahaha/3]).
-export([start/1]).
-c(tie_lzw_old).
-c(tie_rle8).

start(Text)
 -> spawn(arch,hahaha,[self(),Text,lzv]),
	spawn(arch,hahaha,[self(),Text,rlelzv]),
	receive
		{A,B}
			->  receive
					{C,D}
						->  if  length(B) > length(D) -> [C,D];
								length(B) =< length(D) -> [A,B] end
				end
	end.

hahaha(X,Text,Metod)
 -> if  Metod == rlelzv -> X!({rlelzv, tie_lzw_old:lzw_pack(tie_rle8:rle8_pack(Text))});
		Metod == lzv -> X!({lzv,tie_lzw_old:lzw_pack(Text)})end.
	