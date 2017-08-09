-module(war).
-export([addplayer/1]).
-export([men/6]).
-export([grenades/2]).

addplayer(Name) -> spawn(war,men,[100,50,50,5,15,Name]).

men(Zdor,Def,Luck,Attackmin,Attackmax,Name)
 -> if  Zdor =< 0 
			->  io:format("Player ~w is dead ",[Name]);
		Zdor > 0 
			->  receive
					{hitme,[Name2,Attackmin2,Attackmax2,Luck2]} 
						->  A = damagecounter(Def,Luck2,Attackmin2,Attackmax2),io:format("~w hits ~w by ~w ",[Name2,Name,A]),men(Zdor-A,Def,Luck,Attackmin,Attackmax,Name);
					{hit,X} 
						->  X ! ({hitme,[Name,Attackmin,Attackmax,Luck]}),men(Zdor,Def,Luck,Attackmin,Attackmax,Name);
					look_at_me 
						->  io:format(" name - ~w ~n health - ~w ~n defense - ~w ~n luck - ~w ~n attack - ~w...~w ~n",[Name,Zdor,Def,Luck,Attackmin,Attackmax]),men(Zdor,Def,Luck,Attackmin,Attackmax,Name);
					{look_at_him,X} 
						->  X!(my_inf),men(Zdor,Def,Luck,Attackmin,Attackmax,Name);
					my_inf 
						->  io:format(" name - ~w ~n health - ~w ~n",[Name,Zdor]),men(Zdor,Def,Luck,Attackmin,Attackmax,Name);
					my_param 
						->  [Def,Name];
					{throw_grenade,X} 
						->  io:format("~w threw the grenade ",[Name]),
							spawn(war,grenades,[self(),X]),
							men(Zdor,Def,Luck,Attackmin,Attackmax,Name)
				end 
	end.
	
grenades(Y,X)
 -> receive
		after
			2000
				->  io:format("BOOM! "),
					AA = random:uniform(100)-95,
					if  AA > 0 
							-> Y!({hitme,[grenade,50,100,100]});
						AA =< 0 
							-> X!({hitme,[grenade,50,100,100]})
					end
	end.

damagecounter(Def,Luck,Attackmin,Attackmax)
 -> A = random:uniform(100)-Luck,
	if  A > 0 
			-> 0;
		A =< 0 
			->  B = random:uniform(Attackmax-Attackmin+1)+Attackmin-1,
				C = random:uniform(Def),
				round(B/100*(100-C))end. 