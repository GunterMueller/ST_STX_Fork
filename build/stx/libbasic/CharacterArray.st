"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

UninterpretedBytes variableByteSubclass:#CharacterArray
	instanceVariableNames:''
	classVariableNames:'DecoderTables DecodingFailedSignal EncoderTables
		EncodingFailedSignal PreviousMatches UnicodeDenormalizationMap
		UnicodeNormalizationMap'
	poolDictionaries:''
	category:'Collections-Text'
!

!CharacterArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    CharacterArray is a superclass for all kinds of Strings (i.e.
    (singleByte-)Strings, TwoByteStrings, UnicodeStrings
    and whatever may come in the future.

    This class is abstract, meaning that there are no instances of it;
    concrete subclasses define how the characters are stored (i.e. either as
    single byte, two-byte or four byte strings).

    All this class does is provide common protocol for concrete subclasses.

    Notice:
        internally, ST/X uses a unicode encoding for ALL characters - both
        for individual chatacter entities and for strings of characters.
        When reading/writing files in different encodings, the conversion is
        done at read/write time by use of a CharacterEncoder instance.
        These know how to convert to a wide range of encodings.

    Also notice:
        UTF8 and UTF16 are external encodings of a Unicode string; they are never
        used internally. When interacting with a UTF8 interface (OS-API or files),
        you should convert UTF8 into the internal full Unicode right at the interface.
        Do not keep UTF8 around internally as String instances.
        The reason is that UTF8 makes it harder to manipulate strings (for example
        to insert/extract substrings or to get its size. Of such operations would
        require a scan of the UTF8, which would complicate them).
        Of course, there may be rare exceptions to this, for example if a file's contents
        is treated as raw data, and the strings have to be copied/shuffled around only,
        without any real processing on it.

    [author:]
        Claus Gittinger

    [see also:]
        String TwoByteString Unicode16String Uniode32String
        StringCollection
"
! !

!CharacterArray class methodsFor:'initialization'!

initialize
    DecodingFailedSignal isNil ifTrue:[
        DecodingFailedSignal := DecodingError.
        DecodingFailedSignal notifierString:'error during decode'.

        EncodingFailedSignal :=EncodingError.
        EncodingFailedSignal notifierString:'error during encode'.
    ]

    "
     CharacterArray initialize
    "

    "Modified: 3.8.1997 / 18:15:59 / cg"
! !

!CharacterArray class methodsFor:'instance creation'!

basicNew
    "return a new empty string"

    ^ self basicNew:0
!

fromBytes:aByteCollection
    "return an instance of the receiver class,
     taking untranslated bytes from the argument, aByteCollection
     in most-significant first order.
     Only useful, when reading twoByteStrings from external sources."

    ^ self fromBytes:aByteCollection MSB:true

    "
     Unicode16String fromBytes:#[16r02 16r20]
     Unicode16String fromBytes:#[16r02 16r20] MSB:true
     Unicode16String fromBytes:#[16r02 16r20] MSB:false
    "

    "Modified: 30.6.1997 / 20:08:37 / cg"
!

fromBytes:aByteCollection MSB:msb
    "return an instance of the receiver class,
     taking untranslated bytes from the argument, aByteCollection
     in the given byte order.
     Only useful, when reading twoByteStrings from external sources."

    |mySize nBytes newString dstIdx|

    self assert:(self ~~ CharacterArray). "/ only works for concrete subclasses.

    "/ the following is a quite inefficient implementation.
    "/ consider rewriting, if heavily used.
    nBytes := aByteCollection size.
    mySize := self basicNew bitsPerCharacter.
    mySize == 16 ifTrue:[
        newString := self uninitializedNew:(nBytes // 2).
        dstIdx := 1.
        msb ifTrue:[
            aByteCollection pairWiseDo:[:hi :lo |
                newString at:dstIdx put:(Character value:(hi bitShift:8)+lo).
                dstIdx := dstIdx + 1
            ].
        ] ifFalse:[
            aByteCollection pairWiseDo:[:lo :hi |
                newString at:dstIdx put:(Character value:(hi bitShift:8)+lo).
                dstIdx := dstIdx + 1
            ].
        ].
        ^ newString.
    ].

    ^ (self uninitializedNew:nBytes) replaceFrom:1 with:aByteCollection

    "
     Unicode16String fromBytes:#[16r02 16r20]
    "

    "Modified: 30.6.1997 / 20:08:37 / cg"
!

fromString:aString
    "return a copy of the argument, aString"

    |sz|

    sz := aString size.
    ^ (self uninitializedNew:sz) replaceFrom:1 to:sz with:aString startingAt:1

    "
        Unicode16String fromString:'hello'
    "
!

fromStringCollection:aCollectionOfStrings
    "return new string formed by concatenating a copy of the argument, aString"

    ^ self fromStringCollection:aCollectionOfStrings separatedBy:''

    "
     String fromStringCollection:#('hello' 'world' 'how' 'about' 'this')
    "

    "Created: 20.11.1995 / 15:26:59 / cg"
!

fromStringCollection:aCollectionOfStrings separatedBy:aSeparatorString
    "return new string formed by concatenating a copy of the argument, aString"

    |stream|

    aCollectionOfStrings do:[:eachString |
        stream isNil ifTrue:[
            stream := self writeStreamClass with:eachString.
        ] ifFalse:[
            stream
                nextPutAll:aSeparatorString;
                nextPutAll:eachString.
        ].
    ].
    stream isNil ifTrue:[^ ''].
    ^ stream contents

    "
     String fromStringCollection:#('hello' 'world' 'how' 'about' 'this') separatedBy:' '
     String fromStringCollection:#('hello' 'world' 'how' 'about' 'this') separatedBy:'Ƞ'
     Text fromStringCollection:{'hello'. 'world'. 'how' allBold. 'about'. 'this'. 'äöü'} separatedBy:'Ƞ'
    "

    "Created: 20.11.1995 / 15:32:17 / cg"
!

fromUTF8Bytes:aByteCollection
    "return a new string which represents the characters as decoded
     from the utf8 encoded bytes, aByteCollection.
     Returns either a normal String, or a TwoByteString instance.
     Only useful, when reading twoByteStrings from external sources.
     This only handles up-to 16bit characters"

    ^ self decodeFromUTF8:aByteCollection.

    "
     CharacterArray fromUTF8Bytes:#[ 16r41 16r42 ]
     CharacterArray fromUTF8Bytes:#[ 16rC1 16r02 ]
     CharacterArray fromUTF8Bytes:#[ 16rE0 16r81 16r02 ]
     CharacterArray fromUTF8Bytes:#[ 16rEF 16rBF 16rBF ]

   rfc2279 examples:
     CharacterArray fromUTF8Bytes:#[ 16r41 16rE2 16r89 16rA2 16rCE 16r91 16r2E ]
     CharacterArray fromUTF8Bytes:#[ 16rED 16r95 16r9C 16rEA 16rB5 16rAD 16rEC 16r96 16rB4 ]
     CharacterArray fromUTF8Bytes:#[ 16rE6 16r97 16rA5 16rE6 16r9C 16rAC 16rE8 16rAA 16r9E ]

   invalid:
     CharacterArray fromUTF8Bytes:#[ 16rC0 16r80 ]
     CharacterArray fromUTF8Bytes:#[ 16rE0 16r80 16r80 ]
    "
!

new
    "return a new empty string"

    ^ self basicNew:0
!

readSmalltalkStringFrom:aStreamOrString onError:exceptionBlock
    "read & return the next String from the (character-)stream aStream;
     skipping all whitespace first; return the value of exceptionBlock,
     if no string can be read. The sequence of characters as read from the
     stream must be one as stored via storeOn: or storeString."

    |str collected char|

    str := aStreamOrString readStream.

    "skip whiteSpace"
    str skipSeparators.

    (str peekOrNil == $') ifTrue:[
        str next.
        collected := self writeStream.
        [str atEnd] whileFalse:[
            char := str next.
            char == $' ifTrue:[
                "/ look for another quote
                str peekOrNil ~~ $' ifTrue:[
                    "end of string reached"
                    ^ collected contents.
                ].
                "eat doubled quote"
                str next.
            ].
            ((char ~~ Character return) or:[str peekOrNil ~~ Character lf]) ifTrue:[
                "compress CRLF to LF, but keep a single CR"
                collected nextPut:char.
            ].
        ].
        "if we come here, we reached the end without finding a closing $'"
    ].
    ^ exceptionBlock value

    "
     String readFrom:('''hello world''' readStream)
     String readFrom:('''hello '''' world''' readStream)
     String readFrom:('1 ''hello'' ' readStream)
     String readFrom:('1 ''hello'' ' readStream) onError:['foobar']
    "

    "Created: / 05-07-2006 / 16:41:04 / cg"
    "Modified: / 06-10-2006 / 14:05:32 / cg"
!

writeStreamClass
    "the type of stream used in writeStream.
     Here, we return CharacterWriteStream, which automatically changes
     the underlying collection to a multiByte string (i.e. UnicodeString).
     So you can stream wide characters into it."

    ^ CharacterWriteStream

    "
     String writeStream

     - the following delivers a Unicode16String:
     
     String streamContents:[:s |
         s nextPut:(Character value:16r3f30).
         s nextPutAll:'hello'.
         s cr.
     ] 
    "

    "Created: / 09-01-2011 / 10:37:57 / cg"
! !


!CharacterArray class methodsFor:'Compatibility-VW'!

fromIntegerArray: anArray
    "Answer a new instance of the receiver that is created from the argument, anArray."

    | new |

    new := self new: anArray size.
    1 to: anArray size do:[:index |
        new at: index put: (anArray at: index) asCharacter
    ].
    ^new

    "
     String fromIntegerArray: #[8 127]
    "
! !

!CharacterArray class methodsFor:'Signal constants'!

decodingFailedSignal
    "return the signal, raised when decoding of a string is not possible
     due to invalid characters contained in the source.
     This may happen for example, if a non EUC coded 8-bit string
     is attempted to be decoded into a JIS string."

    ^ DecodingFailedSignal

    "Created: 28.6.1997 / 20:09:55 / cg"
    "Modified: 3.8.1997 / 18:16:47 / cg"
!

encodingFailedSignal
    "return the (query-) signal, raised when encoding of a string is not possible
     due to invalid characters contained in the source."

    ^ EncodingFailedSignal

    "Modified: 28.6.1997 / 20:09:35 / cg"
    "Created: 3.8.1997 / 18:16:40 / cg"
! !


!CharacterArray class methodsFor:'cleanup'!

lowSpaceCleanup
    "cleanup in low-memory situations"

    DecoderTables := EncoderTables := nil

    "
     CharacterArray lowSpaceCleanup
    "

    "Created: 22.2.1996 / 16:30:30 / cg"
    "Modified: 22.2.1996 / 17:58:05 / cg"
! !

!CharacterArray class methodsFor:'encoding & decoding'!

decodeFromUTF8:aStringOrByteCollection
    "given a string in UTF8 encoding,
     return a new string containing the same characters, in Unicode encoding.
     Returns either a normal String, a Unicode16String or a Unicode32String instance.
     This is only useful, when reading from external sources or communicating with
     other systems 
     (ST/X never uses utf8 internally, but always uses strings of fully decoded unicode characters).
     This only handles up-to 30bit characters."

    |sz anyAbove7BitAscii nBitsRequired
     ascii "{ Class: SmallInteger }"
     byte  "{ Class: SmallInteger }"
     lastIdx  "{ Class: SmallInteger }"
     srcIdx  "{ Class: SmallInteger }"
     idx  "{ Class: SmallInteger }"
     nFollowBytes  "{ Class: SmallInteger }"
     minValue "{ Class: SmallInteger }"
     newString|

    "/ fast track, also avoid creation of new strings if aStringOrByteCollection is already a 7-bit string
    aStringOrByteCollection containsNon7BitAscii ifFalse:[
        ^ aStringOrByteCollection asSingleByteString
    ].

    nBitsRequired := 8.
    anyAbove7BitAscii := false.
    sz := 0.

    lastIdx := aStringOrByteCollection size.
    srcIdx := 1.

    "first determine the string size and max element size.
     Check for UTF-8 confomance on the fly."
    [srcIdx <= lastIdx] whileTrue:[
        byte := ascii := aStringOrByteCollection byteAt:srcIdx. 
        srcIdx := srcIdx + 1.
        (byte bitAnd:16r80) ~~ 0 ifTrue:[
            anyAbove7BitAscii := true.
            (byte bitAnd:2r11100000) == 2r11000000 ifTrue:[
                "/ 80 .. 7FF
                ascii := byte bitAnd:2r00011111.
                nFollowBytes := 1.
                minValue := 16r80.
            ] ifFalse:[(byte bitAnd:2r11110000) == 2r11100000 ifTrue:[
                "/ 800 .. FFFF
                ascii := byte bitAnd:2r00001111.
                nFollowBytes := 2.
                minValue := 16r800.
            ] ifFalse:[(byte bitAnd:2r11111000) == 2r11110000 ifTrue:[
                "/ 10000 .. 1FFFFF
                ascii := byte bitAnd:2r00000111.
                nFollowBytes := 3.
                minValue := 16r10000.
            ] ifFalse:[(byte bitAnd:2r11111100) == 2r11111000 ifTrue:[
                "/ 200000 .. 3FFFFFF
                ascii := byte bitAnd:2r00000011.
                nFollowBytes := 4.
                minValue := 16r200000.
            ] ifFalse:[(byte bitAnd:2r11111110) == 2r11111100 ifTrue:[
                "/ 4000000 .. 7FFFFFFF
                ascii := byte bitAnd:2r00000001.
                ascii ~~ 0 ifTrue:[
                    "/ ST/X can only represent 30 bit unicode characters.
                    "/ but the max unicode character is defined as 16r10 FFFF anyway
                    ^ DecodingError newException
                           defaultValue:aStringOrByteCollection;
                           raiseRequestWith:aStringOrByteCollection 
                           errorString:('unicode character out of range at: %1' bindWith:srcIdx).
                ].
                nFollowBytes := 5.
                minValue := 16r4000000.
            ] ifFalse:[
                ^ DecodingError newException
                       defaultValue:aStringOrByteCollection;
                       raiseRequestWith:aStringOrByteCollection errorString:'invalid utf8 encoding'.
            ]]]]].

            nFollowBytes timesRepeat:[
                byte := aStringOrByteCollection byteAt:srcIdx.
                srcIdx := srcIdx + 1.
                (byte bitAnd:2r11000000) ~~ 2r10000000 ifTrue:[
                    ^ DecodingError newException
                           defaultValue:aStringOrByteCollection;
                           raiseRequestWith:aStringOrByteCollection 
                           errorString:('illegal followbyte: 0x%1 at:%2' bindWith:(byte hexPrintString:2) with:srcIdx-1).
                ].
                ascii := (ascii bitShift:6) bitOr:(byte bitAnd:2r00111111). 
            ]. 
            ascii > 16rFFFF ifTrue:[
                nBitsRequired < 32 ifTrue:[nBitsRequired := 32].
            ] ifFalse:[ascii > 16rFF ifTrue:[
                nBitsRequired < 16 ifTrue:[nBitsRequired := 16].
            ]].
            ascii < minValue ifTrue:[
                "encoding a value in a longer utf8-sequence than required is not allowed
                 and imposes a security risk"
                ^ DecodingError newException
                       defaultValue:aStringOrByteCollection;
                       raiseRequestWith:aStringOrByteCollection errorString:'overlong utf8 sequence'.
            ].
        ].
        sz := sz + 1.
    ].

    nBitsRequired == 8 ifTrue:[
        anyAbove7BitAscii ifFalse:[
            "/ can return the original string
            ^ aStringOrByteCollection asSingleByteString.
        ].
        newString := String uninitializedNew:sz
    ] ifFalse:[nBitsRequired <= 16 ifTrue:[
        newString := Unicode16String new:sz
    ] ifFalse:[
        newString := Unicode32String new:sz
    ]].

    idx := srcIdx := 1.

    "now fill the string"
    [srcIdx <= lastIdx] whileTrue:[
        byte := ascii := aStringOrByteCollection byteAt:srcIdx.
        srcIdx := srcIdx + 1.
        (byte bitAnd:2r10000000) ~~ 0 ifTrue:[
            (byte bitAnd:2r11100000) == 2r11000000 ifTrue:[
                ascii := byte bitAnd:2r00011111.
                nFollowBytes := 1.
            ] ifFalse:[(byte bitAnd:2r11110000) == 2r11100000 ifTrue:[
                ascii := byte bitAnd:2r00001111.
                nFollowBytes := 2.
            ] ifFalse:[(byte bitAnd:2r11111000) == 2r11110000 ifTrue:[
                ascii := byte bitAnd:2r00000111.
                nFollowBytes := 3.
            ] ifFalse:[(byte bitAnd:2r11111100) == 2r11111000 ifTrue:[
                "5 byte sequences do not result in valid unicode"
                ascii := byte bitAnd:2r00000011.
                nFollowBytes := 4.
            ] ifFalse:[(byte bitAnd:2r11111110) == 2r11111100 ifTrue:[
                "6 byte sequences do not result in valid unicode"
                ascii := byte bitAnd:2r00000001.
                nFollowBytes := 5.
            ]]]]].
            nFollowBytes timesRepeat:[
                byte := aStringOrByteCollection byteAt:srcIdx.
                srcIdx := srcIdx + 1.
                ascii := (ascii bitShift:6) bitOr:(byte bitAnd:2r00111111). 
            ].
        ].
        newString at:idx put:(Character value:ascii).
        idx := idx + 1.
    ].
    ^ newString

    "
     CharacterArray decodeFromUTF8:#[ 16r41 16r42 ]
     CharacterArray decodeFromUTF8:#[ 16rC6 16r8F ]
     CharacterArray decodeFromUTF8:#[ 16rE0 16r81 16r02 ]
     CharacterArray decodeFromUTF8:#[ 16rEF 16rBF 16rBF ]

   rfc2279 (deprecated) examples:
     CharacterArray decodeFromUTF8:#[ 16r41 16rE2 16r89 16rA2 16rCE 16r91 16r2E ]
     CharacterArray decodeFromUTF8:#[ 16rED 16r95 16r9C 16rEA 16rB5 16rAD 16rEC 16r96 16rB4 ]
     CharacterArray decodeFromUTF8:#[ 16rE6 16r97 16rA5 16rE6 16r9C 16rAC 16rE8 16rAA 16r9E ]

   invalid:
     CharacterArray decodeFromUTF8:#[ 16rC0 16r80 ]
     CharacterArray decodeFromUTF8:#[ 16rE0 16r80 16r80 ]
    "

    "
     CharacterArray decodeFromUTF8:#[ 16r41 16r42 ]
     CharacterArray decodeFromUTF8:#[ 16rC1 16r02 ]
     CharacterArray decodeFromUTF8:#[ 16rE0 16r81 16r02 ]
     CharacterArray decodeFromUTF8:#[ 16rEF 16rBF 16rBF ]

   rfc2279 examples:
     CharacterArray decodeFromUTF8:#[ 16r41 16rE2 16r89 16rA2 16rCE 16r91 16r2E ]
     CharacterArray decodeFromUTF8:#[ 16rED 16r95 16r9C 16rEA 16rB5 16rAD 16rEC 16r96 16rB4 ]
     CharacterArray decodeFromUTF8:#[ 16rE6 16r97 16rA5 16rE6 16r9C 16rAC 16rE8 16rAA 16r9E ]

   invalid:
     CharacterArray decodeFromUTF8:#[ 16rC0 16r80 ]
     CharacterArray decodeFromUTF8:#[ 16rE0 16r80 16r80 ]
    "
!

setupNormalizationMaps
    "returns a 2-stage map from ch2 -> ch1 -> mappedChar.
     for unicode normalization 
     (i.e. for replacing combining char-sequences with regular characters).
     ch2 is the combining charCode (eg. 0x0308), ch1 is the previous character (eg. $A),
     mappedChar is the result (eg. $Ä).
     Caveat: 
        possibly incomplete: only COMBINING_DIACRITICAL_MARKS are cared for.
        Does not care for COMBINING_DIACRITICAL_MARKS_EXTENDED
        and COMBINING_DIACRITICAL_MARKS_SUPPLEMENT.
        However; those are used for German dialectology, ancient Greek and other similar
        exotic uses. Probably noone will ever even notice that they are missing..."
     
    |def|

    UnicodeNormalizationMap := Dictionary new.
    UnicodeDenormalizationMap := Dictionary new.

    def := [:combiner :chars :mappedChars |
               |d|

               d := UnicodeNormalizationMap at:combiner ifAbsentPut:[Dictionary new].
               chars with:mappedChars do:[:ch1 :mappedChar | 
                    d at:ch1 put:mappedChar.
                    UnicodeDenormalizationMap at:mappedChar put:(Unicode16String with:ch1 with:combiner).
               ].
           ].        
    def value:(Character codePoint:16r0300) "grave"         value:'AEIOUaeiouWw' value:'ÀÈÌÒÙàèìòùẀẁ'.
    def value:(Character codePoint:16r0301) "acute"         value:'AEIOUYaeiouyÇçKkMmPpWw' value:'ÁÉÍÓÚÝáéíóúýḈḉḰḱḾḿṔṕẂẃ'.
    def value:(Character codePoint:16r0302) "circumflex"    value:'AEIOUaeiouZz' value:'ÂÊÎÔÛâêîôûẐẑ'.
    def value:(Character codePoint:16r0303) "tilde"         value:'AONaon' value:'ÃÕÑãõñ'.
    def value:(Character codePoint:16r0307) "dot over"      value:'BbDdFfHhMmNnPpRrSsTtWwXxYyṢṣ' value:'ḂḃḊḋḞḟḢḣṀṁṄṅṖṗṘṙṠṡṪṫẆẇẊẋẎẏṨṩ'.
    def value:(Character codePoint:16r0308) "diaresis"      value:'AEIOUaeiouyHhWwXxt' value:'ÄËÏÖÜäëïöüÿḦḧẄẅẌẍẗ'.
    def value:(Character codePoint:16r030A) "ring"          value:'Aawy' value:'Ååẘẙ'.
    def value:(Character codePoint:16r0323) "dot under"     value:'AaBbDdEeIiHhKkLlMmNnOoRrSsTtUuVvWwZzṠṡ' value:'ẠạḄḅḌḍẸẹỊịḤḥḲḳḶḷṂṃṆṇỌọṚṛṢṣṬṭỤụṾṿẈẉẒẓṨṩ'.
    def value:(Character codePoint:16r0327) "cedilla"       value:'Cc' value:'Çç'.

    "
     self setupNormalizationMaps
    "
!

unicodeDenormalizationMap
    "returns a 2-stage map from ch2 -> ch1 -> mappedChar
     for unicode normalization (i.e. for making combining chars regular ones).
     Caveat: 
        possibly incomplete: only COMBINING_DIACRITICAL_MARKS are cared for.
        Does not care for COMBINING_DIACRITICAL_MARKS_EXTENDED
        and COMBINING_DIACRITICAL_MARKS_SUPPLEMENT.
        However; those are used for German dialectology, ancient Greek and other similar
        exotic uses. Probably noone will ever even notice that they are missing..."
     
    UnicodeDenormalizationMap isNil ifTrue:[
        self setupNormalizationMaps
    ].
    ^ UnicodeDenormalizationMap

    "
     self unicodeDenormalizationMap
    "
!

unicodeNormalizationMap
    "returns a 2-stage map from ch2 -> ch1 -> mappedChar
     for unicode normalization (i.e. for making combining chars regular ones).
     Caveat: 
        possibly incomplete: only COMBINING_DIACRITICAL_MARKS are cared for.
        Does not care for COMBINING_DIACRITICAL_MARKS_EXTENDED
        and COMBINING_DIACRITICAL_MARKS_SUPPLEMENT.
        However; those are used for German dialectology, ancient Greek and other similar
        exotic uses. Probably noone will ever even notice that they are missing..."
     
    UnicodeNormalizationMap isNil ifTrue:[
        self setupNormalizationMaps
    ].
    ^ UnicodeNormalizationMap

    "
     self unicodeNormalizationMap
    "
! !


!CharacterArray class methodsFor:'pattern matching'!

matchEscapeCharacter
    "return the character used to escape a matchCharacter
     (i.e. make it a regular character in a matchPattern)"

    ^ $\
!

matchScan:matchScanArray from:matchStart to:matchStop with:aString from:start to:stop caseSensitive:caseSensitive
    "helper for match; return true if the characters from start to stop in
     aString are matching the scan in matchScan from matchStart to matchStop.
     The matchScan is as created by asMatchScanArray.

     This algorithm is not at all the most efficient;
     for heavy duty pattern matching, an interface (primitive) to the regex
     pattern matching package should be added."

    |matchEntry
     mStart "{ Class: SmallInteger }"
     mStop  "{ Class: SmallInteger }"
     sStart "{ Class: SmallInteger }"
     sStop  "{ Class: SmallInteger }"
     mSize  "{ Class: SmallInteger }"
     sSize  "{ Class: SmallInteger }"
     index  "{ Class: SmallInteger }"
     quickCheck matchLast nextMatchEntry
     checkChar included|

    mStart := matchStart.
    mStop := matchStop.
    sStart := start.
    sStop := stop.

    [
"/ Transcript showCR:('match: ''' , (aString copyFrom:sStart to:sStop) ,
"/                    ''' against:' , (matchScanArray copyFrom:mStart to:mStop) printString).

        mSize := mStop - mStart + 1.
        sSize := sStop - sStart + 1.

        "empty strings match"
        (mSize == 0) ifTrue:[^ (sSize == 0)].

        matchEntry := matchScanArray at:mStart.

        "/ the most common case first:
        (sSize ~~ 0
        and:[(checkChar := (aString at:sStart)) = matchEntry]) ifTrue:[
            "advance by one and continue"
            mStart := mStart + 1.
            sStart := sStart + 1
        ] ifFalse:[
            (matchEntry == #any) ifTrue:[
                "restString empty -> no match"
                (sSize == 0) ifTrue:[^ false].
                "# matches single character"
                ((sSize == 1) and:[mSize == 1]) ifTrue:[^ true].
                "advance by one and continue"
                mStart := mStart + 1.
                sStart := sStart + 1
            ] ifFalse:[
                (matchEntry == #anyString) ifTrue:[
                    "* alone matches anything"
                    (mSize == 1) ifTrue:[^ true].
                    "restString empty & matchString not empty -> no match"
                    (sSize == 0) ifTrue:[^ false].

                    "
                     try to avoid some of the recursion by checking last
                     character and continue with shortened strings if possible
                    "
                    quickCheck := false.
                    (mStop >= mStart) ifTrue:[
                        matchLast := matchScanArray at:mStop.
                        (matchLast ~~ #anyString) ifTrue:[
                            (matchLast == #any) ifTrue:[
                                quickCheck := true
                            ] ifFalse:[
                                matchLast == (aString at:sStop) ifTrue:[
                                    quickCheck := true
                                ] ifFalse:[
                                    matchLast isString ifTrue:[
                                        quickCheck := matchLast includes:(aString at:sStop)
                                    ]
                                ]
                            ]
                        ]
                    ].
                    quickCheck ifTrue:[
                        "
                         quickCheck ok, advance from the right
                        "
                        mStop := mStop - 1.
                        sStop := sStop - 1
                    ] ifFalse:[
                        "/ no quick check;
                        "/ look for the next character(s)
                        "/ and try matching there
                        "/ (to avoid recursion)

                        mStart < mStop ifTrue:[
                            nextMatchEntry := matchScanArray at:mStart+1.
                            nextMatchEntry isCharacter ifTrue:[
                                sStart <= sStop ifTrue:[
                                    [
                                        caseSensitive ifTrue:[
                                            index := aString indexOf:nextMatchEntry startingAt:sStart
                                        ] ifFalse:[
                                            index := aString findFirst:[:c | c asLowercase = nextMatchEntry asLowercase]
                                                             startingAt:sStart.
                                        ].
                                        (index == 0 or:[index > sStop]) ifTrue:[
                                            ^ false
                                        ].
                                        (self matchScan:matchScanArray
                                              from:(mStart + 1)
                                              to:mStop
                                              with:aString
                                              from:index
                                              to:sStop
                                              caseSensitive:caseSensitive
                                        ) ifTrue:[
                                            ^ true
                                        ].
                                        sStart := index + 1.
                                    ] loop.
                                ]
                            ]
                        ].

                        "
                         no quick check possible;
                         loop over all possible substrings
                        "
                        index := sStart.
                        [index <= sStop] whileTrue:[
                            (self matchScan:matchScanArray
                                  from:(mStart + 1)
                                  to:mStop
                                  with:aString
                                  from:index
                                  to:sStop
                                  caseSensitive:caseSensitive
                            ) ifTrue:[
                                ^ true
                            ].
                            index := index + 1
                        ].
                        ^ false
                    ].
                ] ifFalse:[
                    (matchEntry isString) ifTrue:[
                        "testString empty -> no match"
                        (sSize == 0) ifTrue:[^ false].

                        included := false.
                        "/ checkChar := aString at:sStart.
                        included := matchEntry includes:checkChar.
                        included ifFalse:[
                            caseSensitive ifFalse:[
                                checkChar isUppercase ifTrue:[
                                    included := matchEntry includes:checkChar asLowercase.
                                ] ifFalse:[
                                    included := matchEntry includes:checkChar asUppercase.
                                ]
                            ].
                        ].
                        mStart := mStart + 1.
                        mSize := mSize - 1.
                        included ifFalse:[^ false].

                        ((sSize == 1) and:[mSize == 0]) ifTrue:[^ true].
                    ] ifFalse:[
                        "/ must be single character

                        "testString empty ?"
                        (sSize == 0) ifTrue:[^ false].

                        "first characters equal ?"
                        "/ checkChar := aString at:sStart.
                        caseSensitive ifTrue:[^ false].
                        (checkChar asUppercase ~= matchEntry asUppercase) ifTrue:[^ false].

                        "advance and continue"
                        mStart := mStart + 1.
                    ].
                    "cut off 1st char and continue"
                    sStart := sStart + 1
                ]
            ]
        ]
    ] loop.

    "
     |scanArray s|

     scanArray := self matchScanArrayFrom:'*hello'.
     s := 'foo bar hello world'.
     CharacterArray
         matchScan:scanArray
         from:1
         to:scanArray size
         with:s
         from:1
         to:s size
         caseSensitive:true
    "
    "
     |scanArray s|

     scanArray := self matchScanArrayFrom:'*hello*'.
     s := 'foo bar hello world'.
     CharacterArray
         matchScan:scanArray
         from:1
         to:scanArray size
         with:s
         from:1
         to:s size
         caseSensitive:true
    "

    "Modified: / 24-07-2011 / 07:17:03 / cg"
    "Modified (comment): / 24-07-2011 / 08:55:14 / cg"
!

matchScan:matchScanArray from:matchStart to:matchStop with:aString from:start to:stop ignoreCase:ignoreCase
    <resource: #obsolete>
    "helper for match; return true if the characters from start to stop in
     aString are matching the scan in matchScan from matchStart to matchStop.
     The matchScan is as created by asMatchScanArray.

     This algorithm is not at all the most efficient;
     for heavy duty pattern matching, an interface (primitive) to the regex
     pattern matching package should be added."

    ^ self
        matchScan:matchScanArray from:matchStart to:matchStop with:aString from:start to:stop caseSensitive:ignoreCase not

    "
     |scanArray s|

     scanArray := self matchScanArrayFrom:'*hello'.
     s := 'foo bar hello world'.
     CharacterArray
         matchScan:scanArray
         from:1
         to:scanArray size
         with:s
         from:1
         to:s size
         ignoreCase:false
    "
    "
     |scanArray s|

     scanArray := self matchScanArrayFrom:'*hello*'.
     s := 'foo bar hello world'.
     CharacterArray
         matchScan:scanArray
         from:1
         to:scanArray size
         with:s
         from:1
         to:s size
         ignoreCase:false
    "

    "Modified: / 24-07-2011 / 07:17:03 / cg"
    "Modified (comment): / 24-07-2011 / 08:55:14 / cg"
!

