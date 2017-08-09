-module(eda).
-export([main/2]).

-export([preda/1]).


main(Food, Z) ->
Caneat = [yabloko, grusha, grib, kuritsa],
Veget = [yabloko, grusha, grib],
Cannoteat = [stal, plutonii, erlang],

%%preda(Cannoteat),
%%io:format("~n GRUUSHA "),
%%lists:member(grusha,Veget) /= false,
%%io:format("GRIIIB "),
lists:member(Food,Z)
.


preda([]) -> io:format("");
preda(L) ->
 [P|H] = L,
 io:format("~w ~n",[P]), preda(H).

