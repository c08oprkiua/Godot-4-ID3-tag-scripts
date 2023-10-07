# Godot-ID3-tag-scripts
These are GDscript scripts made for Godot 4 that read ID3 metadata from an MP3 file. 

To use the v2 script, set it to autoload. To mount a file for scanning, call `(yourglobalvariable).OpenFile(file)`, where `yourglobalvariable` is whatever you set the global variable for the script as, and `file` is the path to a file (MP3s work, others *might* work by coincidence, but not by intention, lol). From there, call `yourglobalvariable.SongInfo.get(value)`, where  `value` is whichever tag you're looking for from the file, corresponding to one of [these](https://exiftool.org/TagNames/ID3.html#v2_3) internal tags. 

To use the v1 script, call `ReadTags` with the path to the MP3 as the parameter, then once it has processed the file, access the ID3v1 tags from the the `SongInfo` dictionary in the script.
