"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies' }"

"{ NameSpace: Smalltalk }"

Object subclass:#CharacterEncoderCodeGenerator
	instanceVariableNames:'targetClass codeTable nameTable unicodeTable unicodeNameTable
		minCode maxCode minUnicode maxUnicode firstDiff lastDiff
		firstUnicodeDiff lastUnicodeDiff firstDiffToSuper lastDiffToSuper
		firstUnicodeDiffToSuper lastUnicodeDiffToSuper'
	classVariableNames:'RFC1345Mapping'
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!CharacterEncoderCodeGenerator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CharacterEncoderCodeGenerator class methodsFor:'helpers'!

flushRFC1345Data
    RFC1345Mapping := nil

    "
     self flushRFC1345Data
    "
!

readRFC1345Data
    |fileStream lineStream line rfcName codePoint unicodeName|

    RFC1345Mapping := Dictionary new.

    fileStream := '../../doc/data/rfc1345data' asFilename readStream.
    [fileStream atEnd] whileFalse:[
        line := fileStream nextLine.
        (line startsWith:' ') ifTrue:[
            lineStream := line readStream.
            lineStream skipSeparators.
            rfcName := lineStream upToSeparator.
            lineStream skipSeparators.
            codePoint := Integer readFrom:(lineStream upToSeparator) radix:16.
            lineStream skipSeparators.
            unicodeName := lineStream upToEnd.

            RFC1345Mapping at:rfcName put:codePoint.
        ].
    ].
    fileStream close.

    "
     self readRFC1345Data
    "
!

rfc1345Map
    RFC1345Mapping isNil ifTrue:[
        self readRFC1345Data.
    ].
    ^ RFC1345Mapping
! !

!CharacterEncoderCodeGenerator methodsFor:'accessing'!

targetClass:something
    targetClass := something.
! !

!CharacterEncoderCodeGenerator methodsFor:'charmap file caching'!

mappingSourceFrom:aClass
    "get the source code of a mapping method.
     If not present, loads the mapping table from:
        http://www.unicode.org/Public/MAPPINGS/xxx
     where xxx is provided by the classes mappingURL1 method.
     (see http://www.unicode.org/Public/MAPPINGS/VENDORS/ADOBE/stdenc.txt
      for a typical mapping)"

    |url m response text source|

    m := (aClass class compiledMethodAt:#mapping).
    m isNil ifTrue:[
        url := aClass mappingURL2.
        url notNil ifTrue:[
            response := HTTPInterface get:url.
        ] ifFalse:[
            url := aClass mappingURL1.
            url isNil ifTrue:[
                self error:'neither url1 nor url2 is defined (needed for mappingTables)'.
            ].
            response := HTTPInterface get:url.
        ].
        text := response data.
        text replaceAll:$" with:$'.

        source := 'mapping\"\# From: ' withCRs, url, '\\' withCRs, text , '\"' withCRs.

"/        source size > 30000 ifTrue:[ 
"/            ^ source
"/        ].
        
        "/ compiled codes comment used as a cache.
        aClass class compile:source classified:'mapping'.
        ^ source
    ].
    ^ m source

    "
     ISO8859_1 mappingSource
     ISO8859_2 mappingSource
     ISO8859_3 mappingSource
     KOI8_U mappingSource
     self new mappingSourceFrom:(CharacterEncoderImplementations::MS_Symbol)
     self new mappingSourceFrom:(CharacterEncoderImplementations::AdobeStandard)
    "
! !

!CharacterEncoderCodeGenerator methodsFor:'charmap file parsing'!

mappingTablesFrom:aClass
    "reads and parses the character maps;
     Returns an array with 2 tables:
     - the first maps codes to uniCode
     - the second maps codes to uniCode character names."

    |src codeTable nameTable codeCol|

    "/ the code here reads mappings from unicode.org.
    "/ the i18n charactermaps are read in a separate method.

    codeTable := IdentityDictionary new.
    nameTable := IdentityDictionary new.

    codeCol := aClass mapFileURL1_codeColumn.

    src := self mappingSourceFrom:aClass.
    src readStream linesDo:[:line |
        |l|

        (line startsWith:' &') ifTrue:[
            ^ self readRfc1345CharmapFrom:src.
        ].

        l := line withoutSeparators.
        (l startsWith:'<code_set_name>') ifTrue:[
            ^ self readI18NCharmapFrom:src.
        ].

        (l startsWith:'0x') ifTrue:[
            |s code uniCode characterComment rest columns|

            columns := OrderedCollection new:2.

            s := l readStream.
            s skip:2.
            code := Integer readFrom:s radix:16.
            columns add:code.

            s skipSeparators.
            s peek = $= ifTrue:[
                s next.
                s peek = $> ifTrue:[
                    s next
                ]
            ].
            [(s next:2) = '0x'] whileTrue:[
                code := Integer readFrom:s radix:16.
                columns add:code.
                s skipSeparators.
            ].
            s position:(s position - 2).
            s next == $# ifTrue:[ 
                s skipSeparators.
                characterComment := s upToEnd withoutSeparators.
            ].
            uniCode := columns last.
            code := columns at:codeCol.

            codeTable at:code put:uniCode.
            nameTable at:code put:characterComment.
        ] ifFalse:[
            (l startsWith:'#') ifFalse:[
                (l size >= (4+1+2)) ifTrue:[
                    ((l first:4) conform:[:ch | ch isDigitRadix:16]) ifTrue:[
                        (l at:5) isSeparator ifTrue:[
                            |code uniCode s characterComment|

                            uniCode := Integer readFrom:(l first:4) radix:16.
                            l := l copyFrom:6.
                            l := l withoutSeparators.
                            ((l first:2) conform:[:ch | ch isDigitRadix:16]) ifTrue:[
                                (l at:3) isSeparator ifTrue:[
                                    code := Integer readFrom:(l first:2) radix:16.
                                    l := l copyFrom:4.
                                    l := l withoutSeparators.
                                    l first == $# ifTrue:[ 
                                        s := l readStream. s next.
                                        s skipSeparators.
                                        characterComment := s upToEnd withoutSeparators.
                                    ].
                                    codeTable at:code put:uniCode.
                                    nameTable at:code put:characterComment.
                                ]
                            ]
                        ]
                    ]
                ]
            ].
        ].
    ].
    codeTable isNil ifTrue:[^ nil].
    ^ Array with:codeTable with:nameTable

    "
     self new mappingTablesFrom:(CharacterEncoderImplementations::ISO8859_1)
     self new mappingTablesFrom:(CharacterEncoderImplementations::ISO8859_2).
     self new mappingTablesFrom:(CharacterEncoderImplementations::ISO8859_5).
     self new mappingTablesFrom:(CharacterEncoderImplementations::KOI8_R).
     self new mappingTablesFrom:(CharacterEncoderImplementations::JIS0208).
     self new mappingTablesFrom:(CharacterEncoderImplementations::AdobeStandard).
    "

    "Modified (format): / 16-01-2018 / 19:08:08 / stefan"
!

