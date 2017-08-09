-module(name4).
-export([pere/1]).
-export([pere/2]).

pere(P)->pere(P,[]).
pere([],P)->P;
pere(N,P) -> [K|Nost]=N,
             pere(Nost,[K|P]).