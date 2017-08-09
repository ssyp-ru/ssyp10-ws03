-module(par).
-export([w/1]).

w(T) ->
receive "open" -> if	element(2,T)=1 -> Tu=T, io:format("It's opened now. ");
								element(2,T)=0 -> Tu=setelement(2,T,1), io:format("Window opened. ") end;
			"close" -> if	element(2,T)=0 -> Tu=T, io:format("It's closed now. ");
								element(2,T)=1 -> Tu=setelement(2,T,0), io:format("Window closed. ") end;
			"cnock" -> if	element(3,T)=1 -> Tu=T, io:format("I'm cnocking now. ");
								element(3,T)=0 -> Tu=setelement(3,T,1), io:format("*cnock-cnock* ") end;
			"stop" -> if	element(3,T)=0 -> Tu=T, io:format("I'm not cnocking. ");
								element(3,T)=1 -> Tu=setelement(3,T,1), io:format("O'kay ") end;
			"die" -> Tu=T, io:format("I can't do that. ") 
end,
w(Tu).