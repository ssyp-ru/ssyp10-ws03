-module(tie0_0).
-export[pack/2].
-export[unpack/2].

%%%%%%%PACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pack(IFiledir,OFiledir) ->
	[_,IFile] = file:open(IFiledir, [read,binary]),
	[_,OFile] = file:open(OFiledir, [read,write,binary]),
	header(OFile),
	writeData(IFiledir,IFile,OFile),
	prop(IFiledir,OFile,Method).

header(OFile) ->
	file:write(OFile,<<"ThisIsErlang0.00":(16*8)>>),
	file:write(OFile,<<"1":(2*8)>>).
	file:write(OFile,<<"":(6*8)>>)

writeData(IFiledir,IFile,OFile) ->
	[_,FileData] = file:read_file(IFiledir),
	Data = dopack(FileData,zero),
	Method = bestMethod(IFile),
	file:write(OFile,<<Data:(lists:flatlength(Data))>>),
	[SizeBefore,_,_,_,_,CDate|_] = file:read_file_info(IFiledir),
	file:write(OFile,<<IFiledir:(300*8)>>),
	file:write(OFile,<<SizeBefore:(2*8)>>),
	%%SizeAfter
	file:write(OFile,<<CDate:(8*8)>>),
	file:write(OFile,<<Method:(4*8)>>).

bestMethod(_) -> rle8sm.

prop(IFiledir,OFile,Method) ->
	[SizeBefore,_,_,_,_,CDate|_] = file:read_file_info(IFiledir),
	file:write(OFile,<<IFiledir:(300*8)>>),
	file:write(OFile,<<SizeBefore:(2*8)>>),
	%%SizeAfter
	file:write(OFile,<<CDate:(8*8)>>),
	file:write(OFile,<<Method:(4*8)>>).

dopack(File,zero) -> File;
dopack(File,rle8sm) ->  tie_rle8sm:pack(File).

	
%%%%%UNPACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

unpack(IFiledir,OFiledir) ->
	IFile = openfile(IFiledir),
	OFile = openfile(OFiledir),
	Mark = binary_to_term(file:read(IFile,(16*8))),
	case Mark of
		"ThisIsErlang0.00" -> counter(IFile,IFiledir);
		_ -> "What's The File exception error"
	end,
	Data = dounpack(File,zero).

counter(IFile,IFiledir) ->
	[IFileSize|_] = file:read_file_info(IFiledir),
	NFiles = binary_to_term(file:read(IFile,(2*8))),
	ListPos = binary_to_term(file:read(IFile,(6*8))).
	

dounpack(File,zero) -> File;
dounpack(File,rle8sm) ->  tie_rle8sm:unpack(File).

openfile(File) ->
    case file:open(File, [read,write,binary]) of
		{ok, _} ->
			[ok,F] = file:open(File, [read,write,binary]),
			F,true;
		[error, Reason] ->
			io:write(error, Reason)
    end.