readI18NCharmapFrom:src
    "q&d hack to read i18n character map files"
    "as an example, see http://std.dkuug.dk/i18n/charmaps/KOI8-U"

    |codeTable nameTable commentChar escapeChar|

    src readStream linesDo:[:line |
	|l|

	l := line withoutSeparators.
	(l startsWith:commentChar) ifTrue:[
	] ifFalse:[
	    (l startsWith:'<') ifTrue:[
		|s w code uniCode characterComment rest|

		s := l readStream.
		w := WriteStream on:(String new:10).
		s next.

		[                                        
		    |ch|
		    [

			ch := s nextOrNil.
			ch == escapeChar ifTrue:[
			    s nextOrNil.
			    true
			] ifFalse:[
			    ch notNil and:[ch ~~ $>] 
			]
		    ] whileTrue:[ w nextPut:ch ].
		] doUntil:[(s atEnd or:[s peek ~~ $>])].
		w := w contents.
		s skipSeparators.
		rest := s upToEnd.
		w = 'code_set_name' ifTrue:[
		] ifFalse:[
		    w = 'comment_char' ifTrue:[
			commentChar := rest first.
		    ] ifFalse:[
			w = 'escape_char' ifTrue:[
			    escapeChar := rest first.
			] ifFalse:[
			    s := rest readStream.
			    s peek == escapeChar ifTrue:[
				s next.
				s peek == $x ifTrue:[
				    s next.
				    code := Integer readFrom:s radix:16.
				    s skipSeparators.
				    s peek == $< ifTrue:[
					s next.
					s peek == $U ifTrue:[
					    s next.
					    uniCode := Integer readFrom:s radix:16.
					    s peek == $> ifTrue:[
						s next.
						s skipSeparators.
						characterComment := s upToEnd withoutSeparators.
						codeTable isNil ifTrue:[
						    codeTable := IdentityDictionary new.
						    nameTable := IdentityDictionary new.
						].
						codeTable at:code put:uniCode.
						nameTable at:code put:characterComment.

					    ] ifFalse:[
						self halt.    
					    ].
					] ifFalse:[
					    self halt.    
					].
				    ] ifFalse:[
					self halt.    
				    ].
				] ifFalse:[
				    self halt.    
				].
			    ] ifFalse:[
				self halt.    
			    ]
			]
		    ]
		].
	    ].
	].
    ].
    codeTable isNil ifTrue:[^ nil].
    ^ Array with:codeTable with:nameTable

    "
     ISO8859_1 mappingTables
     ISO8859_2 mappingTables
     ISO8859_5 mappingTables
     KOI8_U mappingTables
    "
!

readRfc1345CharmapFrom:src
    "q&d hack to read Rfc1345 character map files"

    |in codeTable gotStart nameTable|

    gotStart := false.
    in := src readStream.
    in linesDo:[:line |
        |l|

        l := line withoutSeparators.
        "/ skip for the first line starting with '&'.
        (l startsWith:'&') ifTrue:[
            gotStart := true
        ].
        gotStart ifTrue:[
            (l isEmpty) ifFalse:[
                (l startsWith:'&rem') ifTrue:[
                ] ifFalse:[            
                    (l startsWith:'&charset') ifTrue:[
                    ] ifFalse:[            
self halt.
                    ]
                ]
            ].
        ].
    ].
self halt.
    ^ Array with:codeTable with:nameTable

    "
     self new mappingTablesFrom:(CharacterEncoder::ISO8859_1)
     self new mappingTablesFrom:(CharacterEncoder::ISO8859_2)
     self new mappingTablesFrom:(CharacterEncoder::ISO8859_5)
     self new mappingTablesFrom:(CharacterEncoder::KOI8_U)
     self new mappingTablesFrom:(CharacterEncoder::KOI8_E)
    "

    "Modified (format): / 16-01-2018 / 19:08:34 / stefan"
!

readingUnicodeDataFrom:src do:aBlock
    [src atEnd] whileFalse:[
        |l parts
         codePoint name category canOrd biCat decMap
            decDigitValue digitValue numValue
            mirrored unicodeName comment ucValue lcValue tcValue |

        l := src nextLine.
        parts := l asCollectionOfSubstringsSeparatedBy:$;.

        codePoint := Integer readFrom:(parts at:1) radix:16.
        parts at:1 put:codePoint.

        name      := parts at:2.
        category  := parts at:3.
        canOrd    := parts at:4.
        biCat     := parts at:5.
        decMap    := parts at:6.
        decDigitValue := Integer readFrom:(parts at:7) radix:16 onError:nil.
        parts at:7 put:decDigitValue.
        digitValue    := Integer readFrom:(parts at:8) radix:16 onError:nil.
        parts at:8 put:digitValue.
        numValue    := parts at:9.

        mirrored    := parts at:10.
        mirrored = 'N' 
            ifTrue:[ mirrored := false ]
            ifFalse:[ 
                mirrored = 'Y' 
                    ifTrue:[ mirrored := true ]
                    ifFalse:[ self halt ]].

        unicodeName := parts at:11.
        comment     := parts at:12.
        ucValue     := Integer readFrom:(parts at:13) radix:16 onError:nil.
        parts at:13 put:ucValue.

        lcValue     := Integer readFrom:(parts at:14) radix:16 onError:nil.
        parts at:14 put:lcValue.

        parts size >= 15 ifTrue:[
            tcValue     := Integer readFrom:(parts at:15) radix:16 onError:nil.
        ] ifFalse:[
            parts grow:15.
        ].
        parts at:15 put:tcValue.

        aBlock valueWithArguments:parts asArray.
    ]

    "
     CharacterEncoderCodeGenerator new
        readingUnicodeDataFrom:'/phys/exept/home/documentation/standards/unicode/UnicodeData-3.1.0.txt' asFilename readStream
        do:[:codePoint :name :category :canOrd :biCat :decMap
            :decDigitValue :digitValue :numValue
            :mirrored :unicodeName :comment :ucValue :lcValue :tcValue |
        ].
    "

    "
     |testData|

     testData := '0061;LATIN SMALL LETTER A;Ll;0;L;;;;;N;;;0041;;0041'.
     CharacterEncoderCodeGenerator new
        readingUnicodeDataFrom:testData readStream
        do:[:codePoint :name :category :canOrd :biCat :decMap
            :decDigitValue :digitValue :numValue
            :mirrored :unicodeName :comment :ucValue :lcValue :tcValue |
self halt.
        ].
    "

    "
     |testData|

    testData := 
