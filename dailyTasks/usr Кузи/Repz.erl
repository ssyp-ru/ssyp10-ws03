%%Repmrjrjd Cthutq v0.6.
-module(Repz).

newfile(Name, Files) -> 							%%добавляем новый файл в список архивируемых.
	{ok,S}=file:read_file_info(Name),			%% берем нужные данные
	Size=element(2,S),							%%узнаем размер
	Date=element(7,S),							%%запоминаем дату создания
	Crc=crc(Name,Size),							%%подсчитываем контрольную сумму
	[{Name,Size,Date,0,0,Сrc}|Files]			%%формат кортежа: 
															%%{Имя, Размер до, время создания
															%%Размер после, тип сжатия, контрольная сумма}

tempname() ->	integer_to_string(element(1,time())+element(2,time())+element(3,time())). %%сумма часа, минуты и секунды
archive(Files,An) ->												%%архивируем. An - имя архива
	[F|File]=Files,													%%Берем файл из списка
	N=element(1,F),												%%Узнаем имя файла
	S=element(2,F),												%%Узнаем изначальный размер
	Tempname=tempname().									%%Клепаем имена временных файлов
	{ok,F}=file:open(N, [read, binary]),					%%Открываем файл
	Rle=rle(F,S,[Tempname++"rle.tmp"]),				%%Узнаем размер файла с архивацией типа рле.
	%%Haf=haf(F,S,[Tempname++"haf.tmp"]),			%%Узнаем размер файла с архивацией Хаффмана.
	%%Lz=lz(F,S,[Tempname++"lz.tmp"]),				%%Узнаем размер файла с архивацией Лз.
	%%Lzw=lzw(F,S,[Tempname++"lzw.tmp"]),		%%То же самое с Лзв
	%%She=she(F,S,[Tempname++"she.tmp"]),		%%Шеннон
	
rle(F,S,Tmp) -> {ok,T}=file:open(Tmp,[write,binary]),						%%Рле
	rle(F,S,T,Tmp).																			%%Открываем файл и запускаем освновной алгоритм
rle(File,0,Arc,Na) -> file:position(Arc,eof);										%%если файл кончился, то мы узнаем размер архива
rle(File,Size,Arc,Na) ->																	%%основной алгоритм
	if Size>=1024*1024  -> {ok,Ft}=file:read(File, 1024*1024);		%%если файл больше или равен одному мб, то считываем один мб
		Size<1024*1024 -> {ok,Ft}=file:read(File,Size) end,				%%иначе - считываем весь файл
	L=binary_to_list(Ft),																	%%перводим в лист полученные данные
	rlest(L,0,0,Arc),																			%%основа основ РЛЕ
    if Size>=1024*1024 -> rle(File,Size-1024*1024,Arc,Na);			%%если файл больше либо равен 1 мб, тогда запускаем заново.
	   Size<1024*1024 -> rle(File, 0,Arc,Na) end.								%%иначе - запускаем конец архивации
rlest([],I,C,Ar) -> file:write(Ar, <<I, C>>);
rlest(List,I,C,Ar) ->
	[L|Ist]=List,
	if	L==C -> rlest(Ist,I+1,C,Ar);
		L/=C -> file:write(Ar, <<I, C>>),
					rlest(Ist,1,L,Ar) end.
					
crc(Name,Size) -> {ok, File}=file:open(Name,[read,binary]), %%узнаем контрольную сумму
	C=crc2(File,Size),
	F=crc3(C),
	B=file:close(File),
	F.
crc2(F,0) -> 0;
crc2(F,Size) ->  {ok,C}=file:read(F,1),
[S|[]]=binary_to_list(C),
crc2(F,Size-1)+S.
crc3(C) ->
	if C>=65536 -> crc3(C-65536);
	   C<65536 -> C end.