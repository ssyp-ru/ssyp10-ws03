-module(meat).
-export([poisk/1]).

poisk(A) ->
 Food = [[Meat,True,False], [Mushroom,True,True], [Grass,True,True],
        [Leaves,True,True], [Milk,True,False], [Vegetables,True,True],
        [Fruits,True,True], [Rocks,False,False], [Metals,False,False],
        [Trees,False,False], [Computers,False,False], [Fish,True,False]],
L = fun(Spi) -> 
     if [Spi,X,C]==A ->
         io:format("~w, ~w, ~w; ~n",Food) end,
lists:map(L,Food).n