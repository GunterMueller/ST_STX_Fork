"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2015 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: CharacterEncoderImplementations }"

ISO10646_to_UTF8 subclass:#ISO10646_to_UTF8_MAC
	instanceVariableNames:''
	classVariableNames:'AccentMap DecomposeMap ComposeMap'
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_to_UTF8_MAC class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by eXept Software AG
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
    UTF-8 can encode some diacritical characters (umlauts) in multiple ways:
        - either with a single uniode (e.g. ae -> ä -> &#228 -> C3 A4)
        - or as so called 'Normalization Form canonical Decomposition', i.e. as a regular 'a' followed by a
          combining diacritical mark (for example: acute).

    MAC OSX needs the second form for its file names.
    However, OSX does not decompose the ranges U+2000-U+2FFF, U+F900-U+FAFF and U+2F800-U+2FAFF.

    This is a q&d hack, to at least support the first page (latin1) characters.
    Will be enhanced for the 2nd and 3rd unicode page, when I find time.

    [caveat:]
        only a small subset of multi-composes are supported yet (for example: trema plus acute)

    [author:]
        Claus Gittinger

    [instance variables:]

    [class variables:]
        ComposeMap DecomposeMap

    [see also:]
        http://developer.apple.com/library/mac/#qa/qa2001/qa1173.html

"
! !

!ISO10646_to_UTF8_MAC class methodsFor:'initialization'!

initializeDecomposeMap
    "the map which decomposes a diacritical character into its two components"

    DecomposeMap := Dictionary new.
    ComposeMap := Dictionary new.

    #(
        "/ attention: the following strings contain non-latin characters
        "/ if you don't see them, change your font setting for a better font

        (16r0300 "gravis"       'AÀaàEÈeèIÌiìoòOÒUÙuùNǸnǹWẀwẁYỲyỳÜǛüǜ')  
        (16r0301 "akut"         'AÁaáEÉeéIÍiíOÓoóUÚuúyýYÝCĆcćNŃnńRŔrŕSŚsśZŹzźGǴgǵÆǼæǽØǾøǿMḾmḿKḰkḱPṔpṕWẂwẃÜǗüǘ') 
        (16r0302 "circonflex"   'AÂaâEÊeêIÎiîOÔoôUÛuûCĈcĉGĜgĝHĤhĥJĴjĵSŜsŝWŴwŵYŶyŷZẐzẑ')
        (16r0303 "tilde"        'AÃaãNÑnñOÕoõUŨuũYỸyỹEẼeẽVṼvṽ')
        (16r0304 "macron"       'AĀaāEĒeēIĪiīOŌoōUŪuūGḠgḡÜǕüǖ' ) 
        (16r0306 "breve"        'AĂaăEĔeĕGĞgğIĬiĭOŎoŏUŬuŭ')
        (16r0307 "dot above"    'AȦaȧOȮoȯCĊcċEĖeėGĠgġZŻzżBḂbḃDḊdḋFḞfḟHḢhḣMṀmṁNṄnṅPṖpṗRṘrṙSṠsṡTṪtṫWẆwẇXẊxẋYẎyẏ' )
        (16r0308 "umlaut/trema" 'AÄaäEËeëOÖoöUÜuüIÏiïyÿYŸHḦhḧXẌxẍtẗÙǛùǜŪǕūǖÚǗúǘǓǙǔǚ')
        (16r030A "ring"         'AÅaåUŮuůwẘyẙ')
        (16r030B "dbl akut"     'OŐoőUŰuű')
        (16r030C "hatcheck"     'CČcčDĎEĚeěNŇnňRŘrřSŠsšZŽzžAǍaǎIǏiǐOǑoǒUǓuǔGǦgǧKǨkǩÜǙüǚ')
        (16r030F "dbl grave"    'AȀaȁEȄeȅIȈiȉOȌoȍRȐrȑUȔuȕ')
        (16r0311 "inv. breve"   'AȂaȃEȆeȇIȊiȋOȎoȏRȒrȓUȖuȗ')
        (16r0317 "acute. below" 'KĶkķLĻlļNŅnņRŖrŗSȘsșTȚtț')
        (16r0327 "cedille"      'CÇcçŞşTŢtţEȨeȩDḐdḑHḨhḩ')       
        (16r0328 "ogonek"       'AĄaąEĘeęIĮiįOǪoǫUŲuų')
    ) do:[:eachPair |
        |composeCode mapping|

        composeCode := eachPair first.
        mapping := eachPair second.
        mapping pairWiseDo:[:baseChar :composedChar |
            "/ setup, so that we find
            "/    DecomposeMap at:"$à codePoint" 16rE0 put:#( "$a codePoint" 16r61 "greve codePoint" 16r0300).
            DecomposeMap 
                at:composedChar codePoint 
                put:(Array with:baseChar codePoint with:composeCode)
        ].

        ComposeMap at:composeCode put:mapping.
    ].
