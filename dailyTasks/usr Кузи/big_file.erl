-module(big_file).
-export([do_this/0]).

do_this() -> 
	{ok, F}=file:open("big.txt", [write, binary]),
	file:write(F, <<"dmnfladklglklkjdlklklsaf;khiuhoadsatiigraildorogavraiognerngfkjrjgonsfjlksjfdvnjzdkjvmzlkjfsdkjokijdkjjdflkjoijskjjdoijoijgojopjsoijojdkikfjjflflflfllalallalllaalalaaaalaaalalaknllklk":100000>>).