matchScanArrayFrom:aString
    "scan a pattern string and decompose it into a scanArray.
     This is processed faster (especially with character ranges), and
     can also be reused later. (if the same pattern is to be searched again)"

    ^ self matchScanArrayFrom:aString escapeCharacter:(self matchEscapeCharacter)

    "
     String matchScanArrayFrom:'*ute*'
     String matchScanArrayFrom:'**ute**'
     String matchScanArrayFrom:'*uter'
     String matchScanArrayFrom:'\*uter'
     String matchScanArrayFrom:'[cC]#mpute[rR]'
     String matchScanArrayFrom:'[abcd]*'
     String matchScanArrayFrom:'[a-k]*'
     String matchScanArrayFrom:'*some*compl*ern*'
     String matchScanArrayFrom:'[a-'
     String matchScanArrayFrom:'[a-zA-Z]'
     String matchScanArrayFrom:'[a-z01234A-Z]'
    "

    "Modified: 2.4.1997 / 16:20:29 / cg"
!

matchScanArrayFrom:aString escapeCharacter:escape
    "scan a pattern string and decompose it into a scanArray.
     This is processed faster (especially with character ranges), and
     can also be reused later. (if the same pattern is to be searched again)"

    |coll
     idx "{ Class: SmallInteger }"
     end c1 c2 matchSet previous|

    previous := nil.

    coll := OrderedCollection new.
    idx := 1. end := aString size.
    [idx <= end] whileTrue:[
        |char this|

        char := aString at:idx.
        char == $* ifTrue:[
            previous ~~ #anyString ifTrue:[
                this := #anyString
            ]
        ] ifFalse:[
            char == $# ifTrue:[
                previous ~~ #anyString ifTrue:[
                    this := #any
                ]
            ] ifFalse:[
                char == $[ ifTrue:[
                    matchSet := IdentitySet new.
                    idx := idx + 1.
                    idx > end ifTrue:[^ nil].
                    char := aString at:idx.
                    c1 := nil.
                    [char ~~ $]] whileTrue:[
                        ((char == $-) and:[c1 notNil]) ifTrue:[
                            idx := idx + 1.
                            idx > end ifTrue:[^ nil].
                            c2 := aString at:idx.
                            c1 to:c2 do:[:c | matchSet add:c].
                            c1 := nil.
                            idx := idx + 1.
                        ] ifFalse:[
                            (char ~~ $]) ifTrue:[
                                matchSet add:char.
                                c1 := char.
                                idx := idx + 1
                            ]
                        ].
                        idx > end ifTrue:[^ nil].
                        char := aString at:idx
                    ].
                    this := matchSet asString
                ] ifFalse:[
                    char == escape ifTrue:[
                        idx := idx + 1.
                        idx > end ifTrue:[
                            "/ mhmh - what should we do here ?
                            this := char
                        ] ifFalse:[
                            this := aString at:idx.
                        ]
                    ] ifFalse:[
                        this := char
                    ]
                ]
            ]
        ].
        this notNil ifTrue:[coll add:this. previous := this].
        idx := idx + 1
    ].

    ^ coll asArray

    "
     String matchScanArrayFrom:'*ute*'
     String matchScanArrayFrom:'**ute**'
     String matchScanArrayFrom:'*uter'
     String matchScanArrayFrom:'\*uter'
     String matchScanArrayFrom:'[cC]#mpute[rR]'
     String matchScanArrayFrom:'[abcd]*'
     String matchScanArrayFrom:'[a-k]*'
     String matchScanArrayFrom:'*some*compl*ern*'
     String matchScanArrayFrom:'[a-'
     String matchScanArrayFrom:'[a-zA-Z]'
     String matchScanArrayFrom:'[a-z01234A-Z]'
    "

    "Modified: 2.4.1997 / 16:20:29 / cg"
! !

!CharacterArray class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for CharacterArray here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == CharacterArray
!

speciesForCharacterSize:characterSize
    "answer the class, that is able to hold characters of size characterSize"

    characterSize <= 8 ifTrue:[^ String].
    characterSize <= 16 ifTrue:[^ Unicode16String].
    ^ Unicode32String
! !


!CharacterArray methodsFor:'Compatibility-ANSI'!

addLineDelimiters
    "Ansi compatibility - same as withCRs"

    ^ self withCRs

    "Modified: / 13.11.2001 / 19:16:25 / cg"
! !


!CharacterArray methodsFor:'Compatibility-Dolphin'!

copyExpanding:expandTable
    "return a copy of myself, with translations from the expandTable sliced in.
     The argument is supposed to map from characters to either characters or strings.
     Added for Dolphin compatibility"

    |ds|

    ds := WriteStream on:(self species new).
    self do:[:eachChar |
        |repl|

        repl := expandTable at:eachChar ifAbsent:[nil].
        repl isNil ifTrue:[
            ds nextPut:eachChar
        ] ifFalse:[
            repl size == 0 ifTrue:[
                ds nextPut:repl
            ] ifFalse:[
                ds nextPutAll:repl
            ]
        ].
    ].
    ^ ds contents.
!

formatWith:aString
    "Compatibility method - do not use in new code.
     same as #bindWith: for Dolphin compatibility"

    ^ self bindWith:aString

    "
     'hello%1world' formatWith:'123'
    "
!

formatWith:arg1 with:arg2
    "Compatibility method - do not use in new code.
     same as #bindWith: for Dolphin compatibility"

    ^ self bindWith:arg1 with:arg2

    "
     'hello%1 %2world' formatWith:'123' with:234
    "
!

formatWith:arg1 with:arg2 with:arg3
    "Compatibility method - do not use in new code.
     same as #bindWith: for Dolphin compatibility"

    ^ self bindWith:arg1 with:arg2 with:arg3

    "
     'hello%1 %2 %3world' formatWith:'123' with:234 with:345
    "
! !

!CharacterArray methodsFor:'Compatibility-GNU'!

% anArrayOfOperands
    "return a copy of the receiver, where a '%i' escape
     is replaced by the coresponding string from the argument array.
     'i' may be between 1 and 9 (i.e. a maximum of 9 placeholders is allowed).
     Added for GNU-ST compatibility."

    ^ self expandPlaceholdersWith:anArrayOfOperands

    "
     'do you prefer %1 or rather %2 (not talking about %3) ?'
        % #('smalltalk' 'c++' 'c')

     'do you %(what) ?'
        % (Dictionary new at:#'what' put:'understand'; yourself)
    "
! !

!CharacterArray methodsFor:'Compatibility-ST/V'!

asArrayOfSubstrings
    "return an array of substrings from the receiver, interpreting
     separators (i.e. spaces & newlines) as word-delimiters.
     This has been added for ST/V compatibility
     - the actual work is done in asCollectionOfWords.
     (sigh: it is called #'subStrings' in V'Age, #'substrings' in Squeak
     and #'asCollectionOfWords' in ST/X) "

    ^ self asCollectionOfWords asArray

    "
     '1 one two three four 5 five' asArrayOfSubstrings
     '1
one
        two three four 5 five' asArrayOfSubstrings
    "
!

byteAt:index put:aByte
    "store a byte at given index.
     This is an ST/V compatibility method."

"/    (aByte == 0) ifTrue:[
"/        "store a space instead"
"/        ^ super basicAt:index put:(Character space)
"/    ].
    ^ self basicAt:index put:(Character value:aByte)

    "
     'hello' copy at:1 put:$H asciiValue; yourself
     'hello' copy byteAt:1 put:72; yourself
     'hello' copy byteAt:1 put:0; yourself
    "

    "Modified: 6.5.1996 / 10:35:26 / cg"
!

equalsIgnoreCase:aString
    "This is an ST/V compatibility method and an alias for sameAs:."

    ^ self sameAs:aString

    "
     'abc' equalsIgnoreCase: 'aBC'
    "
!

replChar:oldChar with:newChar
    "return a copy of the receiver, with all oldChars replaced by newChar.
     This is an ST/V compatibility method and an alias for copyReplaceAll."

    ^ self copyReplaceAll:oldChar with:newChar

    "
     '12345678901234567890' replChar:$0 with:$*
    "

    "Modified: / 18.7.1998 / 22:52:57 / cg"
!

replChar:oldChar withString:newString
    "return a copy of the receiver, with all oldChars replaced
     by newString (i.e. slice in the newString in place of the oldChar).
     This is an ST/V compatibility method."

    |tmpStream|

    tmpStream := self species writeStream.
    self do:[:element |
        element = oldChar ifTrue:[
            tmpStream nextPutAll:newString
        ] ifFalse:[
            tmpStream nextPut:element
        ].
    ].
    ^ tmpStream contents

   "
     '12345678901234567890' replChar:$0 withString:'foo'
     'a string with spaces' replChar:$  withString:' foo '
    "
!

replString:subString withString:newString
    "return a copy of the receiver, with all sequences of subString replaced
     by newString (i.e. slice in the newString in place of the oldString).
     This is an ST/V compatibility method and an alias for copyReplaceString."

    ^ self copyReplaceString:subString withString:newString

   "
     '12345678901234567890' replString:'123' withString:'OneTwoThree'
     '12345678901234567890' replString:'123' withString:'*'
     '12345678901234567890' replString:'234' withString:'foo'

     ('a string with spaces' replChar:$  withString:' foo ')
        replString:'foo' withString:'bar'
    "

    "Modified: / 12-05-2004 / 12:00:27 / cg"
!

subString:start to:end
    "same as copyFrom:to:
     This is an ST/V compatibility method and an alias for copyFrom:to:."

    ^ self copyFrom:start to:end

   "
     '12345678901234567890' subString:3 to:8
    "
!

trimBlanks
    "return a copy of the receiver without leading and trailing spaces.
     This is an ST/V compatibility method and an alias for withoutSpaces."

    ^ self withoutSpaces

    "
     '    spaces at beginning' trimBlanks
     'spaces at end    ' trimBlanks
     '    spaces at beginning and end     ' trimBlanks
     'no spaces' trimBlanks
    "
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

asBoldText
    "return self as a bold text"

    ^Text string: self emphasis: #bold
!

asDate
    "Many allowed forms, see Date.readFrom:"

    ^ Date readFrom: (ReadStream on: self)

    "
     '30 Apr 1999' asDate dayName capitalized
    "
!

caseInsensitiveLessOrEqual:aString
    "compare the receiver against the argument ignoring case differences
     For Squeak/Pharo compatibility"

    ^ (self compareCaselessWith:aString) <= 0
!

caseSensitiveLessOrEqual:aString
    "compare the receiver against the argument caring for case differences
     For Squeak/Pharo compatibility"

    ^ self <= aString
!

charactersExactlyMatching:aString
    "return the number of characters I share as a prefix with the argument, aString"

    |idx nMax|

    nMax :=(self size) min:(aString size).
    idx := 1.
    [idx <= nMax] whileTrue:[
        (self at:idx) = (aString at:idx) ifFalse:[
            ^ idx - 1
        ].
        idx := idx + 1.
    ].
    ^ nMax

    "
     'abc' charactersExactlyMatching:'abc'
     'abc' charactersExactlyMatching:'abcd'
     'abcd' charactersExactlyMatching:'abc'
     'abc' charactersExactlyMatching:'abd'
     'abc' charactersExactlyMatching:'xxx'
    "
!

endsWithDigit
    "Answer whether the receiver's final character represents a digit.  3/11/96 sw"

    |len|

    ^ (len := self size) ~~ 0 and:[(self at:len) isDigit]
!

findDelimiters:delimiters startingAt:start
    "Answer the index of the character within the receiver, starting at start,
     that matches one of the delimiters.
     If the receiver does not contain any of the delimiters, answer size + 1."

    |idx|

    idx := self indexOfAny:delimiters startingAt:start.
    idx == 0 ifTrue:[^ self size + 1].
    ^ idx.
"/start to: self size do: [:i |
"/        |char|
"/
"/        char := self at: i.
"/        delimiters do: [:delim | delim = char ifTrue: [^ i]]
"/    ].
"/    ^ self size + 1
!

findTokens:delimiterOrDelimiters
    "cg: I am not sure, if this is really the squeak semantics (w.r.t. empty fields)"

    delimiterOrDelimiters size == 0 ifTrue:[
        ^ self asCollectionOfSubstringsSeparatedBy:delimiterOrDelimiters
    ] ifFalse:[
        ^ self asCollectionOfSubstringsSeparatedByAny:delimiterOrDelimiters
    ].

    "
     'a|b#c||e' findTokens:#($# $|)
     'a|b#c||e' findTokens:$|
    "

    "Modified: / 04-09-2011 / 20:31:21 / cg"
    "Modified (comment): / 05-09-2011 / 04:25:28 / cg"
!

includesSubString:aString
    "return true, if a substring is contained in the receiver.
     The compare is case sensitive."

    ^ self includesString:aString

    "
     'hello world' includesSubString:'Hel'
     'hello world' includesSubString:'hel'
     'hello world' includesSubString:'llo'
    "



!

includesSubString:aString caseSensitive:caseSensitive
    "sigh - an alias; added for Squeak/Pharo compatibility"

    ^ self includesSubstring:aString caseSensitive:caseSensitive
!

includesSubstring: aString
    "sigh - an alias; added for Squeak/Pharo compatibility"

    ^ self includesSubString: aString

    "Created: / 03-10-2014 / 02:47:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesSubstring:aString caseSensitive:caseSensitive
    "return true, if a substring is contained in the receiver.
     The argument, caseSensitive controls if case is ignored in the compare."

    "/ for now,  a q&d hack ...

    caseSensitive ifFalse:[
        ^ self asLowercase includesString:aString asLowercase
    ].
    ^ self includesString:aString

    "
     'hello world' includesSubstring:'Hel' caseSensitive:true
     'hello world' includesSubstring:'Hel' caseSensitive:false
    "



!

isAllDigits
    "Answer whether the receiver's characters are all digits"

    ^ self conform:[:eachChar | eachChar isDigit]

    "
     'hello world' isAllDigits
     '12344' isAllDigits
    "
!

lastSpacePosition
    "return the index of the last space character; 0 if there is none.
     Added for Squeak/Pharo compatibility"

    "/ CG: is this correct? separator or space only???
    ^ self lastIndexOfSeparator
!

linesDo:aBlock
    "evaluate the argument, aBlock for all lines,
     up to the end"

    ^ self readStream linesDo:aBlock
!

padded:leftOrRight to:paddedSize with:padCharacter
    "pad left (leftOrRight == #left) or right"

    leftOrRight == #left ifTrue:[
        ^ self leftPaddedTo:paddedSize with:padCharacter
    ].
    ^ self paddedTo:paddedSize with:padCharacter

    "
     'hello' padded:#right to:10 with:$.
     'hello' padded:#left to:10 with:$.
    "

    "Modified (comment): / 07-03-2012 / 16:31:33 / cg"
!

skipDelimiters:delimiters startingAt:start
    "Answer the index of the character within the receiver, starting at start,
     that does NOT match one of the delimiters.
     If the receiver does not contain any of the delimiters, answer size + 1.
     Assumes the delimiters to be a non-empty string."

    start to:self size do:[:i |
        delimiters detect:[:delim | delim = (self at:i) ] ifNone:[ ^ i ]
    ].
    ^ self size + 1

    "
     '123***7890' skipDelimiters:'*' startingAt:4
     '123***7890' skipDelimiters:'*' startingAt:3
     '123***7890' skipDelimiters:'*' startingAt:10
     '123*******' skipDelimiters:'*' startingAt:10
    "
!

substrings
    "return a collection consisting of all words contained in the receiver.
     Words are separated by whitespace.
     This has been added for Squeak compatibility.
     (sigh: it is called #'subStrings' in V'Age, and #'asCollectionOfWords' in ST/X) "

    ^ self asCollectionOfWords

    "
     'foo bar baz' substrings
    "
!

substringsSeparatedBy:separatorCharacter
    "return a collection consisting of all words contained in the receiver.
     Words are separated by the given separator character.
     This has been added for Squeak/Pharo compatibility.
     (sigh: it is called #'subStrings:' in V'Age,
      and #'asCollectionOfSubstringsSeparatedBy' in ST/X) "

    ^ self asCollectionOfSubstringsSeparatedBy:separatorCharacter

    "
     'foo bar, baz' substringsSeparatedBy:$,
     '1.2.3.4' substringsSeparatedBy:$.
    "
!

truncateTo:smallSize
    "return myself or a copy shortened to smallSize.  1/18/96 sw"

    self size <= smallSize ifTrue:[^ self].
    ^ self copyFrom: 1 to: smallSize

    "
     'hello world' truncateTo:5
     'hello' truncateTo:10

     'hello world' copyTo:5
     'hello' copyTo:10
    "
!

withBlanksTrimmed
    "Return a copy of the receiver from which leading and trailing whitespace have been trimmed.
     Notice the bad naming - it is trimming separators, not just blanks.
     Added for Squeak compatibility and an alias for withoutSeparators"

    ^ self withoutSeparators "withoutSpaces"    "/ cg: it seems that squeak cares for any whitespace

    "
     '  hello    world    ' withBlanksTrimmed
    "
!

withNoLineLongerThan: aNumber
    "Answer a string with the same content as receiver, but rewrapped so that no line has more characters than the given number"

    | listOfLines currentLast currentStart resultString putativeLast putativeLine crPosition |

    (aNumber isNumber not or:[ aNumber < 1] ) ifTrue: [self error: 'too narrow'].
    listOfLines _ OrderedCollection new.
    currentLast _ 0.
    [currentLast < self size] whileTrue:
            [currentStart _ currentLast + 1.
            putativeLast _ (currentStart + aNumber - 1) min: self size.
            putativeLine _ self copyFrom: currentStart to: putativeLast.
            (crPosition _ putativeLine indexOf: Character cr) > 0 ifTrue:
                    [putativeLast _ currentStart + crPosition - 1.
                    putativeLine _ self copyFrom: currentStart to: putativeLast].
            currentLast _ putativeLast == self size
                    ifTrue:
                            [putativeLast]
                    ifFalse:
                            [currentStart + putativeLine lastSpacePosition - 1].
            currentLast <= currentStart ifTrue:
                    ["line has NO spaces; baleout!!"
                    currentLast _ putativeLast].
            listOfLines add: (self copyFrom: currentStart to: currentLast) withBlanksTrimmed].

    listOfLines size > 0 ifFalse: [^ ''].
    resultString _ listOfLines first.
    2 to: listOfLines size do:
            [:i | resultString _ resultString, Character cr asString, (listOfLines at: i)].
    ^ resultString

    "
     #(5 7 20) collect:
        [:i | 'Fred the bear went down to the brook to read his book in silence' withNoLineLongerThan: i]
    "
!

withSqueakLineEndings
    "assume the string is textual, and that CR, LF, and CRLF are all
     valid line endings.  Replace each occurrence with a single CR"

    ^ self asStringCollection asStringWith:Character cr.
!

withoutLeading: char
    "return a copy of myself without leading a char.
     Returns an empty string, if the receiver consist only of a char."

    ^ self withoutLeadingForWhich:[:ch | ch = char]

    "
     '****foo****' withoutLeading: $*
     'foo****'     withoutLeading: $*
     '*'           withoutLeading: $*
     ''            withoutLeading: $*
     '****foo'     withoutLeading: $*
     '*******'     withoutLeading: $*
     'foo'         withoutLeading: $*
     'f***o***o'   withoutLeading: $*
     ('**' , Character tab asString , '*foo***') withoutLeading: $* inspect
    "
!

withoutTrailing:char
    "return a copy of myself without trailing char.
     Returns an empty string, if the receiver consist only of char."

    ^ self withoutTrailingForWhich:[:ch | ch = char]

    "
     '    foo....' withoutTrailing:$.
     'foo....'     withoutTrailing:$.
     '    foo'     withoutTrailing:$.
     '.......'     withoutTrailing:$.
     'foo'         withoutTrailing:$.
    "
! !

!CharacterArray methodsFor:'Compatibility-V''Age'!

addLineDelimiter
    "replace all '\'-characters by line delimiter (cr) - characters.
     This has been added for VisualAge compatibility."

    ^ self withCRs
!

bindWith:aString
    "return a copy of the receiver, where a '%1' escape is
     replaced by aString.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:aString)

    "
     'do you like %1 ?' bindWith:'smalltalk'
     'do you like %(foo) ?' bindWithArguments:(Dictionary new at:'foo' put:'smalltalk'; yourself)
    "
!

bindWith:string1 with:string2
    "return a copy of the receiver, where a '%1' escape is
     replaced by string1 and '%2' is replaced by string2.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:string1 with:string2)

    "
     'do you prefer %1 or rather %2 ?'
        bindWith:'smalltalk' with:'c++'
    "
!

bindWith:str1 with:str2 with:str3
    "return a copy of the receiver, where a '%1', '%2' and '%3' escapes
     are replaced by str1, str2 and str3 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2 with:str3)

    "
     'do you prefer %1 or rather %2 (not talking about %3) ?'
        bindWith:'smalltalk' with:'c++' with:'c'
    "
!

bindWith:str1 with:str2 with:str3 with:str4
    "return a copy of the receiver, where a '%1', '%2', '%3' and '%4' escapes
     are replaced by str1, str2, str3 and str4 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2 with:str3 with:str4)

    "
     'do you prefer %1 or rather %2 (not talking about %3 or even %4) ?'
        bindWith:'smalltalk' with:'c++' with:'c' with:'assembler'
    "
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5
    "return a copy of the receiver, where a '%1' .. '%5' escapes
     are replaced by str1 .. str5 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2 with:str3 with:str4 with:str5)

    "Created: 31.1.1997 / 16:25:42 / cg"
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5 with:str6
    "return a copy of the receiver, where a '%1' .. '%6' escapes
     are replaced by str1 .. str6 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2
                                         with:str3 with:str4
                                         with:str5 with:str6)
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5 with:str6 with:str7
    "return a copy of the receiver, where a '%1' .. '%7' escapes
     are replaced by str1 .. str7 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2
                                         with:str3 with:str4
                                         with:str5 with:str6
                                         with:str7)
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5 with:str6 with:str7 with:str8
    "return a copy of the receiver, where a '%1' .. '%8' escapes
     are replaced by str1 .. str8 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2
                                         with:str3 with:str4
                                         with:str5 with:str6
                                         with:str7 with:str8)

    "Created: / 06-02-2012 / 10:33:18 / cg"
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5 with:str6 with:str7 with:str8 with:str9
    "return a copy of the receiver, where a '%1' .. '%9' escapes
     are replaced by str1 .. str9 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2
                                         with:str3 with:str4
                                         with:str5 with:str6
                                         with:str7 with:str8
                                         with:str9)

    "Created: / 14-02-2012 / 17:42:31 / cg"
!

