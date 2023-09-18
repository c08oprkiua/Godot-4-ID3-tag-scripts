extends Node

#internal variables
var file
var ID3pos
var Tagsize

func OpenFile(filepath):
	file = FileAccess.open(filepath,FileAccess.READ)
	file.set_big_endian(true)
	#First we search for the 10 byte ID3 tag header
	#ID3 tags are supposed to, but don't always, prepend the music data in the file
	if file.get_buffer(3).get_string_from_utf8().contains("ID3"):
		print("ID3 found at file beginning")
		ID3pos = file.get_position()
	#And when they don't...
	else:
		var filebytes = file.get_buffer(file.get_length())
		ID3pos = filebytes.hex_encode().find("494433")/2
		print("Alternate ID3 tag finder used")
		file.seek(ID3pos+3)
		print(file.get_position())
		print(file.get_buffer(3).get_string_from_utf8())
	#The next 7 bytes after that are part of the header of the ID3 tag
	#These next two are version number
	print(file.get_buffer(2).hex_encode())
	#After that is the flag byte
	print(file.get_buffer(1).hex_encode())
	#Then the size information. This doesn't actually fetch the right size,
	#Because it's a synchsafe integer that only people who haven't touched
	#grass in 20 years seem to be able to explain in understandable English
	Tagsize = file.get_buffer(4).hex_encode()
	print(Tagsize)
	ID3pos = file.get_position()

func TagSearch(tag):
	var tagashex = tag.to_utf8_buffer().hex_encode()
	print(tagashex)
	var tagbytes = file.get_buffer(Tagsize)
	file.seek(ID3pos)
	file.seek(tagbytes.hex_encode().find(tagashex))
	print(file.get_position())
	print(file.get_buffer(4).get_string_from_utf8())

func TagLoad():
	#Now we start actually loading tags
	print(file.get_buffer(4).get_string_from_utf8())
	#These next 4 bytes have the information about the tag's size
	var size = file.get_buffer(4).hex_encode().hex_to_int()
	#These next two are flags
	file.get_buffer(2).hex_encode()
	var bytes = 1
	var input: PackedStringArray
	while bytes <= size:
		input.append(file.get_buffer(1).get_string_from_utf8())
		bytes = bytes+1
	var output: String
	print(output.join(input))