'0020;SPACE;Zs;0;WS;;;;;N;;;;;
0021;EXCLAMATION MARK;Po;0;ON;;;;;N;;;;;
0022;QUOTATION MARK;Po;0;ON;;;;;N;;;;;
0023;NUMBER SIGN;Po;0;ET;;;;;N;;;;;
0024;DOLLAR SIGN;Sc;0;ET;;;;;N;;;;;
0025;PERCENT SIGN;Po;0;ET;;;;;N;;;;;
0026;AMPERSAND;Po;0;ON;;;;;N;;;;;
0027;APOSTROPHE;Po;0;ON;;;;;N;APOSTROPHE-QUOTE;;;;
0028;LEFT PARENTHESIS;Ps;0;ON;;;;;Y;OPENING PARENTHESIS;;;;
0029;RIGHT PARENTHESIS;Pe;0;ON;;;;;Y;CLOSING PARENTHESIS;;;;
002A;ASTERISK;Po;0;ON;;;;;N;;;;;
002B;PLUS SIGN;Sm;0;ET;;;;;N;;;;;
002C;COMMA;Po;0;CS;;;;;N;;;;;
002D;HYPHEN-MINUS;Pd;0;ET;;;;;N;;;;;
002E;FULL STOP;Po;0;CS;;;;;N;PERIOD;;;;
002F;SOLIDUS;Po;0;ES;;;;;N;SLASH;;;;
0030;DIGIT ZERO;Nd;0;EN;;0;0;0;N;;;;;
0031;DIGIT ONE;Nd;0;EN;;1;1;1;N;;;;;
0032;DIGIT TWO;Nd;0;EN;;2;2;2;N;;;;;
0033;DIGIT THREE;Nd;0;EN;;3;3;3;N;;;;;
0034;DIGIT FOUR;Nd;0;EN;;4;4;4;N;;;;;
0035;DIGIT FIVE;Nd;0;EN;;5;5;5;N;;;;;
0036;DIGIT SIX;Nd;0;EN;;6;6;6;N;;;;;
0037;DIGIT SEVEN;Nd;0;EN;;7;7;7;N;;;;;
0038;DIGIT EIGHT;Nd;0;EN;;8;8;8;N;;;;;
0039;DIGIT NINE;Nd;0;EN;;9;9;9;N;;;;;
003A;COLON;Po;0;CS;;;;;N;;;;;
003B;SEMICOLON;Po;0;ON;;;;;N;;;;;
003C;LESS-THAN SIGN;Sm;0;ON;;;;;Y;;;;;
003D;EQUALS SIGN;Sm;0;ON;;;;;N;;;;;
003E;GREATER-THAN SIGN;Sm;0;ON;;;;;Y;;;;;
003F;QUESTION MARK;Po;0;ON;;;;;N;;;;;
0040;COMMERCIAL AT;Po;0;ON;;;;;N;;;;;
0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;
0042;LATIN CAPITAL LETTER B;Lu;0;L;;;;;N;;;;0062;
0043;LATIN CAPITAL LETTER C;Lu;0;L;;;;;N;;;;0063;
0044;LATIN CAPITAL LETTER D;Lu;0;L;;;;;N;;;;0064;
0045;LATIN CAPITAL LETTER E;Lu;0;L;;;;;N;;;;0065;
0046;LATIN CAPITAL LETTER F;Lu;0;L;;;;;N;;;;0066;
0047;LATIN CAPITAL LETTER G;Lu;0;L;;;;;N;;;;0067;
0048;LATIN CAPITAL LETTER H;Lu;0;L;;;;;N;;;;0068;
0049;LATIN CAPITAL LETTER I;Lu;0;L;;;;;N;;;;0069;
004A;LATIN CAPITAL LETTER J;Lu;0;L;;;;;N;;;;006A;
004B;LATIN CAPITAL LETTER K;Lu;0;L;;;;;N;;;;006B;
004C;LATIN CAPITAL LETTER L;Lu;0;L;;;;;N;;;;006C;
004D;LATIN CAPITAL LETTER M;Lu;0;L;;;;;N;;;;006D;
004E;LATIN CAPITAL LETTER N;Lu;0;L;;;;;N;;;;006E;
004F;LATIN CAPITAL LETTER O;Lu;0;L;;;;;N;;;;006F;
0050;LATIN CAPITAL LETTER P;Lu;0;L;;;;;N;;;;0070;
0051;LATIN CAPITAL LETTER Q;Lu;0;L;;;;;N;;;;0071;
0052;LATIN CAPITAL LETTER R;Lu;0;L;;;;;N;;;;0072;
0053;LATIN CAPITAL LETTER S;Lu;0;L;;;;;N;;;;0073;
0054;LATIN CAPITAL LETTER T;Lu;0;L;;;;;N;;;;0074;
0055;LATIN CAPITAL LETTER U;Lu;0;L;;;;;N;;;;0075;
0056;LATIN CAPITAL LETTER V;Lu;0;L;;;;;N;;;;0076;
0057;LATIN CAPITAL LETTER W;Lu;0;L;;;;;N;;;;0077;
0058;LATIN CAPITAL LETTER X;Lu;0;L;;;;;N;;;;0078;
0059;LATIN CAPITAL LETTER Y;Lu;0;L;;;;;N;;;;0079;
005A;LATIN CAPITAL LETTER Z;Lu;0;L;;;;;N;;;;007A;
005B;LEFT SQUARE BRACKET;Ps;0;ON;;;;;Y;OPENING SQUARE BRACKET;;;;
005C;REVERSE SOLIDUS;Po;0;ON;;;;;N;BACKSLASH;;;;
005D;RIGHT SQUARE BRACKET;Pe;0;ON;;;;;Y;CLOSING SQUARE BRACKET;;;;
005E;CIRCUMFLEX ACCENT;Sk;0;ON;;;;;N;SPACING CIRCUMFLEX;;;;
005F;LOW LINE;Pc;0;ON;;;;;N;SPACING UNDERSCORE;;;;
0060;GRAVE ACCENT;Sk;0;ON;;;;;N;SPACING GRAVE;;;;
0061;LATIN SMALL LETTER A;Ll;0;L;;;;;N;;;0041;;0041
0062;LATIN SMALL LETTER B;Ll;0;L;;;;;N;;;0042;;0042
0063;LATIN SMALL LETTER C;Ll;0;L;;;;;N;;;0043;;0043
0064;LATIN SMALL LETTER D;Ll;0;L;;;;;N;;;0044;;0044
0065;LATIN SMALL LETTER E;Ll;0;L;;;;;N;;;0045;;0045
0066;LATIN SMALL LETTER F;Ll;0;L;;;;;N;;;0046;;0046
0067;LATIN SMALL LETTER G;Ll;0;L;;;;;N;;;0047;;0047
0068;LATIN SMALL LETTER H;Ll;0;L;;;;;N;;;0048;;0048
0069;LATIN SMALL LETTER I;Ll;0;L;;;;;N;;;0049;;0049
006A;LATIN SMALL LETTER J;Ll;0;L;;;;;N;;;004A;;004A
006B;LATIN SMALL LETTER K;Ll;0;L;;;;;N;;;004B;;004B
006C;LATIN SMALL LETTER L;Ll;0;L;;;;;N;;;004C;;004C
006D;LATIN SMALL LETTER M;Ll;0;L;;;;;N;;;004D;;004D
006E;LATIN SMALL LETTER N;Ll;0;L;;;;;N;;;004E;;004E
006F;LATIN SMALL LETTER O;Ll;0;L;;;;;N;;;004F;;004F
0070;LATIN SMALL LETTER P;Ll;0;L;;;;;N;;;0050;;0050
0071;LATIN SMALL LETTER Q;Ll;0;L;;;;;N;;;0051;;0051
0072;LATIN SMALL LETTER R;Ll;0;L;;;;;N;;;0052;;0052
0073;LATIN SMALL LETTER S;Ll;0;L;;;;;N;;;0053;;0053
0074;LATIN SMALL LETTER T;Ll;0;L;;;;;N;;;0054;;0054
0075;LATIN SMALL LETTER U;Ll;0;L;;;;;N;;;0055;;0055
0076;LATIN SMALL LETTER V;Ll;0;L;;;;;N;;;0056;;0056
0077;LATIN SMALL LETTER W;Ll;0;L;;;;;N;;;0057;;0057
0078;LATIN SMALL LETTER X;Ll;0;L;;;;;N;;;0058;;0058
0079;LATIN SMALL LETTER Y;Ll;0;L;;;;;N;;;0059;;0059
007A;LATIN SMALL LETTER Z;Ll;0;L;;;;;N;;;005A;;005A
007B;LEFT CURLY BRACKET;Ps;0;ON;;;;;Y;OPENING CURLY BRACKET;;;;
007C;VERTICAL LINE;Sm;0;ON;;;;;N;VERTICAL BAR;;;;
007D;RIGHT CURLY BRACKET;Pe;0;ON;;;;;Y;CLOSING CURLY BRACKET;;;;
007E;TILDE;Sm;0;ON;;;;;N;;;;;
'.
     CharacterEncoderCodeGenerator new
        readingUnicodeDataFrom:testData readStream
        do:[:codePoint :name :category :canOrd :biCat :decMap
            :decDigitValue :digitValue :numValue
            :mirrored :unicodeName :comment :ucValue :lcValue :tcValue |
        ].
    "
!