bindWithArguments:anArrayOfStrings
    "return a copy of the receiver, where a '%i' escape
     is replaced by the coresponding string from the argument array.
     'i' may be between 1 and 9 (i.e. a maximum of 9 placeholders is allowed).
     To get an integer-indexed placeHolder followed by another digit,
     or an index > 9, you must use %(digit).
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:anArrayOfStrings

    "
     'do you prefer %1 or rather %2 (not talking about %3) ?'
        bindWithArguments:#('smalltalk' 'c++' 'c')

     'do you %(what) ?'
        bindWithArguments:(Dictionary new at:#'what' put:'understand'; yourself)
    "
!

subStrings
    "return a collection consisting of all words contained in the receiver.
     Words are separated by whitespace.
     This has been added for VisualAge compatibility.
     (sigh: it is called #'subbtrings' in Squeak, and #'asCollectionOfWords' in ST/X) "

    ^ self asCollectionOfWords

    "
     'hello world, this is smalltalk' subStrings
    "
!

subStrings:separatorCharacterOrString
    "return a collection consisting of all words contained in the receiver.
     Words are separated by separatorCharacter.
     This is similar to split: (squeak) and asCollectionOfSubstringsSeparatedBy: (st/x)
     and has been added for VisualAge compatibility."

    separatorCharacterOrString isCharacter ifTrue:[
        ^ self asCollectionOfSubstringsSeparatedBy:separatorCharacterOrString
    ].
    ^ self asCollectionOfSubstringsSeparatedByAny:separatorCharacterOrString

    "
     'foo:bar:baz:smalltalk' subStrings:$:
     'foo:bar:baz:smalltalk' subStrings:':'
     'foo.bar,baz-smalltalk' subStrings:'.,-'
    "
!

trimSeparators
    "return a copy of the receiver without leading and trailing whiteSpace.
     Added for VisualAge compatibility (an alias for withoutSeparators)"

    ^ self withoutSeparators
! !

!CharacterArray methodsFor:'Compatibility-VW'!

asLogicalFileSpecification
    ^ self asFilename

    "Created: / 30.10.2001 / 17:29:53 / cg"
!

expandMacros
    "ST80 compatibility - expand '<..>' macros with
     argument strings. Similar to #bindWith:.
     Read the comment in #expandMacrosWithArguments: about
     limited compatibility issues."

    ^ self expandMacrosWithArguments:#()

    "
     'hello<n>foo' expandMacros
    "

    "Modified: / 18.6.1998 / 16:03:02 / cg"
!

expandMacrosWith:arg
    "ST80 compatibility - expand '<..>' macros with
     argument strings. Similar to #bindWith:.
     Read the comment in #expandMacrosWithArguments: about
     limited compatibility issues."

    ^ self expandMacrosWithArguments:(Array with:arg)

    "Created: / 1.11.1997 / 13:01:28 / cg"
    "Modified: / 1.11.1997 / 13:30:50 / cg"
!

expandMacrosWith:arg1 with:arg2
    "ST80 compatibility - expand '<..>' macros with
     argument strings. Similar to #bindWith:.
     Read the comment in #expandMacrosWithArguments: about
     limited compatibility issues."

    ^ self expandMacrosWithArguments:(Array with:arg1 with:arg2)

    "Modified: / 6.7.1998 / 21:58:14 / cg"
!

expandMacrosWith:arg1 with:arg2 with:arg3
    "ST80 compatibility - expand '<..>' macros with
     argument strings. Similar to #bindWith:.
     Read the comment in #expandMacrosWithArguments: about
     limited compatibility issues."

    ^ self expandMacrosWithArguments:(Array with:arg1 with:arg2 with:arg3)
!

expandMacrosWith:arg1 with:arg2 with:arg3 with:arg4
    "ST80 compatibility - expand '<..>' macros with
     argument strings. Similar to #bindWith:.
     Read the comment in #expandMacrosWithArguments: about
     limited compatibility issues."

    ^ self expandMacrosWithArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4)
!

expandMacrosWithArguments:argArray
    "ST80 compatibility - expand '<..>' macros with
     argument strings. Similar to #bindWith:.
     WARNING: possibly not all ST80 expansions are supported here."

    "/ supported expansions:
    "/
    "/   <#p>       # is arg Number; slice in the args printString
    "/   <#s>       # is arg Number; slice in the arg itself (must know asString)
    "/   <#?s1:s2>  # is arg Number; slice in s1 if the arg is true, s2 otherwise
    "/              use first arg if # is not given (i.e. no number before s,p ...)
    "/   <n>        replace by a newLine character
    "/   <t>        replace by a tab character
    "/   %X         the X character itself

    |in out c fmt nr arg s1 s2 peekc|

    in := self readStream.
    out := CharacterWriteStream on:(self species uninitializedNew:self size).

    [in atEnd] whileFalse:[
        c := in next.
        c == $% ifTrue:[
            c := in next.
            out nextPut:c
        ] ifFalse:[c ~~ $< ifTrue:[
            out nextPut:c.
        ] ifFalse:[
            peekc := in peek.
            [peekc == $<] whileTrue:[
                out nextPut:$<.
                peekc := in nextPeek.
            ].
            peekc == $n ifTrue:[
                peekc := in nextPeek.
                peekc == $> ifTrue:[
                    in next.
                    out cr.
                ] ifFalse:[
                    out nextPutAll:'<n'.
                ]
            ] ifFalse:[peekc == $t ifTrue:[
                peekc := in nextPeek.
                peekc == $> ifTrue:[
                    in next.
                    out tab.
                ] ifFalse:[
                    out nextPutAll:'<t'.
                ]
            ] ifFalse:[
                peekc isDigit ifTrue:[
                    "start an argument expansion ..."
                    nr := Integer readFrom:in onError:nil.
                    nr isNil ifTrue:[
                        "this cannot happen (there is at least one digit)"
                        self error:'invalid format' mayProceed:true.
                        ^ self
                    ].
                    fmt := in next.
                    (fmt ~~ $? and:[in peek ~~ $>]) ifTrue:[
                        out nextPut:$<.
                        nr printOn:out.
                        out nextPut:fmt.
                    ] ifFalse:[
                        (nr between:1 and:argArray size) ifTrue:[
                            arg := argArray at:nr.
                        ] ifFalse:[
                            arg := ''
                        ].

                        fmt == $p ifTrue:[
                            "expand with args printString"
                            arg printOn:out.
                        ] ifFalse:[fmt == $s ifTrue:[
                            "expand with arg itself"
                            arg isText ifTrue:[
                                out contentsSpecies isText ifFalse:[
                                    out := (TextStream ? CharacterWriteStream on:Text new) nextPutAll:out contents; yourself.
                                ].
                                out nextPutAll:arg.
                            ] ifFalse:[
                                out nextPutAll:arg asString string.  "see method comment: arg must know #asString"
                            ]
                        ] ifFalse:[fmt == $? ifTrue:[
                            s1 := in upTo:$:.
                            s2 := in nextUpTo:$>.
                            arg == true ifTrue:[
                                out nextPutAll:s1
                            ] ifFalse:[
                                out nextPutAll:s2
                            ].
                        ] ifFalse:[
                            "what does VW do here ?"
                            self error:'invalid format' mayProceed:true.
                            ^ self
                        ]]].
                        c := in next.
                        c ~~ $> ifTrue:[
                            "what does VW do here ?"
                            self error:'invalid format' mayProceed:true.
                            ^ self
                        ]

                    ].
                ] ifFalse:[
                    out nextPut:$<.
                ].
            ]].
        ]].
    ].
    ^ out contents

    "
     'hello <1s> how are you' expandMacrosWith:(OperatingSystem getLoginName)
     'one plus one is <1p>' expandMacrosWith:2
    "

    "Modified: / 18-09-2007 / 22:50:43 / cg"
!

isCharacters
    "true, if the receiver is a string-like thing.
     added for visual works compatibility"

    "/ kept in libbasic package, because it is used in libjava and imap-implementation 
    ^ true
! !

!CharacterArray methodsFor:'JavaScript support'!

unquote
    "removes double quotes from the receiver.
     This is the JavaScript standard unquote function."

    ^ self unquote:$"

    "
     'hello' quote unquote

     JavaScriptParser evaluate:'''hello''.quote.unquote'
    "
!

unquote:quoteCharacter
    "removes quoteCharacter from either end of the receiver."

    |mySize|

    (mySize := self size) >= 2 ifTrue:[
        ((self first == quoteCharacter) and:[self last == quoteCharacter]) ifTrue:[
            ^ self copyFrom:2 to:mySize-1
        ].
    ].
    ^ self

    "
     '*hello*' unquote:$*
    "
! !


!CharacterArray methodsFor:'character searching'!

includesMatchCharacters
    "return true if the receiver includes any GLOB meta-match characters (i.e. $* or $#)
     for match operations; false if not.
     Here, do not care for $\ escapes"

    ^ self includesAny:'*#['

    "
     '*foo' includesMatchCharacters
     '\*foo' includesMatchCharacters
     '\*foo' includesUnescapedMatchCharacters
     '*foo' includesMatchCharacters
     '\\*foo' includesMatchCharacters
     'foo*' includesMatchCharacters
     'foo\*' includesMatchCharacters
     'foo\' includesMatchCharacters
    "

    "Modified: 2.4.1997 / 18:12:34 / cg"
!

includesSeparator
    "return true, if the receiver contains any whitespace characters"

    ^ (self indexOfSeparator ~~ 0)

    "
     'hello world' includesSeparator
     'helloworld' includesSeparator
    "
!

includesUnescapedMatchCharacters
    "return true if the receiver really includes any meta characters (i.e. $* or $#)
     for match operations; false if not.
     Here, care for $\ escapes"

    |idx sz specialChars escape|

    idx := 1.
    sz := self size.
    specialChars := '*#[\'.
    (escape := self class matchEscapeCharacter) ~~ $\ ifTrue:[
        specialChars := specialChars copy.
        specialChars at:specialChars size put:escape
    ].

    [
        idx := self indexOfAny:specialChars startingAt:idx.
        idx == 0 ifTrue:[^ false].
        (self at:idx) == escape ifFalse:[^ true].
        idx := idx + 2.
        idx > sz ifTrue:[^ false].
    ] loop.

    "
     '*foo' includesUnescapedMatchCharacters
     '\*foo' includesUnescapedMatchCharacters
     '\\foo' includesUnescapedMatchCharacters
     '\\\$foo' includesUnescapedMatchCharacters
     '*foo' includesUnescapedMatchCharacters
     '\\*foo' includesUnescapedMatchCharacters
     'foo*' includesUnescapedMatchCharacters
     'foo\*' includesUnescapedMatchCharacters
     'foo\' includesUnescapedMatchCharacters
    "

    "Modified: 2.4.1997 / 17:08:52 / cg"
    "Created: 2.4.1997 / 17:23:26 / cg"
!

indexOfControlCharacterStartingAt:startIndex
    "return the index of the next control character;
     that is a character with asciiValue < 32.
     Start the search at startIndex, searching forward.
     Return 0 if none is found."

    |start  "{ Class: SmallInteger }"
     mySize "{ Class: SmallInteger }"|

    start := startIndex.
    mySize := self size.

    start to:mySize do:[:index |
        (self at:index) isControlCharacter ifTrue:[^ index]
    ].
    ^ 0

    "
     'hello world' asTwoByteString            indexOfControlCharacterStartingAt:1
     'hello world\foo' withCRsasTwoByteString indexOfControlCharacterStartingAt:1
    "

    "Modified: / 21.7.1998 / 17:25:07 / cg"
!

indexOfNonSeparator
    "return the index of the first non-whitespace character.
     return 0 if no non-separator was found"

    ^ self indexOfNonSeparatorStartingAt:1.

    "
     '    hello world' indexOfNonSeparator
     '    ' indexOfNonSeparator
     'a   ' indexOfNonSeparator
     'abc' indexOfNonSeparator
     ' ' indexOfNonSeparator
     '' indexOfNonSeparator
    "
!

indexOfNonSeparatorStartingAt:startIndex
    "return the index of the next non-whitespace character,
     starting the search at startIndex, searching forward;
     return 0 if no non-separator was found"

    |start  "{ Class: SmallInteger }"
     mySize "{ Class: SmallInteger }"|

    start := startIndex.
    mySize := self size.

    start to:mySize do:[:index |
        (self at:index) isSeparator ifFalse:[^ index]
    ].
    ^ 0

    "
     '    hello world' indexOfNonSeparatorStartingAt:1
     '    ' indexOfNonSeparatorStartingAt:1
     'a   ' indexOfNonSeparatorStartingAt:2
    "

    "
     |s index1 index2|
     s := '   foo    bar      baz'.
     index1 := s indexOfNonSeparatorStartingAt:1.
     index2 := s indexOfSeparatorStartingAt:index1.
     s copyFrom:index1 to:index2 - 1
    "
!

indexOfSeparator
    "return the index of the first whitespace character;
     starting the search at the beginning, searching forward;
     return 0 if no separator was found"

    ^ self indexOfSeparatorStartingAt:1

    "
     'hello world' indexOfSeparator
     'helloworld' indexOfSeparator
     'hello   ' indexOfSeparator
     '   hello' indexOfSeparator
    "
!

indexOfSeparatorOrEndStartingAt:startIndex
    "return the index of the next whitespace character,
     starting the search at startIndex, searching forward;
     return the index of one beyond the end of the receiver if no separator was found.
     To extract the word, copy from startIndex to the returned index-1"

    |idx|

    idx := self indexOfSeparatorStartingAt:startIndex.
    idx == 0 ifTrue:[^ self size + 1].
    ^ idx.

    "
     'hello world' indexOfSeparatorOrEndStartingAt:3
     ' hello world' indexOfSeparatorOrEndStartingAt:3
     'hello world ' indexOfSeparatorOrEndStartingAt:3
     'hello world ' indexOfSeparatorOrEndStartingAt:6
     'hello world ' indexOfSeparatorOrEndStartingAt:7
     'helloworld ' indexOfSeparatorOrEndStartingAt:7
     'helloworld' indexOfSeparatorOrEndStartingAt:7
     'helloworld' indexOfSeparatorStartingAt:7
    "
!

indexOfSeparatorStartingAt:startIndex
    "return the index of the next whitespace character,
     starting the search at startIndex, searching forward;
     return 0 if no separator was found"

    |start  "{ Class: SmallInteger }"
     mySize "{ Class: SmallInteger }"|

    start := startIndex.
    mySize := self size.

    start to:mySize do:[:index |
        (self at:index) isSeparator ifTrue:[^ index]
    ].
    ^ 0

    "
     'hello world' indexOfSeparatorStartingAt:3
     ' hello world' indexOfSeparatorStartingAt:3
     'hello world ' indexOfSeparatorStartingAt:3
     'hello world ' indexOfSeparatorStartingAt:6
     'hello world ' indexOfSeparatorStartingAt:7
     'helloworld ' indexOfSeparatorStartingAt:7
     'helloworld' indexOfSeparatorStartingAt:7
    "
!

lastIndexOfSeparator
    "return the last index of a whitespace character (space or tab).
     (i.e. start the search at the end and search backwards);
     Returns 0 if no separator is found."

    ^ self lastIndexOfSeparatorStartingAt:(self size)

    "
     'hello world' lastIndexOfSeparator
     'helloworld' lastIndexOfSeparator
     'hel lo wor ld' lastIndexOfSeparator
     'hel   ' lastIndexOfSeparator 6
    "

    "Modified (comment): / 01-06-2012 / 13:10:30 / cg"
!

lastIndexOfSeparatorStartingAt:startIndex
    "return the index of the previous whitespace character,
     starting the search at startIndex (and searching backwards);
     returns 0 if no separator was found"

    |start  "{ Class: SmallInteger }"|

    start := startIndex.

    start to:1 by:-1 do:[:index |
        (self at:index) isSeparator ifTrue:[^ index]
    ].
    ^ 0

    "
     'hello world' lastIndexOfSeparatorStartingAt:3
     'hello world' lastIndexOfSeparatorStartingAt:7
     'helloworld' lastIndexOfSeparatorStartingAt:7
     ' helloworld' lastIndexOfSeparatorStartingAt:7
    "
! !

!CharacterArray methodsFor:'comparing'!

< aString
    "Compare the receiver with the argument and return true if the
     receiver is greater than the argument. Otherwise return false.
     This comparison is based on the elements ascii code -
     i.e. upper/lowercase & upper/lowercase & national characters are NOT treated specially."

    |mySize    "{ Class: SmallInteger }"
     otherSize "{ Class: SmallInteger }"
     n         "{ Class: SmallInteger }"
     c1 c2|

    mySize := self size.
    otherSize := aString string size.
    n := mySize min:otherSize.

    1 to:n do:[:index |
        c1 := self at:index.
        c2 := aString at:index.
        (c1 == c2 or:[c1 = c2]) ifFalse:[^ c1 < c2].
    ].
    ^ mySize < otherSize
!

= aString
    "Compare the receiver with the argument and return true if the
     receiver is equal to the argument. Otherwise return false.

     This compare does NOT ignore case differences,
     therefore 'foo' = 'Foo' will return false.
     Since this is incompatible to ST-80 (at least, V2.x) , this may change."

    |mySize    "{ Class: SmallInteger }"|

    (aString isString or:[aString species == self species]) ifFalse:[
        ^ false
    ].
    mySize := self size.
    mySize ~~ (aString size) ifTrue:[^ false].

    1 to:mySize do:[:index |
        (self at:index) = (aString at:index) ifFalse:[^ false].
    ].
    ^ true

    "
     'foo' = 'Foo'
     'foo' = 'bar'
     'foo' = 'foo'
     'foo' = 'foo' asText
     'foo' asText = 'foo'
     'foo' asText = 'foo' asText
    "

    "Modified: 22.4.1996 / 15:53:58 / cg"
!

> aString
    "Compare the receiver with the argument and return true if the
     receiver is greater than the argument. Otherwise return false.
     This comparison is based on the elements ascii code -
     i.e. upper/lowercase & upper/lowercase & national characters are NOT treated specially."

    |mySize    "{ Class: SmallInteger }"
     otherSize "{ Class: SmallInteger }"
     n         "{ Class: SmallInteger }"
     c1 c2|

    mySize := self size.
    otherSize := aString string size.
    n := mySize min:otherSize.

    1 to:n do:[:index |
        c1 := self at:index.
        c2 := aString at:index.
        (c1 == c2 or:[c1 = c2]) ifFalse:[^ c1 > c2].
    ].
    ^ mySize > otherSize

    "Modified: 22.4.1996 / 15:55:00 / cg"
!

after:aString
    "Compare the receiver with the argument and return true if the
     receiver should come after the argument in a sorted list.
     Otherwise return false.
     NOTE: The comparison should be language specific, depending on the value of
            LC_COLLATE, which is initialized from the environment.

            Currently it is for Strings, but not for UnicodeStrings...

     STUPID:
        #after has a completely different meaning in SeqColl ..."

    ^ (self compareCollatingWith:aString) > 0
!

compareAsVersionNumberWith:aStringOrCollection
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument in a sorted list.
     Compare as version numbers in the form a.b.c... ."

    |rev1 rev2 removeTrailingZerosBlock trailingZerosCount|

    rev1 := self asCollectionOfSubstringsSeparatedBy:$..
    aStringOrCollection isString ifTrue:[
        rev2 := aStringOrCollection asCollectionOfSubstringsSeparatedBy:$..
    ].
    rev1 := rev1 collect:[:each| each asInteger].
    rev2 := rev2 collect:[:each| each asInteger].

    removeTrailingZerosBlock := 
        [:numbers |
            trailingZerosCount := 0.
            numbers reversed doWithExit:[:each :exit |
                each == 0 ifTrue:[
                    trailingZerosCount := trailingZerosCount + 1.
                ] ifFalse:[
                    exit value:nil.
                ].
            ].

            trailingZerosCount > 0 ifTrue:[
                numbers copyTo:numbers size - trailingZerosCount
            ] ifFalse:[
                numbers
            ]
        ].

    rev1 := removeTrailingZerosBlock value:rev1.
    rev2 := removeTrailingZerosBlock value:rev2.

    ^ rev1 compareWith:rev2

   "
     self assert:('1' compareAsVersionNumberWith:'2') < 0.
     self assert:('2' compareAsVersionNumberWith:'1') > 0.
     self assert:('1.1' compareAsVersionNumberWith:'2.1.2') < 0.
     self assert:('2.1' compareAsVersionNumberWith:'1.2.3') > 0.
     self assert:('1' compareAsVersionNumberWith:'1.1') < 0.
     self assert:('1.1' compareAsVersionNumberWith:'1') > 0.
     self assert:('1.1' compareAsVersionNumberWith:'1.2') < 0.
     self assert:('1.10' compareAsVersionNumberWith:'1.2') > 0.
     self assert:('1.2.3.4' compareAsVersionNumberWith:'1.2.3.5') < 0.
     self assert:('1.2.3.4' compareAsVersionNumberWith:'1.2.3.3') > 0.
     self assert:('1.2.3.4' compareAsVersionNumberWith:'1.2.3') > 0.
     self assert:('1.2.3.4' compareAsVersionNumberWith:'1.2.3.4') = 0.
     self assert:('1.2.3.4' compareAsVersionNumberWith:'01.002.03.004') = 0.
     self assert:('1.2.3.4' compareAsVersionNumberWith:#(1 2 3 4)) = 0.
    "
!

compareCaselessWith:aString
    "Compare the receiver against the argument, ignoreing case.
     Return 1 if the receiver is greater, 0 if equal and -1 if less than the argument.

     This comparison is based on the elements ascii code -
     i.e. national characters are NOT treated specially.
     'foo' compareWith: 'Foo' will return 0"

    |mySize    "{ Class: SmallInteger }"
     otherSize "{ Class: SmallInteger }"
     n         "{ Class: SmallInteger }"
     c1 c2|

    mySize := self size.
    otherSize := aString string size.
    n := mySize min:otherSize.

    1 to:n do:[:index |
        c1 := (self at:index) asLowercase.
        c2 := (aString at:index) asLowercase.
        c1 > c2 ifTrue:[^ 1].
        c1 < c2 ifTrue:[^ -1].
    ].
    mySize > otherSize ifTrue:[^ 1].
    mySize < otherSize ifTrue:[^ -1].
    ^ 0

    "Modified: 22.4.1996 / 15:56:07 / cg"
!

compareCollatingWith:aString
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument in a sorted list.
     The comparison is language specific, depending on the value of
     LC_COLLATE, which is in the shell environment."

    "TODO not yet defined for unicode"
    <resource: #todo>

    |s|

    (s := self string) ~~ self ifTrue:[
        ^ s compareCollatingWith:aString
    ].
    ^ self compareWith:aString
!

compareWith:aString
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument.
     This comparison is based on the elements' codepoints -
     i.e. upper/lowercase & national characters are NOT treated specially.
     'foo' compareWith: 'Foo' will return 1.
     while 'foo' sameAs:'Foo' will return true"

    |s|

    s := self string.
    s ~~ self ifTrue:[
        ^ s compareWith:aString string.
    ].
    ^ super compareWith:aString string.
!

endsWith:aStringOrCharacter
    "return true, if the receiver ends with something, aStringOrCharacter.
     If aStringOrCharacter is empty, true is returned"

    |s|

    (s := self string) ~~ self ifTrue:[
        ^ s endsWith:aStringOrCharacter
    ].
    (self size ~~ 0 and:[aStringOrCharacter isCharacter]) ifTrue:[
        ^ self last = aStringOrCharacter
    ].
    ^ super endsWith:aStringOrCharacter

    "
     'hello world' endsWith:'world'
     'hello world' asText allBold endsWith:'world'
     'hello world' endsWith:''
     'hello world' asText allBold endsWith:''
    "

    "Modified: 12.5.1996 / 15:49:18 / cg"
!

hammingDistanceTo:aString
    "return the hamming distance (the number of characters which are different).
     In information theory, the Hamming distance between two strings of equal length
     is the number of positions for which the corresponding symbols are different.
     Put another way, it measures the minimum number of substitutions required to change
     one into the other, or the number of errors that transformed one string into the other."

    self assert:(aString size == self size).
    ^ 1 to:self size count:[:idx | (self at:idx) ~= (aString at:idx)]

    "
     'roses' hammingDistanceTo:'toned'
    "
!

hash
    "return an integer useful as a hash-key"

    "/ whenever changing, also care for String>>hash.
    "/ immediately after any change, execute (maybe in a debugger):
    "/      Set allSubInstancesDo:[:s | s rehash]
    ^ self hash_fnv1a

    "
     'a' hash
     'a' asUnicode16String hash
     'a' asUnicode32String hash
     'aa' hash
     'aa' asUnicode16String hash
     'aa' asUnicode32String hash
     'ab' hash
     'ab' asUnicode16String hash
     'ab' asUnicode32String hash
     'ab' hash
     'ab' asArray hash
    "

    "
        |syms ms|

        syms := Symbol allInstances.
        Transcript show:'syms: '; showCR:syms size.
        Transcript show:'sdbm hashes: '; showCR:(syms collect:[:s| s hash]) asSet size.
        Transcript show:'dragonBook hashes: '; showCR:(syms collect:[:s| s hash_dragonBook]) asSet size.

        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash].
            ].
        ].
        Transcript show:'sdbm hash: '; showCR:ms.

        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash_dragonBook].
            ].
        ].
        Transcript show:'dragonBook: '; showCR:ms.

        syms := syms collect:[:each| each asUnicode16String].
        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash].
            ].
        ].
        Transcript show:'unicode sdbm hash: '; showCR:ms.

        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash_dragonBook].
            ].
        ].
        Transcript show:'unicode dragonBook:'; showCR:ms.
    "

    "Modified: / 26-12-2011 / 14:09:07 / cg"
!

hash_dragonBook
    "return an integer useful as a hash-key"

    |h g|

    "/
    "/ this is the dragon-book algorithm
    "/
    h := 0.
    self reverseDo:[:char |
"/ Sorry, stc cannot compile this (as of 10.9.2007)
"/        h := (h bitShift:4) + char asciiValue.
        h := (h bitShift:4).
        h := h + char codePoint.
        h := h bitAnd:16rFFFFFFFF.
        g := (h bitAnd: 16rF0000000).
        g ~~ 0 ifTrue:[
            h := h bitXor:(g bitShift:-24).
            h := h bitXor:g.
        ].
    ].
    "/
    "/ multiply by large prime to spread values
    "/ This speeds up Set and Dictionary by a factor of 10!!
    "/
    h := h times:31415821.
    ^ h

    "
     'a' hash
     'a' asUnicode16String hash
     'aa' hash
     'aa' asUnicode16String hash
     'ab' hash
     'ab' asUnicode16String hash
     'ab' hash
     'ab' asArray hash
    "

    "Created: / 26-12-2011 / 13:46:06 / cg"
!

hash_fnv1a
    "return an integer useful as a hash-key.
     This method uses the fnv-1a algorithm
     (which is actually a very good one).
     Also: on 64bit CPUs, only small 4-byte hashvalues are returned,
                (so hash values are independent from the architecture)"

    |h byte|

    h := 2166136261.
    self do:[:eachChar |
        byte := eachChar codePoint.
        h := h bitXor:byte.
        h := (h * 16777619) bitAnd:16rFFFFFFFF.
    ].
    "/ make sure, it fits into a smallInt
    h := (h bitXor: (h >> 30)) bitAnd: 16r3FFFFFFF.
    ^ h

    "
     'abc' hash_fnv1a
     'abc' asUnicode16String hash_fnv1a
     'abc' asUnicode32String hash_fnv1a

     'foofooHelloWorld' hash_fnv1a
     'foofooHelloWorld' asUnicode16String hash_fnv1a
     'foofooHelloWorld' asUnicode32String hash_fnv1a

     'blablaHelloWorld' hash_fnv1a
     'blablaHelloWorld' asUnicode16String hash_fnv1a
     'blablaHelloWorld' asUnicode32String hash_fnv1a
    "

    "Modified: / 23-06-2016 / 23:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash_java
    "return an integer useful as a hash-key.
     This method uses the same algorithm as used in
     the java virtual machine
     (which is actually not a very good one)."

    |h|

    h := 0.
    self do:[:eachChar |
        h := (h * 31) + (eachChar codePoint).
        h := h bitAnd:16rFFFFFFFF.
    ].
    ^ h

    "
     'abc' hash_java
     'foofooHelloWorld' hash_java
     'blablaHelloWorld' hash_java
    "
!

hash_sdbm
    "return an integer useful as a hash-key.
     This method implements the sdbm algorithm."

    |h|

    "/
    "/ this is the sdbm algorithm
    "/
    h := 0.
    self do:[:char |
        h := (65599 times:h) plus:char codePoint.
    ].
    ^ h

    "
     'a' hash
     'a' asUnicode16String hash
     'aa' hash
     'aa' asUnicode16String hash
     'ab' hash
     'ab' asUnicode16String hash
     'ab' hash
     'ab' asArray hash
    "

    "
        |syms ms|

        syms := Symbol allInstances.
        Transcript show:'syms: '; showCR:syms size.
        Transcript show:'sdbm hashes: '; showCR:(syms collect:[:s| s hash]) asSet size.
        Transcript show:'dragonBook hashes: '; showCR:(syms collect:[:s| s hash_dragonBook]) asSet size.

        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash].
            ].
        ].
        Transcript show:'sdbm hash: '; showCR:ms.

        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash_dragonBook].
            ].
        ].
        Transcript show:'dragonBook: '; showCR:ms.

        syms := syms collect:[:each| each asUnicode16String].
        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash].
            ].
        ].
        Transcript show:'unicode sdbm hash: '; showCR:ms.

        ms := Time millisecondsToRun:[
            10 timesRepeat:[
                syms do:[:each| each hash_dragonBook].
            ].
        ].
        Transcript show:'unicode dragonBook:'; showCR:ms.
    "

    "Modified: / 26-12-2011 / 14:09:07 / cg"
!

levenshteinTo:aString
    "return the levenshtein distance to the argument, aString;
     this value corresponds to the number of replacements that have to be
     made to get aString from the receiver.
     See IEEE transactions on Computers 1976 Pg 172 ff."

    "
     in the following, we assume that ommiting a character
     is less of an error than inserting an extra character.
     Therefore the different insertion (i) and deletion (d) values.
        s: substitution weight (4)
        k: keyboard weight (k) (typing a nearby key) - or nil (then use s)
        c: case weight (4)                           - or nil (then use s)
        e: exchange weight (8)                       - or nil (then use s*2)
        i: insertion of extra character weight (2)
        d: delete of a character weight (6)
    "

    ^ StringUtilities
            levenshteinDistanceFrom:self
            to:aString
            s:4 k:4 c:4 e:nil i:2 d:6

    "
     'computer' levenshteinTo:'computer'
     'cOmputer' levenshteinTo:'computer'
     'cOmpuTer' levenshteinTo:'computer'
     'cimputer' levenshteinTo:'computer'
     'cumputer' levenshteinTo:'computer'

     'cmputer' levenshteinTo:'computer'
     'coomputer' levenshteinTo:'computer'

     'ocmprt' levenshteinTo:'computer'
     'computer' levenshteinTo:'computer'
     'ocmputer' levenshteinTo:'computer'
     'cmputer' levenshteinTo:'computer'
     'computer' levenshteinTo:'cmputer'
     'Computer' levenshteinTo:'computer'

     'compiter' levenshteinTo:'computer'
     'compoter' levenshteinTo:'computer'

     'comptuer' levenshteinTo:'computer'
    "
!

levenshteinTo:aString s:substWeight k:kbdTypoWeight c:caseWeight i:insrtWeight d:deleteWeight
    "parametrized levenshtein.
     return the levenshtein distance to the argument, aString;
     this value corrensponds to the number of replacements that have to be
     made to get aString from the receiver.
     The arguments are the costs for
        s:substitution,
        k:keyboard type (substitution),
        c:case-change,
        i:insertion
        d:deletion
     of a character.
     See IEEE transactions on Computers 1976 Pg 172 ff"

    ^ StringUtilities
            levenshteinDistanceFrom:self
            to:aString
            s:substWeight k:kbdTypoWeight c:caseWeight e:nil i:insrtWeight d:deleteWeight
!

sameAs:aString
    "Compare the receiver with the argument like =, but ignore case differences.
     Return true or false."

    |mySize "{ Class: SmallInteger }"
     otherSize c1 c2|

    self == aString ifTrue:[^ true].

    mySize := self size.
    otherSize := aString string size.
    mySize ~~ otherSize ifTrue:[^ false].

    1 to:mySize do:[:index |
        c1 := self at:index.
        c2 := aString at:index.
        c1 ~~ c2 ifTrue:[
            (c1 sameAs:c2) ifFalse:[^ false].
        ]
    ].
    ^ true

    "
     'foo' sameAs: 'Foo'
     'foo' sameAs: 'bar'
     'foo' sameAs: 'foo'
    "

    "Modified: 22.4.1996 / 15:56:17 / cg"
!

sameAs:aString caseSensitive:caseSensitive
    "Compare the receiver with the argument.
     If caseSensitive is false, this is the same as #sameAs:,
     if false, this is the same as #=."

    caseSensitive ifFalse:[
        ^ self sameAs:aString
    ].
    ^ self = aString

    "
     'foo' sameAs:'Foo' caseSensitive:false
     'foo' sameAs:'foo' caseSensitive:true
    "
!

sameAs:aString ignoreCase:ignoreCase
    <resource: #obsolete>
    "Compare the receiver with the argument.
     If ignoreCase is true, this is the same as #sameAs:,
     if false, this is the same as #=."

    ignoreCase ifTrue:[
        ^ self sameAs:aString
    ].
    ^ self = aString

    "
     'foo' sameAs:'Foo' ignoreCase:false
     'foo' sameAs:'foo' ignoreCase:true
    "

!

sameCharacters:aString
    "count & return the number of characters which are the same
     (ignoring case and emphasis) in the receiver and the argument, aString."

    |n "{ Class: SmallInteger }"
     c1 c2 cnt|

    n := self size.
    n := n min:(aString string size).

    cnt := 0.
    1 to:n do:[:index |
        c1 := self at:index.
        c2 := aString at:index.
        ((c1 == c2)
        or:[c1 asLowercase = c2 asLowercase]) ifTrue:[
            cnt := cnt + 1
        ]
    ].
    ^ cnt

    "
     'foobarbaz' sameCharacters: 'foo'
     'foobarbaz' sameCharacters: 'Foo'
     'foobarbaz' sameCharacters: 'baz'
    "
!

sameEmphasisAs:aStringOrText
    "compare the receiver's and the argument's emphasis"

    ^ self emphasis = aStringOrText emphasis

    "
     'hello' asText sameEmphasisAs: 'hello'
     'hello' asText sameEmphasisAs: 'hello' asText
     'hello' asText allBold sameEmphasisAs: 'hello'
     'hello' asText allBold sameEmphasisAs: 'fooba' asText allBold
     'hello' asText allBold sameEmphasisAs: 'fooba' asText allItalic
    "
!

sameStringAndEmphasisAs:aStringOrText
    "compare both emphasis and string of the receiver and the argument"

    aStringOrText isString ifFalse:[^ false].
    (self string = aStringOrText string) ifFalse:[^ false].
    self hasChangeOfEmphasis = aStringOrText hasChangeOfEmphasis ifFalse:[^ false].
    ^ self emphasis = aStringOrText emphasis

    "
     'hello' asText sameEmphasisAs: 'hello'
     'hello' asText sameEmphasisAs: 'hello' asText
     'hello' asText allBold sameEmphasisAs: 'hello'
     'hello' asText allBold sameEmphasisAs: 'fooba' asText allBold
     'hello' asText allBold sameEmphasisAs: 'fooba' asText allItalic

     'hello' sameEmphasisAs: 'hello' asText
     'hello' sameEmphasisAs: 'hello' asText allBold
     'hello' sameEmphasisAs: 'fooba'
     'hello' sameEmphasisAs: 'fooba' asText
     'hello' sameEmphasisAs: 'fooba' asText allBold
     'hello' sameEmphasisAs: 'fooba' asText allItalic

     'hello' asText sameStringAndEmphasisAs: 'hello'
     'hello' asText sameStringAndEmphasisAs: 'hello' asText
     'hello' asText allBold sameStringAndEmphasisAs: 'hello'
     'hello' asText allBold sameStringAndEmphasisAs: 'fooba' asText allBold
     'hello' asText allBold sameStringAndEmphasisAs: 'fooba' asText allItalic

     'hello' sameStringAndEmphasisAs: 'hello' asText
     'hello' sameStringAndEmphasisAs: 'hello' asText allBold
     'hello' sameStringAndEmphasisAs: 'fooba'
     'hello' sameStringAndEmphasisAs: 'fooba' asText
     'hello' sameStringAndEmphasisAs: 'fooba' asText allBold
     'hello' sameStringAndEmphasisAs: 'fooba' asText allItalic
    "
!

spellAgainst: aString
    "return an integer between 0 and 100 indicating how similar
     the argument is to the receiver.  No case conversion is done.
     This algorithm is much simpler (but also less exact) than the
     levenshtein distance. Experiment which is better for your
     application."

    | i1     "{ Class: SmallInteger }"
      i2     "{ Class: SmallInteger }"
      next1  "{ Class: SmallInteger }"
      next2  "{ Class: SmallInteger }"
      size1  "{ Class: SmallInteger }"
      size2  "{ Class: SmallInteger }"
      score  "{ Class: SmallInteger }"
      maxLen "{ Class: SmallInteger }" |

    size1 := self size.
    size2 := aString size.
    maxLen := size1 max:size2.
    score := 0.
    i1 := i2 := 1.
    [i1 <= size1 and: [i2 <= size2]] whileTrue:[
        next1 := i1 + 1.
        next2 := i2 + 1.
        (self at:i1) == (aString at:i2) ifTrue: [
            score := score+1.
            i1 := next1.
            i2 := next2
        ] ifFalse: [
            (i2 < size2 and: [(self at:i1) == (aString at:next2)]) ifTrue: [
                i2 := next2
            ] ifFalse: [
                (i1 < size1 and: [(self at:next1) == (aString at:i2)]) ifTrue: [
                    i1 := next1
                ] ifFalse: [
                    i1 := next1.
                    i2 := next2
                ]
            ]
        ]
    ].

    score == maxLen ifTrue: [^ 100].
    ^ 100 * score // maxLen

    "
     'Smalltalk' spellAgainst: 'Smalltlak'
     'Smalltalk' spellAgainst: 'smalltlak'
     'Smalltalk' spellAgainst: 'smalltalk'
     'Smalltalk' spellAgainst: 'smalltlk'
     'Smalltalk' spellAgainst: 'Smalltolk'
    "
!

startsWith:aStringOrCharacter
    "return true, if the receiver starts with something, aStringOrCharacter.
     If the argument is empty, true is returned.
     Notice, that this is similar to, but slightly different from VW's and Squeak's beginsWith:,
     which are both inconsistent w.r.t. an empty argument."

    |s|

    aStringOrCharacter isCharacter ifTrue:[
        ^ (self size ~~ 0) and:[ (self at:1) == aStringOrCharacter ]
    ].
    (s := self string) ~~ self ifTrue:[
        ^ s startsWith:aStringOrCharacter
    ].
    ^ super startsWith:aStringOrCharacter

    "
     'abcde' startsWith:#($a $b $c)
     'abcde' startsWith:'abc'
     'abcd' startsWith:'abcde'
     'abcde' startsWith:'abd'
     'hello world' startsWith:'hello'
     'hello world' asText allBold startsWith:'hello'
     'hello world' asText allBold startsWith:''
    "

    "Created: 12.5.1996 / 15:46:40 / cg"
    "Modified: 12.5.1996 / 15:49:24 / cg"
! !

!CharacterArray methodsFor:'converting'!

asAsciiZ
    "if the receiver does not end with a 0-valued character, return a copy of it,
     with an additional 0-character. Otherwise return the receiver. This is sometimes
     needed when a string has to be passed to C, which needs 0-terminated strings.
     Notice, that all singleByte strings are already 0-terminated in ST/X, whereas wide
     strings are not."

    (self notEmpty and:[self last codePoint == 0]) ifTrue:[^ self ].
    ^ self copyWith:(Character value:0).

    "
     'abc' asAsciiZ
     'abc' asWideString asAsciiZ
    "
!

asByteArray
    "depending on the size of the characters in the receiver,
     return a byteArray containing single-, double- or even 4-bytewise values.
     The size of the returned byteArray will be the strings size multiplied by the
     size required for the largest character.
     Attention: The bytes are in native byte order.
     Caveat: better use utf8Encoded, to get reproducable results"

    |bytes sz bytesPerCharacter idx str|

    str := self string.
    str ~~ self ifTrue:[
        "/ for text and other wrappers
        ^ str asByteArray
    ].

    "/ for real strings, a fallback
    sz := self size.
    bytesPerCharacter := self bytesPerCharacter.
    bytes := ByteArray new:(sz * bytesPerCharacter).
    idx := 1.
    self do:[:char |
        |code|

        code := char codePoint.
        bytesPerCharacter == 2 ifTrue:[
            bytes unsignedInt16At:idx put:code
        ] ifFalse:[
            bytesPerCharacter == 4 ifTrue:[
                bytes unsignedInt32At:idx put:code
            ] ifFalse:[
                bytes at:idx put:code
            ].
        ].
        idx := idx + bytesPerCharacter.
    ].
    ^ bytes

    "Created: / 27-07-2011 / 00:56:17 / cg"
!

asByteArrayMSB:msb
    "depending on the size of the characters in the receiver,
     return a byteArray containing single-, double- or even 4-bytewise values.
     The size of the returned byteArray will be the strings size multiplied by the
     size required for the largest character.
     Caveat: better use utf8Encoded, to get reproducable results"

    |ba|

    ba := self asByteArray. "/ native order
    UninterpretedBytes isBigEndian ~~ msb ifTrue:[
        ba swapBytes
    ].
    ^ ba
!

asCanonicalizedFilename
    "return a Filename with pathname taken from the receiver.
     The filename is canonicalized, meaning that it cares for trailing directory separators,
     '.' components etc."

    ^ self asFilename asCanonicalizedFilename

    "on windows:
     'c:\foo\bar' asFilename
     'c:\foo\bar\' asFilename
     'c:\foo\bar\..\baz' asFilename
     'c:\foo\bar\..\baz\.' asFilename
     'c:\foo\bar' asCanonicalizedFilename
     'c:\foo\bar\' asCanonicalizedFilename
     'c:\foo\bar\..\baz' asCanonicalizedFilename
     'c:\foo\bar\..\baz\.' asCanonicalizedFilename
    
    on unix:
     '/foo/bar' asFilename
     '/foo/bar/' asFilename
     '/foo/bar/../baz' asFilename
     '/foo/bar/../baz/.' asFilename
     '/foo/bar' asCanonicalizedFilename
     '/foo/bar/' asCanonicalizedFilename
     '/foo/bar/../baz' asCanonicalizedFilename
     '/foo/bar/../baz/.' asCanonicalizedFilename
    "
!

asCollectionOfLines
    "return a collection containing the lines (separated by cr)
     of the receiver. If multiple cr's occur in a row, the result will
     contain empty strings.
     If the string ends with a cr, an empty line will be found as last element of the resulting collection.
     See also #asCollectionOfLinesWithReturn
     (would have rather changed this method instead of adding another one, but a lot of code already uses
      this method and we did not want to risk any incompatibilities)"

    ^ self asCollectionOfSubstringsSeparatedBy:Character cr.

    "
     '1 one\2 two\3 three\4 four\5 five' withCRs asCollectionOfLines
     '1 one\\\\2 two\3 three' withCRs asCollectionOfLines

     ('foo \r\nbar\nbaz\t\r\n\r\nbla' printf:#())
        asCollectionOfLines collect:[:l | (l endsWith:Character return) ifTrue:[l copyButLast:1] ifFalse:l]
    "
!

asCollectionOfLinesWithReturn
    "return a collection containing the lines (separated by cr)
     of the receiver. If multiple cr's occur in a row, the result will
     contain empty strings."

    |lines|

    lines := self asCollectionOfSubstringsSeparatedBy:Character cr.
    (lines notEmpty and:[lines last isEmpty]) ifTrue:[
        ^ lines copyButLast:1
    ].
    ^ lines

    "
     '1\2\3' withCRs asCollectionOfLines
     '1\2\3\' withCRs asCollectionOfLines
     '1\2\3' withCRs asCollectionOfLinesWithReturn
     '1\2\3\' withCRs asCollectionOfLinesWithReturn
     '' withCRs asCollectionOfLinesWithReturn
    "
!

asCollectionOfSubstringsSeparatedBy:aCharacter
    "return a collection containing substrings (separated by aCharacter)
     of the receiver.
     If aCharacter occurs multiple times in a row, the result will contain empty strings.
     If the receiver ends with aCharacter, an empty string with be the last result element."

    ^ self asCollectionOfSubCollectionsSeparatedBy:aCharacter

    "
     '1 one:2 two:3 three:4 four:5 five' asCollectionOfSubstringsSeparatedBy:$:
     '1 one:2 two:3 three:4 four:5 five:' asCollectionOfSubstringsSeparatedBy:$:
     '1 one 2 two 3 three 4 four 5 five' asCollectionOfSubstringsSeparatedBy:Character space
    "
!

asCollectionOfSubstringsSeparatedBy:aCharacter exceptIn:ch
    "return a collection containing the substrings (separated by aCharacter)
     of the receiver. If aCharacter occurs multiple times in a row,
     the result will contain empty strings.
     The separation is not done, inside a matching pair of ch-substrings.
     Can be used to tokenize csv-like strings, which may or may not be enclosed in quotes."

    |lines myClass except i c
     startIndex    "{ Class:SmallInteger }"
     stopIndex     "{ Class:SmallInteger }" |

    lines := StringCollection new.
    myClass := self species.

    startIndex := 1.
    except := false.
    [
        i := startIndex-1.
        [
            i := i+1.
            c := self at:i.
            c = ch ifTrue:[ except := except not. ].
            i < self size and:[except or:[c ~= aCharacter]]
        ] whileTrue.

        c = aCharacter ifTrue:[
            stopIndex := i -1.
        ] ifFalse: [
            stopIndex := i.
        ].
        (stopIndex < startIndex) ifTrue: [
            lines add:(myClass new:0)
        ] ifFalse: [
            lines add:(self copyFrom:startIndex to:stopIndex)
        ].
        startIndex := stopIndex + 2.
        startIndex <= self size
    ] whileTrue.
    ^ lines

    "
     'asd''f;d''dd;s' asCollectionOfSubstringsSeparatedBy:$; exceptIn:$'
    "
    "/ 'asd "hello bla" foo "bla bla" bar' asCollectionOfSubstringsSeparatedBy:$  exceptIn:$"
!

asCollectionOfSubstringsSeparatedBy:aFieldSeparatorString textSeparator:aTextSeparatorOrNil
    "return a collection containing the words (separated by aFieldSeparatorString) of the receiver.
     Individual words might be enclosed in aTextSeparator characters, in case they contain blanks or fieldSeparators.
     Typically used for CSV line parsing, with a $; as aFieldSeparator and $'' (dquote) as textSeparator."

    |aTextSeparatorChar items scanningWord inStream element lastIsFieldSeparator sz|

    aTextSeparatorOrNil isNil ifTrue:[
        ^ self asCollectionOfSubstringsSeparatedByAll: aFieldSeparatorString
    ].
    sz := aTextSeparatorOrNil size.
    sz = 0 ifTrue:[
        aTextSeparatorChar := aTextSeparatorOrNil
    ] ifFalse:[sz = 1  ifTrue:[
        "this is a String. Fetch the first character - compatibility to older expecco libs"
        aTextSeparatorChar := aTextSeparatorOrNil first.
    ] ifFalse:[
        self error:'textSeparatorSize > 1'.
    ]].

    items := OrderedCollection new.

    inStream := ReadStream on:self.
    [
        inStream skipSeparators.
        inStream atEnd
    ] whileFalse:[
        lastIsFieldSeparator := false.
        inStream peek == aTextSeparatorChar ifTrue:[
            inStream next.
            element := ''.
            scanningWord := true.
            [ scanningWord and:[inStream atEnd not] ] whileTrue:[
                element := element , (inStream upTo:aTextSeparatorChar).
                (inStream peek == aTextSeparatorChar) ifTrue:[
                    element := element , aTextSeparatorChar .
                    inStream next.
                ] ifFalse:[
                    scanningWord := false.
                ].
            ].
            inStream upToAll_positionBefore:aFieldSeparatorString.
        ] ifFalse:[
            element := inStream upToAll_positionBefore:aFieldSeparatorString
        ].
        items add:element.
        lastIsFieldSeparator := (inStream skipThroughAll:aFieldSeparatorString) notNil.
    ].
    lastIsFieldSeparator ifTrue:[
        "empty element at the end of the line"
        items add:''.
    ].

    ^ items

    "
     self assert:(('#First#, #Second,SecondAdd#, #Third#' asCollectionOfSubstringsSeparatedBy:',' textSeparator: $#)
                  sameContentsAs:#('First' 'Second,SecondAdd' 'Third')).
     self assert:(('#Fir##st#, #Second,SecondAdd#, #Third#' asCollectionOfSubstringsSeparatedBy:',' textSeparator: $#)
                  sameContentsAs:#('Fir#st' 'Second,SecondAdd' 'Third')).
     self assert:(('#Fir##st#, Second,SecondAdd, #Third#' asCollectionOfSubstringsSeparatedBy:',' textSeparator: $#)
                  sameContentsAs:#('Fir#st' 'Second' 'SecondAdd' 'Third')).
     self assert:(('First,Second,Third,,' asCollectionOfSubstringsSeparatedBy:',' textSeparator:nil)
                   sameContentsAs:#('First' 'Second' 'Third' '' '')).
     self assert:(('First,Second,Third,,' asCollectionOfSubstringsSeparatedBy:',' textSeparator:'#')
                   sameContentsAs:#('First' 'Second' 'Third' '' '')).
    "

    "Modified: / 07-04-2011 / 13:23:19 / cg"
!

asCollectionOfSubstringsSeparatedByAll:aSeparatorString
    "return a collection containing the lines (separated by aSeparatorString)
     of the receiver. If aSeparatorString occurs multiple times in a row,
     the result will contain empty strings."

    ^ self asCollectionOfSubCollectionsSeparatedByAll:aSeparatorString

    "
     '1::2::3::4::5::' asCollectionOfSubstringsSeparatedByAll:'::'
    "
!

asCollectionOfSubstringsSeparatedByAny:aCollectionOfSeparators
    "return a collection containing the words (separated by any character
     from aCollectionOfSeparators) of the receiver.
     This allows breaking up strings using any character as separator."

    ^ self asCollectionOfSubCollectionsSeparatedByAny:aCollectionOfSeparators

    "
     'hello:world:isnt:this nice' asCollectionOfSubstringsSeparatedByAny:#($:)
     'hello:world:isnt:this nice' asCollectionOfSubstringsSeparatedByAny:':'
     'hello:world:isnt:this nice' asCollectionOfSubstringsSeparatedByAny:(Array with:$: with:Character space)
     'hello:world:isnt:this nice' asCollectionOfSubstringsSeparatedByAny:': '
     'h1e2l3l4o' asCollectionOfSubstringsSeparatedByAny:($1 to: $9)
    "
!

asCollectionOfWords
    "return a collection containing the words (separated by whitespace)
     of the receiver. Multiple occurrences of whitespace characters will
     be treated like one - i.e. whitespace is skipped.
     (sigh: it is called #'subStrings' in V'Age, and #'substrings' in Squeak) "

    |words|

    words := StringCollection new.
    self asCollectionOfWordsDo:[:w | words add:w].
    ^ words

    "
     'hello world isnt this nice' asCollectionOfWords
     '    hello    world   isnt   this   nice  ' asCollectionOfWords
     'hello' asCollectionOfWords
     '' asCollectionOfWords
     '      ' asCollectionOfWords
     ' foo bar__baz__bla__ bar ' asCollectionOfWords
     ' foo __bar__baz__bla__ bar ' asCollectionOfWords
    "
!

asCollectionOfWordsDo:aBlock
    "evaluate aBlock for each word (separated by whitespace) of the receiver.
     Multiple occurrences of whitespace characters will be treated like one
     - i.e. whitespace is skipped.
     Returns the number of words (i.e. the number of invocations of aBlock)."

    |count  "{ Class:SmallInteger }"
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
     mySize "{ Class:SmallInteger }"|

    count := 0.
    start := 1.
    mySize := self size.
    [start <= mySize] whileTrue:[
        start := self indexOfNonSeparatorStartingAt:start.
        start == 0 ifTrue:[
            ^ count
        ].
        stop := self indexOfSeparatorStartingAt:start.
        stop == 0 ifTrue:[
            aBlock value:(self copyFrom:start to:mySize).
            ^ count + 1
        ].
        aBlock value:(self copyFrom:start to:(stop - 1)).
        start := stop.
        count := count + 1
    ].
    ^ count

    "
     'hello world isnt this nice' asCollectionOfWordsDo:[:w | Transcript showCR:w]
     '    hello    world   isnt   this   nice  ' asCollectionOfWordsDo:[:w | Transcript showCR:w]
     'hello' asCollectionOfWordsDo:[:w | Transcript showCR:w]
     '' asCollectionOfWordsDo:[:w | Transcript showCR:w]
     '      ' asCollectionOfWordsDo:[:w | Transcript showCR:w]
    "
!

asFilename
    "return a Filename with pathname taken from the receiver"

    ^ Filename named:self "(self asSingleByteStringReplaceInvalidWith:$?)"

    "Modified: 20.5.1996 / 09:38:15 / cg"
!

asFixedPoint
    "read a fixedPoint number from the receiver.
     Notice, that errors may occur during the read,
     so you better setup some signal handler when using this method."

    ^ FixedPoint readFromString:self

    "
     '0.123' asFixedPoint
     '12345' asFixedPoint
     '(1/5)' asFixedPoint
     'foo' asFixedPoint
     Object errorSignal handle:[:ex | ex return:0] do:['foo' asFixedPoint]
    "

    "Modified: / 25.10.1997 / 15:19:00 / cg"
!

asFixedPoint:scale
    "read a fixedPoint number with scale number of post-decimal digits
     from the receiver. Scale controls the number of displayed digits,
     not the number of actually valid digits.
     Notice, that errors may occur during the read,
     so you better setup some signal handler when using this method."

    ^ (FixedPoint readFromString:self) scale:scale

    "
     '0.123' asFixedPoint:2
     '123456' asFixedPoint:2
     ('3.14157' asFixedPoint:1) asFixedPoint:5
     '3.14157' asFixedPoint:2
     'foo' asFixedPoint:2
    "

    "Modified: / 25.10.1997 / 15:21:57 / cg"
!

asFloat
    "read a float number from the receiver.
     Notice, that errors may occur during the read,
     so you better setup some exception handler when using this method."

    ^ (Number readFromString:self) asFloat

    "
     '0.123' asFloat
     '12345' asFloat
     '(1/5)' asFloat
     Object errorSignal handle:[:ex | ex return:0] do:['foo' asFloat]
    "
!

asInteger
    "convert the receiver into an integer.
     Notice, that errors may occur during the read,
     so you better setup some exception handler when using this method.
     Also notice, that this method here is more strict than the code found
     in other smalltalks.
     For less strict integer reading, use Integer readFrom:aString"

    ^ Integer readFromString:self

    "
     '12345678901234567890' asInteger
     '-1234' asInteger

     The following raises an error:
         '0.123' asInteger              <- reader finds more after reading 0

     whereas the less strict readFrom does not:
         Integer readFrom:'0.123'       <- reader stops at ., returning 0

     '0.123' asInteger
     '0.123' asNumber    <- returns what you expect
     Object errorSignal handle:[:ex | ex return:0] do:['foo' asInteger]

    "
!

asLowercase
    "return a copy of myself in lowercase letters"

    |newStr c bitsPerCharacter
     mySize "{ Class: SmallInteger }" |

    mySize := self size.
    mySize == 0 ifTrue:[^ self].

    newStr := self species new:mySize.
    bitsPerCharacter := newStr bitsPerCharacter.

    "/ handle the very seldom case of an uppercase char which needs
    "/ more bits in its lowercase variant
    "/ (there are only a few of them)

    1 to:mySize do:[:i |
        c := (self at:i) asLowercase.
        (c bitsPerCharacter > bitsPerCharacter
         and:[c stringSpecies ~= newStr stringSpecies]) ifTrue:[
            newStr := c stringSpecies fromString:newStr.
            bitsPerCharacter := newStr bitsPerCharacter.
        ].
        newStr at:i put:c
    ].
    ^ newStr

    "
     'HelloWorld' asLowercase
     'HelloWorld' asUnicode16String asLowercase
     'HelloWorld' asLowercaseFirst
     'HelloWorld' asUppercase
     'HelloWorldÿ' asUppercase
     'HelloWorldŸ' asLowercase - currently returns an U16 string; should this be u8?
    "
!

asLowercaseFirst
    "return a copy of myself where the first character is converted to lowercase.
     If the first character is already lowercase, or there is no uppercase for it, return the
     receiver."

    |newString firstChar firstCharAsLowercase|

    self isEmpty ifTrue:[^ self].
    firstChar := (self at:1).
    firstCharAsLowercase := firstChar asLowercase.
    firstChar == firstCharAsLowercase ifTrue:[ ^ self].

    firstCharAsLowercase bitsPerCharacter > self bitsPerCharacter ifTrue:[
        newString := firstCharAsLowercase stringSpecies fromString:self.
    ] ifFalse:[
        newString := self stringSpecies fromString:self.
    ].
    newString at:1 put:firstCharAsLowercase.
    ^ newString

    "
     'HelloWorld' asLowercase
     'HelloWorld' asLowercaseFirst
    "
!

asLowercaseLast
    "return a copy of myself where the last character is
     converted to lowercase."

    |newString sz|

    sz := self size.
    newString := self copyFrom:1 to:sz.
    sz > 0 ifTrue:[
        newString at:sz put:(newString at:sz) asLowercase
    ].
    ^ newString

    "
     'HelloWorld' asLowercase
     'HelloWorlD' asLowercaseLast
    "
!

asMutator
    "return a corresponding setter method's selector.
     I.e. #foo asMutator returns #foo:"

    ^ (self asSingleByteString,':') asSymbol
!

asNumber
    "read a number from the receiver.
     Notice, that (in contrast to ST-80) errors may occur during the read,
     so you better setup some signal handler when using this method.
     Also notice, that this is meant to read end-user numbers from a string;
     it does not handle smalltalk numbers (i.e. radix).
     To read a smalltalk number, use Number >> readSmalltalkFrom:.
     This may change if ANSI specifies it."

"/ ST-80 behavior:
"/  ^ Number readFromString:self onError:0

    ^ Number fromString:self

    "
     '123'     asNumber
     '123.567' asNumber
     '(5/6)'   asNumber
     'foo'     asNumber
     '123a'    asNumber
     Object errorSignal handle:[:ex | ex returnWith:0] do:['foo' asNumber]
    "
!

asNumberFromFormatString:ignored
    "read a number from the receiver, ignoring any nonDigit characters.
     This is typically used to convert from strings which include
     dollar-signs or millenium digits. However, this method also ignores
     the decimal point (if any) and therefore should be used with care."

    |tempString|

    tempString := self collect:[:char | char isDigit].
    ^ Number readFromString:tempString onError:0

    "
     'USD 123' asNumberFromFormatString:'foo'
     'DM 123'  asNumberFromFormatString:'foo'
     '123'     asNumberFromFormatString:'foo'
     '123.567' asNumberFromFormatString:'foo'
     '(5/6)'   asNumberFromFormatString:'foo'
     'foo'     asNumberFromFormatString:'foo'
    "
!

asSingleByteStringIfPossible
    "if possible, return the receiver converted to a 'normal' string.
     It is only possible, if there are no characters with codePoints above 255 in the receiver.
     If not possible, the (wideString) receiver is returned."

    self isWideString ifFalse:[^ self].
    self containsNon8BitElements ifTrue:[^ self].
    ^ self asSingleByteString

    "
     'hello' asSingleByteStringIfPossible
     'hello' asText asSingleByteStringIfPossible
     'hello' asUnicodeString asText asSingleByteStringIfPossible
     'hello' asUnicodeString asSingleByteStringIfPossible
    "
!

asSingleByteStringReplaceInvalidWith:replacementCharacter
    "return the receiver converted to a 'normal' string,
     with invalid characters replaced by replacementCharacter.
     Can be used to convert from 16-bit strings to 8-bit strings
     and replace characters above code-255 with some replacement."

    |newString|

    newString := String new:(self size).
    1 to:self size do:[:idx |
        |char|

        char := self at:idx.
        char codePoint <= 16rFF ifTrue:[
            newString at:idx put:char
        ] ifFalse:[
            newString at:idx put:replacementCharacter
        ].
    ].
    ^ newString

    "Created: 30.6.1997 / 13:02:14 / cg"
!

asString
    "return myself - I am a string"

    ^ self
!

asStringCollection
    "return a collection of lines from myself."

    ^ StringCollection fromString:self "string"

    "Modified: 13.5.1996 / 20:36:59 / cg"
!

asSymbol
    "Return a unique symbol with the name taken from the receiver's characters.
     The receiver must be a singleByte-String.
     TwoByte- and FourByteSymbols are (currently ?) not allowed."

    |str|

    str := self string.
    str ~~ self ifTrue:[ ^ str asSymbol ].
    ^ self asSingleByteString asSymbol
!

asSymbolIfInterned
    "If a symbol with the receiver's characters is already known, return it.
     Otherwise, return nil.
     This can be used to query for an existing symbol and is the same as:
        self knownAsSymbol ifTrue:[self asSymbol] ifFalse:[nil]
     but slightly faster, since the symbol lookup operation is only performed once.
     The receiver must be a singleByte-String.
     TwoByte- and FourByteSymbols are (currently ?) not allowed."

    |str|

    str := self string.
    str == self ifTrue:[
        "must be some kind of N-ByteString"
        str := self asSingleByteStringIfPossible.
        str == self ifTrue:[
            "single byte string conversion is not possible"
            ^ nil.
        ].
    ].
    ^ str asSymbolIfInterned

    "
     (Unicode16String with:(Character value:16rFFFF)) asSymbolIfInterned
     'new' asUnicodeString asSymbolIfInterned
     'new' asText asSymbolIfInterned
     'new' asUnicodeString asText asSymbolIfInterned
    "

    "Created: 22.5.1996 / 16:37:04 / cg"
!

asSymbolIfInternedOrSelf
    "If a symbol with the receiver's characters is already known, return it.
     Otherwise, return self.
     This can be used to query for an existing symbol and is the same as:
        self knownAsSymbol ifTrue:[self asSymbol] ifFalse:[self]
     but slightly faster, since the symbol lookup operation is only performed once.
     The receiver must be a singleByte-String.
     TwoByte- and FourByteSymbols are (currently ?) not allowed."

    |sym|

    sym := self asSymbolIfInterned.
    ^ sym isNil ifTrue:[self] ifFalse:[sym].


    "
     (Unicode16String with:(Character value:16rFFFF)) asSymbolIfInternedOrSelf
     'new' asUnicodeString asSymbolIfInternedOrSelf
     'new' asText asSymbolIfInternedOrSelf
     'new' asUnicodeString asText asSymbolIfInternedOrSelf
    "

    "Created: 22.5.1996 / 16:37:04 / cg"
!

asText
    "return a Text-object (string with emphasis) from myself."

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ Text string:self

    "Created: 12.5.1996 / 10:41:14 / cg"
!

asTimestamp
    "convert the receiver into an Timestamp.
     Notice, that errors may occur during the read,
     so you better setup some exception handler when using this method."

    ^ Timestamp readFrom:self

    "
     '2014-11-10 21:30:22.444' asTimestamp
     '2014-11-10 21:30:22.444Z' asTimestamp
     '2014-11-10 21:30:22.444+0200' asTimestamp
    "
!

asTitlecase
    "return a version of the receiver, where the first character is converted to titlecase,
     and everything else to lowercase.
     See the comment in Character on what titlecase is."

    |newStr c bitsPerCharacter
     mySize "{ Class: SmallInteger }" |

    mySize := self size.
    newStr := self species new:mySize.
    bitsPerCharacter := newStr bitsPerCharacter.

    1 to:mySize do:[:i |
        i == 1 ifTrue:[
            c := (self at:i) asTitlecase.
        ] ifFalse:[
            c := (self at:i) asLowercase.
        ].
        c bitsPerCharacter > bitsPerCharacter ifTrue:[
            newStr := c stringSpecies fromString:newStr.
            bitsPerCharacter := newStr bitsPerCharacter.
        ].
        newStr at:i put:c
    ].
    ^ newStr

    "
     'helloWorld' asTitlecase
     'HelloWorld' asTitlecase
     'HELLOWORLD' asTitlecase
     'helloworld' asTitlecase
    "
!

asTitlecaseFirst
    "return a version of the receiver, where the first character is converted to titlecase.
     Titlecase is much like uppercase for most characters, with the exception of some combined
     (2-character glyphs), which consist of an upper- and lower-case characters.
     If the first character is already titlecase, or there is no titlecasepercase for it, return the
     receiver."

    "
     For example, in Unicode, character U+01F3 is LATIN SMALL LETTER DZ.
     (Let us write this compound character using ASCII as 'dz'.)
     This character uppercases to character U+01F1, LATIN CAPITAL LETTER DZ.
     (Which is basically 'DZ'.)
     But it titlecases to to character U+01F2, LATIN CAPITAL LETTER D WITH SMALL LETTER Z.
     (Which we can write 'Dz'.)

      character uppercase titlecase
      --------- --------- ---------
      dz        DZ        Dz
    "

    |newString firstChar firstCharAsTitlecase|

    firstChar := (self at:1).
    firstCharAsTitlecase := firstChar asTitlecase.
    firstChar == firstCharAsTitlecase ifTrue:[ ^ self].

    firstCharAsTitlecase bitsPerCharacter > self bitsPerCharacter ifTrue:[
        newString := firstCharAsTitlecase stringSpecies fromString:self.
    ] ifFalse:[
        newString := self stringSpecies fromString:self.
    ].
    newString at:1 put:firstCharAsTitlecase.
    ^ newString

    "
     'helloWorld' asTitlecaseFirst
     'HelloWorld' asTitlecaseFirst
    "
!

asTwoByteString
    "return the receiver converted to a two-byte string.
     Will be obsolete soon - use asUnicode16String."

    ^ TwoByteString fromString:self
!

asURI
    "return an URI with string taken from the receiver"

    ^ URI fromString:self
!

asURL
    "return an URL-object from myself."

    ^ URL fromString:self

    "
     'http://www.exept.de:80/index.html' asURL host
     'http://www.exept.de:80/index.html' asURL port
     'http://www.exept.de:80/index.html' asURL method
     'http://www.exept.de:80/index.html' asURL path
    "
!

asUUID
    "return self as a UUID"

    ^ UUID fromString:self

    "
     UUID genUUID asString asUUID
     '{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}' asUUID
     '{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}' asUnicodeString asUUID
     'EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B' asUUID
     'EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B quatsch' asUUID
     'quark EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B' asUUID
    "

    "Modified: / 02-08-2007 / 16:43:29 / cg"
!

asUnicode16String
    "return the receiver in a two-byte per character representation.
     Normally, the internal ST/X representation should be transparent and not
     of the programmer's concern; except when strings are passed to the outside world,
     such as wide-string ffi calls or file contents."

     |sz|

     sz := self size.

     ^ (Unicode16String new:sz)
           replaceFrom:1 to:sz with:self startingAt:1;
           yourself.

    "
        'abc' asUnicode16String
    "
!

asUnicode16StringZ
    "return the receiver in a two-byte per character representation.
     Make sure that is zero terminated (last char is 16r0000).
     Normally, the internal ST/X representation should be transparent and not
     of the programmer's concern; except when strings are passed to the outside world,
     such as wide-string ffi calls or file contents."

     |sz|

     sz := self size.
     (self at:sz) == (Character codePoint:0) ifTrue:[
         ^ self asUnicode16String.
     ].

     ^ (Unicode16String new:sz+1)
           replaceFrom:1 to:sz with:self startingAt:1;
           at:sz+1 put:(Character codePoint:0);
           yourself.

     "
        'abc' asUnicode16StringZ
        'abc' asUnicode16String asUnicode16StringZ
     "
!

asUnicode32String
    "return the receiver in a four-byte per character representation.
     Normally, the internal ST/X representation should be transparent and not
     of the programmer's concern; except when strings are passed to the outside world,
     such as wide-string ffi calls or file contents."

    ^ self as:Unicode32String
!

asUnicodeString
    "return the receiver in a two-byte per character representation.
     Normally, the internal ST/X representation should be transparent and not
     of the programmer's concern; except when strings are passed to the outside world,
     such as wide-string ffi calls or file contents."

    ^ self asUnicode16String
    "
     'Hello World' asUnicodeString
    "
!

asUnixFilename
    "return a UnixFilename with pathname taken from the receiver"

    ^ UnixFilename named:self

    "Created: / 20-09-2010 / 21:42:55 / cg"
!

asUppercase
    "return a copy of myself in uppercase letters"

    |newStr c bitsPerCharacter
     mySize "{ Class: SmallInteger }" |

    mySize := self size.
    mySize == 0 ifTrue:[^ self].
    newStr := self species new:mySize.
    bitsPerCharacter := newStr bitsPerCharacter.

    "/ handle the very seldom case of a lowercase char which needs
    "/ more bits in its uppercase variant
    "/ (there are only a few of them)

    1 to:mySize do:[:i |
        c := (self at:i) asUppercase.
        c bitsPerCharacter > bitsPerCharacter ifTrue:[
            newStr := c stringSpecies fromString:newStr.
            bitsPerCharacter := newStr bitsPerCharacter.
        ].
        newStr at:i put:c
    ].
    ^ newStr

    "
     'helloWorld' asUppercase
     'helloWorld' asUppercaseFirst
     (Character value:16rB5) asString asUppercase   -- needs 16 bits !!
     (Character value:16rFF) asString asUppercase   -- needs 16 bits !!
    "
!

asUppercaseFirst
    "return a version of the receiver, where the first character is converted to uppercase.
     If the first character is already uppercase, or there is no uppercase for it, return the
     receiver."

    |newString firstChar firstCharAsUppercase|

    self isEmpty ifTrue:[^ self].
    firstChar := self at:1.
    firstCharAsUppercase := firstChar asUppercase.
    firstChar == firstCharAsUppercase ifTrue:[ ^ self].

    "/ very seldom, the uppercase-char needs more bits than the lowercase one (turkish y-diaresis)
    firstCharAsUppercase bitsPerCharacter > self bitsPerCharacter ifTrue:[
        newString := firstCharAsUppercase stringSpecies fromString:self.
    ] ifFalse:[
        newString := self stringSpecies fromString:self.
    ].
    newString at:1 put:firstCharAsUppercase.
    ^ newString

    "
     'helloWorld' asUppercase
     'helloWorld' asUppercaseFirst
     'HelloWorld' asUppercaseFirst
    "
!

asUppercaseLast
    "return a copy of myself where the last character is
     converted to uppercase."

    |newString sz|

    sz := self size.
    newString := self copyFrom:1 to:sz.
    sz > 0 ifTrue:[
        newString at:sz put:(newString at:sz) asUppercase
    ].
    ^ newString

    "
     'HelloWorld' asUppercase
     'HelloWorld' asUppercaseLast
    "
!

asUtcTimestamp
    "convert the receiver into an UtcTimestamp (Time is interpreted in the UTC timezone).
     Notice, that errors may occur during the read,
     so you better setup some exception handler when using this method."

    ^ UtcTimestamp readFrom:self

    "
     '2014-11-10 21:30:22.444' asUtcTimestamp
    "
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    ^ self

    "Modified: 1.9.1995 / 02:25:45 / claus"
    "Modified: 22.4.1996 / 13:00:50 / cg"
!

string
    "return the receiver - for ST-80 compatibility"

    ^ self

    "Modified: 27.4.1996 / 13:29:30 / cg"
! !

!CharacterArray methodsFor:'copying'!

, aStringOrCharacter
    "redefined to allow characters and mixed strings to be appended.
     This is nonStandard, but convenient"

    |myWidth otherWidth|

    aStringOrCharacter isCharacter ifTrue:[
        ^ self copyWith:aStringOrCharacter
    ].
    aStringOrCharacter isText ifTrue:[
        ^ aStringOrCharacter concatenateFromString:self
    ].
    aStringOrCharacter isString ifTrue:[
        (otherWidth := aStringOrCharacter bitsPerCharacter) ~~ (myWidth := self bitsPerCharacter) ifTrue:[
            otherWidth > myWidth ifTrue:[
                ^ (aStringOrCharacter species fromString:self) , aStringOrCharacter
            ].
            ^ self , (self species fromString:aStringOrCharacter)
        ].
    ].
    ^ super , aStringOrCharacter

    "
     'hello' , $1
     'hello' , '1'
     'hello' , (' world' asText allBold)
     'hello' , (JISEncodedString fromString:' world')
     (JISEncodedString fromString:'hello') , ' world'

     Transcript showCR:
         (Text string:'hello' emphasis:#italic) , (Text string:' world' emphasis:#bold)
    "

    "Modified: 28.6.1997 / 00:13:17 / cg"
!

,, aString
    "concatenate with a newLine in between"

    ^ (self copyWith:Character cr) , aString

   "
     hello ,, world
     'hello' ,, 'world'
   "
!

chopTo:maxLen
    "if the receiver's size is less or equal to maxLen, return it.
     Otherwise, return a copy of the receiver, where some characters
     in the middle have been removed for a total string length
     of maxLen."

    |sz n1 n2|

    (sz := self size) <= maxLen ifTrue:[ ^ self ].

    n1 := n2 := maxLen // 2.
    maxLen odd ifTrue:[
        n2 := n1 + 1
    ].
    ^ (self copyFrom:1 to:n1) , (self copyFrom:sz - n2 + 1)

    "
     '12345678901234'   chopTo:15
     '123456789012345'  chopTo:15
     '1234567890123456' chopTo:15
     'aShortString' chopTo:15
     'aVeryLongNameForAStringThatShouldBeShortened' chopTo:15
    "

    "Modified: / 24-10-2006 / 12:32:01 / cg"
!

contractAtBeginningTo:maxLen
    "if the receiver's size is less or equal to maxLen, return it.
     Otherwise, return a copy of the receiver, where some characters
     at the beginning have been replaced by '...' for a total string length
     of maxLen. Can be used to abbreviate long entries in tables."

    |sz|

    (sz := self size) <= maxLen ifTrue:[ ^ self ].

    ^ '...' , (self copyFrom:(sz - (maxLen - 4)))

    "
     '12345678901234' contractAtBeginningTo:15
     '123456789012345' contractAtBeginningTo:15
     '1234567890123456' contractAtBeginningTo:15
     'aShortString' contractAtBeginningTo:15
     'aVeryLongNameForAStringThatShouldBeShortened' contractAtBeginningTo:15
    "

    "Modified: / 24-10-2006 / 12:32:13 / cg"
!

contractAtEndTo:maxLen
    "if the receiver's size is less or equal to maxLen, return it.
     Otherwise, return a copy of the receiver, where some characters
     at the end have been replaced by '...' for a total string length
     of maxLen. Can be used to abbreviate long entries in tables."

    |sz|

    (sz := self size) <= maxLen ifTrue:[ ^ self ].

    ^ (self copyTo:maxLen-3),'...'

    "
     '12345678901234' contractAtEndTo:15
     '123456789012345' contractAtEndTo:15
     '1234567890123456' contractAtEndTo:15
     'aShortString' contractAtEndTo:15
     'aVeryLongNameForAStringThatShouldBeShortened' contractAtEndTo:15
    "

    "Modified: / 24-10-2006 / 12:32:26 / cg"
!

contractLeftTo:maxLen
    "if the receiver's size is less or equal to maxLen, return it.
     Otherwise, return a copy of the receiver, where some characters
     near the first quarter have been replaced by '...' for a total string length
     of maxLen.
     Very similar to contractTo:, but better to abbreviate long filename entries,
     where the right part is of more use than the left."

    |sz "{ SmallInteger }"
     halfSize quarterSize "{ SmallInteger }"
     leftEnd rightEnd rightStart|

    (sz := self size) <= maxLen ifTrue:[ ^ self ].

    halfSize := maxLen // 2.
    quarterSize := maxLen // 4.
    leftEnd := quarterSize-1.
    rightEnd := maxLen - leftEnd - 3.
    rightStart := sz - rightEnd + 1.
    ^ (self copyTo:leftEnd),'...',(self copyFrom:rightStart)

    "
     '12345678901234' contractLeftTo:15
     '123456789012345' contractLeftTo:15
     '1234567890123456' contractLeftTo:15
     'aShortString' contractLeftTo:15
     'aVeryLongNameForAStringThatShouldBeShortened' contractLeftTo:15
     'C:\Dokumente und Einstellungen\cg\work\bosch\dapas\hw_schnittstellen\DAPAS__HpibDLL.st' contractLeftTo:40
    "
!

contractTo:maxLen
    "if the receiver's size is less or equal to maxLen, return it.
     Otherwise, return a copy of the receiver, where some characters
     in the middle have been replaced by '...' for a total string length
     of maxLen. Can be used to abbreviate long entries in tables."

    |sz "{ SmallInteger }" leftSize rightSize|

    (sz := self size) <= maxLen ifTrue:[ ^ self ].

    rightSize := maxLen // 2.
    leftSize := maxLen - rightSize.
    leftSize := leftSize - 2.
    rightSize := rightSize - 1.
    ^ (self copyTo:leftSize),'...',(self copyFrom:(sz+1-rightSize))

    "
     '12345678901234' contractTo:15
     '123456789012345' contractTo:15
     '1234567890123456' contractTo:15
     '12345678901234567' contractTo:15
     '123456789012345678' contractTo:15
     'aShortString' contractTo:15
     'aVeryLongNameForAStringThatShouldBeShortened' contractTo:15
     'C:\Dokumente und Einstellungen\cg\work\bosch\dapas\hw_schnittstellen\DAPAS__HpibDLL.st' contractTo:40
     ('1234567890123456789012345678901234567' contractTo:30) size
     ('1234567890123456789012345678901234567' contractTo:29) size
    "

    "Modified (comment): / 24-11-2011 / 19:17:46 / cg"
!

copyReplaceAll:oldElement with:newElement
    "return a copy of the receiver as a string, where all elements equal to oldElement
     have been replaced by newElement."

    "/ ANSI seems to allow a sequence to be replaced by another sequence,
    "/ whereas the old ST80 meant replace all occurrences... - sigh.
    oldElement isByteCollection ifTrue:[
        newElement isByteCollection ifTrue:[
            ^ self copyReplaceString:oldElement withString:newElement.
        ].
        self halt:'check if this is legal'.
    ].
    newElement isByteCollection ifTrue:[
        self halt:'check if this is legal'.
    ].
    ^ super copyReplaceAll:oldElement with:newElement
!

copyReplaceString:subString withString:newString
    "return a copy of the receiver, with all sequences of subString replaced
     by newString (i.e. slice in the newString in place of the oldString)."

    |tmpStream idx idx1|

    tmpStream := self species writeStream.
    idx := 1.
    [idx ~~ 0] whileTrue:[
        idx1 := idx.
        idx := self indexOfSubCollection:subString startingAt:idx.
        idx ~~ 0 ifTrue:[
            tmpStream nextPutAll:(self copyFrom:idx1 to:idx-1).
            tmpStream nextPutAll:newString.
            idx := idx + subString size
        ]
    ].
    tmpStream nextPutAll:(self copyFrom:idx1).
    ^ tmpStream contents

   "
     '12345678901234567890' copyReplaceString:'123' withString:'OneTwoThree'
     '12345678901234567890' copyReplaceString:'123' withString:'*'
     '12345678901234567890' copyReplaceString:'234' withString:'foo'

     ('a string with spaces' copyReplaceAll:$  withAll:' foo ')
        copyReplaceString:'foo' withString:'bar'
    "

    "Modified: / 31-05-1999 / 12:33:59 / cg"
    "Created: / 12-05-2004 / 12:00:00 / cg"
!

copyWith:aCharacter
    "return a new string containing the receiver's characters
     and the single new character, aCharacter.
     This is different from concatentation, which expects another string
     as argument, but equivalent to copy-and-addLast.
     The code below cares for different width characters
     (i.e. when appending a 16bit char to an 8bit string)"

    |sz newString|

    aCharacter bitsPerCharacter > self bitsPerCharacter ifTrue:[
        sz := self size.
        newString := aCharacter stringSpecies new:sz + 1.
        newString replaceFrom:1 to:sz with:self startingAt:1.
        newString at:sz+1 put:aCharacter.
        ^ newString.
    ].
    ^ super copyWith:aCharacter
!

restAfter:keyword withoutSeparators:strip
    "compare the left of the receiver with keyword,
     if it matches return the right.
     Finally, if strip is true, remove whiteSpace.
     This method is used to match and extract lines of the form:
        something: rest
     where we are interested in rest, but only if the receiver string
     begins with something.

     You may wonder why such a specialized method exists here
     - this is so common when processing mailboxes,
     rcs files, nntp/pop3 responses, that is was considered worth
     a special method here to avoid having the code below a hundred
     times in variuos places."

    |rest|

    (self startsWith:keyword) ifTrue:[
        rest := self copyFrom:(keyword size + 1).
        strip ifTrue:[
            rest := rest withoutSeparators
        ].
        ^ rest
    ].
    ^ nil

    "
     'foo: hello world' restAfter:'foo:' withoutSeparators:true
     'funny: something' restAfter:'foo:' withoutSeparators:true

     'foo:     hello world    ' restAfter:'foo:' withoutSeparators:true
     'foo:     hello world    ' restAfter:'foo:' withoutSeparators:false
    "

    "Created: 25.11.1995 / 11:04:18 / cg"
!

splitAtString:subString withoutSeparators:strip
    "If the receiver is of the form:
        <left><subString><right>
     return a collection containing left and right only.
     If strip is true, remove whiteSpace in the returned substrings."

    |idx left right|

    (idx := self indexOfSubCollection:subString) ~~ 0 ifTrue:[
        left := self copyTo:(idx - 1).
        right := self copyFrom:(idx + subString size).
        strip ifTrue:[
            left := left withoutSeparators.
            right := right withoutSeparators.
        ].
        ^ StringCollection with:left with:right
    ].
    self error:'substring not present in receiver' mayProceed:true.
    ^ self

    "
     'hello -> world' splitAtString:'->' withoutSeparators:false
     'hello -> world' splitAtString:'->' withoutSeparators:true
     'hello -> ' splitAtString:'->' withoutSeparators:true
     'hello > error' splitAtString:'->' withoutSeparators:true
    "

    "Created: 25.11.1995 / 11:04:18 / cg"
! !

!CharacterArray methodsFor:'displaying'!

displayOn:aGC x:x y:y from:start to:stop
    "display the receiver on a GC"

    self displayOn:aGC x:x y:y from:start to:stop opaque:false

    "Modified: 12.5.1996 / 12:49:33 / cg"
!

displayOn:aGC x:x y:y from:start to:stop opaque:opaque
    "display the receiver on a GC"

    "q&d hack"

    (start == 1 and:[stop == self size]) ifTrue:[
        self displayOn:aGC x:x y:y opaque:opaque.
    ] ifFalse:[
        (self copyFrom:start to:stop) displayOn:aGC x:x y:y opaque:opaque.
    ].
!

displayOn:aGc x:x y:y opaque:opaque
    "display the receiver in a graphicsContext - this method allows
     strings to be used like DisplayObjects."

    |s|

    s := self string.
    opaque ifTrue:[
        aGc displayOpaqueString:s x:x y:y.
    ] ifFalse:[
        aGc displayString:s x:x y:y.
    ].

    "Modified: 11.5.1996 / 14:42:48 / cg"
!

displayOpaqueOn:aGC x:x y:y from:start to:stop
    "display the receiver on a GC"

    self displayOn:aGC x:x y:y from:start to:stop opaque:true
! !

!CharacterArray methodsFor:'emphasis'!

actionForAll:aBlock
    "change the action block of all characters.
     Some widgets use this like a href if clicked onto the text."

    ^ self asText actionForAll:aBlock
!

allBold
    "return a text object representing the receiver, but all boldified"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText allBold

    "
     Transcript showCR:'hello' asText allBold
     Transcript showCR:'hello' allBold
    "
!

allItalic
    "return a text object representing the receiver, but all in italic"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText allItalic

    "
     Transcript showCR:'hello' asText allItalic
     Transcript showCR:'hello' allItalic
    "
!

allStrikedOut
    "return a text object representing the receiver, but all in strikeout"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText allStrikedOut

    "
     Transcript showCR:'hello' asText allStrikedOut
     Transcript showCR:'hello' allStrikedOut
    "
!

allUnderlined
    "return a text object representing the receiver, but all with underline"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText allUnderlined

    "
     Transcript showCR:'hello' asText allUnderlined
     Transcript showCR:'hello' allUnderlined
    "
!

asActionLinkTo:aBlock
    "change the action block of all characters and colorize as a link.
     Some widgets use this like a href if clicked onto the text
     (for example, the system-browser's info at the bottom is such a widget)."

    "/ the blue may become a user-setting some time later..
    ^ (self actionForAll:aBlock) withColor:(Color blue)
!

colorizeAllWith:aColor
    "return a text object representing the receiver, but all colorized"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText colorizeAllWith:aColor

    "
     Transcript showCR:('hello' colorizeAllWith:Color red)
     Transcript showCR:('world' colorizeAllWith:Color green darkened)
    "
!

colorizeAllWith:fgColor on:bgColor
    "return a text object representing the receiver, but all colorized with
     both fg and background color"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText colorizeAllWith:fgColor on:bgColor

    "
     Transcript showCR:('hello' colorizeAllWith:Color red on:Color yellow)
     Transcript showCR:('world' colorizeAllWith:Color red)
    "
!

emphasis
    "return the emphasis.
     Since characterArrays do not hold any emphasis information,
     nil (no emphasis) is returned here."

    ^ RunArray new:self size withAll:nil

    "Created: 14.5.1996 / 13:58:58 / cg"
!

emphasis:emphasisCollection
    ^ self asText emphasis:emphasisCollection

    "
     Transcript showCR:('hello' emphasis:#(bold bold bold bold bold))
    "
!

emphasisAt:characterIndex
    "return the emphasis at some index.
     Since characterArrays do not hold any emphasis information,
     nil (no emphasis) is returned here."

    ^ nil

    "Created: 11.5.1996 / 14:13:27 / cg"
!

emphasisAtPoint:aPoint on:aGC
    "return the emphasis at a given point, or nil if there is none"

    ^ nil
!

emphasisCollection
    "return the emphasis.
     Since characterArrays do not hold any emphasis information,
     nil (no emphasis) is returned here."

    ^ RunArray new:(self size)

    "Created: 14.5.1996 / 13:58:58 / cg"
    "Modified: 14.5.1996 / 15:02:29 / cg"
!

emphasiseFrom:start to:stop with:newEmphasis
    "set to the emphasis within some range. return the receiver"

    ^ self asText emphasiseFrom:start to:stop with:newEmphasis

    "
     'hello' emphasiseFrom:2 with:#italic

     Transcript showCR:('hello' emphasiseFrom:2 with:#italic)
    "
!

emphasiseFrom:start with:newEmphasis
    "set to the emphasis within some range. return the receiver"

    ^ self emphasiseFrom:start to:(self size) with:newEmphasis

    "
     'hello' emphasiseFrom:2 with:#italic

     Transcript showCR:('hello' emphasiseFrom:2 with:#italic)
    "
!

emphasizeAllWith:emphasis
    "return a text object representing the receiver, but all emphasized"

    "this test allows for small non-gui apps to be built without libbasic2 (where Text is)"
    Text isNil ifTrue:[^ self].
    ^ self asText emphasizeAllWith:emphasis

    "
     Transcript showCR:('hello' emphasizeAllWith:#bold)
     Transcript showCR:('hello' emphasizeAllWith:(#color -> Color red))
     Transcript showCR:('hello' emphasizeAllWith:(#color -> Color red))
    "

    "Modified: / 17.6.1998 / 12:51:44 / cg"
!

makeSelectorBoldIn:aClass
    "the receiver represents some source code for a method in aClass.
     Change myself to boldify the selector.
     Not yet implemented (could easily use the syntaxHighlighter for this ...).
     For protocol compatibility with other smalltalks"

    ^ self

    "Created: / 13-12-1999 / 21:49:24 / cg"
!

withColor:aColorOrColorSymbol
    "return a text object representing the receiver, but all colorized.
     Usage of a colorSymbol is considered bad style (provided for backward compatibility);
     please change to pass a proper color 
     (makes it easier to find color uses)"

    |color|
    
    aColorOrColorSymbol isSymbol ifTrue:[
        color := (Color perform:aColorOrColorSymbol)
    ] ifFalse:[
        color := aColorOrColorSymbol
    ].    
    ^ self colorizeAllWith:color

    "
     Transcript showCR:('hello' withColor:#red)
     Transcript showCR:('world' withColor:#blue)
     Transcript showCR:('hello' withColor:Color red)
     Transcript showCR:('world' withColor:Color green darkened)
    "
!

withoutAnyColorEmphasis
    "for protocol compatibility with Text"

    ^ self

    "Created: / 06-03-2012 / 18:15:38 / cg"
!

withoutBackgroundColorEmphasis
    "for protocol compatibility with Text"

    ^ self

    "Modified (comment): / 06-03-2012 / 18:14:27 / cg"
!

withoutEmphasis:emphasisToRemove
    "for protocol compatibility with Text"

    ^ self

    "Modified (comment): / 06-03-2012 / 18:14:29 / cg"
!

withoutForegroundColorEmphasis
    "for protocol compatibility with Text"

    ^ self

    "Modified (comment): / 06-03-2012 / 18:14:31 / cg"
! !

!CharacterArray methodsFor:'encoding & decoding'!

asDenormalizedUnicodeString
    "return a new string containing the same characters, as a denormalized Unicode string.
     This replaces diacritical chars (umlauts, accented chars etc) by
     a sequence with combination characters.
     (i.e. a plain character followed by a combining diacritical in the 0x03xx range)"

    |map outStream mapChar|

    map := self class unicodeDenormalizationMap.
    
    self containsNon7BitAscii ifFalse:[^ self]. "/ I cannot contain any

    mapChar := 
        [:char |
            |mappedChars|

            (mappedChars := map at:char ifAbsent:nil) notNil ifTrue:[ 
                mappedChars do:mapChar.
            ] ifFalse:[
                outStream nextPut:char.        
            ].
        ].
        
    outStream := WriteStream on:(Unicode16String new:self size).
    self do:mapChar.        
    ^ outStream contents asSingleByteStringIfPossible.

    "
     'Ö' asDenormalizedUnicodeString 
     'aÖÄx' asDenormalizedUnicodeString 
     'abc' asDenormalizedUnicodeString 
     'ṩ'  asString asDenormalizedUnicodeString 
    "
!

asNormalizedUnicodeString
    "return a new string containing the same characters, as a normalized Unicode string.
     This replaces combination characters by corresponding single characters.
     (i.e. diaresis and other combining diacriticals in the 0x03xx range).
     Caveat: 
        possibly incomplete: only COMBINING_DIACRITICAL_MARKS are cared for.
        Does not care for COMBINING_DIACRITICAL_MARKS_EXTENDED
        and COMBINING_DIACRITICAL_MARKS_SUPPLEMENT.
        However; those are used for German dialectology, ancient Greek and other similar
        exotic uses. Probably noone will ever even notice that they are missing..."

    |outStream prevChar map mapEntries mappedChar|

    map := self class unicodeNormalizationMap.
     
    self bitsPerCharacter <= 8 ifTrue:[^ self]. "/ I cannot contain any overtypes
    (self contains:[:ch | ch unicodeBlock == #'COMBINING_DIACRITICAL_MARKS']) ifFalse:[^ self]. "/ I do not contain any overtypes 

    outStream := WriteStream on:(self species new:self size).
    self do:[:char |
        ((char unicodeBlock == #'COMBINING_DIACRITICAL_MARKS')
          and:[ (mapEntries := map at:char ifAbsent:nil) notNil
          and:[ (mappedChar := mapEntries at:prevChar ifAbsent:nil) notNil ]]) ifTrue:[ 
            prevChar := mappedChar.
        ] ifFalse:[
            prevChar notNil ifTrue:[ outStream nextPut:prevChar].        
            prevChar := char
        ].
    ].        
    prevChar notNil ifTrue:[ outStream nextPut:prevChar].        
    ^ outStream contents asSingleByteStringIfPossible.

    "
     self unicodeNormalizationMap
     ('O' , (Character value:16r0308)) asNormalizedUnicodeString -> 'Ö'
     ('O' , (Character value:16r0308) ,
      'A' , (Character value:16r0308)) asNormalizedUnicodeString -> 'ÖÄ'
     ('s' , (Character value:16r0323) , (Character value:16r0307)) asNormalizedUnicodeString -> 'ṩ'
     ('s' , (Character value:16r0307) , (Character value:16r0323)) asNormalizedUnicodeString -> 'ṩ'
    "
!

decodeAsLiteralArray
    "given a literalEncoding in the receiver,
     create & return the corresponding object.
     The inverse operation to #literalArrayEncoding."

    ^ self
!

decodeFrom:encodingSymbol
    "given the receiver encoded as described by encodingSymbol,
     convert it into internal ST/X (unicode) encoding and return a corresponding CharacterArray."

    |myEncoding encoder|

    encodingSymbol isNil ifTrue:[^ self].
    myEncoding := self encoding.
    encodingSymbol == myEncoding ifTrue:[^ self].

    encoder := CharacterEncoder encoderToEncodeFrom:(self encoding) into:encodingSymbol.
    encoder isNil ifTrue:[^ self].
    ^ encoder decodeString:self.
!

encodeFrom:oldEncoding into:newEncoding
    ^ CharacterEncoder encodeString:self from:oldEncoding into:newEncoding

    "
     'äüö' encodeFrom:#iso8859 into:#utf8
     ('äüö' encodeFrom:#iso8859 into:#utf8) encodeFrom:#utf8 into:#unicode
    "
!

rot13
     "Usenet: from `rotate alphabet 13 places']
      The simple Caesar-cypher encryption that replaces each English
      letter with the one 13 places forward or back along the alphabet,
      so that 'The butler did it!!' becomes 'Gur ohgyre qvq vg!!'
      Most Usenet news reading and posting programs include a rot13 feature.
      It is used to enclose the text in a sealed wrapper that the reader must choose
      to open -- e.g., for posting things that might offend some readers, or spoilers.
      A major advantage of rot13 over rot(N) for other N is that it
      is self-inverse, so the same code can be used for encoding and decoding."

    ^ self rot:13

    "
     'hello world' rot13
     'hello world' rot13 rot13
    "
!

rot:n
     "Usenet: from `rotate alphabet N places']
      The simple Caesar-cypher encryption that replaces each English
      letter with the one N places forward or back along the alphabet,
      so that 'The butler did it!!' becomes 'Gur ohgyre qvq vg!!' by rot 13
      Most Usenet news reading and posting programs include a rot13 feature.
      It is used to enclose the text in a sealed wrapper that the reader must choose
      to open -- e.g., for posting things that might offend some readers, or spoilers.
      A major advantage of rot13 over rot(N) for other N is that it
      is self-inverse, so the same code can be used for encoding and decoding."

    ^ self species
        streamContents:[:aStream |
            self do:[:char |
                aStream nextPut:(char rot:n) ]]

    "
     'hello world' rot:13
     ('hello world' rot:13) rot:13
    "
!

utf16Encoded
    "Return my UTF-16 representation as a new TwoByteString"

    |s|

    s := WriteStream on:(TwoByteString uninitializedNew:self size).
    s nextPutAllUtf16:self.
    ^ s contents

    "
     'abcde1234' utf16Encoded
     'abcdeäöüß' utf16Encoded
    "

    "Modified: / 11-05-2010 / 19:12:37 / cg"
!

utf8Encoded
    "return the UTF-8 representation of a Unicode string.
     The resulting string is only useful to be stored on some external file,
     or sent to a communaction channel.
     Not for being used inside ST/X."

    |string stream|

    string := self string.

    "/ avoid creation of new strings if possible
    string containsNon7BitAscii ifFalse:[
        ^ string asSingleByteString
    ].

    "make it size 2 for 1-byte strings"
    stream := WriteStream on:(String uninitializedNew:(1 + (string size * 3 // 2))).
    string utf8EncodedOn:stream.
    ^ stream contents.

    "
     'hello' utf8Encoded asByteArray                             #[104 101 108 108 111]
     (Character value:16r40) asString utf8Encoded asByteArray    #[64]
     (Character value:16r7F) asString utf8Encoded asByteArray    #[127]
     (Character value:16r80) asString utf8Encoded asByteArray    #[194 128]
     (Character value:16rFF) asString utf8Encoded asByteArray    #[195 191]
     (Character value:16r100) asString utf8Encoded asByteArray   #[196 128]
     (Character value:16r200) asString utf8Encoded asByteArray   #[200 128]
     (Character value:16r400) asString utf8Encoded asByteArray   #[208 128]
     (Character value:16r800) asString utf8Encoded asByteArray   #[224 160 128]
     (Character value:16r1000) asString utf8Encoded asByteArray  #[225 128 128]
     (Character value:16r2000) asString utf8Encoded asByteArray  #[226 128 128]
     (Character value:16r4000) asString utf8Encoded asByteArray  #[228 128 128]
     (Character value:16r8000) asString utf8Encoded asByteArray  #[232 128 128]
     (Character value:16rFFFF) asString utf8Encoded asByteArray  #[239 191 191]
     (Character value:16r1FFFF) asString utf8Encoded asByteArray #[240 159 191 191]
     (Character value:16r3FFFF) asString utf8Encoded asByteArray #[240 191 191 191]
     (Character value:16rFFFFF) asString utf8Encoded asByteArray #[243 191 191 191]
     (Character value:16r3FFFFF) asString utf8Encoded asByteArray #[248 143 191 191 191]

     'abcde1234' asUnicode32String utf8Encoded
     'abcdeäöüß' asUnicode32String utf8Encoded
    "
!

utf8EncodedOn:aStream
    "return the UTF-8 representation of a Unicode string.
     The resulting string is only useful to be stored on some external file,
     not for being used inside ST/X."

    |string 
     stringSize "{ Class: SmallInteger }"
     codePoint "{Class: SmallInteger }" 
     v "{Class: SmallInteger }"
     character b1 b2 b3 b4 b5|

    string := self string.

    "/ avoid creation of new strings if possible
    string containsNon7BitAscii ifFalse:[
        aStream nextPutAll:string asSingleByteString.
        ^ self.
    ].

    stringSize := string size.

    1 to:stringSize do:[:idx |
        character := string at:idx.
        codePoint := character codePoint.
        codePoint < 16r80 ifTrue:[
            aStream nextPutByte:codePoint.
        ] ifFalse:[
            b1 := (codePoint bitAnd:16r3F) bitOr:2r10000000.
            v := codePoint bitShift:-6.
            v <= 16r1F ifTrue:[
                aStream nextPutByte:(v bitOr:2r11000000).
                aStream nextPutByte:b1.
            ] ifFalse:[
                b2 := (v bitAnd:16r3F) bitOr:2r10000000.
                v := v bitShift:-6.
                v <= 16r0F ifTrue:[
                    aStream nextPutByte:(v bitOr:2r11100000).
                    aStream nextPutByte:b2; nextPutByte:b1.
                ] ifFalse:[
                    b3 := (v bitAnd:16r3F) bitOr:2r10000000.
                    v := v bitShift:-6.
                    v <= 16r07 ifTrue:[
                        aStream nextPutByte:(v bitOr:2r11110000).
                        aStream nextPutByte:b3; nextPutByte:b2; nextPutByte:b1.
                    ] ifFalse:[
                        b4 := (v bitAnd:16r3F) bitOr:2r10000000.
                        v := v bitShift:-6.
                        v <= 16r03 ifTrue:[
                            aStream nextPutByte:(v bitOr:2r11111000).
                            aStream nextPutByte:b4; nextPutByte:b3; nextPutByte:b2; nextPutByte:b1.
                        ] ifFalse:[
                            b5 := (v bitAnd:16r3F) bitOr:2r10000000.
                            v := v bitShift:-6.
                            v <= 16r01 ifTrue:[
                                aStream nextPutByte:(v bitOr:2r11111100).
                                aStream nextPutByte:b5; nextPutByte:b4; nextPutByte:b3; nextPutByte:b2; nextPutByte:b1.
                            ] ifFalse:[
                                "/ cannot happen - we only support up to 30 bit characters
                                EncodingError raiseWith:character errorString:'codePoint > 31bit in #utf8Encode'.
                            ]
                        ].
                    ].
                ].
            ].
        ].
    ].

    "
        String streamContents:[:s|
            'hallo' utf8EncodedOn:s
        ].

        ByteArray streamContents:[:s|
            'hallo' utf8EncodedOn:s
        ].

        String streamContents:[:s|
            'abcdeäöüß' asUnicode32String utf8EncodedOn:s
        ].
.
        ByteArray streamContents:[:s|
            'abcdeäöüß' asUnicode32String utf8EncodedOn:s
        ].

        '/tmp/bytes' asFilename writingFileDo:[:s|
            'abcdeäöüß' utf8EncodedOn:s
        ].
    "
! !




!CharacterArray methodsFor:'matching - glob expressions'!

compoundMatch:aString
    "like match, but the receiver may be a compound match pattern,
     consisting of multiple simple GLOB patterns, separated by semicolons.
     This is usable with fileName pattern fields.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self compoundMatch:aString caseSensitive:true withoutSeparators:false

    "
     'f*' match:'foo'
     'b*' match:'foo'
     'f*;b*' match:'foo'
     'f*;b*' match:'bar'
     'f*;b*' compoundMatch:'foo'
     'f*;b*' compoundMatch:'bar'
    "

    "Modified: / 30.1.1998 / 11:40:18 / stefan"
    "Modified: / 16.12.1999 / 01:22:08 / cg"
!

compoundMatch:aString caseSensitive:caseSensitive
    "like match, but the receiver may be a compound match pattern,
     consisting of multiple simple GLOB patterns, separated by semicolons.
     This is usable with fileName pattern fields.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^self compoundMatch:aString caseSensitive:caseSensitive withoutSeparators:false

    "
     'f*' match:'foo'
     'b*' match:'foo'
     'f*;b*' match:'foo'
     'f*;b*' match:'bar'
     'f*;b*' compoundMatch:'foo'
     'f*;b*' compoundMatch:'bar'
     'f*;b*' compoundMatch:'Foo' caseSensitive:false
     'f*;b*' compoundMatch:'Bar' caseSensitive:false
     'f*;b*' compoundMatch:'ccc' caseSensitive:false
    "

    "Modified: / 15.4.1997 / 15:50:33 / cg"
    "Modified: / 30.1.1998 / 11:40:18 / stefan"
    "Created: / 16.12.1999 / 01:21:35 / cg"
!

compoundMatch:aString caseSensitive:caseSensitive withoutSeparators:withoutSeparators
    "like match, but the receiver may be a compound match pattern,
     consisting of multiple simple GLOB patterns, separated by semicolons.
     If withoutSeparators is true, spaces around individual patterns are stripped off.
     This is usable with fileName pattern fields.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    |matchers|

    matchers := self asCollectionOfSubstringsSeparatedBy:$;.
    withoutSeparators ifTrue:[ matchers := matchers collect:[:each | each withoutSeparators] ].
    ^ matchers
        contains:[:aPattern |
            aPattern match:aString caseSensitive:caseSensitive escapeCharacter:nil
        ].

    "
     'f*' match:'foo'
     'b*' match:'foo'
     'f*;b*' match:'foo'
     'f*;b*' match:'bar'
     'f*;b*' compoundMatch:'foo'
     'f*;b*' compoundMatch:'bar'
     'f*;b*' compoundMatch:'Foo' caseSensitive:false
     'f*;b*' compoundMatch:'Bar' caseSensitive:false
     'f*;b*' compoundMatch:'ccc' caseSensitive:false

     'f* ; b*' compoundMatch:'foo'
     'f* ; b*' compoundMatch:'foo' caseSensitive:true withoutSeparators:true
    "

    "Modified: / 15.4.1997 / 15:50:33 / cg"
    "Modified: / 30.1.1998 / 11:40:18 / stefan"
    "Created: / 16.12.1999 / 01:21:35 / cg"
!

compoundMatch:aString ignoreCase:ignoreCase
    <resource: #obsolete>

    "like match, but the receiver may be a compound match pattern,
     consisting of multiple simple GLOB patterns, separated by semicolons.
     This is usable with fileName pattern fields.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self compoundMatch:aString caseSensitive:ignoreCase not

    "
     'f*' match:'foo'
     'b*' match:'foo'
     'f*;b*' match:'foo'
     'f*;b*' match:'bar'
     'f*;b*' compoundMatch:'foo'
     'f*;b*' compoundMatch:'bar'
     'f*;b*' compoundMatch:'Foo' ignoreCase:true
     'f*;b*' compoundMatch:'Bar' ignoreCase:true
     'f*;b*' compoundMatch:'ccc' ignoreCase:true
    "

    "Modified: / 15.4.1997 / 15:50:33 / cg"
    "Modified: / 30.1.1998 / 11:40:18 / stefan"
    "Created: / 16.12.1999 / 01:21:35 / cg"
!

findMatchString:matchString
    "like findString/indexOfSubCollection, but allowing GLOB match patterns.
     find matchstring; if found, return the index;
     if not found, return 0.

     NOTICE: match-meta character interpretation is like in unix-matching,
             NOT the ST-80 meaning.
     NOTICE: this GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the argument is the match pattern"

    ^ self findMatchString:matchString startingAt:1 caseSensitive:true ifAbsent:0

    "
      1234567890123
     'hello world bla foo baz' findMatchString:'b* '
    "
!

findMatchString:matchString startingAt:index
    "like findString, but allowing GLOB match patterns.
     find matchstring, starting at index. if found, return the index;
     if not found, return 0.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the argument is the match pattern"

    ^ self findMatchString:matchString startingAt:index caseSensitive:true ifAbsent:0
!

findMatchString:matchString startingAt:index caseSensitive:caseSensitive ifAbsent:exceptionBlock
    "like findString, but allowing GLOB match patterns.
     find matchstring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the argument is the match pattern"

    |firstChar firstSet
     startIndex "{ Class: SmallInteger }"
     matchSize  "{ Class: SmallInteger }"
     mySize     "{ Class: SmallInteger }"
     realMatchString lcChar ucChar|

    matchSize := matchString size.
    matchSize == 0 ifTrue:[^ index]. "empty string matches"

    realMatchString := matchString.
    (realMatchString endsWith:$*) ifFalse:[
        realMatchString := realMatchString , '*'.
        matchSize := matchSize + 1
    ].

    mySize := self size.
    firstChar := realMatchString at:1.
    firstChar == self class matchEscapeCharacter ifTrue:[
        firstChar := realMatchString at:2.
    ].

    firstChar asString includesMatchCharacters ifTrue:[
        index to:mySize do:[:col |
            (realMatchString match:self from:col to:mySize caseSensitive:caseSensitive)
            ifTrue:[^ col]
        ].
        ^ exceptionBlock value.
    ].

    lcChar := firstChar asLowercase.
    ucChar := firstChar asUppercase.
    (caseSensitive not and:[ lcChar ~= ucChar ]) ifTrue:[
        firstSet := Array with:ucChar with:lcChar.
        startIndex := self indexOfAny:firstSet startingAt:index.
    ] ifFalse:[
        startIndex := self indexOf:firstChar startingAt:index.
    ].
    [startIndex == 0] whileFalse:[
        (realMatchString match:self from:startIndex to:mySize caseSensitive:caseSensitive)
        ifTrue:[^ startIndex].

        firstSet notNil ifTrue:[
            startIndex := self indexOfAny:firstSet startingAt:(startIndex + 1).
        ] ifFalse:[
            startIndex := self indexOf:firstChar startingAt:(startIndex + 1).
        ].
    ].
    ^ exceptionBlock value

    "
     'one two three four' findMatchString:'o[nu]'
     'one two three four' findMatchString:'o[nu]' startingAt:3
     'one two three four one' findMatchString:'ONE' startingAt:3 caseSensitive:false ifAbsent:0
     'one two three four one' findMatchString:'ONE' startingAt:3 caseSensitive:true ifAbsent:0
     'one two three four ONE' findMatchString:'O#E' startingAt:1 caseSensitive:false ifAbsent:0
     'one two three four ONE' findMatchString:'O#E' startingAt:1 caseSensitive:true ifAbsent:0
      12345678901234567890
    "

    "Modified: 13.9.1997 / 06:31:22 / cg"
!

findMatchString:matchString startingAt:index ignoreCase:ignoreCase ifAbsent:exceptionBlock
    <resource: #obsolete>
    "like findString, but allowing GLOB match patterns.
     find matchstring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the argument is the match pattern"

    ^ self
        findMatchString:matchString startingAt:index caseSensitive:ignoreCase not ifAbsent:exceptionBlock

    "
     'one two three four' findMatchString:'o[nu]'
     'one two three four' findMatchString:'o[nu]' startingAt:3
     'one two three four one' findMatchString:'ONE' startingAt:3 ignoreCase:true ifAbsent:0
    "

    "Modified: 13.9.1997 / 06:31:22 / cg"
!

globPatternAsRegexPattern
    "taking the receiver as a GLOB pattern,
     return a corresponding regex pattern.
     As regex does provide information about the matching substring,
     it may be useful to apply a regex after a GLOB match,
     in order to highlight matching substrings (eg. in a CodeView after a search).
     If it turns out to be better, we may convert all GLOB searches to regex and use it right away.
     (currently, it is not sure, if GLOB is not better for most simple searches, as they are encountered
      in typical real life)"

    ^ self species streamContents:[:s |
        |addCharacter|

        addCharacter :=
            [:ch |
                ch isLetterOrDigit ifFalse:[
                    s nextPut:$\.
                ].
                s nextPut:ch
            ].

        (String matchScanArrayFrom:self) do:[:matchEntry |
            matchEntry isCharacter ifTrue:[
                addCharacter value:matchEntry
            ] ifFalse:[
                matchEntry == #anyString ifTrue:[
                    s nextPutAll:'.*'
                ] ifFalse:[
                    matchEntry == #any ifTrue:[
                        s nextPut:$.
                    ] ifFalse:[
                        matchEntry isString ifTrue:[
                            |set min max|

                            s nextPut:$[.
                            set := matchEntry copy sort.
                            min := set min.
                            max := set max.
                            set asSet = (min to:max) asSet ifTrue:[
                                addCharacter value:min.
                                s nextPut:$-.
                                addCharacter value:max.
                            ] ifFalse:[
                                set do:addCharacter.
                            ].
                            s nextPut:$].
                        ] ifFalse:[
                            self halt.
                        ].
                    ].
                ].
            ]
        ].
    ].

    "
     'hello' globPatternAsRegexPattern
     'hello*' globPatternAsRegexPattern
     '*hello*' globPatternAsRegexPattern
     'h###' globPatternAsRegexPattern
     'h[0-9]' globPatternAsRegexPattern
     'h[0-9][0-9][0-9]' globPatternAsRegexPattern
     'h[0-9]*' globPatternAsRegexPattern
     'h[-+]*' globPatternAsRegexPattern

     'hello world' matches:'h*w'
     'hello world' matchesRegex:('h*w' globPatternAsRegexPattern)
     'hello world' matches:'h*d'
     'hello world' matchesRegex:('h*d' globPatternAsRegexPattern)
    "
!

includesMatchString:matchString
    "like includesString, but allowing GLOB match patterns.
     find matchstring; if found, return true, otherwise return false.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the argument is the match pattern"

    ^ (self findMatchString:matchString) ~~ 0

    "
     'hello world' includesMatchString:'h*'
     'hello world' includesMatchString:'h[aeiou]llo'
     'hello world' includesMatchString:'wor*'
     'hello world' includesMatchString:'woR*'
    "
!

includesMatchString:matchString caseSensitive:caseSensitive
    "like includesString, but allowing GLOB match patterns.
     find matchstring; if found, return true, otherwise return false.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the argument is the match pattern"

    ^ (self findMatchString:matchString startingAt:1 caseSensitive:caseSensitive ifAbsent:0) ~~ 0

    "
     'hello world' includesMatchString:'h*' caseSensitive:true
     'hello world' includesMatchString:'h*' caseSensitive:false
     'Hello world' includesMatchString:'h*' caseSensitive:true
     'Hello world' includesMatchString:'h*' caseSensitive:false

     'hello world' includesMatchString:'h[aeiou]llo' caseSensitive:true
     'hello world' includesMatchString:'h[aeiou]llo' caseSensitive:false

     'hello world' includesMatchString:'wor*' caseSensitive:true
     'hello world' includesMatchString:'wor*' caseSensitive:false

     'hello world' includesMatchString:'woR*' caseSensitive:true
     'hello world' includesMatchString:'woR*' caseSensitive:false
    "
!

match:aString
    "return true if aString matches self, where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character).
     or [...] to match a set of characters.
     Lower/uppercase are considered different.
     The escape character is the backQuote.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self match:aString from:1 to:aString size caseSensitive:true

    "
     '\*f*' match:'f'
     '\*f*' match:'*f'
     '*\*f*' match:'*f'
     '*f*' match:'*f'
     '*ute*' match:'computer'
     '*uter' match:'computer'
     'uter*' match:'computer'
     '*ute*' match:''
     '[abcd]*' match:'computer'
     '[abcd]*' match:'komputer'
     '*some*compl*ern*' match:'this is some more complicated pattern match'
     '*some*compl*ern*' match:'this is another complicated pattern match'
     '*-hh' match:'anton-h'
    "

    "Modified: / 9.6.1998 / 18:50:00 / cg"
!

match:aString caseSensitive:caseSensitive
    "return true if aString matches self, where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If caseSensitive is false, lower/uppercase are considered the same.
     The escape character is the backQuote.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self match:aString from:1 to:aString size caseSensitive:caseSensitive

    "
     '*ute*' match:'COMPUTER' caseSensitive:false
     '*uter' match:'COMPUTER' caseSensitive:true
     '[abcd]*' match:'computer' caseSensitive:true
     '[abcd]*' match:'Computer' caseSensitive:true
     '[a-k]*' match:'komputer' caseSensitive:true
     '[a-k]*' match:'zomputer' caseSensitive:true
     '[a-k]*' match:'Komputer' caseSensitive:true
     '[a-k]*' match:'Komputer' caseSensitive:false
     '*some*compl*ern*' match:'this is some more complicated pattern match' caseSensitive:false
     '*some*compl*ern*' match:'this is another complicated pattern match' caseSensitive:false

     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '[ab]*' match:sym caseSensitive:true
        ]
     ].
     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '*at:*' match:sym caseSensitive:true
        ]
     ].
    "

    "Modified: 2.4.1997 / 17:28:58 / cg"
!

match:aString caseSensitive:caseSensitive escapeCharacter:escape
    "return true if aString matches self, where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If caseSensitive is false, lower/uppercase are considered the same.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self match:aString from:1 to:aString size caseSensitive:caseSensitive escapeCharacter:escape

    "
     '*ute*' match:'COMPUTER' caseSensitive:false
     '*uter' match:'COMPUTER' caseSensitive:true
     '[abcd]*' match:'computer' caseSensitive:true
     '[abcd]*' match:'Computer' caseSensitive:true
     '[a-k]*' match:'komputer' caseSensitive:true
     '[a-k]*' match:'zomputer' caseSensitive:true
     '[a-k]*' match:'Komputer' caseSensitive:true
     '[a-k]*' match:'Komputer' caseSensitive:false
     '*some*compl*ern*' match:'this is some more complicated pattern match' caseSensitive:false
     '*some*compl*ern*' match:'this is another complicated pattern match' caseSensitive:false

     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '[ab]*' match:sym caseSensitive:true
        ]
     ].
     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '*at:*' match:sym caseSensitive:true
        ]
     ].
    "

    "Modified: 2.4.1997 / 17:28:58 / cg"
!

match:aString escapeCharacter:escape
    "return true if aString matches self, where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character).
     or [...] to match a set of characters.
     Lower/uppercase are considered different.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self match:aString from:1 to:aString size caseSensitive:true escapeCharacter:escape

    "
     'a\b\c\*' match:'a\b\c\d'
     'a\b\c\*' match:'a\b\c\d' escapeCharacter:nil
    "
!

match:aString from:start to:stop caseSensitive:caseSensitive
    "return true if part of aString matches myself,
     where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If caseSensitive is false, lower/uppercase are considered the same.
     The escape character is the backQuote.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self
        match:aString from:start to:stop caseSensitive:caseSensitive
        escapeCharacter:(self class matchEscapeCharacter)

    "
     '*ute*' match:'12345COMPUTER' from:1 to:5 caseSensitive:false
     '*ute*' match:'12345COMPUTER' from:6 to:13 caseSensitive:false
    "

    "Modified: / 10.11.1998 / 21:43:46 / cg"
!

match:aString from:start to:stop caseSensitive:caseSensitive escapeCharacter:escape
    "return true if part of aString matches myself,
     where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If caseSensitive is false, lower/uppercase are considered the same.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    |matchScanArray|

    "
     keep the matchScanArray from the most recent match -
     avoids parsing the pattern over-and over if multiple searches
     are done with the same pattern.
    "

    (PreviousMatches isNil
    or:[(matchScanArray := PreviousMatches at: self ifAbsent:[nil]) isNil]) ifTrue:[
        matchScanArray := self class matchScanArrayFrom:self escapeCharacter:escape.
        matchScanArray isNil ifTrue:[
            'CharacterArray [info]: invalid matchpattern:''' infoPrint. self infoPrint. ''' comparing for equality.' infoPrintCR.
            ^ self = aString
"/            ^ false
        ].
        PreviousMatches isNil ifTrue:[
            PreviousMatches := CacheDictionary new:10
        ].
        PreviousMatches at:self put:matchScanArray.
    ].

    ^ self class
        matchScan:matchScanArray
        from:1 to:matchScanArray size
        with:aString
        from:start to:stop
        caseSensitive:caseSensitive

    "
     '*ute*' match:'12345COMPUTER' from:1 to:5 caseSensitive:false
     '*ute*' match:'12345COMPUTER' from:6 to:13 caseSensitive:false
    "

    "Modified: / 10.11.1998 / 21:43:46 / cg"
!

match:aString from:start to:stop ignoreCase:ignoreCase
    <resource: #obsolete>
    "return true if part of aString matches myself,
     where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If ignoreCase is true, lower/uppercase are considered the same.
     The escape character is the backQuote.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self
        match:aString from:start to:stop caseSensitive:ignoreCase not
        escapeCharacter:(self class matchEscapeCharacter)

    "
     '*ute*' match:'12345COMPUTER' from:1 to:5 ignoreCase:true
     '*ute*' match:'12345COMPUTER' from:6 to:13 ignoreCase:true
    "

    "Modified: / 10.11.1998 / 21:43:46 / cg"
!

match:aString from:start to:stop ignoreCase:ignoreCase escapeCharacter:escape
    <resource: #obsolete>
    "return true if part of aString matches myself,
     where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If ignoreCase is true, lower/uppercase are considered the same.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self
        match:aString from:start to:stop
        caseSensitive:ignoreCase not
        escapeCharacter:escape

    "
     '*ute*' match:'12345COMPUTER' from:1 to:5 ignoreCase:true
     '*ute*' match:'12345COMPUTER' from:6 to:13 ignoreCase:true
    "

    "Modified: / 10.11.1998 / 21:43:46 / cg"
!

match:aString ignoreCase:ignoreCase
    <resource: #obsolete>
    "return true if aString matches self, where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If ignoreCase is true, lower/uppercase are considered the same.
     The escape character is the backQuote.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    "/ leave it this way, in case a customer has redefined it for performance (for a while)
    ^ self match:aString from:1 to:aString size caseSensitive:ignoreCase not

    "
     '*ute*' match:'COMPUTER' ignoreCase:true
     '*uter' match:'COMPUTER' ignoreCase:false
     '[abcd]*' match:'computer' ignoreCase:false
     '[abcd]*' match:'Computer' ignoreCase:false
     '[a-k]*' match:'komputer' ignoreCase:false
     '[a-k]*' match:'zomputer' ignoreCase:false
     '[a-k]*' match:'Komputer' ignoreCase:false
     '[a-k]*' match:'Komputer' ignoreCase:true
     '*some*compl*ern*' match:'this is some more complicated pattern match' ignoreCase:true
     '*some*compl*ern*' match:'this is another complicated pattern match' ignoreCase:true

     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '[ab]*' match:sym ignoreCase:false
        ]
     ].
     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '*at:*' match:sym ignoreCase:false
        ]
     ].
    "

    "Modified: 2.4.1997 / 17:28:58 / cg"
!

match:aString ignoreCase:ignoreCase escapeCharacter:escape
    <resource: #obsolete>
    "return true if aString matches self, where self may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character)
     or [...] to match a set of characters.
     If ignoreCase is true, lower/uppercase are considered the same.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ self match:aString from:1 to:aString size caseSensitive:ignoreCase not escapeCharacter:escape

    "
     '*ute*' match:'COMPUTER' ignoreCase:true
     '*uter' match:'COMPUTER' ignoreCase:false
     '[abcd]*' match:'computer' ignoreCase:false
     '[abcd]*' match:'Computer' ignoreCase:false
     '[a-k]*' match:'komputer' ignoreCase:false
     '[a-k]*' match:'zomputer' ignoreCase:false
     '[a-k]*' match:'Komputer' ignoreCase:false
     '[a-k]*' match:'Komputer' ignoreCase:true
     '*some*compl*ern*' match:'this is some more complicated pattern match' ignoreCase:true
     '*some*compl*ern*' match:'this is another complicated pattern match' ignoreCase:true

     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '[ab]*' match:sym ignoreCase:false
        ]
     ].
     Time millisecondsToRun:[
        Symbol allInstancesDo:[:sym |
            '*at:*' match:sym ignoreCase:false
        ]
     ].
    "

    "Modified: 2.4.1997 / 17:28:58 / cg"
!

matches:aPatternString
    "return true if the receiver matches aString, where aPatternString may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character).
     or [...] to match a set of characters.
     Lower/uppercase are considered different.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ aPatternString match:self
!

matches:aPatternString caseSensitive:caseSensitive
    "return true if the receiver matches aString, where aPatternString may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character).
     or [...] to match a set of characters.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ aPatternString match:self caseSensitive:caseSensitive
!

matches:aPatternString ignoreCase:ignoreCase
    <resource: #obsolete>
    "return true if the receiver matches aString, where aPatternString may contain GLOB meta-match
     characters $* (to match any string) or $# (to match any character).
     or [...] to match a set of characters.
     Lower/uppercase are considered different.

     NOTICE: match-meta character interpretation is like in unix-matching (glob),
             NOT the ST-80 meaning.
     NOTICE: this is GLOB, which is different from regex matching (see matchesRegex:)
     NOTICE: the receiver is the match pattern"

    ^ aPatternString match:self caseSensitive:ignoreCase not

    "Created: / 08-03-2012 / 03:11:11 / cg"
! !


!CharacterArray methodsFor:'matching - regex'!

matchesRegex:regexString caseSensitive:aBoolean
    "Test if the receiver matches a regex.
     May raise RxParser>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
        (c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    aBoolean ifFalse:[
        ^ self matchesRegexIgnoringCase:regexString
    ] ifTrue:[
        ^ self matchesRegex:regexString
    ].

    "
     'hello world' matchesRegex:'h.*d'.
    "

    "Created: / 13-12-2010 / 11:01:49 / cg"
! !

!CharacterArray methodsFor:'padded copying'!

centerPaddedTo:newSize
     "return a new string consisting of the receiver's characters,
      plus spaces up to length and center the receiver's characters in
      the resulting string.
      If the receiver's size is equal or greater than the length argument,
      the original receiver is returned unchanged."

     ^ self centerPaddedTo:newSize with:(Character space)

    "
     'foo' centerPaddedTo:10
     123 printString centerPaddedTo:10
    "

    "Created: 25.11.1995 / 10:53:57 / cg"
!

centerPaddedTo:size with:padCharacter
    "return a new string of length size, which contains the receiver
     centered (i.e. padded on both sides).
     Characters are filled with padCharacter.
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged."

    |len s|

    len := self size.
    (len < size) ifTrue:[
        s := self species new:size withAll:padCharacter.
        s replaceFrom:(size - len) // 2  + 1 with:self.
        ^ s
    ]

    "
     'foo' centerPaddedTo:11 with:$.
     'fooBar' centerPaddedTo:5 with:$.
     123 printString centerPaddedTo:10 with:$.
     (' ' , 123 printString) centerPaddedTo:10 with:$.
     (Float pi printString) centerPaddedTo:15 with:(Character space)
     (Float pi printString) centerPaddedTo:15 with:$-
     (' ' , Float pi class name) centerPaddedTo:15 with:$.
    "
!

decimalPaddedTo:size and:afterPeriod at:decimalCharacter
    "return a new string of overall length size, which contains the receiver
     aligned at the decimal-period column and afterPeriod characters to the right
     of the period. The periodCharacter is passed as arguments (allowing for US and European formats
     to be padded).
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged.
     (sounds complicated ? -> see examples below)."

    ^ self
        decimalPaddedTo:size
        and:afterPeriod
        at:decimalCharacter
        withLeft:(Character space)
        right:$0

    "
     '123' decimalPaddedTo:10 and:3 at:$.      -> '   123    '
     '123' decimalPaddedTo:10 and:3 at:$.      -> '   123.000'
     '123.' decimalPaddedTo:10 and:3 at:$.     -> '   123.000'
     '123.1' decimalPaddedTo:10 and:3 at:$.    -> '   123.100'
     '123.1' decimalPaddedTo:10 and:3 at:$.    -> '   123.1  '
     '123.123' decimalPaddedTo:10 and:3 at:$.  -> '   123.123'
    "

    "Created: 23.12.1995 / 13:11:52 / cg"
!

decimalPaddedTo:size and:afterPeriod at:decimalCharacter withLeft:leftPadChar right:rightPadChar
    "return a new string of overall length size, which contains the receiver
     aligned at the decimal-period column and afterPeriod characters to the right
     of the period.
     Characters on the left are filled with leftPadChar.
     If rightPadChar is nil, characters on the right are filled with leftPadCharacter too;
     otherwise, if missing, a decimal point is added and right characters filled with this.
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged.
     (sounds complicated ? -> see examples below)."

    |s idx n rest|

    idx := self indexOf:decimalCharacter.
    idx == 0 ifTrue:[
        "/
        "/ no decimal point found; adjust string to the left of the period column
        "/
        rightPadChar isNil ifTrue:[
            s := self , (self species new:afterPeriod + 1 withAll:leftPadChar)
        ] ifFalse:[
            s:= self , decimalCharacter asString , (self species new:afterPeriod withAll:rightPadChar).
        ].
    ] ifFalse:[

        "/ the number of after-decimalPoint characters
        n := self size - idx.
        rest := afterPeriod - n.
        rest > 0 ifTrue:[
            s := (self species new:rest withAll:(rightPadChar ? leftPadChar)).
        ] ifFalse:[
            s := ''
        ].
        s := self , s.
    ].

    ^ s leftPaddedTo:size with:leftPadChar

    "
     '123' decimalPaddedTo:10 and:3 at:$. withLeft:(Character space) right:nil     -> '   123    '
     '123' decimalPaddedTo:10 and:3 at:$. withLeft:(Character space) right:$0      -> '   123.000'
     '123.' decimalPaddedTo:10 and:3 at:$. withLeft:(Character space) right:$0     -> '   123.000'
     '123.1' decimalPaddedTo:10 and:3 at:$. withLeft:(Character space) right:$0    -> '   123.100'
     '123.1' decimalPaddedTo:10 and:3 at:$. withLeft:(Character space) right:nil   -> '   123.1  '
     '123.123' decimalPaddedTo:10 and:3 at:$. withLeft:(Character space) right:$0  -> '   123.123'
    "

    "Modified: 23.12.1995 / 13:08:18 / cg"
!

leftPaddedTo:size
    "return a new string of length size, which contains the receiver
     right-adjusted (i.e. padded on the left).
     Characters on the left are filled with spaces.
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged."

    ^ self leftPaddedTo:size with:(Character space)

    "
     'foo' leftPaddedTo:10
     'fooBar' leftPaddedTo:5
     123 printString leftPaddedTo:10
    "
!

paddedTo:newSize
     "return a new string consisting of the receiver's characters,
     plus spaces up to length.
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged."

     ^ self paddedTo:newSize with:(Character space)

    "
     'foo' paddedTo:10
     123 printString paddedTo:10
     '12345678901234' paddedTo:10
    "
! !

!CharacterArray methodsFor:'printing & storing'!

article
    "return an article string for the receiver.
     The original code only looked at the first character being a vowel;
     this has been enhanced by some heuristics - not perfect, still."

    |firstChar secondChar thirdChar|

    firstChar := (self at:1) asLowercase.
    ((firstChar isVowel and:[firstChar ~~ $u]) or:[firstChar == $x]) ifTrue:[
        ^ 'an'
    ].

    (self size >= 3) ifTrue:[
        secondChar := (self at:2) asLowercase.

        "/ may need more here...
        ( #('rb') includes:(String with:firstChar with:secondChar)) ifTrue:[
            ^ 'an'
        ].

        thirdChar := (self at:3) asLowercase.

        (firstChar isVowel not
        and:[(secondChar isVowel or:[secondChar == $y]) not
        and:[thirdChar isVowel not ]]) ifTrue:[
            "/ exceptions: 3 non-vowels in a row: looks like an abbreviation
            (self size > 4) ifTrue:[
                (firstChar == $s) ifTrue:[
                    ((secondChar == $c and:[thirdChar == $r])
                    or:[ (secondChar == $t and:[thirdChar == $r]) ]) ifTrue:[
                        (self at:4) isVowel ifTrue:[
                            ^ 'a'
                        ]
                    ]
                ].
            ].
            "/ an abbreviation; treat x, s as vowels
            (firstChar == $x or:[ firstChar == $s ]) ifTrue:[^ 'an'].
        ]
    ].
    ^ 'a'

    "
        'uboot' article.
        'xmas' article.
        'alarm' article.
        'baby' article.
        'sql' article.
        'scr' article.
        'screen' article.
        'scrollbar' article.
        'scrs' article.
        'cvs' article.
        'cvssource' article.
        'symbol' article.
        'string' article.
        'rbparser' article.
    "

    "Modified (comment): / 01-05-2016 / 10:57:25 / cg"
!

basicStoreString
    "return a String for storing myself"

    |s n index|

    n := self occurrencesOf:$'.
    n ~~ 0 ifTrue:[
        s := self species new:(n + 2 + self size).
        s at:1 put:$'.
        index := 2.
        self do:[:thisChar |
            (thisChar == $') ifTrue:[
                s at:index put:thisChar.
                index := index + 1.
            ].
            s at:index put:thisChar.
            index := index + 1.
        ].
        s at:index put:$'.
        ^ s
    ].

    ^ '''' , self , ''''

    "
     '''immutable'' string' asImmutableString basicStoreString
     'immutable string' asImmutableString basicStoreString
    "

    "Modified: / 14-07-2013 / 19:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        self storeOn:aGCOrStream.
        ^ self
    ].
    ^ super displayOn:aGCOrStream
