%%Repmrjrjd Cthutq v0.6.
-module(Repz).

newfile(Name, Files) -> 							%%��������� ����� ���� � ������ ������������.
	{ok,S}=file:read_file_info(Name),			%% ����� ������ ������
	Size=element(2,S),							%%������ ������
	Date=element(7,S),							%%���������� ���� ��������
	Crc=crc(Name,Size),							%%������������ ����������� �����
	[{Name,Size,Date,0,0,�rc}|Files]			%%������ �������: 
															%%{���, ������ ��, ����� ��������
															%%������ �����, ��� ������, ����������� �����}

tempname() ->	integer_to_string(element(1,time())+element(2,time())+element(3,time())). %%����� ����, ������ � �������
archive(Files,An) ->												%%����������. An - ��� ������
	[F|File]=Files,													%%����� ���� �� ������
	N=element(1,F),												%%������ ��� �����
	S=element(2,F),												%%������ ����������� ������
	Tempname=tempname().									%%������� ����� ��������� ������
	{ok,F}=file:open(N, [read, binary]),					%%��������� ����
	Rle=rle(F,S,[Tempname++"rle.tmp"]),				%%������ ������ ����� � ���������� ���� ���.
	%%Haf=haf(F,S,[Tempname++"haf.tmp"]),			%%������ ������ ����� � ���������� ��������.
	%%Lz=lz(F,S,[Tempname++"lz.tmp"]),				%%������ ������ ����� � ���������� ��.
	%%Lzw=lzw(F,S,[Tempname++"lzw.tmp"]),		%%�� �� ����� � ���
	%%She=she(F,S,[Tempname++"she.tmp"]),		%%������
	
rle(F,S,Tmp) -> {ok,T}=file:open(Tmp,[write,binary]),						%%���
	rle(F,S,T,Tmp).																			%%��������� ���� � ��������� ��������� ��������
rle(File,0,Arc,Na) -> file:position(Arc,eof);										%%���� ���� ��������, �� �� ������ ������ ������
rle(File,Size,Arc,Na) ->																	%%�������� ��������
	if Size>=1024*1024  -> {ok,Ft}=file:read(File, 1024*1024);		%%���� ���� ������ ��� ����� ������ ��, �� ��������� ���� ��
		Size<1024*1024 -> {ok,Ft}=file:read(File,Size) end,				%%����� - ��������� ���� ����
	L=binary_to_list(Ft),																	%%�������� � ���� ���������� ������
	rlest(L,0,0,Arc),																			%%������ ����� ���
    if Size>=1024*1024 -> rle(File,Size-1024*1024,Arc,Na);			%%���� ���� ������ ���� ����� 1 ��, ����� ��������� ������.
	   Size<1024*1024 -> rle(File, 0,Arc,Na) end.								%%����� - ��������� ����� ���������
rlest([],I,C,Ar) -> file:write(Ar, <<I, C>>);
rlest(List,I,C,Ar) ->
	[L|Ist]=List,
	if	L==C -> rlest(Ist,I+1,C,Ar);
		L/=C -> file:write(Ar, <<I, C>>),
					rlest(Ist,1,L,Ar) end.
					
crc(Name,Size) -> {ok, File}=file:open(Name,[read,binary]), %%������ ����������� �����
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