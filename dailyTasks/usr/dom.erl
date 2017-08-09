%%B = spawn(dom,domGO,[]) - адрес первого человека,B2 = spawn(dom,sos2,[false,false]) - адрес второго человека, B ! ("команда") - обращаться к первому           
-module(dom).
-export([domGO/0]).
-export([sos2/2]).

domGO() -> sos1(false,false).

sos1(Okno1,Okno2) ->	
	receive 
		open  -> if Okno1 /= true -> io:format("Otkril"),sos1(true,Okno2);
					Okno1 == true -> io:format("Uzhe otkrito"),sos1(true,Okno2)end;
		close -> if Okno1 == true -> io:format("Zakril"),sos1(false,Okno2);
					Okno1 /= true -> io:format("Uzhe zakrito"),sos1(false,Okno2)end;

		{A,open} -> A ! (open),sos1(Okno1,Okno2);
		
		{B,close} -> B ! (close),sos1(Okno1,Okno2)
	end.
	
sos2(Okno1,Okno2) ->	
	receive 
		open  -> io:format("asd"),if Okno2 /= true -> io:format("Otkril"),sos1(Okno1,true);
					Okno2 == true -> io:format("Uzhe otkrito"),sos1(Okno1,true)end;
		close -> if Okno2 == true -> io:format("Zakril"),sos1(Okno1,false);
					Okno2 /= true -> io:format("Uzhe zakrito"),sos1(Okno1,false)end
	end.