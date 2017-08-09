-module(ksm_06_00).
-export[exe/3].

conv1(N,mm,_) -> N/1000;
conv1(N,cm,_) -> N/100;
conv1(N,dm,_) -> N/10;
conv1(N,m,_) -> N;
conv1(N,km,_) -> N*1000;
conv1(N,_,_) -> 0.

conv2(N,_,mm) -> N*1000;
conv2(N,_,cm) -> N*100;
conv2(N,_,dm) -> N*10;
conv2(N,_,m) -> N;
conv2(N,_,km) -> N/1000;
conv2(N,_,_) -> 0;
conv2(N,0,_) -> 0.

exe(N,M1,M2) ->
	"0 = metrage error",
	conv1(N,M1,M2),
	conv2(N,M1,M2).
	N.