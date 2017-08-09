-module(maxn).
-export[max/1].

max(L) ->
	[M|R] = L,
	max(R,M).
max([],M) -> M;
max([F|R],M) ->
	if
		bF<M -> max(R,F);
		F>M -> max(R,M)
	end.