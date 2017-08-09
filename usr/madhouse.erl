-module(madhouse).
-export[exe/0].

exe() ->
	a11 = spawn(madhouse,flat11,[false]),
	a21 = spawn(madhouse,flat11,[false]).

flat11(W) ->
	receive
		open -> flat11(true);
		close -> flat11(false);
		throw ->
			case W of
				true -> io:write("11 did ololo");
				false -> io:write("11 error")
			end;
		catcha ->
			case W of
				true -> io:write("11 is a loser");
				false -> io:write("11 is ok :3")
			end
	end.

flat21(W) ->
	receive
		open -> flat21(true);
		close -> flat21(false);
		throw ->
			case W of
				true -> io:write("21 did ololo"), a11 ! catcha;
				false -> io:write("21 error")
			end
	end.