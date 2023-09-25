extends Node

#internal variables
var file
var ID3pos
var synchbytes
var Tagsize

var MoreTags = true

var SongInfo = {}

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
	#Then the size information. We have to do some funny business here, cause 
	#this is a synchsafe integer
	synchbytes = file.get_32()
	print(synchbytes)
	Synchsafeconversion()
	while MoreTags:
		TagLoad()

var converted = 0
var magic = 0x7F000000
#Max return from this should be 4095
func Synchsafeconversion():
	for byte in range(4):
		converted >>= 1
		converted |= synchbytes & magic
		magic >>= 8
	Tagsize = converted

func TagLoad():
	#Now we start actually loading tags
	var tag = file.get_buffer(4).get_string_from_utf8()
	if tag == "":
		MoreTags = false
		return
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
	SongInfo[tag] = output.join(input)
	Tagsize = Tagsize-size
