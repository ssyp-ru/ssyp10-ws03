-module(shennon).
-export([shennon_pack/1,shennon_unpack/1,sort/4,delete/4]).

shennon_pack(S1)
 -> UU = slovarik(S1,[],[]),
	UUU = sort(lists:nth(1,UU),lists:nth(2,UU),[],[]),
	[main_pack(S1,[],UUU),UUU].

main_pack([],S2,_) -> lists:reverse(S2);
main_pack([A|S1],S2,UUU)
 -> main_pack(S1,[poisk(UUU,A,1)|S2],UUU).
	
	
slovarik([],Sl1,Sl2)                                                    %%ok
 -> [Sl1,Sl2];                                                          %%
slovarik([A|S1],Sl1,Sl2)                                                %%
 -> UU = poisk(Sl1,A,1),                                                %%
	if  UU == false                                                     %%
			-> slovarik(S1,[A|Sl1],[1|Sl2]);                            %%
		UU /= false                                                     %%
			-> slovarik(S1,Sl1,(zamena([],Sl2,UU,1)))end.               %%

zamena(S2,[],_,_)                                                       %%ok
 -> lists:reverse(S2);                                                  %%
zamena(S2,[A|S1],N,M)                                                   %%
 -> if  N /= M                                                          %%
			-> zamena([A|S2],S1,N,M+1);                                 %%
		N == M                                                          %%
			-> zamena([A+1|S2],S1,N,M+1)end.                            %%

poisk([],_,_)                                                           %%ok
 -> false;                                                              %%
poisk([A|S1],B,N)                                                       %%
 -> if  A == B                                                          %%
			-> N;                                                       %%
		A /= B                                                          %%
			-> poisk(S1,B,N+1)end.                                      %%

delete([],S2,_,_)                                                       %%ok
 -> lists:reverse(S2);                                                  %%
delete([A|S1],S2,N,M)                                                   %%
 -> if  N == M                                                          %%
			-> delete(S1,S2,N,M+1);                                     %%
		N /= M                                                          %%
			-> delete(S1,[A|S2],N,M+1)end.                              %%

sort([],[],P1,_) -> P1;                                              					    %%ok
sort(S1,S2,P1,P2)                                                 						    %%
 -> N = poisk(S2,lists:min(S2),1),                                      					%%
	sort(delete(S1,[],N,1),delete(S2,[],N,1),[lists:nth(N,S1)|P1],[lists:nth(N,S2)|P2]).    %%

main_unpack([],_,S3) -> lists:reverse(S3);
main_unpack([A|S1],S2,S3)
 -> main_unpack(S1,S2,[lists:nth(A,S2)|S3]).
	
shennon_unpack(UU)
 -> main_unpack(lists:nth(1,UU),lists:nth(2,UU),[]).                                                                