! !

!ISO10646_to_UTF8_MAC methodsFor:'encoding & decoding'!

compositionOf: baseChar with: diacriticalChar  to: outStream
    "compose two characters into one
     a + umlaut-diacritic-mark -> ä."

    |cp map i|

    cp := diacriticalChar codePoint.
    (cp between:16r300 and:16r328) ifTrue:[
        map := ComposeMap at:cp ifAbsent:nil.
        map notNil ifTrue:[
            "/ compose
            i := map indexOf: baseChar.
            i ~~ 0 ifTrue:[
                outStream nextPut: (map at:i+1).
                ^ self.
            ].
        ].
    ].

    "/ leave as is
    outStream nextPut: baseChar.
    outStream nextPut: diacriticalChar.
!

decodeString:aStringOrByteCollection
    "return a Unicode string from the passed in UTF-8-MAC encoded string.
     This is UTF-8 with compose-characters decomposed 
     (i.e. as separate codes, not as single combined characters).

     For now, here is a limited version, which should work
     at least for most european countries...
    "

    |s buff previous|

    s := super decodeString:aStringOrByteCollection.
    (s contains:[:char | char codePoint between:16r0300 and:16r0328]) ifFalse:[^ s].

    ComposeMap isNil ifTrue:[
        self class initializeDecomposeMap
    ].

    buff := CharacterWriteStream on:''.
    previous := nil.
    s do:[:each |
        (each codePoint between:16r0300 and:16r0328) ifTrue:[
            previous isNil ifTrue:[
                buff isEmpty ifTrue:[
                    "/ wrong - combiner not allowed here.
                    buff nextPut:each.
                ] ifFalse:[
                    "/ ouch - a multi-compose
                    previous := buff last.
                    buff skip:-1.
                    self compositionOf:previous with:each to:buff.
                ].
            ] ifFalse:[
                self compositionOf:previous with:each to:buff.
            ].
            previous := nil.
        ] ifFalse:[
            previous notNil ifTrue:[
                buff nextPut:previous.
            ].
            previous := each.
        ].
    ].
    previous notNil ifTrue:[
        buff nextPut:previous.
    ].
    ^ buff contents.

    "
     (ISO10646_to_UTF8 new encodeString:'aäoöuü') asByteArray   
        -> #[97 195 164 111 195 182 117 195 188]

     (ISO10646_to_UTF8 new decodeString:
            (ISO10646_to_UTF8 new encodeString:'aäoöuü') asByteArray)    

    (ISO10646_to_UTF8_MAC new encodeString:'aäoöuü') asByteArray 
        -> #[97 97 204 136 111 111 204 136 117 117 204 136]  

     (ISO10646_to_UTF8_MAC new decodeString:
            (ISO10646_to_UTF8_MAC new encodeString:'aäoöuü') asByteArray)    
    "
!

decompositionOf: codePointIn into:outBlockWithTwoArgs
    "if required, decompose a diacritical character into a base character and a punctuation;
     eg. ä -> a + umlaut-diacritic-mark.
     Pass both as args to the given block.
     For non diactit. chars, pass a nil diacrit-mark value.
     Return true, if a decomposition was done."

    |entry|

    codePointIn < 16rC0 ifTrue:[ ^ false ].

    entry := DecomposeMap at:codePointIn ifAbsent:nil.
    entry isNil ifTrue:[ ^ false ].

    outBlockWithTwoArgs value:(entry at:1) value:(entry at:2).
    ^ true
!

