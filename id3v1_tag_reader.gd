extends Node

#constants
const BLOCK_SIZE = 128

#internal variables
var SongInfo : Dictionary = {
	"TITLE" : "",
	"ARTIST" : "",
	"ALBUM" : "",
	"YEAR" : "",
	"COMMENT" : "",
	"GENRE" : 0,
}

func ReadTags(filepath) -> void:
	var file = FileAccess.open(filepath, FileAccess.READ)
	
	# fetch tag block
	if file.get_length() < 128:
		return;
	file.seek_end(-BLOCK_SIZE)
	
	# checking identifier
	var tag_id: PackedByteArray = file.get_buffer(3)
	if tag_id.get_string_from_ascii() != "TAG":
		return
	else:
		print("ID3v1 tag found")
	
	# reading tags (ASCII-Encoded)
	SongInfo["TITLE"] = file.get_buffer(30).get_string_from_ascii()
	SongInfo["ARTIST"] = file.get_buffer(30).get_string_from_ascii()
	SongInfo["ALBUM"] = file.get_buffer(30).get_string_from_ascii()
	SongInfo["YEAR"] = file.get_buffer(4).get_string_from_ascii()
	SongInfo["COMMENT"] = file.get_buffer(30).get_string_from_ascii()
	SongInfo["GENRE"] = file.get_buffer(1)[0]	# integer declaring Genre (0-79 or up to 191 [Wisdexnamp])
	
	file.close()