xxx
    |lcToUcDeltas ucToLcDeltas tcToUcDeltas tcToLcDeltas numLcToUcDeltas numUcToLcDeltas categories bidiCategories mapTable|

    lcToUcDeltas := Bag new.
    ucToLcDeltas := Bag new.
    tcToUcDeltas := Bag new.
    tcToLcDeltas := Bag new.
    categories := Set new.
    bidiCategories := Set new.

    self 
        readingUnicodeDataFrom:
            "/ '/phys/exept/home/documentation/standards/unicode/UnicodeData-3.1.0.txt'    
            '/phys/exept/home/documentation/standards/unicode/UnicodeData-4.0.0.txt'    
            asFilename readStream
        do:[:codePoint :name :category :canOrd :bidiCat :decMap
            :decDigitValue :digitValue :numValue
            :mirrored :unicodeName :comment :ucValue :lcValue :tcValue |
                |isUppercase isLowercase isTitlecase isLetter dToUc dToLc|

                categories add:category.
                bidiCategories add:bidiCat.
                isUppercase := category = 'Lu'.
                isLowercase := category = 'Ll'.
                isTitlecase := category = 'Lt'.
                isLetter := isUppercase | isLowercase | isTitlecase
                            or:[(category = 'Lm') or:[(category = 'Lo')]].

                ucValue notNil ifTrue:[
                    dToUc := ucValue - codePoint.
                    isLowercase ifTrue:[
                        lcToUcDeltas add:dToUc.
                    ] ifFalse:[
                        isTitlecase ifTrue:[
                            tcToUcDeltas add:dToUc.
                        ] ifFalse:[
                            "/ self halt.
                        ]
                    ]
                ].
                lcValue notNil ifTrue:[
                    dToLc := lcValue - codePoint.
                    isUppercase ifTrue:[
                        ucToLcDeltas add:dToLc.
                    ] ifFalse:[
                        isTitlecase ifTrue:[
                            tcToLcDeltas add:dToLc.
                        ] ifFalse:[
                            "/ self halt.
                        ]
                    ]
                ].
        ].

    lcToUcDeltas := lcToUcDeltas contents.
    ucToLcDeltas := ucToLcDeltas contents.
    lcToUcDeltas := lcToUcDeltas associations sort:[:a :b | a value < b value].
    ucToLcDeltas := ucToLcDeltas associations sort:[:a :b | a value < b value].
    numLcToUcDeltas := lcToUcDeltas size.
    numUcToLcDeltas := ucToLcDeltas size.

    
    "/ generate characterCategory tables
    "/ need information for:
    "/  isLetter/isUpper/isLower
    "/  isRightToLeft
    mapTable := ByteArray new:16rFFFF.
    self 
        readingUnicodeDataFrom:'/phys/exept/home/documentation/standards/unicode/UnicodeData-3.1.0.txt' asFilename readStream
        do:[:codePoint :name :category :canOrd :bidiCat :decMap
            :decDigitValue :digitValue :numValue
            :mirrored :unicodeName :comment :ucValue :lcValue :tcValue |
        ].

self halt.

    "
     CharacterEncoderCodeGenerator new xxx
    "
! !

!CharacterEncoderCodeGenerator methodsFor:'code generation - lookup'!

generateDirectTableLookupFor:codeTable nameTable:nameTable from:firstIndex to:lastIndex varName:codeVar errorCode:errorCode indent:indentArg onto:stream
    "/ generate direct table lookup

    |maxElement useByteArray valPad anyInvalid anyDifferent usedElements invalidMarker indent code unicode unicodeCharacterName|

    indent := indentArg.

    firstIndex == lastIndex ifTrue:[
        code := firstIndex.
        unicode := codeTable at:code ifAbsent:nil.
        unicodeCharacterName := nameTable at:code ifAbsent:nil.
        unicode isNil ifTrue:[
            unicodeCharacterName := 'invalid'.
        ].
        unicode isNil ifTrue:[
            stream spaces:indent; nextPutLine:errorCode.
        ] ifFalse:[
            stream spaces:indent; nextPutAll:'^ '.
            stream nextPutAll:' "' , '16r' , ((code printStringRadix:16) leftPaddedTo:4 with:$0).
            stream nextPutAll:'" ' , '16r' , ((unicode printStringRadix:16) leftPaddedTo:4 with:$0).
            unicodeCharacterName notNil ifTrue:[
                stream nextPutAll:' " ' , unicodeCharacterName , ' " '.
            ].
            stream cr.
        ].
        ^ self
    ].

    anyInvalid := anyDifferent := false.
    usedElements := IdentitySet new.
    maxElement := -1.
    firstIndex to:lastIndex do:[:code |
        |unicode|

        unicode := codeTable at:code ifAbsent:nil.
        unicode ~~ code ifTrue:[anyDifferent := true].
        unicode notNil ifTrue:[
            usedElements add:unicode.
            maxElement := maxElement max:unicode.  
        ] ifFalse:[
            anyInvalid := true.
        ]
    ].
    anyDifferent ifFalse:[
        stream spaces:indent; nextPutAll:'^ '; nextPutAll:codeVar; cr.
        ^ self
    ].

    useByteArray := maxElement <= 255.

    (usedElements includes:0) ifFalse:[
        invalidMarker := 0.
    ] ifTrue:[
        useByteArray ifTrue:[
            (usedElements includes:255) ifFalse:[
                invalidMarker := 255.
            ] ifTrue:[
                invalidMarker := (1 to:255) detect:[:n | (usedElements includes:n) not].
            ].
        ] ifFalse:[
            (usedElements includes:16rFFFF) ifFalse:[
                invalidMarker := 16rFFFF.
            ] ifTrue:[
                invalidMarker := maxElement + 1.
            ]
        ].
    ].

    anyInvalid ifTrue:[
        stream spaces:indent; nextPutLine:'['.
        indent := indent + 4.
        stream spaces:indent; nextPutLine:'|t|'.
        stream spaces:indent; nextPutAll:'t := '.
    ] ifFalse:[
        stream spaces:indent; nextPutAll:'^ '.
    ].
    useByteArray ifTrue:[
        valPad := 2.
        stream nextPutLine:'#['.
    ] ifFalse:[
        valPad := 4.
        stream nextPutLine:'#('.
    ].
    firstIndex to:lastIndex do:[:code |
        |unicode unicodeCharacterName|

        unicode := codeTable at:code ifAbsent:nil.
        unicodeCharacterName := nameTable at:code ifAbsent:nil.
        unicode isNil ifTrue:[
            unicode := invalidMarker.
            unicodeCharacterName := 'invalid'.
        ].
        stream spaces:indent; nextPutAll:'   "' , '16r' , ((code printStringRadix:16) leftPaddedTo:4 with:$0).
        stream nextPutAll:'"    ' , '16r' , ((unicode printStringRadix:16) leftPaddedTo:valPad with:$0).
        unicodeCharacterName notNil ifTrue:[
            stream nextPutAll:' " ' , unicodeCharacterName , ' " '.
        ].
        stream cr.
    ].
    useByteArray ifTrue:[
        stream spaces:indent; nextPutAll:'   ]'.
    ] ifFalse:[
        stream spaces:indent; nextPutAll:'   )'.
    ].
    firstIndex == 0 ifTrue:[
        stream nextPutLine:' at:(',codeVar,' + 1).'.
    ] ifFalse:[
        stream nextPutLine:' at:(',codeVar,' - ' , ((firstIndex-1) radixPrintStringRadix:16) , ').'.
    ].

    anyInvalid ifTrue:[
        stream spaces:indent; nextPutLine:'t == ',invalidMarker printString,' ifFalse:[^ t].'.
        stream spaces:indent; nextPutLine:errorCode.
        indent := indent - 4.
        stream spaces:indent; nextPutLine:'] value.'.
    ].
!