!

printOn:aStream
    "print the receiver on aStream"

    aStream nextPutAll:self
!

printString
    "return a string for printing - that's myself"

    ^ self
!

printWithQuotesDoubledOn:aStream
    "put the raw storeString of myself on aStream"

    self do:[:thisChar |
        (thisChar == $') ifTrue:[aStream nextPut:thisChar].
        aStream nextPut:thisChar
    ]

    "Modified: / 15.6.1998 / 17:21:17 / cg"
    "Created: / 15.6.1998 / 17:22:13 / cg"
!

printXmlQuotedOn:aStream
    "convert aString to a valid XML string
     that can be used for attributes, text, comments an PIs
     TODO: care for 16bit UNICODE string and escape chars ..."

    self do:[:eachChar |
        eachChar == $< ifTrue:[
            aStream nextPutAll:'&lt;'     "mapping needed for xml text"
        ] ifFalse:[ eachChar == $& ifTrue:[
            aStream nextPutAll:'&amp;'    "mapping needed for all"
        ] ifFalse:[ eachChar == $> ifTrue:[
            aStream nextPutAll:'&gt;'     "mapping needed for comments"
        ] ifFalse:[ eachChar == $' ifTrue:[
            aStream nextPutAll:'&apos;'   "mapping needed for attributes"
        ] ifFalse:[ eachChar == $" ifTrue:[
            aStream nextPutAll:'&quot;'   "mapping needed for attributes"
        ] ifFalse:[
            |codePoint|
            codePoint := eachChar codePoint.
            (codePoint < 16r20 or:[codePoint >= 16r7F]) ifTrue:[
                aStream nextPutAll:'&#'.
                codePoint printOn:aStream.
                aStream nextPut:$;.
        ] ifFalse:[
            aStream nextPut:eachChar
        ]]]]]]
    ].