encodeString:aUnicodeString
    "return the UTF-8-MAC representation of a aUnicodeString.
     This is UTF-8 with compose-characters decompose (i.e. as separate codes, not as
     single combined characters).

     For now, here is a limited version, which should work
     at least for most european countries...
    "

    |gen s decomp codePoint composeCodePoint|

    DecomposeMap isNil ifTrue:[
        self class initializeDecomposeMap
    ].

    gen := 
        [:codePointArg |
            |codePoint "{Class: SmallInteger }" b1 b2 b3 b4 b5 v "{Class: SmallInteger }"|

            codePoint := codePointArg.
            codePoint <= 16r7F ifTrue:[
                s nextPut:(Character value:codePoint).
            ] ifFalse:[
                b1 := Character value:((codePoint bitAnd:16r3F) bitOr:2r10000000).
                v := codePoint bitShift:-6.
                v <= 16r1F ifTrue:[
                    s nextPut:(Character value:(v bitOr:2r11000000)).
                    s nextPut:b1.
                ] ifFalse:[
                    b2 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                    v := v bitShift:-6.
                    v <= 16r0F ifTrue:[
                        s nextPut:(Character value:(v bitOr:2r11100000)).
                        s nextPut:b2; nextPut:b1.
                    ] ifFalse:[
                        b3 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                        v := v bitShift:-6.
                        v <= 16r07 ifTrue:[
                            s nextPut:(Character value:(v bitOr:2r11110000)).
                            s nextPut:b3; nextPut:b2; nextPut:b1.
                        ] ifFalse:[
                            b4 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                            v := v bitShift:-6.
                            v <= 16r03 ifTrue:[
                                s nextPut:(Character value:(v bitOr:2r11111000)).
                                s nextPut:b4; nextPut:b3; nextPut:b2; nextPut:b1.
                            ] ifFalse:[
                                b5 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                                v := v bitShift:-6.
                                v <= 16r01 ifTrue:[
                                    s nextPut:(Character value:(v bitOr:2r11111100)).
                                    s nextPut:b5; nextPut:b4; nextPut:b3; nextPut:b2; nextPut:b1.
                                ] ifFalse:[
                                    "/ cannot happen - we only support up to 30 bit characters
                                    self error:'ascii value > 31bit in utf8Encode'.
                                ]
                            ].
                        ].
                    ].
                ].
            ].
        ].

    decomp := 
        [:baseCodePointArg :composeCodePointArg | 
            codePoint := baseCodePointArg. composeCodePoint := composeCodePointArg
        ].

    s := WriteStream on:(String uninitializedNew:aUnicodeString size).
    aUnicodeString do:[:eachCharacter |
        |needExtra|

        codePoint := eachCharacter codePoint.
        needExtra := self decompositionOf: codePoint into:decomp.
        gen value:codePoint.
        needExtra ifTrue:[
            gen value:composeCodePoint
        ].
    ].

    ^ s contents

    "
     (self encodeString:'hello') asByteArray                             #[104 101 108 108 111]
     (self encodeString:(Character value:16r40) asString) asByteArray    #[64]
     (self encodeString:(Character value:16r7F) asString) asByteArray    #[127]
     (self encodeString:(Character value:16r80) asString) asByteArray    #[194 128]
     (self encodeString:(Character value:16rFF) asString) asByteArray    #[195 191]

     (ISO10646_to_UTF8     new encodeString:'aäoöuü') asByteArray   
        -> #[97 195 164 111 195 182 117 195 188]
     (ISO10646_to_UTF8_MAC new encodeString:'aäoöuü') asByteArray 
        -> #[97 97 204 136 111 111 204 136 117 117 204 136]  

     ISO10646_to_UTF8_MAC new decodeString:
         (ISO10646_to_UTF8_MAC new encodeString:'Packages aus VSE für Smalltalk_X') asByteArray 
    "
! !

!ISO10646_to_UTF8_MAC methodsFor:'queries'!

nameOfEncoding
    ^ #'utf8-mac'
! !

!ISO10646_to_UTF8_MAC class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_UTF8_MAC.st,v 1.8 2015-02-27 18:53:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_UTF8_MAC.st,v 1.8 2015-02-27 18:53:22 cg Exp $'
! !

