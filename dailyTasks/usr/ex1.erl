-module(ex1).
-export([a/1]).
-export([a/2]).

a(K) ->
 K*K.
a(K,L) ->
 K+L.