!

printXmlTextQuotedOn:aStream
    "convert aString to a valid XML string
     that can be used for XML text.
     Here line formatting characters are not escaped.
     TODO: care for 16bit UNICODE string and escape chars ..."

    self do:[:eachChar |
        eachChar == $< ifTrue:[
            aStream nextPutAll:'&lt;'     "mapping needed for xml text"
        ] ifFalse:[ eachChar == $& ifTrue:[
            aStream nextPutAll:'&amp;'    "mapping needed for all"
"/        ] ifFalse:[ eachChar == $> ifTrue:[
"/            aStream nextPutAll:'&gt;'     "mapping needed for comments"
"/        ] ifFalse:[ eachChar == $' ifTrue:[
"/            aStream nextPutAll:'&apos;'   "mapping needed for attributes"
"/        ] ifFalse:[ eachChar == $" ifTrue:[
"/            aStream nextPutAll:'&quot;'   "mapping needed for attributes"
        ] ifFalse:[
            |codePoint|
            codePoint := eachChar codePoint.
            ((codePoint < 16r20 and:[codePoint ~~ 9 and:[codePoint ~~ 10 and:[codePoint ~~ 13]]])
             or:[codePoint >= 16r7F]) ifTrue:[
                aStream nextPutAll:'&#'.
                codePoint printOn:aStream.
                aStream nextPut:$;.
        ] ifFalse:[
            aStream nextPut:eachChar
        ]]]"/]]]
    ].
!

printfWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "Format and print the receiver with <argI> formatted in C style,
     as specified in the Unix C-language manual page for printf(3).
     Return the resulting string (i.e actually, this is more like an sprintf)."

    ^ self printf:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5)

    "
     Transcript showCR:('%d %05x %08o %b' printfWith:123 with:234 with:345 with:123)
    "
