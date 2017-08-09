-module(file_test0).
-export[exe/1].

exe(A) ->
	F = file:open("temp.txt",[write]),
	file:write_file("temp.txt","asdfghj").