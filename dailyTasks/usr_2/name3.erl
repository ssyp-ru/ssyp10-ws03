-module(name3).
-export([ln/1]).

ln([])-> 0;
ln(A)->
   [_|CH]=A,
   1+ln(CH).