!

xmlQuotedPrintString
    "convert aString to a valid XML string
     that can be used for attributes, text, comments an PIs
     TODO: care for 16bit UNICODE string and escape chars ..."

    ^ String streamContents:[:s|
        self printXmlQuotedOn:s
    ].
! !


!CharacterArray methodsFor:'queries'!

bitsPerCharacter
    "return the underlying string's bitsPerCharacter
     (i.e. is it a regular String or a TwoByteString)"

    |string max|

    (string := self string) ~~ self ifTrue:[
        ^ string bitsPerCharacter
    ].

    max := 8.
    self do:[:eachCharacter |
        max := max max:(eachCharacter bitsPerCharacter)
    ].
    ^ max

    "
     'hello' bitsPerCharacter
     'hello' asText allBold bitsPerCharacter
    "
!

bytesPerCharacter
    "return the underlying string's required
     bytesPerCharacter
     (i.e. is it a regular String or a TwoByteString)"

    |string max|

    (string := self string) ~~ self ifTrue:[
        ^ string bytesPerCharacter
    ].

    max := 1.
    self do:[:eachCharacter |
        max := max max:(eachCharacter bytesPerCharacter)
    ].
    ^ max

    "
     'hello' bytesPerCharacter
     'hello' asUnicode16String bytesPerCharacter
     'hello' asText allBold bytesPerCharacter
    "
!

containsNon8BitElements
    "return true, if the underlying string contains elements larger than a single byte"

    |string sz "{ Class:SmallInteger }"|

    (string := self string) ~~ self ifTrue:[
        ^ string containsNon8BitElements
    ].
    sz := self size.
    1 to:sz do:[:idx|
        (self at:idx) codePoint > 16rFF ifTrue:[
            ^ true.
        ].
    ].
    ^ false.
!

continuesWith:aString startingAt:startIndex
    "return true, if the receiver beginning at startIndex
     contains the characters in aString."

    |sz  "{Class: SmallInteger }"
     idx "{Class: SmallInteger }"|

    sz := aString size.
    idx := startIndex.

    1 to:sz do:[:i |
        (self at:idx) ~~ (aString at:i) ifTrue:[^ false].
        idx := idx + 1
    ].
    ^ true

    "
     'hello world' continuesWith:'world' startingAt:6
     'hello world' continuesWith:'world' startingAt:7
    "

    "Created: 12.5.1996 / 15:46:40 / cg"
    "Modified: 26.7.1996 / 19:08:36 / cg"