generateLookupFor:codeTable nameTable:nameTable from:firstIndex to:lastIndex varName:codeVar errorCode:errorCode indent:indent onto:stream
    |info info2 fillRatio firstValidNonIdentical lastValidNonIdentical|

    firstIndex == lastIndex ifTrue:[ 
        fillRatio := 1. 
    ] ifFalse:[
        info := self mapInfoFor:codeTable from:firstIndex to:lastIndex.
        fillRatio := info validRangeSize / info domainSize.
    ].


    (info notNil
    and:[firstIndex == info firstDiff]) ifTrue:[
        info2 := self mapInfoFor:codeTable from:firstIndex+1 to:lastIndex.
        (firstIndex+1 to:info2 firstDiff-1) size >= 20 ifTrue:[
            "/ single difference at the beginning, followed by a larger block of identities
            stream spaces:indent; nextPutLine:codeVar,' == ', (firstIndex radixPrintStringRadix:16),' ifTrue:['.
            self 
                generateLookupFor:codeTable nameTable:nameTable from:firstIndex to:firstIndex varName:codeVar 
                errorCode:errorCode 
                indent:indent+4 onto:stream.
            stream spaces:indent; nextPutLine:'].'.
            self 
                generateLookupFor:codeTable nameTable:nameTable from:firstIndex+1 to:lastIndex varName:codeVar 
                errorCode:errorCode 
                indent:indent onto:stream.
            ^ self.
        ]
    ].

    fillRatio < 1 ifTrue:[
        "/ some mappings are invalid
        firstIndex == (info firstInvalid-1) ifTrue:[
            info2 := self mapInfoFor:codeTable from:firstIndex+1 to:lastIndex.
            (firstIndex+1 to:info2 firstInvalid-1) size >= 20 ifTrue:[
                "/ single difference at the beginning, followed by a larger block of identities
                stream spaces:indent; nextPutLine:codeVar,' == ', (firstIndex radixPrintStringRadix:16),' ifTrue:['.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:firstIndex to:firstIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent+4 onto:stream.
                stream spaces:indent; nextPutLine:'].'.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:firstIndex+1 to:lastIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent onto:stream.
                ^ self.
            ]
        ].

        info firstInvalid == firstIndex ifTrue:[
            "/ invalid block at beginning...
            (firstIndex to:info firstValid-1) size >= 10 ifTrue:[
                stream spaces:indent; nextPutLine:codeVar,' <= ', ((info firstValid - 1) radixPrintStringRadix:16),' ifTrue:['.
                stream spaces:indent+4; nextPutLine:errorCode.
                stream spaces:indent; nextPutLine:'].'.

                self 
                    generateLookupFor:codeTable nameTable:nameTable from:(info firstValid) to:lastIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent onto:stream.
                ^ self.
            ].
        ].

        info lastInvalid == lastIndex ifTrue:[
            "/ invalid block at the end...
self halt.
        ].

        (info largestInvalidBlock size) / (firstIndex to:lastIndex) size > 0.3 ifTrue:[
            (info largestInvalidBlock size) > 15 ifTrue:[
                "/ big invalid block in the middle...
                firstIndex == (info largestInvalidBlock start-1) ifTrue:[
                    stream spaces:indent; nextPutLine:codeVar,' == ', (firstIndex radixPrintStringRadix:16),' ifTrue:['.
                ] ifFalse:[
                    stream spaces:indent; nextPutLine:codeVar,' <= ',((info largestInvalidBlock start - 1) radixPrintStringRadix:16),' ifTrue:['.
                ].
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:firstIndex to:(info largestInvalidBlock start-1) varName:codeVar 
                    errorCode:errorCode 
                    indent:indent+4 onto:stream.
                stream spaces:indent; nextPutLine:'].'.
                "/ invalid block...
                stream spaces:indent; nextPutLine:codeVar,' <= ',(info largestInvalidBlock stop radixPrintStringRadix:16),' ifTrue:['.
                stream spaces:indent+4; nextPutLine:errorCode.
                stream spaces:indent; nextPutLine:'].'.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:(info largestInvalidBlock stop+1) to:lastIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent onto:stream.
                ^ self.
            ].
        ].

        info domainSize > 40 ifTrue:[
            "/ is there a part of the mapping which is either identity-mapping or error ?
            firstValidNonIdentical := (firstIndex to:lastIndex) detect:[:idx | (codeTable at:idx ifAbsent:idx) ~~ idx] ifNone:nil.

            firstValidNonIdentical isNil ifTrue:[
                "/ wow - all should be done this way
                self 
                    generateLookupForIdenticalOrInvalid:codeTable nameTable:nameTable from:firstIndex to:lastIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent+4 onto:stream.
                ^ self.
            ].

            (firstIndex to:firstValidNonIdentical-1) size > 40 ifTrue:[
                stream spaces:indent; nextPutLine:codeVar,' <= ',((firstValidNonIdentical - 1) radixPrintStringRadix:16),' ifTrue:['.
                self 
                    generateLookupForIdenticalOrInvalid:codeTable nameTable:nameTable from:firstIndex to:firstValidNonIdentical-1 varName:codeVar 
                    errorCode:errorCode 
                    indent:indent+4 onto:stream.
                stream spaces:indent; nextPutLine:'].'.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:firstValidNonIdentical to:lastIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent onto:stream.
                ^ self.
            ].

            lastValidNonIdentical := (lastIndex to:firstIndex by:-1) detect:[:idx | (codeTable at:idx ifAbsent:idx) ~~ idx] ifNone:nil.
            (lastValidNonIdentical+1 to:lastIndex) size > 40 ifTrue:[
self halt.
            ].

            info largestInvalidBlock size > 40 ifTrue:[
                stream spaces:indent; nextPutLine:codeVar,' <= ',((info largestInvalidBlock start - 1) radixPrintStringRadix:16),' ifTrue:['.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:firstIndex to:(info largestInvalidBlock start-1) varName:codeVar 
                    errorCode:errorCode 
                    indent:indent+4 onto:stream.
                stream spaces:indent; nextPutLine:'].'.
                "/ invalid block...
                stream spaces:indent; nextPutLine:codeVar,' <= ',(info largestInvalidBlock stop radixPrintStringRadix:16),' ifTrue:['.
                stream spaces:indent+4; nextPutLine:errorCode.
                stream spaces:indent; nextPutLine:'].'.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:(info largestInvalidBlock stop+1) to:lastIndex varName:codeVar 
                    errorCode:errorCode 
                    indent:indent onto:stream.
                ^ self.
            ].
            "/ how would it look if we did it in parts/page-wise ?
"/            fillRatio < 0.5 ifTrue:[
"/            ].
"/ self halt.
        ] ifFalse:[
            info firstInvalid == (firstIndex+1) ifTrue:[
                info largestInvalidBlock start == info firstInvalid ifTrue:[
                    "/ a single valid item followed by an invalid block
                    info largestInvalidBlock size >= 10 ifTrue:[
                        stream spaces:indent; nextPutLine:codeVar,' == ', (firstIndex radixPrintStringRadix:16),' ifTrue:['.
                        self 
                            generateLookupForIdenticalOrInvalid:codeTable nameTable:nameTable from:firstIndex to:firstIndex varName:codeVar 
                            errorCode:errorCode 
                            indent:indent+4 onto:stream.
                        stream spaces:indent; nextPutLine:'].'.
                        self 
                            generateLookupFor:codeTable nameTable:nameTable from:firstIndex+1 to:lastIndex varName:codeVar 
                            errorCode:errorCode 
                            indent:indent onto:stream.
                        ^ self.
                    ]
                ]
            ].
            info lastInvalid == (lastIndex-1) ifTrue:[
                info largestInvalidBlock stop == info lastInvalid ifTrue:[
                    info largestInvalidBlock size >= 10 ifTrue:[
self halt.
                    ]
                ]
            ].
"/ self halt.
        ]
    ].

    self 
        generateDirectTableLookupFor:codeTable nameTable:nameTable from:firstIndex to:lastIndex varName:codeVar 
        errorCode:errorCode 
        indent:indent onto:stream
