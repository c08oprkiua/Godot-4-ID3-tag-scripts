extends RefCounted
class_name ID3V1

#constants
const BLOCK_SIZE = 128

#internal variables
var SongInfo : Dictionary = {
	"TITLE" : "",
	"ARTIST" : "",
	"ALBUM" : "",
	"YEAR" : "",
	"COMMENT" : "",
	"TRACKNUM": "",
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
	SongInfo["COMMENT"] = file.get_buffer(28).get_string_from_ascii()
	#Only difference between 1 and 1.1 is that the last two bytes of the 
	# comment in 1.1 are used for the track number
	var oneonebyte = file.get_buffer(2)
	if oneonebyte[0] == 0 and oneonebyte[1] != 0:
		SongInfo["TRACKNUM"] = oneonebyte[1]
	else:
		SongInfo["TRACKNUM"] = null
		var add = oneonebyte.get_string_from_ascii()
		var comment = SongInfo.get("COMMENT")
		SongInfo["COMMENT"] = comment+add
	SongInfo["GENRE"] = file.get_buffer(1)[0]	# integer declaring Genre (0-79 or up to 191 [Wisdexnamp])
	file.close()


#stuck this at the end so it wouldn't bloat the script
enum genres {
	Blues,
	Classic_Rock, 
	Country,
	Dance,
	Disco,
	Funk,
	Grunge,
	Hip_Hop, #Hip-Hop
	Jazz,
	Metal,
	New_Age,
	Oldies, 
	Other,
	Pop, 
	R_B, #R&B
	Rap,
	Reggae,
	Rock,
	Techno,
	Industrial,
	Alternative,
	Ska,
	Death_Metal, 
	Pranks, 
	Soundtrack, 
	Euro_Techno, #Euro-Techno
	Ambient,
	Trip_Hop, #Trip-Hop
	Vocal,
	Jazz_Funk, #Jazz+Funk
	Fusion,
	Trance,
	Classical,
	Instrumental,
	Acid,
	House,
	Game, 
	Sound_Clip,
	Gospel, 
	Noise, 
	AlternRock,
	Bass,
	Soul,
	Punk, 
	Space, 
	Meditative, 
	Instrumental_Pop,
	Instrumental_Rock,
	Ethnic,
	Gothic, 
	Darkwave, 
	Techno_Industrial, #Techno-Industrial
	Electronic, 
	Pop_Folk, 
	Eurodance, 
	Dream, 
	Southern_Rock,
	Comedy,
	Cult,
	Gangsta,
	Top_40,
	Christian_Rap,
	Pop_Funk, #Pop/Funk
	Jungle,
	Native_American,
	Cabaret,
	New_Wave,
	Psychadelic,
	Rave,
	Showtunes,
	Trailer,
	Lo_Fi, #Lo-Fi
	Tribal,
	Acid_Punk,
	Acid_Jazz,
	Polka,
	Retro,
	Musical,
	Rock_Roll, #Rock & Roll
	Hard_Rock,
	Folk,
	Folk_Rock, #Folk-Rock
	National_Folk,
	Swing,
	Fast_Fusion,
	Bebob,
	Latin,
	Revival,
	Celtic,
	Bluegrass,
	Avantgarde,
	Gothic_Rock,
	Progressive_Rock,
	Psychedelic_Rock,
	Symphonic_Rock,
	Slow_Rock,
	Big_Band,
	Chorus,
	Easy_Listening,
	Acoustic,
	Humour,
	Speech,
	Chanson,
	Opera,
	Chamber_Music,
	Sonata,
	Symphony,
	Booty_Bass,
	Primus,
	Porn_Groove,
	Satire,
	Slow_Jam,
	Club,
	Tango,
	Samba,
	Folklore,
	Ballad,
	Power_Ballad,
	Rhythmic_Soul,
	Freestyle,
	Duet,
	Punk_Rock,
	Drum_Solo,
	A_capella,
	Euro_House, #Euro-House
	Dance_Hall
}
