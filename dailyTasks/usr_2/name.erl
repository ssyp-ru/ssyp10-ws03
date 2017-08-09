-module(name).
-export([kv/2]).
-export([kr/2]).
-export([ptr/3]).
-export([pr/3]).
-export([conv/1]).

conv(m)->1;
conv(km)->1000000;
conv(dm)->0.01;
conv(cm)->0.0001;
conv(mm)->0.000001.

kv(A, N)->A*A*conv(N).
kr(B, N)->B*3.141592*conv(N).
ptr(C,D,N)->C*D*2*conv(N).
pr(E,F,N)->E*F*conv(N).