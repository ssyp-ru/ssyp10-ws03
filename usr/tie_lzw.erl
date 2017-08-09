-module(tie_lzw).
-export[lzw_pack/1,lzw_unpack/1,pos/2].

lzw_pack(Data) -> clearT(-1,[],Data,[]).
lzw_pack([],St,Table,OList) -> io:write(Table),lists:append(OList,[pos(St,Table)]);
lzw_pack([S|R],St,Table,OList) ->
	Sts = glue(St,S),
	case pos(Sts,Table) of
		false ->
			case length(Table)>=8192 of
				true -> clearT(-1,[],[S|R],OList);
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
	case (N-1)==length(List) of
		true -> false;
		false ->
			case Elem==lists:nth(N,List) of
				true -> N-1;
				false -> pos(Elem,List,N+1)
			end
	end.

prefmatch(_,[]) -> false;
prefmatch(Elem,[F|R]) ->
	case Elem == F of
		true -> true;
		false -> prefmatch(Elem,R)
	end.

clearT(N,Table,Data,OList) ->
	case N<255 of
		true -> clearT(N+1,lists:append(Table,[N+1]),Data,OList);
		false ->
			[St|R] = Data,
			lzw_pack(R,St,Table,OList)
	end.

lzw_unpack(Data) -> unclearT(-1,[],Data,[]).
lzw_unpack([],_,_,OList) -> OList;
lzw_unpack([S|R],St,Table,OList) ->
	case length(Table)>=8192 of
		true -> unclearT(-1,[],[S|R],OList);
		false ->
			case (length(Table)>=S) and (S>255) of
				true ->
					io:write(lists:nth((S+1),Table)),
					[F|_] = lists:nth((S+1),Table),
					lzw_unpack(R,glue(St,F),glue(Table,glue(St,F)),lists:append(OList,lists:nth((S+1),Table)));
				false ->
					case pos(glue(St,S),Table) of
						false -> lzw_unpack(R,S,glue(Table,glue(St,S)),glue(OList,S));
						_ -> lzw_unpack(R,St,Table,glue(OList,S))
					end
			end
	end.

unclearT(N,Table,Data,OList) ->
case N<255 of
	true -> unclearT(N+1,lists:append(Table,[N+1]),Data,OList);
	false ->
		[St|R] = Data,
		lzw_unpack(R,St,Table,glue(OList,St))
end.