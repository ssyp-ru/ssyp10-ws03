-module(perevi).
-export([perev/1]).


perev(Z) ->
	[P|H] = Z, X = [P], perev(H, X);
perev([],X) ->
         X;
perev(Z,X) ->
	[P|P] = Z, XX = [P|X], glue(H,XX).
