-module(tie_rle8).
-export[rle8_pack/1,rle8_unpack/1].

rle8_pack(Data) -> rle8_pack(Data,1,[]).
rle8_pack([F|[]],N,OList) ->
	case N>=2 of
		true -> lists:append([OList,[N],[F]]);
		false ->
			case F=<127 of
				true -> lists:append([OList,[1],[F]]);
				false -> lists:append([OList,[F]])
			end
	end;
rle8_pack([F,S|R],N,OList) ->
	case N==127 of
		true -> rle8_pack([S|R],1,lists:append([OList,[N],[F]]));
		false ->
			case F==S of
				true -> rle8_pack([S|R],N+1,OList);
				false ->
					case N>=2 of
						true -> rle8_pack([S|R],1,lists:append([OList,[N],[F]]));
						false ->
							case F=<127 of
								true -> rle8_pack([S|R],1,lists:append([OList,[1],[F]]));
								false -> rle8_pack([S|R],1,lists:append([OList,[F]]))
							end
					end
			end
	end.

rle8_unpack(Data) -> rle8_unpack(Data,[]).
rle8_unpack([],OList) -> 
	OList;
rle8_unpack([F|[]],OList) -> 
	lists:append([OList,[F]]);
rle8_unpack([F,S|R],OList) ->
	case F>127 of
		true ->	rle8_unpack([S|R],lists:append([OList,[F]]));
		false ->
			case F==1 of
				true -> rle8_unpack(R,lists:append([OList,[S]])); 
				false -> rle8_unpack([F-1,S|R],lists:append([OList,[S]]))		
			end
	end.