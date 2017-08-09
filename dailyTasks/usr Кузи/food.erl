%%Функция(sed(продукт))определяет съедобен ли продукт.
%%Функция(veg(продукт))определяет съедобен ли продукт для вегетарианца.
-module(food).
-export([sed/1]).
-export([poisk/2]).
-export([veg/1]).


poisk([],A) -> false;
poisk([B|S1],A) -> if B == A -> true;
                      B /= A -> poisk(S1,A)
                   end.

sed(A) -> UU = poisk([konoplya,med,plutoniy,fignja,kirill],A),
          U = poisk([salat,kartofel,makaroni,sup,chipsi],A),
          if U 
           -> io:format("sjedobnoe ");
	     UU     
           -> io:format("ne sjedobnoe ") end.

veg(A) -> UU = poisk([mjaso,belka,kirill,salo,vegetarianetc],A),
          U = poisk([salat,kartofel,pomidor,voda,peretc],A),
          if U 
           -> io:format("Mojno ");
	     UU     
           -> io:format("ne Mojno ") end.