!

generateLookupForIdenticalOrInvalid:codeTable nameTable:nameTable from:firstIndex to:lastIndex varName:codeVar errorCode:errorCode indent:indent onto:stream
    "/ generate flag lookup for either identity or invalid

    stream spaces:indent; nextPutLine:'(#['.
    firstIndex to:lastIndex do:[:code |
        |unicode unicodeCharacterName flag|

        unicode := codeTable at:code ifAbsent:nil.
        unicodeCharacterName := nameTable at:code ifAbsent:nil.
        unicode notNil ifTrue:[
            flag := 1
        ] ifFalse:[
            flag := 0.
            unicodeCharacterName := 'invalid'.
        ].
        stream spaces:indent; nextPutAll:'   "' , '16r' , ((code printStringRadix:16) leftPaddedTo:4 with:$0).
        stream nextPutAll:'"    ' , flag printString.
        unicodeCharacterName notNil ifTrue:[
            stream nextPutAll:' " ' , unicodeCharacterName , ' " '.
        ].
        stream cr.
    ].
    stream spaces:indent; nextPutLine:'] at:(',codeVar,' - ' , (firstIndex-1) printString , ')) ~~ 0 ifTrue:[^ ',codeVar,'].'.
    stream spaces:indent; nextPutLine:errorCode.
! !

!CharacterEncoderCodeGenerator methodsFor:'code generation - private'!

