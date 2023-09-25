# Godot-ID3-tag-script
This is a GDscript script made for Godot 4 that reads ID3 metadata from an MP3 file. 

This is a script I intend to use in some projects of mine, but I figured, since those projects are going to be a ways away, I will release this, cause I'm sure some other Godot devs could use it. 

To use it, set it to autoload. To mount a file for scanning, call `(yourglobalvariable).OpenFile(file)`, where `yourglobalvariable` is whatever you set the global variable for the script as, and `file` is the path to a file (MP3s work, others *might* work by coincidence, but not by intention, lol). From there, call `yourglobalvariable.SongInfo.get(value)`, where  `value` is whichever tag you're looking for from the file, corresponding to one of [these](https://exiftool.org/TagNames/ID3.html#v2_3) internal tags. 
