-module(perev).
-export[glue/1].

glue(A) ->
	[B|C] = A,
	D = [B],
	glue(C,D).
glue([],D) -> D;
glue(A,D) ->
	[B|C] = A,
	D2 = [B|D],
	glue(C,D2).
