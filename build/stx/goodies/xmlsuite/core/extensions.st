"{ Package: 'stx:goodies/xmlsuite/core' }"!

!Character methodsFor:'testing - XML'!

isInXMLCharSpec:aSelector

    (self perform:aSelector) do:[:integerOrArray|
        integerOrArray isArray ifTrue:[
            (self codePoint between:(integerOrArray first) and:(integerOrArray second))
                ifTrue:[^true]
        ] ifFalse:[
            (self codePoint = integerOrArray) ifTrue:[^true]
        ]
    ].
    ^false

    "Created: / 09-04-2005 / 08:19:12 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLBaseChar

    "See XML 1.1 grammar rule #85"

    ^self isInXMLCharSpec:#xmlBaseCharValues

    "
        $1 isXMLBaseChar  
        $a isXMLBaseChar   

    "

    "Created: / 01-04-2005 / 18:35:18 / janfrog"
    "Modified: / 09-04-2005 / 08:21:35 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLChar
    "
        From XML grammar
        [2]     Char            ::=     #x9 | #xA | #xD | [#x20-#xD7FF] | 
                                        [#xE000-#xFFFD] | [#x10000-#x10FFFF]
    "
    (self codePoint = 16r9) ifTrue:[^true].
    (self codePoint = 16rA) ifTrue:[^true].
    (self codePoint = 16rD) ifTrue:[^true].
    (self codePoint between:16r20 and:16rD7FF) ifTrue:[^true].
    (self codePoint between:16rE000 and:16rFFFD) ifTrue:[^true].
    (self codePoint between:16r10000 and:16r10FFFF) ifTrue:[^true].
    ^false

    "Created: / 12-03-2005 / 11:21:33 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLCombiningChar


    ^self isInXMLCharSpec:#xmlCombiningCharValues

    "Created: / 09-04-2005 / 08:15:10 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLDigit


    ^self isInXMLCharSpec:#xmlDigitValues

    "
        $1 isXMLDigit 
        $s isXMLDigit 
    "

    "Created: / 09-04-2005 / 08:23:38 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLExtender


    ^self isInXMLCharSpec:#xmlExtenderValues

    "

    "

    "Created: / 09-04-2005 / 08:25:56 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLIdeographic

    "From XML grammar
    [86]    Ideographic     ::=     [#x4E00-#x9FA5] | #x3007 | [#x3021-#x3029]
    "

    (self codePoint between:16r4E00 and:16r9FA5) ifTrue:[^true].
    (self codePoint between:16r3021 and:16r3029) ifTrue:[^true].
    (self codePoint = 16r3007) ifTrue:[^true].
    ^false

    "Created: / 01-04-2005 / 18:38:30 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLLetter

    "From XML grammar
    [84]    Letter          ::=     BaseChar | Ideographic
    "

    ^self isXMLBaseChar or:[self isXMLIdeographic]

    "Created: / 01-04-2005 / 18:39:15 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLPubidChar
    "
        From XML grammar
        [13]    PubidChar       ::=     #x20 | #xD | #xA | [a-zA-Z0-9] | [-'()+,./:=?;!!*#@$_%]
    "
    (self codePoint = 16r09) ifTrue:[^true].
    (self codePoint = 16r0A) ifTrue:[^true].
    (self codePoint = 16r0D) ifTrue:[^true].
    (self isLetterOrDigit) ifTrue:[^true].
    ('-''()+,./:=?;!!*#@$_%' includes:self) ifTrue:[^true].
    ^false

    "Created: / 01-04-2005 / 17:45:16 / janfrog"
! !

!Character methodsFor:'testing - XML'!

isXMLWhiteSpace

    "From XML grammar
     [3]     S               ::=     (#x20 | #x9 | #xD | #xA)+
    "

    ^ #(16r20 16r09 16r0D 16r0A) includes:self codePoint

    "Created: / 01-04-2005 / 17:37:12 / janfrog"
! !

!Character methodsFor:'XML character specs'!

xmlBaseCharValues
    ^ #( #(16r0041 16r005A) #(16r0061 16r007A) #(16r00C0 16r00D6) #(16r00D8 16r00F6) #(16r00F8 16r00FF) #(16r0100 16r0131) #(16r0134 16r013E) #(16r0141 16r0148) #(16r014A 16r017E) #(16r0180 16r01C3) #(16r01CD 16r01F0) #(16r01F4 16r01F5) #(16r01FA 16r0217) #(16r0250 16r02A8) #(16r02BB 16r02C1) 16r0386 #(16r0388 16r038A) 16r038C #(16r038E 16r03A1) #(16r03A3 16r03CE) #(16r03D0 16r03D6) 16r03DA 16r03DC 16r03DE 16r03E0 #(16r03E2 16r03F3) #(16r0401 16r040C) #(16r040E 16r044F) #(16r0451 16r045C) #(16r045E 16r0481) #(16r0490 16r04C4) #(16r04C7 16r04C8) #(16r04CB 16r04CC) #(16r04D0 16r04EB) #(16r04EE 16r04F5) #(16r04F8 16r04F9) #(16r0531 16r0556) 16r0559 #(16r0561 16r0586) #(16r05D0 16r05EA) #(16r05F0 16r05F2) #(16r0621 16r063A) #(16r0641 16r064A) #(16r0671 16r06B7) #(16r06BA 16r06BE) #(16r06C0 16r06CE) #(16r06D0 16r06D3) 16r06D5 #(16r06E5 16r06E6) #(16r0905 16r0939) 16r093D #(16r0958 16r0961) #(16r0985 16r098C) #(16r098F 16r0990) #(16r0993 16r09A8) #(16r09AA 16r09B0) 16r09B2 #(16r09B6 16r09B9) #(16r09DC 16r09DD) #(16r09DF 16r09E1) #(16r09F0 16r09F1) #(16r0A05 16r0A0A) #(16r0A0F 16r0A10) #(16r0A13 16r0A28) #(16r0A2A 16r0A30) #(16r0A32 16r0A33) #(16r0A35 16r0A36) #(16r0A38 16r0A39) #(16r0A59 16r0A5C) 16r0A5E #(16r0A72 16r0A74) #(16r0A85 16r0A8B) 16r0A8D #(16r0A8F 16r0A91) #(16r0A93 16r0AA8) #(16r0AAA 16r0AB0) #(16r0AB2 16r0AB3) #(16r0AB5 16r0AB9) 16r0ABD 16r0AE0 #(16r0B05 16r0B0C) #(16r0B0F 16r0B10) #(16r0B13 16r0B28) #(16r0B2A 16r0B30) #(16r0B32 16r0B33) #(16r0B36 16r0B39) 16r0B3D #(16r0B5C 16r0B5D) #(16r0B5F 16r0B61) #(16r0B85 16r0B8A) #(16r0B8E 16r0B90) #(16r0B92 16r0B95) #(16r0B99 16r0B9A) 16r0B9C #(16r0B9E 16r0B9F) #(16r0BA3 16r0BA4) #(16r0BA8 16r0BAA) #(16r0BAE 16r0BB5) #(16r0BB7 16r0BB9) #(16r0C05 16r0C0C) #(16r0C0E 16r0C10) #(16r0C12 16r0C28) #(16r0C2A 16r0C33) #(16r0C35 16r0C39) #(16r0C60 16r0C61) #(16r0C85 16r0C8C) #(16r0C8E 16r0C90) #(16r0C92 16r0CA8) #(16r0CAA 16r0CB3) #(16r0CB5 16r0CB9) 16r0CDE #(16r0CE0 16r0CE1) #(16r0D05 16r0D0C) #(16r0D0E 16r0D10) #(16r0D12 16r0D28) #(16r0D2A 16r0D39) #(16r0D60 16r0D61) #(16r0E01 16r0E2E) 16r0E30 #(16r0E32 16r0E33) #(16r0E40 16r0E45) #(16r0E81 16r0E82) 16r0E84 #(16r0E87 16r0E88) 16r0E8A 16r0E8D #(16r0E94 16r0E97) #(16r0E99 16r0E9F) #(16r0EA1 16r0EA3) 16r0EA5 16r0EA7 #(16r0EAA 16r0EAB) #(16r0EAD 16r0EAE) 16r0EB0 #(16r0EB2 16r0EB3) 16r0EBD #(16r0EC0 16r0EC4) #(16r0F40 16r0F47) #(16r0F49 16r0F69) #(16r10A0 16r10C5) #(16r10D0 16r10F6) 16r1100 #(16r1102 16r1103) #(16r1105 16r1107) 16r1109 #(16r110B 16r110C) #(16r110E 16r1112) 16r113C 16r113E 16r1140 16r114C 16r114E 16r1150 #(16r1154 16r1155) 16r1159 #(16r115F 16r1161) 16r1163 16r1165 16r1167 16r1169 #(16r116D 16r116E) #(16r1172 16r1173) 16r1175 16r119E 16r11A8 16r11AB #(16r11AE 16r11AF) #(16r11B7 16r11B8) 16r11BA #(16r11BC 16r11C2) 16r11EB 16r11F0 16r11F9 #(16r1E00 16r1E9B) #(16r1EA0 16r1EF9) #(16r1F00 16r1F15) #(16r1F18 16r1F1D) #(16r1F20 16r1F45) #(16r1F48 16r1F4D) #(16r1F50 16r1F57) 16r1F59 16r1F5B 16r1F5D #(16r1F5F 16r1F7D) #(16r1F80 16r1FB4) #(16r1FB6 16r1FBC) 16r1FBE #(16r1FC2 16r1FC4) #(16r1FC6 16r1FCC) #(16r1FD0 16r1FD3) #(16r1FD6 16r1FDB) #(16r1FE0 16r1FEC) #(16r1FF2 16r1FF4) #(16r1FF6 16r1FFC) 16r2126 #(16r212A 16r212B) 16r212E #(16r2180 16r2182) #(16r3041 16r3094) #(16r30A1 16r30FA) #(16r3105 16r312C) #(16rAC00 16rD7A3) )

    "Created: / 08-03-2006 / 09:35:13 / janfrog"
! !

!Character methodsFor:'XML character specs'!

xmlCombiningCharValues
    ^ #(
    #(16r0300 16r0345)  #(16r0360 16r0361)  #(16r0483 16r0486)  #(16r0591 16r05A1)  #(16r05A3 16r05B9)  #(16r05BB 16r05BD)  16r05BF  #(16r05C1 16r05C2)  16r05C4  #(16r064B 16r0652)  16r0670  #(16r06D6 16r06DC)  #(16r06DD 16r06DF)  #(16r06E0 16r06E4)  #(16r06E7 16r06E8)  #(16r06EA 16r06ED)  #(16r0901 16r0903)  16r093C  #(16r093E 16r094C)  16r094D  #(16r0951 16r0954)  #(16r0962 16r0963)  #(16r0981 16r0983)  16r09BC  16r09BE  16r09BF  #(16r09C0 16r09C4)  #(16r09C7 16r09C8)  #(16r09CB 16r09CD)  16r09D7  #(16r09E2 16r09E3)  16r0A02  16r0A3C  16r0A3E  16r0A3F  #(16r0A40 16r0A42)  #(16r0A47 16r0A48)  #(16r0A4B 16r0A4D)  #(16r0A70 16r0A71)  #(16r0A81 16r0A83)  16r0ABC  #(16r0ABE 16r0AC5)  #(16r0AC7 16r0AC9)  #(16r0ACB 16r0ACD)  #(16r0B01 16r0B03)  16r0B3C  #(16r0B3E 16r0B43)  #(16r0B47 16r0B48)  #(16r0B4B 16r0B4D)  #(16r0B56 16r0B57)  #(16r0B82 16r0B83)  #(16r0BBE 16r0BC2)  #(16r0BC6 16r0BC8)  #(16r0BCA 16r0BCD)  16r0BD7  #(16r0C01 16r0C03)  #(16r0C3E 16r0C44)  #(16r0C46 16r0C48)  #(16r0C4A 16r0C4D)  #(16r0C55 16r0C56)  #(16r0C82 16r0C83)  #(16r0CBE 16r0CC4)  #(16r0CC6 16r0CC8)  #(16r0CCA 16r0CCD)  #(16r0CD5 16r0CD6)  #(16r0D02 16r0D03)  #(16r0D3E 16r0D43)  #(16r0D46 16r0D48)  #(16r0D4A 16r0D4D)  16r0D57  16r0E31  #(16r0E34 16r0E3A)  #(16r0E47 16r0E4E)  16r0EB1  #(16r0EB4 16r0EB9)  #(16r0EBB 16r0EBC)  #(16r0EC8 16r0ECD)  #(16r0F18 16r0F19)  16r0F35  16r0F37  16r0F39  16r0F3E  16r0F3F  #(16r0F71 16r0F84)  #(16r0F86 16r0F8B)  #(16r0F90 16r0F95)  16r0F97  #(16r0F99 16r0FAD)  #(16r0FB1 16r0FB7)  16r0FB9  #(16r20D0 16r20DC)  16r20E1  #(16r302A 16r302F)  16r3099  16r309A
        )

    "Created: / 08-03-2006 / 09:36:37 / janfrog"
! !

!Character methodsFor:'XML character specs'!

xmlDigitValues
    ^ #( (16r0030 16r0039) #(16r0660 16r0669) #(16r06F0 16r06F9) #(16r0966 16r096F) #(16r09E6 16r09EF) #(16r0A66 16r0A6F) #(16r0AE6 16r0AEF) #(16r0B66 16r0B6F) #(16r0BE7 16r0BEF) #(16r0C66 16r0C6F) #(16r0CE6 16r0CEF) #(16r0D66 16r0D6F) #(16r0E50 16r0E59) #(16r0ED0 16r0ED9) #(16r0F20 16r0F29) )

    "Created: / 08-03-2006 / 09:38:10 / janfrog"
! !

!Character methodsFor:'XML character specs'!

xmlExtenderValues
    ^ #( 
            16r00B7  16r02D0  16r02D1  16r0387  16r0640  16r0E46  16r0EC6  16r3005  #(16r3031 16r3035)  #(16r309D 16r309E)  #(16r30FC 16r30FE)
    )

    "Created: / 08-03-2006 / 09:37:48 / janfrog"
! !

!CharacterArray methodsFor:'converting'!

asJamesClarkCanonicalXMLEscapedString

    | output |
    (self anySatisfy:[:char| ((#($< $> $&) includes:char))
                                or:[char == Character tab 
                                    or:[char == Character linefeed 
                                        or:[char == Character return]]]]) ifFalse:[^self].

    output := (self class new:self size) writeStream.
    self do:[:char| | eaten |
            eaten := false.
            char = $< ifTrue:[output nextPutAll:'&lt;'. eaten := true].
            char = $> ifTrue:[output nextPutAll:'&gt;'. eaten := true].
            char = $& ifTrue:[output nextPutAll:'&amp;'. eaten := true].
            char = $" ifTrue:[output nextPutAll:'&quot;'. eaten := true].
            char = Character tab ifTrue:[output nextPutAll:'&#9;'. eaten := true].
            char = Character linefeed ifTrue:[output nextPutAll:'&#A;'. eaten := true].
            char = Character return ifTrue:[output nextPutAll:'&#D;'. eaten := true].
            eaten ifFalse:[output nextPut:char].
    ].
    ^output contents

    "Created: / 21-10-2005 / 15:10:25 / janfrog"
! !

!CharacterArray methodsFor:'converting'!

asXMLEscapedString

    | output |
    (self anySatisfy:[:char| (#($< $> $&) includes:char)])
        ifFalse:[^self].
    output := (self class new:self size) writeStream.
    self do:[:char|
        (#($< $> $& $") includes:char)
            ifTrue:[
                char = $< ifTrue:[output nextPutAll:'&lt;'].
                char = $> ifTrue:[output nextPutAll:'&gt;'].
                char = $& ifTrue:[output nextPutAll:'&amp;'].
                char = $" ifTrue:[output nextPutAll:'&quot;'].
            ] ifFalse:[
                output nextPut:char
            ]
    ].
    ^output contents

    "Created: / 24-06-2005 / 12:12:02 / masca"
    "Modified: / 21-10-2005 / 15:00:36 / janfrog"
! !

!stx_goodies_xmlsuite_core class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
