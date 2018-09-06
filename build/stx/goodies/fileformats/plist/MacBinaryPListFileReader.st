"{ Package: 'stx:goodies/fileformats/plist' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MacBinaryPListFileReader
	instanceVariableNames:'inStream tokenH tokenL offsetSize refSize numObjects topObject
		offsetTableOffset objectOffsets topOffset'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!MacBinaryPListFileReader class methodsFor:'documentation'!

documentation
"
    reads/writes mac osx plist files.
    These are used to store an application's settings.
"
!

examples
"
     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
     self readFrom:('/Library/Preferences/com.apple.Bluetooth.plist' asFilename readStream)
"
! !

!MacBinaryPListFileReader class methodsFor:'writing'!

readFrom:inStream
    ^ self new readFrom:inStream

    "
     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
     self readFrom:('/Library/Preferences/com.apple.Bluetooth.plist' asFilename readStream)
    "
!

write:anObject to:outStream
    self new write:anObject to:outStream

    "
     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
! !

!MacBinaryPListFileReader methodsFor:'reading'!

getSize
    |byte nBytes|

    tokenL == 16r0F ifFalse:[ ^ tokenL ].

    byte := inStream next.
    (byte bitAnd: 16rF0) == 16r10 ifFalse:[
        self error:('Field definition not followed by int type, at offset %1' bindWith:inStream position).
    ].
    nBytes := 2 raisedTo:(byte bitAnd: 16r0F).
    ^ inStream nextNumber:nBytes
!

readBinary
    |trailerBytes trailer|

    inStream binary.
    "/ read the header
    inStream position:(inStream fileSize - 32).

    trailerBytes := inStream next:32.
    trailer := PythonStructPacker unpack:'>6xBBQQQ' from:trailerBytes.
    offsetSize := trailer at:1.         "/ offset_int_size
    refSize := trailer at:2.            "/ collection_offset_size
    numObjects := trailer at:3.         "/ object_count
    topObject := trailer at:4.          "/ top_level_object_index
    offsetTableOffset := trailer at:5.  "/ offest_table_offset

    inStream position:offsetTableOffset.
    objectOffsets := (1 to:numObjects) collect:[:i | 
        inStream nextNumber:offsetSize
    ].
    topOffset := objectOffsets at:topObject+1.
    inStream position:(objectOffsets at:topObject+1).
    
    ^ self readBinaryObject.

    "a binary example:

     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
!

readBinaryArray
    |array_count array_refs|

    array_count := self getSize.    
    array_refs := Array new:array_count.
    1 to:array_count do:[:i |
        array_refs at:i put:(inStream nextNumber:refSize).
    ].
    ^ array_refs 
        collect:[:ref |
            self readBinaryObjectAt:(objectOffsets at:ref+1) 
        ]

    "a binary example:

     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
!

readBinaryDictionary
    |dict_count dict key_refs value_refs|

    dict_count := self getSize.
    
    key_refs := (1 to:dict_count)
        collect:[:i |
            inStream nextNumber:refSize
        ].
    value_refs := (1 to:dict_count)
        collect:[:i |
            inStream nextNumber:refSize
        ].

    dict := Dictionary new.    
    (1 to:dict_count) do:[:i |  
        |key val|
        
        "/ print("Key ref: {0}\tVal ref: {1}".format(key_refs[i], value_refs[i]))
        key := self readBinaryObjectAt:(objectOffsets at:(key_refs at:i)+1).
        val := self readBinaryObjectAt:(objectOffsets at:(value_refs at:i)+1).
        dict at:key put:val.
    ].        
    ^ dict

    "a binary example:

     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
!

readBinaryObject
    |token|

    token := inStream nextByte.
    (token == 16r00) ifTrue:[^ nil].
    (token == 16r08) ifTrue:[^ false].
    (token == 16r09) ifTrue:[^ true].
    (token == 16r0C) ifTrue:[ self error:'URL not supported' ].
    (token == 16r0D) ifTrue:[ self error:'URL not supported' ].
    (token == 16r0E) ifTrue:[ self error:'UUID not supported' ].
    (token == 16r0F) ifTrue:[^ ''].

    tokenH := token bitAnd:16rF0.
    tokenL := token bitAnd:16r0F.

    (tokenH == 16r10) ifTrue:[ 
        |int_length|

        int_length := 2 raisedTo:tokenL.
        ^ inStream nextNumber:int_length.
    ].
    (token == 16r22) ifTrue:[ 
        |float_length float_bytes|

        self halt:'float'.
        float_length := 2 raisedTo:tokenL. 
        float_bytes := inStream nextBytes:float_length.  
        ^ self __decode_float:float_bytes.
    ].
    (token == 16r23) ifTrue:[ self halt:'double'].
    (token == 16r33) ifTrue:[ 
        |date_bytes date_value result|
        
        date_value := Double readBinaryIEEEDoubleFrom:inStream MSB:true.
        [
            result := (Timestamp year:2001 month:1 day:1) + date_value seconds.
        ] on:Error do:[
            result := (Timestamp year:1970 month:1 day:1).
        ].        
        ^ result
    ].

    (tokenH == 16r40) ifTrue:[
        |data_length|
        
        data_length := self getSize.    
        ^ inStream nextBytes:data_length
    ].
    (tokenH == 16r50) ifTrue:[ 
        |ascii_length|

        ascii_length := self getSize.    
        ^ (inStream nextBytes:ascii_length) asString
    ].
    (tokenH == 16r60) ifTrue:[ 
        |utf16_length|

        self halt:'utf16 unicode string'.
        utf16_length := self getSize.    
        ^ (CharacterEncoder encoderFor:#UTF16BE) decodeString:(inStream nextBytes:utf16_length)    
    ].
    (tokenH == 16r80) ifTrue:[
        |uid_length uid_bytes|
        
        self halt:'uuid'.
        uid_length := tokenL + 1.
        uid_bytes := inStream nextBytes:uid_length.
        ^ UUID readFrom:uid_bytes
    ].
    (tokenH == 16rA0) ifTrue:[
        ^ self readBinaryArray 
    ].
    (tokenH == 16rC0) ifTrue:[
        ^ self readBinarySet 
    ].
    (tokenH == 16rD0) ifTrue:[ 
        ^ self readBinaryDictionary 
    ].

    self error:'invalid'.

    "a binary example:

     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
!

readBinaryObjectAt:offset
    inStream position:offset.
    ^ self readBinaryObject.
!

readBinarySet
    |set_count set_refs|

    self halt:'set'.

    set_count := self getSize.    
    set_refs := Array new:set_count.
    1 to:set_count do:[:i |
        set_refs at:i put:(self __decode_multibyte_int:(inStream nextBytes:refSize) signed:false).
    ].
    ^ set_refs 
        collect:[:ref |
            self readBinaryObjectAt:(objectOffsets at:ref+1) 
        ]
        as:Set

    "a binary example:

     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
!

readFrom:inStreamArg
    |magic|

    inStream := inStreamArg.
    magic := inStream next:8.
    magic asString = 'bplist00' ifTrue:[
        "/ binary format
        ^ self readBinary
    ] ifFalse:[
        "/ xml format
        ^ self readXML
    ].

    "a binary example:

     self readFrom:('~/Library/Preferences/com.apple.AddressBook.plist' asFilename readStream)
    "
    "an xml example:
     self readFrom:('~/Library/Preferences/JackPilot.plist' asFilename readStream)
    "
! !

!MacBinaryPListFileReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacBinaryPListFileReader.st,v 1.1 2018-05-03 23:30:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacBinaryPListFileReader.st,v 1.1 2018-05-03 23:30:22 cg Exp $'
! !

