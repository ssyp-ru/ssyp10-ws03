-module(maxi2).
-export([maxi/2]).

maxi(L,S) -> maxi(L,S,tuple_size(L),1,1).
maxi(L,S,D,D,M) ->if D<tuple_size(L) ->
									S1=element(M,S), L1=element(M,L),
									S2=element(D,S), L2=element(D,L),
									S3=setelement(D,S,S1), L3=setelement(D,L,L1),
									S4=setelement(M,S3,S2), L4=setelement(M,L3,L2),
									maxi(L4,S4,tuple_size(L4),D+1,D+1);
									D>=tuple_size(L) -> L end;
maxi(L,S,I,D,M) -> 
	S1=element(I,S), M1=element(M,S),
	if	S1>M1 -> maxi(L,S,I-1,D,I);
		S1=<M1 -> maxi(L,S,I-1,D,M) end.