generateDecodeMethod
    |source m limit|

    "/ do not overwrite handwritten methods...
    m := targetClass compiledMethodAt:#'decode:'.
    (m notNil and:[((m comment ? '') includesString:'Automagically generated') not]) ifTrue:[
        self warn:'Will not overwrite handwritten code.'
    ] ifFalse:[
        "/ generate the decoder...

        source := WriteStream on:(String new:200).
        source nextPutLine:'decode:codeArg'.
        source nextPutLine:'    "Automagically generated by generateCode - do not modify.'.
        source nextPutLine:'     Decode from my encoding into unicode."'.
        source nextPutLine:''.
        source nextPutLine:'    |code "{ Class: SmallInteger }"|'.
        source nextPutLine:''.
        source nextPutLine:'    code := codeArg.'.

        firstDiff isNil ifTrue:[
            minCode ~~ 0 ifTrue:[
                source nextPutLine:'    code <= ' , ((minCode-1) radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self decodingError.'.
                source nextPutLine:'    ].'.
            ].
            true "maxCode ~~ 255" ifTrue:[
                source nextPutLine:'    code > ' , (maxCode radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self decodingError.'.
                source nextPutLine:'    ].'.
            ].
            source nextPutLine:'    ^ code.'.
        ] ifFalse:[
            minCode ~~ 0 ifTrue:[
                source nextPutLine:'    code <= ' , ((minCode-1) radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self decodingError.'.
                source nextPutLine:'    ].'.
            ].
            firstDiff > minCode ifTrue:[
                source nextPutLine:'    code <= ' , ((firstDiff-1) radixPrintStringRadix:16) , ' ifTrue:[ ^ code ].'.
            ].
            true "maxCode ~~ 255" ifTrue:[
                source nextPutLine:'    code > ' , (maxCode radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self decodingError.'.
                source nextPutLine:'    ].'.
            ].
            lastDiff > maxCode ifTrue:[
                source nextPutLine:'    code > ' , (lastDiff radixPrintStringRadix:16) , ' ifTrue:[ ^ code ].'.
                limit := lastDiff
            ] ifFalse:[
                limit := maxCode.
            ].
            self 
                generateLookupFor:codeTable nameTable:nameTable from:firstDiff to:limit varName:'code' 
                errorCode:'^ self decodingError.' 
                indent:4 onto:source.
        ].

        targetClass
            compile:source contents
            classified:'encoding & decoding'
            logged:false.
    ].
!

generateDecodeMethodForSubclassWithDifferences:diffsToSuperClassEncoding
    |source m indent remainingEncodings|

    "/ do not overwrite handwritten methods...
    m := targetClass compiledMethodAt:#'decode:'.
    (m notNil and:[((m comment ? '') includesString:'Automagically generated') not]) ifTrue:[
        self warn:'Will not overwrite handwritten code.'
    ] ifFalse:[
        "/ generate the decoder...

        source := WriteStream on:(String new:200).
        source nextPutLine:'decode:codeArg'.
        source nextPutLine:'    "Automagically generated by generateCode - do not modify.'.
        source nextPutLine:'     Decode from my encoding into unicode."'.
        source nextPutLine:''.
        source nextPutLine:'    |code "{ Class: SmallInteger }"|'.
        source nextPutLine:''.
        source nextPutLine:'    code := codeArg.'.
        indent := 4.
        firstDiffToSuper ~~ 0 ifTrue:[
            source spaces:indent; nextPutLine:'code > ' , ((firstDiffToSuper-1) radixPrintStringRadix:16) , ' ifTrue:['.
            indent := indent + 4.
        ].
        lastDiffToSuper ~~ maxCode ifTrue:[
            source spaces:indent; nextPutLine:'code <= ' , (lastDiffToSuper radixPrintStringRadix:16) , ' ifTrue:['.
            indent := indent + 4.
        ].


        diffsToSuperClassEncoding size <= ((firstDiffToSuper to:lastDiffToSuper) size * 30) ifTrue:[
            remainingEncodings := diffsToSuperClassEncoding asSortedCollection.
            remainingEncodings do:[:eachDifferentCode |
                source spaces:indent; nextPutLine:'code == ' , (eachDifferentCode radixPrintStringRadix:16) , ' ifTrue:['.
                self 
                    generateLookupFor:codeTable nameTable:nameTable from:eachDifferentCode to:eachDifferentCode varName:'code' 
                    errorCode:nil 
                    indent:indent+4 onto:source.
                source spaces:indent; nextPutLine:'].'.
            ].
        ] ifFalse:[
            self 
                generateLookupFor:codeTable nameTable:nameTable from:firstDiffToSuper to:lastDiffToSuper varName:'code' 
                errorCode:'^ self decodingError.' 
                indent:indent onto:source.
        ].
        lastDiffToSuper ~~ maxCode ifTrue:[
            indent := indent - 4.
            source spaces:indent; nextPutLine:'].'.
        ].
        firstDiffToSuper ~~ 0 ifTrue:[
            indent := indent - 4.
            source spaces:indent; nextPutLine:'].'.
        ].
        source spaces:indent; nextPutLine:'^ super decode:code'.
        
        targetClass
            compile:source contents
            classified:'encoding & decoding'
            logged:false.
    ].
!

generateEncodeMethod
    |source m|

    m := targetClass compiledMethodAt:#'encode:'.
    (m notNil and:[((m comment ? '') includesString:'Automagically generated') not]) ifTrue:[
        self warn:'Will not overwrite handwritten code.'
    ] ifFalse:[

        "/ generate the encoder...

        source := WriteStream on:(String new:200).
        source nextPutLine:'encode:unicodeArg'.
        source nextPutLine:'    "Automagically generated by generateCode - do not modify.'.
        source nextPutLine:'     Encode from unicode into my encoding."'.
        source nextPutLine:''.
        source nextPutLine:'    |unicode "{ Class: SmallInteger }"|'.
        source nextPutLine:''.
        source nextPutLine:'    unicode := unicodeArg.'.
        firstDiff isNil ifTrue:[
            minUnicode ~~ 0 ifTrue:[
                source nextPutLine:'    unicode <= ' , ((minUnicode-1) radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self encodingError.'.
                source nextPutLine:'    ].'.
            ].
            true "maxUnicode ~~ 255" ifTrue:[
                source nextPutLine:'    unicode > ' , (maxUnicode radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self encodingError.'.
                source nextPutLine:'    ].'.
            ].
            source nextPutLine:'    ^ unicode.'.
        ] ifFalse:[
            minUnicode ~~ 0 ifTrue:[
                source nextPutLine:'    unicode <= ' , ((minUnicode-1) radixPrintStringRadix:16) , ' ifTrue:['.
                source nextPutLine:'        ^ self decodingError.'.
                source nextPutLine:'    ].'.
            ].
            firstUnicodeDiff > minUnicode ifTrue:[
                source nextPutLine:'    unicode <= ' , ((firstUnicodeDiff-1) radixPrintStringRadix:16) , ' ifTrue:[ ^ unicode ].'.
            ].
            source nextPutLine:'    unicode > ' , (maxUnicode radixPrintStringRadix:16) , ' ifTrue:['.
            source nextPutLine:'        ^ self encodingError.'.
            source nextPutLine:'    ].'.
            lastDiff > maxCode ifTrue:[
                source nextPutLine:'    unicode > ' , (lastUnicodeDiff radixPrintStringRadix:16) , ' ifTrue:[ ^ unicode ].'.
            ].

            self 
                generateLookupFor:unicodeTable nameTable:unicodeNameTable from:firstUnicodeDiff to:lastUnicodeDiff varName:'unicode' 
                errorCode:'^ self encodingError'  
                indent:4 onto:source.
        ].

        targetClass
            compile:source contents
            classified:'encoding & decoding'
            logged:false.
    ].

    "
     ISO8859_1 flushCode; generateCode
     ISO8859_2 flushCode; generateCode
     KOI8_U flushCode; generateCode
     NEXT flushCode; generateCode
    "
!

generateEncodeMethodForSubclassWithDifferences:diffsToSuperClassEncoding
    |source m indent invalidEncodings remainingEncodings|

    m := targetClass compiledMethodAt:#'encode:'.
    (m notNil and:[((m comment ? '') includesString:'Automagically generated') not]) ifTrue:[
        self warn:'Will not overwrite handwritten code.'
    ] ifFalse:[

        "/ generate the encoder...

        source := WriteStream on:(String new:200).
        source nextPutLine:'encode:unicodeArg'.
        source nextPutLine:'    "Automagically generated by generateCode - do not modify.'.
        source nextPutLine:'     Encode from unicode into my encoding."'.
        source nextPutLine:''.
        source nextPutLine:'    |unicode "{ Class: SmallInteger }"|'.
        source nextPutLine:''.
        source nextPutLine:'    unicode := unicodeArg.'.

        indent := 4.
        firstUnicodeDiffToSuper ~~ 0 ifTrue:[
            source spaces:indent; nextPutLine:'unicode > ' , ((firstUnicodeDiffToSuper-1) radixPrintStringRadix:16) , ' ifTrue:['.
            indent := indent + 4.
        ].
        lastUnicodeDiffToSuper ~~ maxUnicode ifTrue:[
            source spaces:indent; nextPutLine:'unicode <= ' , (lastUnicodeDiffToSuper radixPrintStringRadix:16) , ' ifTrue:['.
            indent := indent + 4.
        ].

        diffsToSuperClassEncoding size <= ((firstUnicodeDiffToSuper to:lastUnicodeDiffToSuper) size * 30) ifTrue:[
            remainingEncodings := diffsToSuperClassEncoding.

            invalidEncodings := diffsToSuperClassEncoding select:[:eachDifferentCode | (unicodeTable includesKey:eachDifferentCode) not].
            invalidEncodings size > 1 ifTrue:[
                |first|

                first := true.
                invalidEncodings do:[:eachInvalidCode |
                    first ifTrue:[
                        source spaces:indent; nextPutAll:'('.
                        first := false.
                    ] ifFalse:[
                        source cr; spaces:indent+1; nextPutAll:'or:['.
                    ].
                    source nextPutAll:'(unicode == ' , (eachInvalidCode radixPrintStringRadix:16) , ')'.
                ].
                (invalidEncodings size - 1) timesRepeat:[source nextPutAll:']'].
                source nextPutLine:') ifTrue:['.
                source spaces:indent+4; nextPutLine:'^ self decodingError.'.
                source spaces:indent; nextPutLine:'].'.

                remainingEncodings := diffsToSuperClassEncoding asSet. 
                remainingEncodings removeAll:invalidEncodings.
                remainingEncodings := remainingEncodings asSortedCollection.
            ].

            remainingEncodings do:[:eachDifferentCode |
                source spaces:indent; nextPutLine:'unicode == ' , (eachDifferentCode radixPrintStringRadix:16) , ' ifTrue:['.
                self 
                    generateLookupFor:unicodeTable nameTable:unicodeNameTable from:eachDifferentCode to:eachDifferentCode varName:'unicode' 
                    errorCode:'^ self decodingError.' 
                    indent:indent+4 onto:source.
                source spaces:indent; nextPutLine:'].'.
            ].
        ] ifFalse:[
            self 
                generateLookupFor:unicodeTable nameTable:unicodeNameTable from:firstUnicodeDiffToSuper to:lastUnicodeDiffToSuper varName:'unicode' 
                errorCode:'^ self decodingError.' 
                indent:indent onto:source.
        ].
        lastUnicodeDiffToSuper ~~ maxUnicode ifTrue:[
            indent := indent - 4.
            source spaces:indent; nextPutLine:'].'.
        ].
        firstUnicodeDiffToSuper ~~ 0 ifTrue:[
            indent := indent - 4.
            source spaces:indent; nextPutLine:'].'.
        ].
        source spaces:indent; nextPutLine:'^ super encode:unicode'.

        targetClass
            compile:source contents
            classified:'encoding & decoding'
            logged:false.
    ].
! !

!CharacterEncoderCodeGenerator methodsFor:'code generation - public'!

diffsBetween:class1 and:class2
    |tables1 tables2 class1CodeTable class2CodeTable d1 d2 diffsInEncoding diffsInValues|

    tables1 := self mappingTablesFrom:class1.
    tables2 := self mappingTablesFrom:class2.
    class1CodeTable := tables1 at:1.
    class2CodeTable := tables2 at:1.

    d1 := class1CodeTable asDictionary.
    d2 := class2CodeTable asDictionary.
    diffsInEncoding := Set new.
    d1 keysAndValuesDo:[:k :v | (d2 at:k ifAbsent:d2) ~~ v ifTrue:[ diffsInEncoding add:k ]].
    d2 keysAndValuesDo:[:k :v | (d1 at:k ifAbsent:d1) ~~ v ifTrue:[ diffsInEncoding add:k ]].

    firstDiffToSuper := diffsInEncoding min.
    lastDiffToSuper := diffsInEncoding max.

    diffsInValues := Set new.
    diffsInEncoding do:[:k | (class1CodeTable includesKey:k) ifTrue:[diffsInValues add:(class1CodeTable at:k)]].
    diffsInEncoding do:[:k | (class2CodeTable includesKey:k) ifTrue:[diffsInValues add:(class2CodeTable at:k)]].

    firstUnicodeDiff := diffsInValues min.
    lastUnicodeDiff := diffsInValues max.

    ^ diffsInEncoding collect:[:k | k -> (Array with:(d1 at:k ifAbsent:nil) with:(d2 at:k ifAbsent:nil))].

    "
     CharacterEncoderCodeGenerator new
        diffsBetween:(CharacterEncoder::ISO8859_1) 
        and:(CharacterEncoder::MS_Ansi)
    "
    "
     CharacterEncoderCodeGenerator new
        diffsBetween:(CharacterEncoder::ISO8859_5) 
        and:(CharacterEncoder::MS_Cyrillic)
    "
!

generateCode
    self fetchTables.
    self generateDecodeMethod.
    self generateEncodeMethod.

    "
     CharacterEncoderImplementations::ISO8859_1 flushCode; generateCode
     CharacterEncoderImplementations::ISO8859_2 flushCode; generateCode
     CharacterEncoderImplementations::KOI8_U flushCode; generateCode
     CharacterEncoderImplementations::NEXT flushCode; generateCode
     CharacterEncoderImplementations::KOI7 flushCode; generateCode
     CharacterEncoderImplementations::KOI8_E flushCode; generateCode
     CharacterEncoderImplementations::AdobeStandard generateCode
    "
!

generateSubclassCode
    |tables superClassCodeTable d1 d2 diffsToSuperClassEncoding diffsToSuperClassValues|

    self fetchTables.

    tables := self mappingTablesFrom:targetClass superclass.
    superClassCodeTable := tables at:1.
    d1 := codeTable asDictionary.
    d2 := superClassCodeTable asDictionary.
    diffsToSuperClassEncoding := Set new.
    d1 keysAndValuesDo:[:k :v | (d2 at:k ifAbsent:d2) ~~ v ifTrue:[ diffsToSuperClassEncoding add:k ]].
    d2 keysAndValuesDo:[:k :v | (d1 at:k ifAbsent:d1) ~~ v ifTrue:[ diffsToSuperClassEncoding add:k ]].

    firstDiffToSuper := diffsToSuperClassEncoding min.
    lastDiffToSuper := diffsToSuperClassEncoding max.

    diffsToSuperClassValues := Set new.
    diffsToSuperClassEncoding do:[:k | (codeTable includesKey:k) ifTrue:[diffsToSuperClassValues add:(codeTable at:k)]].
    diffsToSuperClassEncoding do:[:k | (superClassCodeTable includesKey:k) ifTrue:[diffsToSuperClassValues add:(superClassCodeTable at:k)]].

    firstUnicodeDiffToSuper := diffsToSuperClassValues min.
    lastUnicodeDiffToSuper := diffsToSuperClassValues max.

    (diffsToSuperClassEncoding size / codeTable size) > 0.1 ifTrue:[
        self generateDecodeMethod.
    ] ifFalse:[
        self generateDecodeMethodForSubclassWithDifferences:diffsToSuperClassEncoding.
    ].

    (diffsToSuperClassValues size / unicodeTable size) > 0.1 ifTrue:[
        self generateEncodeMethod.
    ] ifFalse:[
        self generateEncodeMethodForSubclassWithDifferences:diffsToSuperClassValues.
    ].

    "
     CharacterEncoder::KOI8_R flushCode; generateCode
     CharacterEncoder::KOI8_U flushCode; generateSubclassCode
    "
! !

!CharacterEncoderCodeGenerator methodsFor:'helpers'!

fetchTables
    |tables|

    tables := self mappingTablesFrom:targetClass.
    tables isNil ifTrue:[
        self halt:'could not fetch mapping table from internet'.
        ^ self.
    ].

    codeTable := tables at:1.
    nameTable := tables at:2.
    unicodeTable := IdentityDictionary new.
    unicodeNameTable := IdentityDictionary new.

    minCode := 16rFFFFFFF.
    maxCode := -1.
    minUnicode := 16rFFFFFFF.
    maxUnicode := -1.

    codeTable keysAndValuesDo:[:code :uniCode |
        minCode := minCode min:code.
        maxCode := maxCode max:code.
        minUnicode := minUnicode min:uniCode.
        maxUnicode := maxUnicode max:uniCode.

        unicodeTable at:uniCode put:code.
        unicodeNameTable at:uniCode put:(nameTable at:code).
    ].

    "/ first difference...
    firstDiff := (minCode to:maxCode) detect:[:code | (codeTable at:code ifAbsent:nil) ~~ code] ifNone:nil.
    lastDiff := (maxCode to:minCode by:-1) detect:[:code | (codeTable at:code ifAbsent:nil) ~~ code] ifNone:nil.

    firstUnicodeDiff := (minUnicode to:maxUnicode) detect:[:unicode | (unicodeTable at:unicode ifAbsent:nil) ~~ unicode] ifNone:nil.
    lastUnicodeDiff := (maxUnicode to:minUnicode by:-1) detect:[:unicode | (unicodeTable at:unicode ifAbsent:nil) ~~ unicode] ifNone:nil.
!

mapInfoFor:codeTable from:firstIndex to:lastIndex
    |minCode maxCode domainSize rangeSize validRangeSize firstDiff lastDiff firstValid lastValid firstInvalid lastInvalid info
     largestInvalidBlock invalidBlockStart invalidBlockEnd sizeOfLargestInvalidBlock|

    minCode := 16rFFFFFFF.
    maxCode := -1.
    validRangeSize := 0.

    sizeOfLargestInvalidBlock := 0.
    largestInvalidBlock := nil.
    invalidBlockStart := nil.
    invalidBlockEnd := nil.

    (firstIndex to:lastIndex) do:[:index |
        |code|

        code := codeTable at:index ifAbsent:nil.
        code notNil ifTrue:[
            validRangeSize := validRangeSize + 1.
            minCode := minCode min:code.
            maxCode := maxCode max:code.

            invalidBlockStart notNil ifTrue:[    
                (invalidBlockStart to:invalidBlockEnd) size > sizeOfLargestInvalidBlock ifTrue:[
                    largestInvalidBlock := (invalidBlockStart to:invalidBlockEnd).
                    sizeOfLargestInvalidBlock := largestInvalidBlock size.
                ].
            ].
            invalidBlockStart := nil.
            invalidBlockEnd := nil.
        ] ifFalse:[
            invalidBlockStart isNil ifTrue:[
                invalidBlockStart := invalidBlockEnd := index.
            ] ifFalse:[
                invalidBlockEnd := index.
            ].
        ]
    ].
    invalidBlockStart notNil ifTrue:[    
self halt.
        (invalidBlockStart to:invalidBlockEnd) size > sizeOfLargestInvalidBlock ifTrue:[
            largestInvalidBlock := (invalidBlockStart to:invalidBlockEnd).
        ].
    ].

    domainSize := (firstIndex to:lastIndex) size.
    rangeSize := (minCode to:maxCode) size.

    "/ first difference...
    firstDiff := (firstIndex to:lastIndex) detect:[:code | (codeTable at:code ifAbsent:nil) ~~ code] ifNone:nil.
    lastDiff := (lastIndex to:firstIndex by:-1) detect:[:code | (codeTable at:code ifAbsent:nil) ~~ code] ifNone:nil.

    firstValid := (firstIndex to:lastIndex) detect:[:code | (codeTable includesKey:code)] ifNone:nil.
    lastValid := (lastIndex to:firstIndex by:-1) detect:[:code | (codeTable includesKey:code)] ifNone:nil.

    firstInvalid := (firstIndex to:lastIndex) detect:[:code | (codeTable includesKey:code) not] ifNone:nil.
    lastInvalid := (lastIndex to:firstIndex by:-1) detect:[:code | (codeTable includesKey:code) not] ifNone:nil.

    info := Structure newWith:#( domainSize rangeSize validRangeSize firstDiff lastDiff firstValid lastValid firstInvalid lastInvalid largestInvalidBlock ).
    info domainSize:domainSize.
    info rangeSize:rangeSize.
    info validRangeSize:validRangeSize.
    info firstDiff:firstDiff.
    info lastDiff:lastDiff.
    info firstValid:firstValid.
    info lastValid:lastValid.
    info firstInvalid:firstInvalid.
    info lastInvalid:lastInvalid.
    info largestInvalidBlock:largestInvalidBlock.
    ^ info.
! !

!CharacterEncoderCodeGenerator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/CharacterEncoderCodeGenerator.st,v 1.19 2018-01-16 22:23:24 stefan Exp $'
! !