!

countWords
    "return the number of words, which are separated by separators"

    |tally "{ Class: SmallInteger }"
     start "{ Class: SmallInteger }"
     mySize "{ Class: SmallInteger }"
     stop ch|

    tally := 0.
    start := 1.
    mySize := self size.
    [start <= mySize] whileTrue:[
        ch := self at:start.
        ch isSeparator ifTrue:[
            start := start + 1
        ] ifFalse:[
            stop := self indexOfSeparatorStartingAt:start.
            (stop == 0) ifTrue:[
                stop := mySize + 1
            ].
            tally := tally + 1.
            start := stop
        ]
    ].
    ^ tally

    "
     'hello world isnt this nice' countWords'
    "
!

defaultElement
    ^ Character space
!

encoding
    "return the strings encoding, as a symbol.
     Here, by default, we assume unicode-encoding.
     Notice, that ISO-8859-1 is a true subset of unicode,
     and that singleByteStrings are therefore both unicode AND
     8859-1 encoded."

    ^ #unicode
!

hasChangeOfEmphasis
    "return true, if the receiver contains non-empty emphasis information
     i.e. any non-normal (=emphasized) characters"

    ^ false

    "Created: 12.5.1996 / 12:31:39 / cg"
!

hasIcon
    "for LabelAndIcon compatibility"

    ^ false
!

hasImage
    "for LabelAndIcon compatibility"

    ^ false
!

heightOn:aGC
    "return the size of the receiver in device units if displayed on aGC"

    ^ aGC deviceFont heightOf:self      "font is already a device font"

    "
     'hello world' heightOn:(View new)
    "

    "Created: 12.5.1996 / 20:09:29 / cg"
    "Modified: 12.5.1996 / 20:32:05 / cg"
!

isLowercaseFirst
    "return true, if the first character is a lowercase character."

    ^ self size ~~ 0 and:[ self first isLowercase ]

    "
     'helloWorld' isLowercaseFirst
     'HelloWorld' isLowercaseFirst
    "
!

isUppercaseFirst
    "return true, if the first character is an uppercase character."

    ^ self size ~~ 0 and:[ self first isUppercase ]

    "
     'helloWorld' isUppercaseFirst
     'HelloWorld' isUppercaseFirst
    "
!

keywords
    "assuming the receiver is a keyword message selector,
     return the individual keywords (i.e. break it up at colons)
     and return these as a collection.
     For binary and unary selectors, the result may be nonsense (an array containing the receiver)."

    |coll s part|

    coll := OrderedCollection new.
    s := ReadStream on:self.
    [s atEnd] whileFalse:[
        part := s through:$:.
        coll add:part
    ].
    ^ coll asArray

    "
     #at:put: keywords
     #at: keywords
     #+ keywords
     #size keywords
    "

    "Modified (Comment): / 30-06-2011 / 17:46:21 / cg"
!

knownAsSymbol
    "for now, only single character strings are allowed as symbols.
     This method is redefined in String."

    ^ false
!

leftIndent
    "if the receiver starts with spaces, return the number of spaces
     at the left - otherwise, return 0.
     If the receiver consists of spaces only, return the receiver's size."

    |index "{Class: SmallInteger }"
     end   "{Class: SmallInteger }"|

    index := 1.
    end := self size.
    [index <= end] whileTrue:[
        (self at:index) isSeparator ifFalse:[^ index - 1].
        index := index + 1
    ].
    ^ end

    "
     '    hello' leftIndent
     'foo      ' leftIndent
     '         ' leftIndent
    "

    "Modified: 20.4.1996 / 19:28:43 / cg"
!

nameSpaceSelectorParts
    "Answer the namespace and baseSelector parts of a namespace selector.
     Namespace selectors are those generated by sends from a method in a different
     namespace; they are prefixed by ':'<ns>'::'.
     You cannot easily change this algorithm here, as it is also known by the VM's lookup function.
     Experimental"

    |nsPart selPart idx|

    (self at:1) == $: ifFalse:[^ Array with:'' with:self].
    idx := self indexOf:$: startingAt:3.
    idx == 0 ifTrue:[^ Array with:'' with:self].

    (idx+2 > self size) ifTrue:[^ Array with:'' with:self].
    (self at:idx+1) == $: ifFalse:[^ Array with:'' with:self].
    nsPart := self copyFrom:2 to:idx-1.
    selPart := self copyFrom:idx+2.
    ^ Array with:nsPart with:selPart

    "test:
     self assert:('+' nameSpaceSelectorParts) = #('' '+').
     self assert:(':+' nameSpaceSelectorParts) = #('' ':+').
     self assert:(':Foo:+' nameSpaceSelectorParts) = #('' ':Foo:+').

     self assert:(':Foo::+' nameSpaceSelectorParts) = #('Foo' '+').
     self assert:(':Foo::bar:baz:' nameSpaceSelectorParts) = #('Foo' 'bar:baz:').
    "

    "Created: / 05-03-2007 / 17:16:58 / cg"
    "Modified: / 06-03-2007 / 11:51:15 / cg"
!

speciesForSubcollection
    "answer the class, when splitting instances into subcollections"

    ^ StringCollection

    "Created: / 24-01-2017 / 18:54:18 / stefan"
!

stringSpecies
    "return the underlying strings bitsPerCharacter
     (i.e. is it a regular String or a TwoByteString)"

    |string|

    string := self string.
    string == self ifTrue:[^ self species].
    ^ string stringSpecies

    "
     'hello' stringSpecies
     'hello' asText allBold stringSpecies
    "
!

widthFrom:startIndex to:endIndex on:aGC
    "return ths size of part of the receiver in device units if displayed on aGC"

    ^ aGC deviceFont widthOf:self from:startIndex to:endIndex

    "
     'hello world' widthFrom:1 to:5 on:(View new)
     'hello' widthOn:(View new)
    "
!

widthOn:aGC
    "return ths size of the receiver in device units if displayed on aGC"

    ^ aGC deviceFont widthOf:self     "font is already a device font"

    "
     'hello world' widthOn:(View new)
    "

    "Created: 12.5.1996 / 20:09:29 / cg"
    "Modified: 17.4.1997 / 12:50:23 / cg"
! !


!CharacterArray methodsFor:'special string converting'!

asUnixFilenameString
    "return a new string consisting of receiver's characters
     with all \-characters replaced by /-characters.
     If there are no backslashes, return the original"

    ^ self copyReplaceAll:$\ with:$/ ifNone:self

    "
     'hello\world' asUnixFilenameString
    "

    "Modified: / 18.7.1998 / 22:53:02 / cg"
!

expandPlaceholders:escapeCharacter with:argArrayOrDictionary
    "this is the generic version of the old %-escaping method, allowing for an arbitrary
     escape character to be used (typically $$ or $% are effectively used).
     Return a copy of the receiver, where all %i escapes are
     replaced by corresponding arguments' printStrings from the argArrayOrDictionary.
     I.e. 'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this') results
     in the new string 'hello world; how is this'.
     As an extension, the argument may also be a dictionary, providing
     values for symbolic keys.
     In this case, %a .. %z and %(...) are also allowed.
     (%1..%9 require a numeric key in the dictionary, however)
     To get a '%' character, use a '%%'-escape.
     To get an integer-indexed placeHolder followed by another digit,
     or an index > 9, you must use %(digit).
     See also bindWith:... for VisualAge compatibility."

    |stream|

    stream := (TextStream ? CharacterWriteStream) on:(self species uninitializedNew:self size + 20).
    self expandPlaceholders:escapeCharacter with:argArrayOrDictionary on:stream.
    ^ stream contents.


    "
     'hello %1' expandPlaceholdersWith:#('world')
     'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this')
     'hello %2; how is %1' expandPlaceholdersWith:#('world' 'this')
     '%1 plus %2 gives %3 ' expandPlaceholdersWith:#(4 5 9)
     '%%(1)0 gives %(1)0' expandPlaceholdersWith:#(123)
     '%%10 gives %10' expandPlaceholdersWith:#(123)
     '%%(10) gives %(10)' expandPlaceholdersWith:#(123)
     '%test gives %1' expandPlaceholdersWith:#(123)
     'bla %1 bla' expandPlaceholdersWith:{ 'hello' allBold }
     'bla %1 bla' expandPlaceholdersWith:{ 'hello' }
    "

    "
     |dict|

     dict := Dictionary new.
     dict at:1 put:'one'.
     dict at:$a put:'AAAAA'.
     dict at:$b put:[ Time now ].
     dict at:'foo' put:[ Date today ].
     'hello $1 %a $b %(foo) $foo ' expandPlaceholders:$$ with:dict.
     'hello $1 %a $b %(foo) $foo ' expandPlaceholders:$% with:dict.
    "

    "Modified: 1.7.1997 / 00:53:24 / cg"
!

expandPlaceholders:escapeCharacter with:argArrayOrDictionary on:aStream
    "this is the generic version of the old %-escaping method, allowing for an arbitrary
     escape character to be used (typically $$ or $% are effectively used).

     Write the receiver to aStream, where all %i escapes are
     replaced by corresponding arguments' printStrings from the argArrayOrDictionary.
     I.e. 'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this') results
     in the new string 'hello world; how is this'.

     As an extension, the argument may also be a dictionary, providing values for symbolic keys.
     In this case, %a .. %z and %(...) are also allowed.
     (%1..%9 require a numeric key in the dictionary, however)
     Also, the values in argArrayOrDictionary may be blocks.

     To get a '%' character, use a '%%'-escape.
     To get an integer-indexed placeHolder followed by another digit,
     or an index > 9, you must use %(digit).

     See also bindWith:... for VisualAge compatibility.
     Use %<cr> to insert a CR and %<tab> to insert a TAB."

    |next v key
     idx   "{ SmallInteger }"
     idx2  "{ SmallInteger }"
     start "{ SmallInteger }"
     stop  "{ SmallInteger }"|

    stop := self size.
    start := 1.
    [start <= stop] whileTrue:[
        idx := self indexOf:escapeCharacter startingAt:start.
        (idx == 0 or:[idx == stop]) ifTrue:[
            aStream nextPutAll:self startingAt:start to:stop.
            ^ self.
        ].
        "found an escapeCharacter"
        aStream nextPutAll:self startingAt:start to:(idx - 1).
        next := self at:(idx + 1).
        (next == escapeCharacter) ifTrue:[
            aStream nextPut:escapeCharacter.
        ] ifFalse:[
            next == $< ifTrue:[
                idx2 := self indexOf:$> startingAt:idx+2.
                key := self copyFrom:idx+2 to:idx2-1.
                idx := idx2 - 1.
                key := key asSymbolIfInterned.
                (#(cr tab nl return lf ff null) includesIdentical:key) ifTrue:[
                    aStream nextPut:(Character perform:key).
                ].
            ] ifFalse:[
                next isDigit ifTrue:[
                    v := argArrayOrDictionary at:(next digitValue) ifAbsent:''
                ] ifFalse:[
                    next == $( ifTrue:[
                        idx2 := self indexOf:$) startingAt:idx+2.
                        key := self copyFrom:idx+2 to:idx2-1.
                        idx := idx2 - 1.
                        (argArrayOrDictionary includesKey:key) ifTrue:[
                            v := argArrayOrDictionary at:key
                        ] ifFalse:[
                            key := key asSymbolIfInternedOrSelf.
                            (argArrayOrDictionary includesKey:key) ifTrue:[
                                v := argArrayOrDictionary at:key
                            ] ifFalse:[
                                (key size == 1 and:[ argArrayOrDictionary includesKey:(key at:1)]) ifTrue:[
                                    v := argArrayOrDictionary at:(key at:1)
                                ] ifFalse:[
                                    key isNumeric ifTrue:[
                                        key := Integer readFrom:key onError:nil.
                                    ].
                                    v := argArrayOrDictionary at:key ifAbsent:''
                                ]
                            ].
                        ].
                    ] ifFalse:[
                        (next isLetter and:[argArrayOrDictionary isSequenceable not "is a Dictionary"]) ifTrue:[
                            "so next is a non-numeric single character."
                            v := argArrayOrDictionary
                                    at:next
                                    ifAbsent:[
                                        "try symbol or string instead of character"
                                        argArrayOrDictionary
                                            at:next asString asSymbolIfInternedOrSelf
                                            ifAbsent:[String with:escapeCharacter with:next].
                                 ].
                        ] ifFalse:[
                            v := String with:$% with:next.
                        ].
                    ]
                ].
                "/ v notNil ifTrue:[
                    v isBlock ifTrue:[
                        v := v value
                    ].

                    v printOn:aStream.
                "/ ].
            ]
        ].
        start := idx + 2
    ].

    "
     String streamContents:[:s|
        'hello %1' expandPlaceholders:$% with:#('world') on:s.
        s cr.
        'hello $1; how is $2' expandPlaceholders:$$ with:#('world' 'this') on:s.
        s cr.
        'hello %2; how is %1' expandPlaceholders:$% with:#('world' 'this') on:s.
        s cr.
        '%1 plus %2 gives %3 ' expandPlaceholders:$% with:#(4 5 9) on:s.
        s cr.
        '%%(1)0 gives %(1)0' expandPlaceholders:$% with:#(123) on:s.
        s cr.
        '%%10 gives %10' expandPlaceholders:$% with:#(123) on:s.
        s cr.
        '%%(10) gives %(10) %<cr>%<tab>next line' expandPlaceholders:$% with:#(123) on:s.
        s cr.
        '%%test gives %test' expandPlaceholders:$% with:#(123) on:s.
        s cr.
        '|%%<tab>|%%1|%%<cr>| gives |%<tab>|%1|%<cr>|' expandPlaceholders:$% with:#(foo) on:s.
     ]
    "

    "
     |dict|

     dict := Dictionary new.
     dict at:1 put:'one'.
     dict at:$a put:'AAAAA'.
     dict at:$b put:[ Time now ].
     String streamContents:[:s|
         'hello $1 $a $b' expandPlaceholders:$$ with:dict on:s.
     ].
    "

    "using blocks:
     |dict|

     dict := Dictionary new.
     dict at:'time' put:[Time now printString].
     dict at:'date' put:[Date today printString].
     String streamContents:[:s|
         'it is $(time) $(date)' expandPlaceholders:$$ with:dict on:s.
     ].
    "

    "Modified: / 18-11-2010 / 15:43:28 / cg"
!

expandPlaceholdersWith:argArrayOrDictionary
    "return a copy of the receiver, where all %i escapes are
     replaced by corresponding arguments' printStrings from the argArrayOrDictionary.
     I.e. 'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this') results
     in the new string 'hello world; how is this'.

     As an extension, the argument may also be a dictionary, providing
     values for symbolic keys.
     In this case, %a .. %z and %(...) are also allowed.
     (%1..%9 require a numeric key in the dictionary, however)
     Also, the values in argArrayOrDictionary may be blocks.

     To get a '%' character, use a '%%'-escape.
     To get an integer-indexed placeHolder followed by another digit,
     or an index > 9, you must use %(digit).
     See also bindWith:... for VisualAge compatibility."

    |stream|

    stream := (TextStream ? CharacterWriteStream) on:(self species uninitializedNew:self size + 20).
    self expandPlaceholdersWith:argArrayOrDictionary on:stream.
    ^ stream contents.

    "
     'hello %1' expandPlaceholdersWith:#('world')
     'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this')
     'hello %2; how is %1' expandPlaceholdersWith:#('world' 'this')
     '%1 plus %2 gives %3 ' expandPlaceholdersWith:#(4 5 9)
     '%%(1)0 gives %(1)0' expandPlaceholdersWith:#(123)
     '%%10 gives %10' expandPlaceholdersWith:#(123)
     '%%(10) gives %(10)' expandPlaceholdersWith:#(123)
     '%test gives %1' expandPlaceholdersWith:#(123)
     'bla %1 bla' expandPlaceholdersWith:{ 'hello' allBold }
     'bla %1 bla' expandPlaceholdersWith:{ 'hello' }
     ('bla %1 bla' withColor:Color red)
        expandPlaceholdersWith:{ 'hello' }
     ('bla %1 bla' withColor:Color red)
        expandPlaceholdersWith:{ 'hello' withColor:Color blue }
    "

    "
     |dict|

     dict := Dictionary new.
     dict at:1 put:'one'.
     dict at:$a put:'AAAAA'.
     dict at:$b put:[ Time now ].
     dict at:'foo' put:[ Date today ].
     'hello %1 %a %b %(foo)' expandPlaceholdersWith:dict
    "

    "Modified: 1.7.1997 / 00:53:24 / cg"
!

expandPlaceholdersWith:argArrayOrDictionary on:aStream
    "write the receiver to aStream, where all %i escapes are
     replaced by corresponding arguments' printStrings from the argArrayOrDictionary.
     I.e. 'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this') results
     in the new string 'hello world; how is this'.

     As an extension, the argument may also be a dictionary, providing
     values for symbolic keys.
     In this case, %a .. %z and %(...) are also allowed.
     (%1..%9 require a numeric key in the dictionary, however)
     Also, the values in argArrayOrDictionary may be blocks.

     To get a '%' character, use a '%%'-escape.
     To get an integer-indexed placeHolder followed by another digit,
     or an index > 9, you must use %(digit).

     See also bindWith:... for VisualAge compatibility.
     Use %<cr> to insert a CR and %<tab> to insert a TAB."

    ^ self expandPlaceholders:$% with:argArrayOrDictionary on:aStream

    "
     String streamContents:[:s|
        'hello %1' expandPlaceholdersWith:#('world') on:s.
        s cr.
        'hello %1; how is %2' expandPlaceholdersWith:#('world' 'this') on:s.
        s cr.
        'hello %2; how is %1' expandPlaceholdersWith:#('world' 'this') on:s.
        s cr.
        '%1 plus %2 gives %3 ' expandPlaceholdersWith:#(4 5 9) on:s.
        s cr.
        '%%(1)0 gives %(1)0' expandPlaceholdersWith:#(123) on:s.
        s cr.
        '%%10 gives %10' expandPlaceholdersWith:#(123) on:s.
        s cr.
        '%%(10) gives %(10) %<cr>%<tab>next line' expandPlaceholdersWith:#(123) on:s.
        s cr.
        '%test gives %1' expandPlaceholdersWith:#(123) on:s.
     ]
    "

    "
     |dict|

     dict := Dictionary new.
     dict at:1 put:'one'.
     dict at:$a put:'AAAAA'.
     dict at:$b put:[ Time now ].
     String streamContents:[:s|
         'hello %1 %a %b' expandPlaceholdersWith:dict on:s.
     ].
    "

    "Modified: / 18-11-2010 / 15:43:28 / cg"
!

firstLine
    "return the first line of a multiline string"

    ^ self asCollectionOfSubCollectionsSeparatedBy:(Character cr) do:[:line | ^ line].

    "
     'hello' firstLine
     '1\2\3' withCRs firstLine
     '\1\2\3' withCRs firstLine
    "
!

tokensBasedOn:aCharacter
    "this is an ST-80 alias for the ST/X method
        asCollectionOfSubstringsSeparatedBy:"

    ^ self asCollectionOfSubstringsSeparatedBy:aCharacter

    "
     'hello:world:isnt:this nice' tokensBasedOn:$:
     'foo,bar,baz' tokensBasedOn:$,
     '/etc/passwd' asFilename readStream nextLine tokensBasedOn:$:
    "
!

