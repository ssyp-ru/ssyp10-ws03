%% Stupis example for dummies by Don Miguel ����2010
-module(tb).
-export([wr/2]).



wr(FileName,FileNameW) ->

%%������� ���� � ������ FileName ��� ������.
	{Error,F} = file:open(FileName, [read,binary]),
%% � Error ������ ���� ok

%%������� ���� � ������ FileNameW ��� ������.
	{ErrorW,FW} = file:open(FileNameW, [write,binary, {encoding, latin1}]),
%% � Error ������ ���� ok


%%������ ������ �� �����. ��� � �������� ���� <<binary>>
	{Error1,Data} = file:read(F,100),
%%������� ������� ���� �������
	io:format("We read ~w bytes from ~w ~n",[size(Data),FileName]),

%% ��������� ������ � ������
	L = binary:bin_to_list(Data),


	io:write(FW,Data),
	                                                        

	%%Error
	%%file:open() ->   

%% ����������� ����� ����������������� ����� ����� �� �������������
file:close(FW),
file:close(F).

my_binary_to_list(<<H,T/binary>>) ->
    [H|my_binary_to_list(T)];
my_binary_to_list(<<>>) -> [].


%% binary:at(���_������, �������) -> int()
%% Pos = int() >= 0
%% If Pos >= byte_size(Subject), a badarg exception is raised.
%%bin_to_list(Subject) -> list()
%% byte_size(Bin)
        