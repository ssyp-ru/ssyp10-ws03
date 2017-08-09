-module(hell).
-export([k/1]).
-export([pr/2]).
-export([kr/1]).
-export([tr/2]).
k(D) -> D*D.
pr(DL,SH) -> DL*SH.
kr(R) -> R*R*3.14.
tr(A,B) -> (A*B)/2.