withCEscapes
    "return a new string consisting of receiver's characters
     with all special and unprintable characters replaced by \X-character escapes.
     (similar to the way C-language literal Strings are represented).
     The resulting string will contain only 7-bit ascii characters.
     Emphasis is not supported.
     The following escapes are generated:
        \'      single quote character
        \dQuote double quote character
        \r      return character
        \r      return character
        \n      newline character
        \t      tab character
        \\      the \ character itself
        \xnn    two digit hex number defining the characters ascii value
        \unnnn  four digit hex number defining the characters ascii value
        \Unnnnnnnn  eight digit hex number defining the characters ascii value
     This is the opposite of withoutCEscapes.

     Sigh: this is named completely wrong (opposite naming of withCRs/witoutCRs),
           but it cannot be changed easily, as these methods are already used heavily
    "

    |anyEscapeNeeded out seq|

    "
     first, check if any escape is needed and return the receiver unchanged if not
    "
    anyEscapeNeeded := self
                        contains:[:ch |
                            ((ch codePoint between:32 and:126) not
                            or:[ch == $' or:[ch == $"]])
                        ].
    anyEscapeNeeded ifFalse:[ ^ self ].

    self hasChangeOfEmphasis ifTrue:[ self error:'emphasis not supported' ].

    out := WriteStream on:(String uninitializedNew:self size-1).

    self do:[:ch |
        |cp|

        (ch == $' or:[ch == $"]) ifTrue:[
            out nextPut:$\.
            out nextPut:ch.
        ] ifFalse:[
            (ch codePoint between:32 and:126) ifTrue:[
                out nextPut:ch
            ] ifFalse:[
                ch == Character return ifTrue:[
                    seq := '\r'
                ] ifFalse:[ ch == Character nl ifTrue:[
                    seq := '\n'
                ] ifFalse:[ ch == Character tab ifTrue:[
                    seq := '\t'
                ] ifFalse:[ ch == $\ ifTrue:[
                    seq := '\\'
                ] ifFalse:[
                    cp := ch codePoint.
                    cp <= 16rFF ifTrue:[
                        seq := '\x' , (cp printStringRadix:16 padTo:2)
                    ] ifFalse:[
                        cp <= 16rFFFF ifTrue:[
                            seq := '\u' , (cp printStringRadix:16 padTo:4)
                        ] ifFalse:[
                            seq := '\U',(cp printStringRadix:16 padTo:8)
                        ]
                    ]
                ]]]].
                out nextPutAll:seq
            ].
        ].
    ].
    ^ out contents

    "
     'hello\n\tworld' withoutCEscapes.
     'hello\nworld\na\n\tnice\n\t\tstring' withoutCEscapes withCEscapes.
     ('hello ',(Character value:16r1234),' world') withCEscapes
    "

    "Created: / 25-01-2012 / 11:08:16 / cg"
!

withCRs
    "return a new string consisting of the receiver's characters
     with all \-characters replaced by cr-characters.
     If there are no backslashes, return the original"

    ^ self copyReplaceAll:$\ with:(Character cr) ifNone:self

    "
     'hello\world' withCRs
    "

    "Modified: / 18.7.1998 / 22:53:02 / cg"
!

withEscapes
    <resource: #obsolete>
    "has been renamed; the name withEscapes is misleading"

    self obsoleteMethodWarning:'use withoutCEscapes'.
    ^ self withoutCEscapes.

    "Modified: / 25-01-2012 / 10:42:30 / cg"
!

withMatchEscapes
    "return a copy of the receiver with all match characters escaped
     by $\ characters (to be usable as a match string).
     Return the receiver, if there are none."

    |in out c escape|

    escape := self class matchEscapeCharacter.

    in := self readStream.
    out := WriteStream on:(self species new:self size).
    [in atEnd] whileFalse:[
        c := in next.
        (c == escape or:['*[#' includes:c]) ifTrue:[
            out nextPut:$\.
        ].
        out nextPut:c.
    ].
    ^ out contents.

    "
     '*foo' withMatchEscapes
     '\*foo' withMatchEscapes
     '*foo' withMatchEscapes
     '\\*foo' withMatchEscapes
     'foo*' withMatchEscapes
     'foo\*' withMatchEscapes
     'foo\' withMatchEscapes
     'f*o*o' withMatchEscapes
    "

    "Modified: 2.4.1997 / 18:13:04 / cg"
!

withSeparatorsCompacted
    "return a new string with each sequence of whiteSpace replaced by a single space character.
     Preserves a leading/trailing space."

    ^ self species streamContents:[:s |
        |skipping|

        skipping := false.
        1 to:self size do:[:idx |
            |char|

            char := self at:idx.
            char isSeparator ifFalse:[
                s nextPut:char.
                skipping := false.
            ] ifTrue:[
                skipping ifFalse:[
                    s nextPut:(Character space).
                    skipping := true
                ].
            ]
        ]
    ]

    "
     'hello wwww'         withSeparatorsCompacted
     'hello    wwww'      withSeparatorsCompacted
     '  hello wwww'       withSeparatorsCompacted
     '  hello wwww   '    withSeparatorsCompacted
     '  hello    wwww   ' withSeparatorsCompacted
     'hel   lo www   w'   withSeparatorsCompacted
    "
!

withSeparatorsReplacedBy:replacementCharacter
    "return a new string with each separator (whitespace) replaced by replacementCharacter.
     Typically used with space as replacementCharacter"

    ^ self species streamContents:[:s |
        self do:[:ch |
            ch isSeparator ifTrue:[
                s nextPut:replacementCharacter
            ] ifFalse:[
                s nextPut:ch.
            ]
        ]
    ]

    "
     'hello wwww'         withSeparatorsReplacedBy:$*
     'hello ww ww'        withSeparatorsReplacedBy:$*
     '  hello wwww'       withSeparatorsReplacedBy:$*
     'hel   lo www   w'   withSeparatorsReplacedBy:$*
     'hel
 lo www
w'   withSeparatorsReplacedBy:$*
    "
!

withTabs
    "return a string consisting of the receiver's characters
     where leading spaces are replaced by tabulator characters (assuming 8-col tabs).
     Notice: if the receiver does not contain any tabs, it is returned unchanged;
     otherwise a new string is returned.
     Limitation: only the very first spaces are replaced
                 (i.e. if the receiver contains newLine characters,
                  no tabs are inserted after those lineBreaks)"

    |idx   "{ SmallInteger }"
     nTabs "{ SmallInteger }"
     newString|

    idx := self findFirst:[:c | (c ~~ Character space)].
    nTabs := (idx-1) // 8.
    nTabs <= 0 ifTrue:[^ self].

    "any tabs"
    newString := self species new:(self size - (nTabs * 7)).
    newString atAll:(1 to:nTabs) put:(Character tab).
    newString replaceFrom:(nTabs + 1) with:self startingAt:(nTabs * 8 + 1).
    ^ newString

    "
     '12345678901234567890' withTabs
     '       8901234567890' withTabs
     '        901234567890' withTabs
     '               67890' withTabs
     '                7890' withTabs
     '                 890' withTabs
    "
!

withTabsExpanded
    "return a string consisting of the receiver's characters,
     where all tabulator characters are expanded into spaces (assuming 8-col tabs).
     Notice: if the receiver does not contain any tabs, it is returned unchanged;
     otherwise a new string is returned.
     This does handle multiline strings."

    ^ self withTabsExpanded:8

    "
     ('1' , Character tab asString , 'x') withTabsExpanded
     ('12345' , Character tab asString , 'x') withTabsExpanded
     ('123456' , Character tab asString , 'x') withTabsExpanded
     ('1234567' , Character tab asString , 'x') withTabsExpanded
     ('12345678' , Character tab asString , 'x') withTabsExpanded
     ('123456789' , Character tab asString , 'x') withTabsExpanded

     (String with:Character tab
             with:Character tab
             with:$1) withTabsExpanded

     (String with:Character tab
             with:$1
             with:Character tab
             with:$2) withTabsExpanded

     (String with:Character tab
             with:$1
             with:Character cr
             with:Character tab
             with:$2) withTabsExpanded
    "

    "Modified: 12.5.1996 / 13:05:10 / cg"
!

withTabsExpanded:numSpaces
    "return a string consisting of the receiver's characters,
     where all tabulator characters are expanded into spaces (assuming numSpaces-col tabs).
     Notice: if the receiver does not contain any tabs, it is returned unchanged;
     otherwise a new string is returned.
     This does handle multiline strings."

    |col    "{ SmallInteger }"
     str ch
     dstIdx "{ SmallInteger }"
     newSz  "{ SmallInteger }"
     sz "{ SmallInteger }"
     hasEmphasis e|

    (self includes:(Character tab)) ifFalse:[^ self].

    sz := self size.

    "/ count the new size first, instead of
    "/ multiple resizing (better for large strings)

    col := 1. newSz := 0.
    1 to:sz do:[:srcIdx |
        ch := self at:srcIdx.
        ch == Character tab ifFalse:[
            col := col + 1.
            newSz := newSz + 1.
            ch == Character cr ifTrue:[
                col := 1
            ].
        ] ifTrue:[
            (col \\ numSpaces) to:numSpaces do:[:ii |
                newSz := newSz + 1.
                col := col + 1
            ].
        ]
    ].

    self isText ifTrue:[ 
        str := Text string: (self string class new: newSz).
    ] ifFalse:[
        str := self species new:newSz.
    ].

    hasEmphasis := self hasChangeOfEmphasis.

    col := 1. dstIdx := 1.
    1 to:sz do:[:srcIdx |
        ch := self at:srcIdx.

        ch == Character tab ifFalse:[
            col := col + 1.
            ch == Character cr ifTrue:[
                col := 1
            ].
            hasEmphasis ifTrue:[
                e := self emphasisAt:srcIdx.
                str emphasisAt:dstIdx put:e
            ].
            str at:dstIdx put:ch.
            dstIdx := dstIdx + 1
        ] ifTrue:[
            (col \\ numSpaces) to:numSpaces do:[:ii |
                str at:dstIdx put:Character space.
                dstIdx := dstIdx + 1.
                col := col + 1
            ].
        ]
    ].
    ^ str

    "
     ('1' , Character tab asString , 'x') withTabsExpanded
     ('1' , Character tab asString , 'x') withTabsExpanded:4
     ('12345' , Character tab asString , 'x') withTabsExpanded
     ('123456' , Character tab asString , 'x') withTabsExpanded
     ('1234567' , Character tab asString , 'x') withTabsExpanded
     ('12345678' , Character tab asString , 'x') withTabsExpanded
     ('123456789' , Character tab asString , 'x') withTabsExpanded

     (String with:Character tab
             with:Character tab
             with:$1) withTabsExpanded

     (String with:Character tab
             with:$1
             with:Character tab
             with:$2) withTabsExpanded

     (String with:Character tab
             with:$1
             with:Character cr
             with:Character tab
             with:$2) withTabsExpanded
    "

    "Modified: / 12-05-1996 / 13:05:10 / cg"
    "Modified: / 21-04-2015 / 15:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withoutAllSpaces
    "return a copy of the receiver with all whitespace removed"

    ^ self asCollectionOfWords asStringWith:''.
"/    |col string|
"/
"/    col := self asCollectionOfWords.
"/    string := String new.
"/    col do:[:el |
"/       string := string,el
"/    ].
"/    ^string

    "
     'hello wwww'  withoutAllSpaces
     'hel   lo www   w'  withoutAllSpaces
    "

    "Modified: / 18.7.1998 / 22:53:08 / cg"
!

withoutCEscapes
    "return a new string consisting of receiver's characters
     with all \X-character escapes replaced by corresponding-characters.
     (similar to the way C-language Strings are converted).
     The following escapes are supported:
        \r      return character
        \n      newline character
        \b      backspace character
        \f      formfeed character
        \t      tab character
        \e      escape character
        \\      the \ character itself
        \nnn    three digit octal number defining the characters ascii value
        \xnn    two digit hex number defining the characters ascii value
        \unnnn  four digit hex number defining the characters unicode value
        \Unnnnnnnn  eight digit hex number defining the characters unicode value
        \other  other

     Notice, that \' is NOT a valid escape, since the general syntax of
     string constants is not affected by this method.

     Although easily implementable, this is NOT done automatically
     by the compiler (due to a lack of a language standard for this).
     However, the compiler may detect sends ot #withEscapes to string literals
     and place a modified string constant into the binary/byte-code.
     Therefore, no runtime penalty will be payed for using these escapes.
     (not in pre 2.11 versions)

     This is the opposite of withCEscapes.

     Sigh: this is named completely wrong (opposite naming of withCRs/witoutCRs),
           but it cannot be changed easily, as these methods are already used heavily
    "

    |val     "{ SmallInteger }"
     in out nextChar nDigits|

    "
     first, see if there is any escape; if not, return the receiver unchanged
    "
    (self includes:$\) ifFalse:[^ self ].

    self hasChangeOfEmphasis ifTrue:[ self error:'emphasis not supported' ].
    out := CharacterWriteStream on:(String new:self size - 1).

    in := ReadStream on:self.
    [in atEnd] whileFalse:[
        nextChar := in next.
        nextChar == $\ ifTrue:[
            in atEnd ifTrue:[
            ] ifFalse:[
                nextChar := in next.
                nextChar == $r ifTrue:[
                    nextChar := Character return
                ] ifFalse:[ nextChar == $n ifTrue:[
                    nextChar := Character nl
                ] ifFalse:[ nextChar == $b ifTrue:[
                    nextChar := Character backspace
                ] ifFalse:[ nextChar == $f ifTrue:[
                    nextChar := Character newPage
                ] ifFalse:[ nextChar == $t ifTrue:[
                    nextChar := Character tab
                ] ifFalse:[ nextChar == $e ifTrue:[
                    nextChar := Character esc
                ] ifFalse:[
                    nextChar == $0 ifTrue:[
                        val := 0.
                        nextChar := in peek.
                        nDigits := 1.
                        [nextChar notNil and:[nextChar isDigit and:[nDigits <= 3]]] whileTrue:[
                            val := (val * 8) + nextChar digitValue.
                            nextChar := in nextPeek.
                            nDigits := nDigits + 1.
                        ].
                        nextChar := Character value:val.
                    ] ifFalse:[
                        val := 0.
                        nextChar == $x ifTrue:[
                            2 timesRepeat:[
                                nextChar := in next.
                                val := (val * 16) + nextChar digitValue.
                            ].
                            nextChar := Character value:val.
                        ] ifFalse:[
                            nextChar == $u ifTrue:[
                                4 timesRepeat:[
                                    nextChar := in next.
                                    val := (val * 16) + nextChar digitValue.
                                ].
                                nextChar := Character value:val.
                            ] ifFalse:[
                                nextChar == $U ifTrue:[
                                    8 timesRepeat:[
                                        nextChar := in next.
                                        val := (val * 16) + nextChar digitValue.
                                    ].
                                    nextChar := Character value:val.
                                ]
                            ]
                        ]
                    ]
                ]]]]]].
            ].
        ].
        out nextPut:nextChar.
    ].
    ^ out contents

    "
     'hello world' withoutCEscapes
     'hello\world' withoutCEscapes
     'hello\world\' withoutCEscapes
     'hello world\' withoutCEscapes
     'hello\tworld' withoutCEscapes
     'hello\nworld\na\n\tnice\n\t\tstring' withoutCEscapes
     'hello\tworld\n' withoutCEscapes
     'hello\010world' withoutCEscapes
     'hello\r\nworld' withoutCEscapes
     'hello\r\n\x08world' withoutCEscapes
     '0\x080' withoutCEscapes
     '0\u12340' withoutCEscapes
     '0\U123456780' withoutCEscapes
     '0\0a' withoutCEscapes
     '0\00a' withoutCEscapes
     '0\000a' withoutCEscapes
     '0\0000a' withoutCEscapes
     '0\00000a' withoutCEscapes
     '0\03770' withoutCEscapes
    "

    "Created: / 25-01-2012 / 10:41:44 / cg"
!

withoutCRs
    "return a new collection consisting of receiver's elements
     with all cr-characters replaced by \-characters.
     This is the reverse operation of withCRs."

    ^ self copyReplaceAll:(Character cr) with:$\ ifNone:self

    "
     'hello
world' withoutCRs
    "

    "Modified: / 18.7.1998 / 22:53:08 / cg"
!

withoutLeadingSeparators
    "return a copy of myself without leading separators.
     Notice: this does remove tabs, newline or any other whitespace.
     Returns an empty string, if the receiver consist only of whitespace."

    |index|

    index := self indexOfNonSeparatorStartingAt:1.
    index ~~ 0 ifTrue:[
        index == 1 ifTrue:[
            ^ self
        ].
        ^ self copyFrom:index
    ].
    ^ ''

    "
     '    foo    ' withoutLeadingSeparators
     'foo    '     withoutLeadingSeparators
     '    foo'     withoutLeadingSeparators
     '       '     withoutLeadingSeparators
     'foo'         withoutLeadingSeparators
     ('  ' , Character tab asString , ' foo   ') withoutLeadingSeparators inspect
    "
!

withoutMatchEscapes
    "return a copy of the receiver with all $\ removed or
     the receiver, if there are none."

    |in out c escape|

    escape := self class matchEscapeCharacter.

    in := self readStream.
    out := self species writeStream.
    [in atEnd] whileFalse:[
        c := in next.
        c == escape ifTrue:[
            in atEnd ifFalse:[
                c := in next.
            ]
        ].
        out nextPut:c.
    ].
    ^ out contents.

    "
     '*foo' withoutMatchEscapes
     '\*foo' withoutMatchEscapes
     '*foo' withoutMatchEscapes
     '\\*foo' withoutMatchEscapes
     'foo*' withoutMatchEscapes
     'foo\*' withoutMatchEscapes
     'foo\' withoutMatchEscapes
     'f\*o\*o' withoutMatchEscapes
    "

    "Modified: 30.6.1997 / 13:40:23 / cg"
!

withoutPrefix:aString
    "if the receiver startsWith aString, return a copy without it.
     Otherwise return the receiver"

    (self startsWith:aString) ifTrue:[
        ^ self copyFrom:aString size+1
    ].
    ^ self

    "
     'helloworld' withoutPrefix:'hello'
     'helloworld' withoutPrefix:'foo'
    "

    "Modified: / 30-04-2016 / 10:01:00 / cg"
!

withoutQuotes
    "/ remove quotes ($" and $') from the front and end of myself (if matching)"

    |firstChar|

    self isEmpty ifTrue:[^ self].

    firstChar := self first.
    ((firstChar == $") or:[firstChar == $']) ifFalse:[^ self].

    self last == firstChar ifTrue:[
        ^ self copyFrom:2 to:(self size-1)
    ].
    ^ self

    "/
    "/ '"hello"' withoutQuotes
    "/ '''hello''' withoutQuotes
    "/ 'hello' withoutQuotes
    "/ '"hello' withoutQuotes
    "/ 'hello"' withoutQuotes
    "/
!

withoutSeparators
    "return a copy of myself without leading and trailing whitespace.
     (but whiteSpace in-between is preserved)
     Whitespace is space, tab, newline, formfeed.
     Use withoutSpaces, if you want to remove spaces only."

    ^ self trimForWhich:[:ch | ch isSeparator]

    "
     '    foo    ' withoutSeparators
     '    foo' withoutSeparators
     'foo    ' withoutSeparators
     '       ' withoutSeparators
     ('  foo' , Character tab asString , '    ') withoutSeparators inspect
     '    foo    ' asUnicode16String withoutSeparators
    "
!

withoutSpaces
    "return a copy of myself without leading and trailing spaces.
     (but spaces in-between are preserved)
     Notice: this does NOT remove tabs, newline or any other whitespace.
     Use withoutSeparators for this."

    ^ self trimForWhich:[:ch | ch == Character space]

    "
     '    foo    ' withoutSpaces
     'foo    '     withoutSpaces
     '    foo'     withoutSpaces
     '       '     withoutSpaces
     'a     b'     withoutSpaces
     ('  foo' , Character tab asString , '    ') withoutSpaces inspect
    "
!

withoutTrailingSeparators
    "return a copy of myself without trailing separators.
     Notice: this does remove tabs, newline or any other whitespace.
     Returns an empty string, if the receiver consist only of whitespace."

    ^ self withoutTrailingForWhich:[:ch | ch isSeparator]

    "
     '    foo    ' withoutTrailingSeparators
     'foo    '     withoutTrailingSeparators
     '    foo'     withoutTrailingSeparators
     '       '     withoutTrailingSeparators
     'foo'         withoutTrailingSeparators
     ('  ' , Character tab asString , ' foo   ') withoutTrailingSeparators inspect
     ('   foo' , Character tab asString) withoutTrailingSeparators inspect
    "
! !


!CharacterArray methodsFor:'substring searching'!

findRangeOfString:subString
    "find a substring. if found, return the start- and endIndex;
     if not found, return an empty interval."

    ^ self rangeOfSubCollection:subString startingAt:1 ifAbsent:[0 to:-1] caseSensitive:true

    "
     'hello world' findRangeOfString:'llo'
     'hello world' findRangeOfString:'ole'
    "
!

findString:subString
    "find a substring. if found, return the index;
     if not found, return 0."

    ^ self indexOfSubCollection:subString startingAt:1 ifAbsent:0 caseSensitive:true

    "
     'hello world' findString:'llo'
     'hello world' findString:'ole'
    "
!

findString:subString caseSensitive:caseSensitive
    "find a substring. if found, return the index;
     if not found, return 0."

    ^ self indexOfSubCollection:subString startingAt:1 ifAbsent:0 caseSensitive:caseSensitive

    "
     'hello world' findString:'LLo' caseSensitive:true
     'hello world' findString:'LLo' caseSensitive:false
    "
!

findString:subString ifAbsent:exceptionBlock
    "find a substring. If found, return the index;
     if not found, return the result of evaluating exceptionBlock."

    ^ self indexOfSubCollection:subString startingAt:1 ifAbsent:exceptionBlock caseSensitive:true
!

findString:subString ignoreCase:ignoreCase
    <resource: #obsolete>
    "find a substring. if found, return the index;
     if not found, return 0."

    ^ self indexOfSubCollection:subString startingAt:1 ifAbsent:0 caseSensitive:ignoreCase not

    "
     'hello world' findString:'LLo' ignoreCase:false
     'hello world' findString:'LLo' ignoreCase:true
    "
!

findString:subString startingAt:index
    "find a substring, starting at index. if found, return the index;
     if not found, return 0."

    ^ self indexOfSubCollection:subString startingAt:index ifAbsent:0 caseSensitive:true

    "
     'hello yello' findString:'llo' startingAt:1
     'hello yello' findString:'llo' startingAt:5
     'hello yello' findString:'llo' startingAt:15
    "
!

findString:subString startingAt:index ifAbsent:exceptionBlock
    "find a substring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock."

    ^ self indexOfSubCollection:subString startingAt:index ifAbsent:exceptionBlock caseSensitive:true
!

findString:subString startingAt:index ifAbsent:exceptionBlock caseSensitive:caseSensitive
    "find a substring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock."

    ^ self indexOfSubCollection:subString startingAt:index ifAbsent:exceptionBlock caseSensitive:caseSensitive
!

includesString:aString
    "return true, if a substring is contained in the receiver"

    ^ (self indexOfSubCollection:aString startingAt:1 ifAbsent:0 caseSensitive:true) ~~ 0

    "
     'hello world' includesString:'hel'
     'hello world' includesString:'rld'
     'hello world' includesString:'llo'
     'hello world' includesString:'LLO'
     'hello world' includesString:''
    "
!

includesString:aString caseSensitive:caseSensitive
    "return true, if a substring is contained in the receiver"

    ^ (self indexOfSubCollection:aString startingAt:1 ifAbsent:0 caseSensitive:caseSensitive) ~~ 0

    "
     'hello world' includesString:'hel' caseSensitive:true
     'hello world' includesString:'HEL' caseSensitive:true
     'hello world' includesString:'HEL' caseSensitive:false

     'hello world' includesString:'wor' caseSensitive:true
     'hello world' includesString:'WOR' caseSensitive:true
     'hello world' includesString:'WOR' caseSensitive:false
    "
!

indexOfString: aString
    "VSE and V'age compatibility"
    "find a substring. If found, return the index; if not found, return 0."

    ^ self indexOfSubCollection: aString startingAt:1 ifAbsent:[0]
!

indexOfString:aString ifAbsent:exceptionValue
    "VSE and V'age compatibility"
    "find a substring. If found, return the index; if not found, return 0."

    ^ self indexOfSubCollection: aString startingAt:1 ifAbsent:exceptionValue

    "
     'abcdefabcdef' indexOfString:'fab' ifAbsent:[999]
     'abcdefabcdef' indexOfString:'xxx' ifAbsent:[999]
    "
!

indexOfString:aString startingAt:startIndex
    "VSE and V'age compatibility"
    "find a substring. If found, return the index; if not found, return 0."

    ^ self indexOfSubCollection:aString startingAt:startIndex ifAbsent:[0]
!

indexOfString:aString startingAt:startIndex ifAbsent:exceptionalValue
    "VSE and V'age compatibility"
    "find a substring.
     If found, return the index; if not found, the value from exceptionalValue."

    ^ self indexOfSubCollection:aString startingAt:startIndex ifAbsent:exceptionalValue
!

indexOfSubCollection:subString caseSensitive:caseSensitive
    "find a substring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient"

    ^ self indexOfSubCollection:subString startingAt:1 ifAbsent:[0] caseSensitive:caseSensitive.
!

indexOfSubCollection:subString startingAt:index ifAbsent:exceptionBlock
    "find a substring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient"

    ^ self indexOfSubCollection:subString startingAt:index ifAbsent:exceptionBlock caseSensitive:true.
!

indexOfSubCollection:subString startingAt:index ifAbsent:exceptionBlock caseSensitive:caseSensitive
    "find a substring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient"

    |firstChar found
     startIndex "{ Class: SmallInteger }"
     subSize    "{ Class: SmallInteger }"
     mySize     "{ Class: SmallInteger }"
     runIdx     "{ Class: SmallInteger }"
     tester|

    subSize := subString size.
    subSize == 0 ifTrue:[
        subString isString ifFalse:[
           self error:'non string argument' mayProceed:true.
        ].
        "empty string does not match"
        ^ 0.
        "empty string matches"
"/        ^ index
    ].

    mySize := self size.
    firstChar := subString at:1.
    caseSensitive ifTrue:[
        tester := [:c1 :c2 | c1 = c2 ].
        startIndex := self indexOf:firstChar startingAt:index.
    ] ifFalse:[
        tester := [:c1 :c2 | c1 sameAs: c2 ].
        startIndex := self findFirst:[:c | c sameAs:firstChar] startingAt:index.
    ].
    [startIndex == 0] whileFalse:[
        runIdx := startIndex.
        found := true.
        1 to:subSize do:[:i |
            runIdx > mySize ifTrue:[
                found := false
            ] ifFalse:[
                (tester value:(subString at:i) value:(self at:runIdx)) ifFalse:[
                    found := false
                ]
            ].
            runIdx := runIdx + 1
        ].
        found ifTrue:[
            ^ startIndex
        ].
        caseSensitive ifTrue:[
            startIndex := self indexOf:firstChar startingAt:(startIndex + 1)
        ] ifFalse:[
            startIndex := self findFirst:[:c | c sameAs:firstChar] startingAt:(startIndex + 1).
        ].
    ].
    ^ exceptionBlock value

    "Modified: 23.2.1996 / 15:35:15 / cg"
!

indexOfSubCollection:subString startingAt:index ifAbsent:exceptionBlock caseSensitive:caseSensitive ignoreDiacritics:ignoreDiacritics
    "find a substring, starting at index. if found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient
     (see implementation in string, for a much faster algorithm)"

    |firstChar found
     startIndex "{ Class: SmallInteger }"
     subSize    "{ Class: SmallInteger }"
     mySize     "{ Class: SmallInteger }"
     runIdx     "{ Class: SmallInteger }"
     tester charMap firstCharMapped findNextIndex|

    subSize := subString size.
    subSize == 0 ifTrue:[
        subString isString ifFalse:[
           self error:'non string argument' mayProceed:true.
        ].
        "empty string does not match"
        ^ 0.
        "empty string matches"
"/        ^ index
    ].

    mySize := self size.
    firstChar := subString at:1.
    ignoreDiacritics ifTrue:[
        caseSensitive ifTrue:[
            charMap := [:ch | ch asLowercase withoutDiacritics].
        ] ifFalse:[
            charMap := [:ch | ch withoutDiacritics].
        ].
        tester := [:c1 :c2 | (charMap value:c1) = (charMap value:c2) ].
        firstCharMapped := (charMap value:firstChar).
        findNextIndex := [:index | self findFirst:[:ch | (charMap value:ch) = firstCharMapped] startingAt:index].
    ] ifFalse:[
        caseSensitive ifTrue:[
            tester := [:c1 :c2 | c1 = c2 ].
            findNextIndex := [:index | self indexOf:firstChar startingAt:index].
        ] ifFalse:[
            tester := [:c1 :c2 | c1 sameAs: c2 ].
            findNextIndex := [:index | self findFirst:[:c | c sameAs:firstChar] startingAt:index].
        ].
    ].
    startIndex := findNextIndex value:index.
    [startIndex == 0] whileFalse:[
        runIdx := startIndex.
        found := true.
        1 to:subSize do:[:i |
            runIdx > mySize ifTrue:[
                found := false
            ] ifFalse:[
                (tester value:(subString at:i) value:(self at:runIdx)) ifFalse:[
                    found := false
                ]
            ].
            runIdx := runIdx + 1
        ].
        found ifTrue:[
            ^ startIndex
        ].
        startIndex := findNextIndex value:(startIndex + 1)
    ].
    ^ exceptionBlock value

    "
     'bla depot bla dépots' indexOfSubCollection:'dep' startingAt:1 ifAbsent:0 caseSensitive:false ignoreDiacritics:true. 5
     'bla depot bla dépots' indexOfSubCollection:'dep' startingAt:6 ifAbsent:0 caseSensitive:false ignoreDiacritics:true. 0

     'bla depot bla dépots' indexOfSubCollection:'dep' startingAt:1 ifAbsent:0 caseSensitive:false ignoreDiacritics:false. 5
     'bla depot bla dépots' indexOfSubCollection:'dep' startingAt:6 ifAbsent:0 caseSensitive:false ignoreDiacritics:false. 0
    "
!

lastIndexOfString:aString
    "VSE and V'age compatibility"
    "find the last occurrence of substring.
     If found, return the index; if not found, return 0."

    ^ self lastIndexOfSubCollection:aString startingAt:(self size-aString size+1) ifAbsent:[0]

    " 123456789012
     'abcdefabcdef' lastIndexOfString:'abc'
     'abcdefabcdef' lastIndexOfString:'abc' startingAt:6
     'abcdefabcdef' lastIndexOfString:'xxx' startingAt:6
    "
!

lastIndexOfString:aString ifAbsent:exceptionValue
    "VSE and V'age compatibility"
    "find the last occurrence of substring.
     If found, return the index; if not found, return 0."

    ^ self lastIndexOfSubCollection:aString startingAt:(self size-aString size+1) ifAbsent:exceptionValue

    " 123456789012
     'abcdefabcdef' lastIndexOfString:'abc' ifAbsent:[999]
     'abcdefabcdef' lastIndexOfString:'xxx' ifAbsent:[999]
    "
!

lastIndexOfString:aString startingAt:startIndex
    "VSE and V'age compatibility"
    "find the last occurrence of a substring.
     If found, return the index; if not found, return 0."

    ^ self lastIndexOfSubCollection:aString startingAt:startIndex ifAbsent:[0]

    " 123456789012
     'abcdefabcdef' lastIndexOfString:'abc'
     'abcdefabcdef' lastIndexOfString:'abc' startingAt:6
    "
!

lastIndexOfString:aString startingAt:startIndex ifAbsent:exceptionValue
    "VSE and V'age compatibility"
    "find the last occurrence of a substring.
     If found, return the index; if not found, return 0."

    ^ self lastIndexOfSubCollection:aString startingAt:startIndex ifAbsent:exceptionValue

    " 123456789012
     'abcdefabcdef' lastIndexOfString:'abc'
     'abcdefabcdef' lastIndexOfString:'abc' startingAt:6
     'abcdefabcdef' lastIndexOfString:'xxx' startingAt:6 ifAbsent:999
    "
!

rangeOfSubCollection:subString startingAt:start ifAbsent:exceptionValue caseSensitive:caseSensitive
    "find a substring. if found, return the start- and endIndex;
     if not found, return the value of exceptionValue."

    |i|

    i := self indexOfSubCollection:subString startingAt:start ifAbsent:0 caseSensitive:caseSensitive.
    i == 0 ifTrue:[
        ^ exceptionValue value
    ].
    ^ i to:(i + subString size - 1)

    "
     'hello world' findRangeOfString:'llo'
     'hello world' findRangeOfString:'ole'
    "
! !

!CharacterArray methodsFor:'testing'!

argumentCount
    "treating the receiver as a message selector, return how many arguments would it take (ANSI)"

    |binopChars|

    (self size <= Method maxBinarySelectorSize) ifTrue:[
        binopChars := Method binarySelectorCharacters.
        (self conform:[:eachChar | (binopChars includes:eachChar)]) ifTrue:[
            ^ 1
        ].
    ].
    ^ self occurrencesOf:$:

    "
     'foo:bar:' argumentCount
     #foo:bar: argumentCount
     'hello' argumentCount
     '+' argumentCount
     '++' argumentCount
     '+++' argumentCount
     '|' argumentCount
     '?' argumentCount
     '_' argumentCount
     '_:' argumentCount
     '_:_:' argumentCount
     '<->' argumentCount
    "
!

characterSize
    "answer the size in bits of my largest character (actually only 7, 8, 16 or 32)"

    |string max
     sz "{ Class:SmallInteger}" |

    (string := self string) ~~ self ifTrue:[
        ^ string characterSize.
    ].

    sz := self size.
    max := 7.
    1 to:sz do:[:idx |
        |thisSize|

        thisSize := (self at:idx) characterSize.
        thisSize > max ifTrue:[
            max := thisSize.
            max == 32 ifTrue:[
                "shortcut: we know, that max size is 32"
                ^ 32.
            ].
        ].
    ].

    ^ max.

    "
     'hello' characterSize
     'hello' asUnicode32String characterSize
     'helloü' asUnicode32String characterSize
     'hello' asText allBold characterSize
    "
!

contains8BitCharacters
    <resource: #obsolete>

    ^ self containsNon7BitAscii
!

containsNon7BitAscii
    "return true, if the underlying string contains 8BitCharacters (or widers)
     (i.e. if it is non-ascii)"

    |string
     sz "{ Class:SmallInteger }"|

    (string := self string) ~~ self ifTrue:[
        ^ string containsNon7BitAscii
    ].
    sz := self size.
    1 to:sz do:[:idx|
        (self at:idx) codePoint > 16r7F ifTrue:[
            ^ true.
        ].
    ].
    ^ false.

    "
     'hello' asUnicode32String containsNon7BitAscii
     'hello üöä' asUnicode32String containsNon7BitAscii
     'hello' asUnicode32String asText allBold containsNon7BitAscii
     'hello üö' asUnicode32String asText allBold containsNon7BitAscii
    "
!

isAlphaNumeric
    "return true, if the receiver is some alphanumeric word;
     i.e. consists of a letter followed by letters or digits."

    self size == 0 ifTrue:[
        "mhmh what is this ?"
        ^ false
    ].
    (self at:1) isLetter ifFalse:[^ false].
    ^ self conform:[:char | char isLetterOrDigit].

    "
     'helloWorld' isAlphaNumeric
     'foo1234' isAlphaNumeric
     'f1234' isAlphaNumeric
     '1234' isAlphaNumeric
     '+' isAlphaNumeric
    "

    "Modified: / 13-10-2006 / 12:53:49 / cg"
!

isBinarySelector
    "treating the receiver as a message selector, return true if its a binary selector.
     Notice, that st/x does not have a size <= 2 limit for unaries"

    |binopChars|

    (self size > Method maxBinarySelectorSize) ifTrue:[^ false].

    binopChars := Method binarySelectorCharacters.
    ^ (self conform:[:char | (binopChars includes:char)])

    "
     'foo:bar:' isBinarySelector
     #foo:bar: isBinarySelector
     'hello' isBinarySelector
     '+' isBinarySelector
     '|' isBinarySelector
     '?' isBinarySelector
     ':' isBinarySelector
     'a:' isBinarySelector
     '->' isBinarySelector
     '<->' isBinarySelector
     '::' isBinarySelector
    "

    "Modified: 4.1.1997 / 14:16:14 / cg"
!

isBlank
    "return true, if the receiver contains spaces only"

    ^ (self contains:[:char | char ~~ Character space]) not

    "
     '' isBlank
     '   a    ' isBlank
     '        ' isBlank
     '        ' asUnicode16String isBlank
    "
!

isInfix
    "return true, if the receiver is a binary message selector"

    ^ self first isLetterOrDigit not

    "
     #at:put: isInfix
     #at: isInfix
     #+ isInfix
     #size isInfix
    "

    "Created: / 1.11.1997 / 12:34:55 / cg"
    "Modified: / 1.11.1997 / 12:36:37 / cg"
!

isKeyword
    "return true, if the receiver is a keyword message selector.
     This is a quick check, which only looks at the last character.
     Should only be used, if we already know that the receiver forms a valid selector.
     To check an arbitrary string, use isKeywordSelector.
     Bad naming, but compatibility is asking for it."

    ^ self last == $:

    "
     #at:put: isKeyword
     #at: isKeyword
     #+ isKeyword
     #size isKeyword
    "

    "Created: / 01-11-1997 / 12:34:55 / cg"
    "Modified (comment): / 30-04-2016 / 18:19:11 / cg"
!

isKeywordSelector
    "return true, iff there are only alphanumeric or underline characters separated by colons.
     Must end with a colon.
     You can use this to check an arbitrary string for being valid as a keyword.
     If you have a valid selector at hand, and need to know if it is a keyword or not,
     use #isKeyword, which is much faster."

    |state|

    (self size == 0) ifTrue:[^ false].
    (self last == $:) ifFalse:[^ false].

    state := #initial.
    self do:[:char |
        (state == #initial or:[ state == #gotColon]) ifTrue:[
            (char isLetterOrUnderline) ifFalse:[^ false].
            state := #gotCharacter.
        ] ifFalse:[
            char == $: ifTrue:[
                state := #gotColon.
            ] ifFalse:[
                (char isLetterOrDigit or:[char == $_]) ifFalse:[^ false].
            ].
        ].
    ].
    ^ state == #gotColon.

    "
     self assert:(':' isKeywordSelector not).
     self assert:(':a' isKeywordSelector not).
     self assert:('1:' isKeywordSelector not).
     self assert:('a:' isKeywordSelector).
     self assert:('_:' isKeywordSelector).
     self assert:('_a:' isKeywordSelector).
     self assert:('_1:' isKeywordSelector).
     self assert:('_1::' isKeywordSelector not).
     self assert:('_:_:' isKeywordSelector).
     self assert:('a:b:' isKeywordSelector).
     self assert:('aa:bb:' isKeywordSelector).
     self assert:('aa:bb:a' isKeywordSelector not).
     self assert:('1:2:' isKeywordSelector not).
    "

    "Modified (comment): / 30-04-2016 / 18:20:14 / cg"
!

isNameSpaceSelector
    "Answer true if the receiver contains chars which form a nameSpace selector name.
     These are of the form ':<ns>::<sel>', where ns is the NameSpace and sel is the regular selector.
     For example, the #+ selector as seen by the Foo namespace would be actually #':Foo::+'.
     This special format (a symbol starting with a colon) was chosen, because almost every other selector
     is legal, and this can be checked quickly by just looking at the first character.
     You cannot easily change this algorithm here, as it is also known by the VM's lookup function."

    |i|

    (self at:1) == $: ifFalse:[^ false].

    i := self indexOf:$: startingAt:2.
    i == 0 ifTrue:[^ false].
    self size <= (i+1) ifTrue:[^ false].
    (self at:i+1) == $: ifFalse:[^ false].
    (self at:i+2) == $: ifTrue:[^ false].
    "/ could check if the rest after the ns-prefix and colons is a valid selector...
    ^ true

    "test:
     self assert:('+' isNameSpaceSelector) not.
     self assert:(':+' isNameSpaceSelector) not.
     self assert:(':Foo:+' isNameSpaceSelector) not.

     self assert:(':Foo::+' isNameSpaceSelector).
     self assert:(':Foo::bar:baz:' isNameSpaceSelector).
    "

    "Created: / 05-03-2007 / 11:35:31 / cg"
!

isNumeric
    "return true, if the receiver is some numeric word;
     i.e. consists only of digits."

    self size == 0 ifTrue:[
        ^ false
    ].
    ^ self conform:[:char | char isDigit]

    "
     'helloWorld' isNumeric
     'foo1234' isNumeric
     'f1234' isNumeric
     '1234' isNumeric
     '+' isNumeric
    "

    "Modified: / 13-10-2006 / 12:54:12 / cg"
!

isPlainString
    "return true, if the receiver is a plain string (without attributes);
     true is returned here - redefinition of Object>>isPlainString."

    ^ true
!

isString
    "return true, if the receiver is some kind of string;
     true is returned here - redefinition of Object>>isString."

    ^ true
!

isUnary
    "Answer true if the receiver is a unary selector.
     That is not a check for being a valid selector, but instead relies on
     the selector being valid."

    ^ self isUnarySelector
!

isUnarySelector
    "Answer true if the receiver contains only chars in an ANSI unary method selector, false otherwise."

    ^ (self first isLetterOrUnderline)
      and:[ self conform: [ :chr | chr isLetterOrDigit or:[chr == $_] ]]

    "Modified: / 13-09-2006 / 11:35:15 / cg"
!

isUnicode16String
    ^ false
!

isUnicode32String
    "true if this is a 4-byte unicode string"

    ^ false
!

isUnicodeString
    "true if this is a 2- or 4-byte unicode string
     (i.e. not a single byte string).
     Notice, that the name is misleading:
     all strings are use unicode encoding"

    ^ false
!

isValidSmalltalkIdentifier
    "return true, if the receiver's characters make up a valid smalltalk identifier"

    |scanner tok|

    scanner := Compiler new.
    scanner source:(self readStream).
    Parser parseErrorSignal handle:[:ex |
        tok := nil.
    ] do:[
        tok := scanner nextToken.
    ].
    tok ~~ #Identifier ifTrue:[
        ^ false
    ].
    scanner tokenPosition == 1 ifFalse:[^ false].
    ^ scanner sourceStream atEnd.

    "
     'foo' isValidSmalltalkIdentifier
     '1foo' isValidSmalltalkIdentifier
     '_foo' isValidSmalltalkIdentifier
     '_foo_bar_' isValidSmalltalkIdentifier
     'foo ' isValidSmalltalkIdentifier
     ' foo' isValidSmalltalkIdentifier
    "
!

isWideString
    "true if I require more than one byte per character"

    |string|

    (string := self string) ~~ self ifTrue:[
        ^ string isWideString.
    ].
    ^ self contains:[:aCharacter | aCharacter codePoint > 16rFF].
!

numArgs
    <resource: #obsolete>
    "treating the receiver as a message selector, return how many arguments would it take.
     Please use argumentCount for ANSI compatibility."

    ^ self argumentCount
!

partsIfSelector
    "treat the receiver as a message selector, return a collection of parts.
     Notice: this is more tolerant than Smalltalk's syntax would suggest;
     especially it allows for empty keyword parts between colons.
     This is not (and should not be checked here), to allow parsing of
     degenerate selectors as appearing with objectiveC."

    |idx1 "{ Class: SmallInteger }"
     coll idx2 sz|

    coll := OrderedCollection new.
    idx1 := 1.
    sz := self size.
    [
        idx2 := self indexOf:$: startingAt:idx1.
        (idx2 == 0 or:[idx2 == sz]) ifTrue:[
            coll add:(self copyFrom:idx1).
            ^ coll
        ].
        coll add:(self copyFrom:idx1 to:idx2).
        idx1 := idx2 + 1
    ] loop.

    "
     'foo:' partsIfSelector
     'foo:bar:' partsIfSelector
     'foo::::' partsIfSelector
     #foo:bar: partsIfSelector
     'hello' partsIfSelector
     '+' partsIfSelector
    "
! !

!CharacterArray methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceCharacterArray:self level:level from:referrer


! !

!CharacterArray methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitString:with: to aVisitor"

    ^ aVisitor visitString:self with:aParameter
! !


!CharacterArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


CharacterArray initialize!
