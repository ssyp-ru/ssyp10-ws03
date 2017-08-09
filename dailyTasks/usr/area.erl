-module(area).
-export[aS/1].
-export[aR/2].
-export[aC/1].
-export[aPT/2].

convert(N,mm) -> N/1000;
convert(N,cm) -> N/100;
convert(N,dm) -> N/10;
convert(N,m) -> N;
convert(N,km) -> N*1000.

%%convert(N,_) -> 0.

aS({In1,M1}) ->
	A = convert(In1,M1),
	math:pow(A,2).

aR({In1,M1},{In2,M2}) ->
	A = convert(In1,M1),
	B = convert(In2,M2),
	A*B.

aC({In1,M1}) ->
	A = convert(In1,M1),
	3.1415*math:pow(A,2).

aPT({In1,M1},{In2,M2}) ->
	A = convert(In1,M1),
	B = convert(In2,M2),
	A*B/2.