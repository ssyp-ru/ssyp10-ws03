%%Функция(poisk(список, элемент)) ищет элемент в списке, состоящем из списков.
-module(spisvspis).
-export([poisk/2]).
-export([poisk2/2]).

poisk([],A) -> false;
poisk([B|S1],A)
         -> UU = poisk2(B,A),
               if UU == false
                        -> poisk(S1,A);
                  UU -> true end.         

poisk2([],A) -> false;
poisk2([B|S1],A) -> if B == A -> true;
                      B /= A -> poisk2(S1,A)
                   end.