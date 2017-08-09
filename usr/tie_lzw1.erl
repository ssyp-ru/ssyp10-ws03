-module(tie_lzw1).
-export[lzw_pack/1,lzw_unpack/1,pos/2,glue/2,clearT/4].

lzw_pack(Data) ->
	clearT(0,[],Data,[]).
lzw_pack([],St,Table,OList) -> io:write(Table),lists:append(OList,[pos(St,Table)]);
lzw_pack([S|R],St,Table,OList) ->
	Sts = glue(St,S),
	io:write(Sts),
	case pos(Sts,Table) of
		false ->
			case length(Table)>=4096 of
				true -> clearT(0,[],[S|R],OList);
				false ->
					A = lists:append(OList,[pos(St,Table)]),
					B = lists:append(Table,[Sts]),
					lzw_pack(R,S,B,A)
			end;
		_ -> lzw_pack(R,Sts,Table,OList)
	end.

glue(St,S) ->
	case is_list(St) of
		true -> lists:append(St,[S]);
		false -> lists:append([St],[S])
	end.

pos(Elem,List) -> pos(Elem,List,1).
pos(Elem,List,N) ->
	case N==length(List) of
		true -> false;
		false ->
			case Elem==lists:nth(N,List) of
				true -> N;
				false -> pos(Elem,List,N+1)
			end
	end.

clearT(N,Table,Data,OList) ->
	case N<255 of
		true -> clearT(N+1,lists:append(Table,[N+1]),Data,OList);
		false ->
			[St|R] = Data,
			lzw_pack(R,St,Table,OList)
	end.

lzw_unpack(Data) -> unclearT(0,[],Data,[]).
lzw_unpack([],_,Table,OList) -> io:write(Table),OList;
lzw_unpack([S|R],St,Table,OList) ->
	Sts = glue(St,S),
	case lists:member(St,Table) of
		true -> lzw_unpack(R,Sts,Table,lists:append(OList,St));
		false ->
			NewTable = glue(Table,St),
			lzw_unpack(R,S,NewTable,NewOList)
			case prefmatch(Sts,Table) of
				true -> 
					NewOList = glue(OList,S),
					lzw_unpack(R,St,Table,NewOList);
				false -> 
					NewTable = glue(Table,Sts),
					NewOList = glue(OList,S),
					lzw_unpack(R,S,NewTable,NewOList)
			end
	end.

unclearT(N,Table,Data,OList) ->
case N<255 of
	true -> unclearT(N+1,lists:append(Table,[N+1]),Data,OList);
	false ->
		[St|R] = Data,
		lzw_unpack(R,St,Table,glue(OList,St))
end.
	
prefmatch(_,[]) -> false;
prefmatch(SL,L) ->
	case lists:prefix(SL,L) of
		true -> io:write(SL),
			true; 
		false -> [_|R] = L, prefmatch(SL,R)
	end.