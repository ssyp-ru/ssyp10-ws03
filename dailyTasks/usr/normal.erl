%%Нормализация элементов списка. Смирнов Павел
-module(normal).
-export([normal/1]).

normal(A) -> Mi = lists:min(A),
 Ma = lists:max(A),
 AAg = fun(UU) -> UU-Mi end,
 AAm = fun(UU) -> UU*255/(Ma-Mi) end,
 lists:map(AAm,lists:map(AAg, A)).



