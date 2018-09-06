"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

Object subclass:#CharacterEncoder
	instanceVariableNames:''
	classVariableNames:'EncoderClassesByName EncodersByName CachedEncoders AccessLock
		NullEncoderInstance Jis7KanjiEscapeSequence
		Jis7RomanEscapeSequence JisISO2022EscapeSequence
		Jis7KanjiOldEscapeSequence EncodingDetectors'
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

CharacterEncoder subclass:#CompoundEncoder
	instanceVariableNames:'decoder encoder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CharacterEncoder
!

CharacterEncoder subclass:#DefaultEncoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CharacterEncoder
!

CharacterEncoder subclass:#InverseEncoder
	instanceVariableNames:'decoder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CharacterEncoder
!

CharacterEncoder subclass:#NullEncoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CharacterEncoder
!

CharacterEncoder subclass:#OtherEncoding
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CharacterEncoder
!

CharacterEncoder subclass:#TwoStepEncoder
	instanceVariableNames:'encoder1 encoder2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CharacterEncoder
!

!CharacterEncoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    unfinished code - please read howToAddMoreCoders.

    Character mappings are based on information in character maps found at either:
        http://std.dkuug.dk/i18n/charmaps
    or:
        http://www.unicode.org/Public/MAPPINGS

    No Warranty.

    All the ISO 8859 codesets include ASCII as a proper codeset within them:

    ISO-8859-1: Latin 1 - Western European Languages.
    ISO-8859-2: Latin 2 - Eastern European Languages.
    ISO-8859-3: Latin 3 - Afrikaans, Catalan, Dutch, English, Esperanto, German,
                          Italian, Maltese, Spanish and Turkish.
    ISO-8859-4: Latin 4 - Danish, English, Estonian, Finnish, German, Greenlandic, Lappish and Latvian.
    ISO-8859-5: Latin/Cyrillic - Bulgarian, Byelorussian, English, Macedonian, Russian, Serbo-Croat and Ukranian.
    ISO-8859-6: Latin/Arabic - Arabic.
    ISO-8859-7: Latin/Greek - Greek.
    ISO-8859-8: Latin/Hebrew - Hebrew.
    ISO-8859-9: Latin 5 - Danish, Dutch, English, Finnish, French, German, Irish, Italian,
                          Norwegian, Portuguese, Spanish, Swedish and Turkish.
    ISO-8859-10: Latin 6 - Danish, English, Estonian, Finnish, German, Greenlandic, Icelandic,
                          Sami (Lappish), Latvian, Lithuanian, Norwegian, Faroese and Swedish.
    [author:]
        Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    |s1 s2|

    s1 := 'hello'.
    s2 := CharacterEncoder encodeString:s1 from:#'iso8859-1' into:#'unicode'.
    s2
                                                                        [exEnd]

                                                                        [exBegin]
    |s1 s2|

    s1 := 'hello'.
    s2 := CharacterEncoder encodeString:s1 from:#'iso8859-1' into:#'iso8859-7'.
    s2
                                                                        [exEnd]
"
!

howToAddMoreCoders
"
    Coders can be hand-written or automagically generated via a mapping table.
    Examples for hand-written coders are UTF8_to_ISO10464 or JIS0208_to_JIS7.

    The table driven encode/decode methods can be generated from a character mapping document
    as found on the unicode consortium host
        (for example: 'http://www.unicode.org/Public/MAPPINGS/ISO8859/8859-1.TXT')

    or from the i18n character maps:
        (for example: 'http://std.dkuug.dk/i18n/charmaps/ISO-8859-1

    In order to add another coder (for example: for EBCDIC or ms-codePage 278),
    perform the following steps:
        - create a public subclass of CharacterEncoderImplementations::CharacterEncoderImplementation named (for example) CharacterEncoderImplementations::CP267.

        - define the mappingURL1_relativeName (if the table is found on 'www.unicode.org')
          or the mappingURL2_relativeName (if it is found on 'std.dkuug.dk') method, which
          should return the name of the tables file, relative to the top directory there
          (which is '.../Public/MAPPINGS' on www.unicode.org and '.../i18n/charmaops' on 'std.dkuug.dk'.

          In this example, the table from 'std.dkuug.dk' is used, and named 'EBCDIC-CP-FI' there.

        - generate code by evaluating (make sure that CharacterEncoderGenerator is loaded from stx:goodies):
            CharacterEncoder::CP267 generateCode

    That's all!!


    The existing code was generated by:

        CharacterEncoder::SingleByteEncoder subclassesDo:[:cls | Transcript showCR:cls name. cls flushCode; generateCode ]
        CharacterEncoder::SingleByteEncoder subclassesDo:[:cls | cls allSubclassesDo:[:sub | Transcript showCR:sub name. sub flushCode; generateSubclassCode]]

    or individually:
        CharacterEncoder::ASCII flushCode; generateCode.
        CharacterEncoder::ISO8859_1 flushCode; generateCode.
        CharacterEncoder::ISO8859_2 flushCode; generateCode.
        CharacterEncoder::ISO8859_3 flushCode; generateCode.
        CharacterEncoder::ISO8859_4 flushCode; generateCode.
        CharacterEncoder::ISO8859_5 flushCode; generateCode.
        CharacterEncoder::ISO8859_6 flushCode; generateCode.
        CharacterEncoder::ISO8859_7 flushCode; generateCode.
        CharacterEncoder::ISO8859_8 flushCode; generateCode.
        CharacterEncoder::ISO8859_9 flushCode; generateCode.
        CharacterEncoder::ISO8859_10 flushCode; generateCode.
        CharacterEncoder::ISO8859_11 flushCode; generateCode.
        CharacterEncoder::ISO8859_13 flushCode; generateCode.
        CharacterEncoder::ISO8859_14 flushCode; generateCode.
        CharacterEncoder::ISO8859_15 flushCode; generateCode.
        CharacterEncoder::ISO8859_16 flushCode; generateCode.
        CharacterEncoder::KOI8_R flushCode; generateCode.
        CharacterEncoder::GSM0338 flushCode; generateCode.

        CharacterEncoder::KOI8_U flushCode; generateSubclassCode.

        CharacterEncoder::JIS0208 flushCode; generateCode.

    Please check if your encoder tables are complete; for example, with:
        0 to:255 do:[:ebc |
            |asc ebc2|

            asc := CharacterEncoderImplementations::EBCDIC new decode:ebc.
            asc notNil ifTrue:[
               ebc2 := CharacterEncoderImplementations::EBCDIC new encode:asc.
               self assert:(ebc2 = ebc)
            ].
        ].

        0 to:255 do:[:asc |
            |ebc asc2|

            ebc := CharacterEncoderImplementations::EBCDIC new encode:asc.
            ebc notNil ifTrue:[
               asc2 := CharacterEncoderImplementations::EBCDIC new decode:ebc.
               self assert:(asc2 = asc)
            ].
        ].
"
! !

!CharacterEncoder class methodsFor:'instance creation'!

encoderFor:encodingNameSymbol
    "given the name of an encoding, return an encoder-instance which can map these from/into unicode."

    ^ self
        encoderFor:encodingNameSymbol 
        ifAbsent:[
            "/ proceed to ignore this error in the future.    

"/            (EncodersByName at:#unicode) at:encodingNameSymbol put:NullEncoderInstance. 
"/            (EncoderClassesByName at:#unicode) at:encodingNameSymbol put:NullEncoder.    

            "/ self error:'no encoder for ' , encodingNameSymbol mayProceed:true.
            ('CharacterEncoder [warning]: no encoder for "' , encodingNameSymbol,'"') infoPrintCR.
            
            NullEncoderInstance
        ]

    "
     CharacterEncoder encoderFor:#'blabla2'       
     CharacterEncoder encoderFor:#'latin1'       
     self encoderFor:#'arabic'       
     self encoderFor:#'ms-arabic'       
     self encoderFor:#'cp1250'       
     self encoderFor:#'cp1251'       
     self encoderFor:#'cp1252'       
     self encoderFor:#'cp1253'       
     self encoderFor:#'iso8859-5'    
     self encoderFor:#'koi8-r'      
     self encoderFor:#'koi8-u'      
     self encoderFor:#'jis0208'      
     self encoderFor:#'jis7'      
     self encoderFor:#'utf8'      
     (self encoderFor:#'utf16le') encodeString:'hello'      
     (self encoderFor:#'utf16le') encode:5    
     (self encoderFor:#'utf16be') encodeString:'hello'      
     (self encoderFor:#'utf16be') encode:5      
     (self encoderFor:#'utf32le') encodeString:'hello'      
     (self encoderFor:#'utf32be') encodeString:'hello'      
     self encoderFor:#'sgml'      
     self encoderFor:#'java'      
    "

    "Modified: / 12-07-2012 / 19:35:43 / cg"
!

encoderFor:encodingNameSymbolArg ifAbsent:exceptionValue
    "given the name of an encoding, return an encoder-instance which can map these from/into unicode."

    |encodingNameSymbol enc clsName cls lcName name unicodeEncoders unicodeEncoderClasses|

    encodingNameSymbol := encodingNameSymbolArg.
    encodingNameSymbol isNil ifTrue:[ ^ NullEncoderInstance].

    encodingNameSymbol = 'iso10646-1' ifTrue:[ encodingNameSymbol := #unicode].

    lcName := encodingNameSymbol asLowercase.
    name := lcName asSymbolIfInterned.
    name isNil ifTrue:[name := lcName].

    name includesMatchCharacters ifTrue:[
        AccessLock critical:[
            unicodeEncoders := EncodersByName at:#unicode ifAbsent:nil.
        ].
        unicodeEncoders notNil ifTrue:[
            unicodeEncoders keysAndValuesDo:[:eachEncodingAlias :eachEncoderInstance |
                (name matches:eachEncodingAlias) ifTrue:[
                    ^ eachEncoderInstance.
                ].
            ].
        ].

        AccessLock critical:[
            unicodeEncoderClasses := self encoderClassesByName at:#unicode.
        ].
        unicodeEncoderClasses notNil ifTrue:[
            unicodeEncoderClasses keysAndValuesDo:[:eachEncodingAlias :eachEncoderClassOrName |
                (name matches:eachEncodingAlias) ifTrue:[
                    eachEncoderClassOrName isBehavior ifTrue:[
                        cls := eachEncoderClassOrName
                    ] ifFalse:[
                        cls := CharacterEncoderImplementations at:eachEncoderClassOrName.
                    ].
                    cls notNil ifTrue:[
                        ^ cls new.
                    ]
                ].
            ].
        ].
        ^ exceptionValue value
    ].

    AccessLock critical:[
        unicodeEncoders := EncodersByName at:#unicode ifAbsent:nil.
        unicodeEncoders isNil ifTrue:[
            EncodersByName at:#unicode put:(unicodeEncoders := Dictionary new).
        ].
        enc := unicodeEncoders at:name ifAbsent:nil.
    ].
    enc isNil ifTrue:[
        AccessLock critical:[
            unicodeEncoderClasses := self encoderClassesByName at:#unicode ifAbsent:nil.
            unicodeEncoderClasses isNil ifTrue:[
                self encoderClassesByName at:#unicode put:(unicodeEncoderClasses := Dictionary new).
            ].
            clsName := unicodeEncoderClasses at:name ifAbsent:nil.
        ].
        clsName notNil ifTrue:[
            clsName isBehavior ifTrue:[
                cls := clsName
            ] ifFalse:[
                cls := CharacterEncoderImplementations at:clsName.
            ].
            cls notNil ifTrue:[
                enc := cls new.
                AccessLock critical:[
                    unicodeEncoders at:name put:enc.
                ]
            ].
        ].
    ].

    enc notNil ifTrue:[
        ^ enc 
    ].

    "/ no direct encoder from unicode->name
    "/ search for unicode->any and: any->name
    AccessLock critical:[
        unicodeEncoderClasses := self encoderClassesByName at:#unicode ifAbsent:nil.
    ].
    unicodeEncoderClasses keysAndValuesDo:[:eachEncodingAlias :eachEncoderClass |
        |dict2 enc1 enc2|

        AccessLock critical:[
            dict2 := self encoderClassesByName at:eachEncodingAlias ifAbsent:nil.
        ].
        dict2 notNil ifTrue:[
            clsName := dict2 at:name ifAbsent:nil.
            clsName notNil ifTrue:[
                clsName isBehavior ifTrue:[
                    cls := clsName
                ] ifFalse:[
                    cls := CharacterEncoderImplementations at:clsName.
                ].
                cls notNil ifTrue:[
                    enc2 := cls new.
                    enc1 := self encoderFor:eachEncodingAlias.
                    (enc1 notNil and:[enc2 notNil]) ifTrue:[
                        enc := TwoStepEncoder new encoder1:enc1 encoder2:enc2.
                        AccessLock critical:[
                            unicodeEncoders at:name put:enc.    
                        ].
                        ^ enc.
                    ]
                ]
            ]
        ].
    ].

    self encoderClassesByName keysAndValuesDo:[:encoding1 :dict1 |
        dict1 keysAndValuesDo:[:encoding2 :clsName1|
            |clsName2 cls1 cls2 dict2 enc1 enc2|

            encoding2 = encodingNameSymbol ifTrue:[
                AccessLock critical:[
                    dict2 := self encoderClassesByName at:#unicode.
                ].
                clsName2 := dict2 at:encoding1 ifAbsent:nil.
                clsName2 notNil ifTrue:[
                    clsName1 isBehavior ifTrue:[
                        cls1 := clsName1
                    ] ifFalse:[
                        cls1 := CharacterEncoderImplementations at:clsName1.
                    ].
                    clsName2 isBehavior ifTrue:[
                        cls2 := clsName2
                    ] ifFalse:[
                        cls2 := CharacterEncoderImplementations at:clsName2.
                    ].
                    (cls1 notNil and:[cls2 notNil]) ifTrue:[
                        enc1 := cls1 new.
                        enc2 := cls2 new.
                        enc := TwoStepEncoder new encoder1:enc1 encoder2:enc2.
                        ^ enc.
                    ].
                ]
            ]
        ]
    ].

    ^ exceptionValue value

    "
     CharacterEncoder encoderFor:#'latin1'       
     self encoderFor:#'arabic'              
     self encoderFor:#'ms-arabic'           
     self encoderFor:#'iso8859-5'           
     self encoderFor:#'koi8-r'      
     self encoderFor:#'koi8-u'      
     self encoderFor:#'jis0208'      
     self encoderFor:#'jis7'      
     self encoderFor:#'unicode'      
     self encoderFor:#'UTF-8'      
     self encoderFor:'UTF-8'      
    "

    "Modified: / 12-07-2012 / 19:45:58 / cg"
!

encoderForUTF8
    "return an encoder-instance which can map unicode into/from utf8"

    ^ self encoderFor:#utf8

    "
     CharacterEncoder encoderFor:#'latin1'       
     self encoderFor:#'arabic'       
     self encoderFor:#'ms-arabic'       
     self encoderFor:#'iso8859-5'    
     self encoderFor:#'koi8-r'      
     self encoderFor:#'koi8-u'      
     self encoderFor:#'jis0208'      
     self encoderFor:#'jis7'      
     self encoderFor:#'utf8'      
     self encoderForUTF8'      
    "
!

encoderToEncodeFrom:oldEncodingArg into:newEncodingArg
    |oldEncoding newEncoding encoders encoderClasses encoder decoder clsName cls|

    oldEncoding := oldEncodingArg ? #unicode.
    oldEncoding == #'iso10646-1' ifTrue:[ oldEncoding :=  #unicode].
    newEncoding := newEncodingArg ? #unicode.
    newEncoding == #'iso10646-1' ifTrue:[ newEncoding :=  #unicode].

    oldEncoding = newEncoding ifTrue:[^ NullEncoderInstance].
    (oldEncoding match:newEncoding) ifTrue:[^ NullEncoderInstance].

    (oldEncoding = #unicode) ifTrue:[
        "/ something -> unicode 
        ^ self encoderFor:newEncoding.
    ].

    oldEncoding isSymbol ifFalse:[oldEncoding := oldEncoding asSymbol].
    newEncoding isSymbol ifFalse:[newEncoding := newEncoding asSymbol].

    AccessLock critical:[
        encoders := EncodersByName at:oldEncoding ifAbsent:nil.
        encoders isNil ifTrue:[
            EncodersByName at:oldEncoding put:(encoders := Dictionary new).
        ].
        encoder := encoders at:newEncodingArg ifAbsent:nil.
        encoder isNil ifTrue:[
            encoderClasses := self encoderClassesByName at:oldEncoding ifAbsent:nil.
            encoderClasses isNil ifTrue:[
                self encoderClassesByName at:oldEncoding put:(encoderClasses := Dictionary new).
            ].
            clsName := encoderClasses at:newEncoding ifAbsent:nil.
            clsName notNil ifTrue:[
                clsName isBehavior ifTrue:[
                    cls := clsName
                ] ifFalse:[
                    cls := CharacterEncoderImplementations at:clsName.
                ]
            ].
        ].
    ].
    cls notNil ifTrue:[
        encoder := cls new.
    ].

    encoder isNil ifTrue:[
        (newEncoding == #unicode) ifTrue:[
            "/ something -> unicode 
            decoder := self encoderFor:oldEncoding.
            encoder := InverseEncoder new decoder:decoder.
        ] ifFalse:[
            "/ do it as: oldEncoding -> unicode -> newEncoding

            "/ something -> unicode 
            decoder := self encoderFor:oldEncoding.

            "/ unicode -> something
            encoder := self encoderFor:newEncoding.
            encoder := CompoundEncoder new encoder:encoder decoder:decoder.
        ].
    ].

    AccessLock critical:[
        (EncodersByName at:oldEncoding) at:newEncoding put:encoder
    ].
    ^ encoder

    "   CharacterEncoder initialize
     CharacterEncoder encoderToEncodeFrom:#'latin1' into:#'jis7'      
     CharacterEncoder encoderToEncodeFrom:#'koi8-r' into:#'mac-cyrillic'              
     CharacterEncoder encoderToEncodeFrom:#'ms-arabic' into:#'mac-arabic'           
     CharacterEncoder encoderToEncodeFrom:#'iso8859-5' into:#'koi8-r'           
     CharacterEncoder encoderToEncodeFrom:#'koi8-r' into:#'koi8-u'       
    "

    "Modified: / 12-07-2012 / 19:45:15 / cg"
! !

!CharacterEncoder class methodsFor:'Compatibility-ST80'!

encoderNamed: encoderName
    "/ q & d hack

    encoderName == #default ifTrue:[
        ^ DefaultEncoder new
    ].
self halt:'should not be reached'.
    ^ self new
!

platformName
    ^ OperatingSystem platformName

    "Created: 20.6.1997 / 17:34:03 / cg"
    "Modified: 20.6.1997 / 17:38:40 / cg"
! !

!CharacterEncoder class methodsFor:'accessing'!

nullEncoderInstance
    ^ NullEncoderInstance
! !

!CharacterEncoder class methodsFor:'class initialization'!

encoderClassesByName
    EncoderClassesByName isNil ifTrue:[
        self initializeEncoderClassesByName
    ].
    ^ EncoderClassesByName    
!

initialize
    AccessLock notNil ifTrue:[^ self].  "/ already initialized

    AccessLock := RecursionLock new name:'CharacterEncoder'.
    NullEncoderInstance := NullEncoder new.

    EncodersByName := Dictionary new.
    CachedEncoders := Dictionary new.

    self initializeEncoderClassesByName.

    OperatingSystem isUNIXlike ifTrue:[
        "/Initialize OS system encoder
        OperatingSystem getCodesetEncoder.
    ].

    "
     self initialize
    "

    "Modified: / 01-04-2011 / 14:30:06 / cg"
    "Modified (format): / 23-01-2013 / 09:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeEncoderClassesByName
    "initialize the dictionary which maps commonly used names
     to encoder classes. 
     This is done, because some encodings come along
     with different names"

    |ud|

    EncoderClassesByName := Dictionary new.

    EncoderClassesByName at:#'unicode' put:(ud := Dictionary new).
    ud at:#'fontspecific' put:NullEncoder.    
    ud at:#'adobe-fontspecific' put:NullEncoder.    
    ud at:#'ms-oem' put:NullEncoder.    
    ud at:#'ms-default' put:NullEncoder.    

    "/ className        decoded-name    array-of-encodingNames
    #(
        (ASCII              unicode     ( ascii 'us-ascii' 'iso-ir-6' 'ibm-367' 'ms-cp367' 'cp367'  'iso646-us' 'ibm-cp367' 'ansi_x3.4-1968' ))

        (BIG5               unicode     ( big5 ))

        (CNS11643           unicode     ( 'cns11643' ))

        (CP437              unicode     ( 'cp437'  'cp-437' 'ibm-437' 'ms-cp437' 'microsoft-cp437' 'ibm-cp437' ))

        (EBCDIC             unicode     ( 'ebcdic' ))

"/        (GB2313_1980        unicode     ( 'gb2313' 'gb2313-1980' ))

        (GB2312_1980_0      unicode     ( 'gb2312' 'gb2312.1980' 'gb2312.1980-0'))

        (HANGUL             unicode     ( 'hangul' ))

        (ISO10646_1         unicode     ( unicode 'iso10646_1' 'iso10646-1' 'iso-10646-1' ))

        (ISO10646_to_UTF8     unicode   ( utf8 'utf-8' ))
        (ISO10646_to_UTF16BE  unicode   ( utf16b utf16be 'utf-16b' 'utf-16be' ))
        (ISO10646_to_UTF16LE  unicode   ( utf16l utf16le 'utf-16e' 'utf-16le' ))

        (ISO10646_to_UTF8_MAC unicode   ( 'utf8-mac' 'utf-8-mac' ))
        (ISO10646_to_XMLUTF8  unicode   ( 'utf8-XML' ))

        (ISO8859_1          unicode     ( 'iso8859_1' 'iso8859-1' 'iso-8859-1' 'latin-1' 'latin1' 'iso-ir-100' 'ibm-819' 'ms-cp819' 'ibm-cp819' 'iso8859'))

        (ISO8859_2          unicode     ( 'iso8859_2' 'iso8859-2' 'iso-8859-2' 'latin2' 'latin-2' 'iso-ir-101'))

        (ISO8859_3          unicode     ( 'iso8859_3' 'iso8859-3' 'iso-8859-3' 'latin3' 'latin-3' 'iso-ir-109'))

        (ISO8859_4          unicode     ( 'iso8859_4' 'iso8859-4' 'iso-8859-4' 'latin4' 'latin-4' 'iso-ir-110'))

        (ISO8859_5          unicode     ( 'iso8859_5' 'iso8859-5' 'iso-8859-5' 'cyrillic' 'iso-ir-144' ))

        (ISO8859_6          unicode     ( 'iso8859_6' 'iso8859-6' 'iso-8859-6' 'arabic' 'asmo-708' 'ecma-114' 'iso-ir-127' ))

        (ISO8859_7          unicode     ( 'iso8859_7' 'iso8859-7' 'iso-8859-7' 'greek' 'iso-ir-126' 'ecma-118'))

        (ISO8859_8          unicode     ( 'iso8859_8' 'iso8859-8' 'iso-8859-8' 'hebrew' 'iso-ir-138' ))

        (ISO8859_9          unicode     ( 'iso8859_9' 'iso8859-9' 'iso-8859-9' 'latin5' 'latin-5' 'iso-ir-148'))

        (ISO8859_10         unicode     ( 'iso8859_10' 'iso8859-10' 'iso-8859-10' 'latin6' 'latin-6' 'iso-ir-157'))

        (ISO8859_11         unicode     ( 'iso8859_11' 'iso8859-11' 'iso-8859-11' 'thai' ))

        (ISO8859_13         unicode     ( 'iso8859_13' 'iso8859-13' 'iso-8859-13' 'latin7' 'latin-7' ))

        (ISO8859_14         unicode     ( 'iso8859_14' 'iso8859-14' 'iso-8859-14' 'latin8' 'latin-8' 'latin-celtic' ))

        (ISO8859_15         unicode     ( 'iso8859_15' 'iso8859-15' 'iso-8859-15' 'latin9' 'latin-9' 'iso-ir-203'))

        (ISO8859_16         unicode     ( 'iso8859_16' 'iso8859-16' 'iso-8859-16' 'latin10' 'latin-10' ))

        (JIS0201            unicode     ( 'jis0201' #'jisx0201.1976-0'))

        (JIS0208            unicode     ( jis0208 'jisx0208' 'jisx0208.1983-0' 'jisx0208.1990-0'))

        (JIS0208_to_JIS7    jis0208     ( jis7 'jis-7' 'x-jis7' 'x-iso2022-jp' 'iso2022-jp'))

        (JIS0208_to_EUC     jis0208     ( euc #'x-euc-jp' ))

        (JIS0208_to_SJIS    jis0208     ( 'sjis' 'shiftjis' 'x-sjis' #'x-shift-jis' #'shift-jis'))

        (JIS0212            unicode     ( 'jis0212' ))

        (JOHAB              unicode     ( 'johab' ))

        (KOI7               unicode     ( 'koi7' ))

        (KOI8_R             unicode     ( #'koi8-r' 'cp878' ))

        (KOI8_U             unicode     ( #'koi8-u' ))

        (KSC5601            unicode     ( #'ksc5601' ))

        (MAC_Arabic         unicode     ( #'mac-arabic' 'macarabic' ))

        (MAC_CentralEuropean unicode    ( #'mac-centraleuropean' #'mac-centraleurope' 'maccentraleurope' 'maccentraleuropean' ))

        (MAC_Croatian       unicode     ( #'mac-croatian' 'maccroatian'))

        (MAC_Cyrillic       unicode     ( #'mac-cyrillic' 'maccyrillic' ))

        (MAC_Dingbats       unicode     ( #'mac-dingbats'  'macdingbats'  'macdingbat'))

        (MAC_Farsi          unicode     ( #'mac-farsi' 'macfarsi' ))

        (MAC_Greek          unicode     ( #'mac-greek' #'macgreek' ))

        (MAC_Hebrew         unicode     ( #'mac-hebrew' #'machebrew'  ))

        (MAC_Iceland        unicode     ( #'mac-iceland' #'maciceland'  ))

        (MAC_Japanese       unicode     ( #'mac-japanese' #'macjapanese'  ))

        (MAC_Korean         unicode     ( #'mac-korean' #'mackorean'  ))

        (MAC_Roman          unicode     ( #'mac-roman' #'macroman' 'macintosh' 'cp10000' ))

        (MAC_Romanian       unicode     ( #'mac-romanian' #'macromanian'  ))

        (MAC_Symbol         unicode     ( #'mac-symbol' #'macsymbol'  ))

        (MAC_Thai           unicode     ( #'mac-thai' #'macthai'  ))

        (MAC_Turkish        unicode     ( #'mac-turkish' #'macturkish'  ))

        (MS_Ansi            unicode     ( #'ms-ansi' 'ms-cp1252' 'microsoft-cp1252' 'cp1252' 'microsoft-ansi' 'windows-1252' 'windows-latin1'))

        (MS_Arabic          unicode     ( 'ms-arabic' 'ms-cp1256' 'microsoft-cp1256' 'cp1256'  'microsoft-arabic' 'windows-1256'  ))

        (MS_Baltic          unicode     ( 'ms-baltic' 'ms-cp1257' 'microsoft-cp1257' 'cp1257' 'microsoft-baltic' 'windows-1257'  ))

        (MS_Cyrillic        unicode     ( 'ms-cyrillic' 'ms-cp1251' 'microsoft-cp1251' 'cp1251' 'microsoft-cyrillic' 'windows-1251'  ))

        (MS_EastEuropean    unicode     ( 'ms-easteuropean' 'ms-ee' 'cp1250' 'ms-cp1250' 'microsoft-cp1250' 'microsoft-easteuropean' 'windows-1250'  ))

        (MS_Greek           unicode     ( 'ms-greek' 'ms-cp1253' 'microsoft-cp1253' 'cp1253' 'microsoft-greek' 'windows-1253' ))

        (MS_Hebrew          unicode     ( 'ms-hebrew' 'ms-cp1255' 'microsoft-cp1255' 'cp1255' 'microsoft-hebrew' 'windows-1255' ))

"/        (MS_Symbol           unicode     ( 'ms-symbol' 'microsoft-symbol'  ))

        (MS_Turkish         unicode     ( 'ms-turkish' 'ms-cp1254' 'microsoft-cp1254' 'cp1254' 'microsoft-turkish' 'windows-1254'  ))

        (NEXT               unicode     ( 'next' 'nextstep'  ))

        (ISO10646_to_SGML       unicode     ( 'sgml' ))
        (ISO10646_to_JavaText   unicode     ( 'java' 'javaText' ))
    ) triplesDo:[:className :decodesTo :encodesTo |
        |dict|

        "/ notice that the encoders are not yet installed as autoloaded.
        "/ Therefore, we remember their names here.
        dict := EncoderClassesByName at:decodesTo ifAbsent:nil.
        dict isNil ifTrue:[
            EncoderClassesByName at:decodesTo put:(dict := Dictionary new).
        ].
        encodesTo do:[:eachEncodingAlias |
            (dict includesKey:eachEncodingAlias) ifTrue:[
                self halt:'conflicting alias'
            ].
            dict at:eachEncodingAlias put:className.    
        ].
    ].

    "
     self initialize
    "

    "Modified: / 01-04-2011 / 14:30:06 / cg"
    "Modified (format): / 23-01-2013 / 09:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterEncoder class methodsFor:'constants'!

jis7KanjiEscapeSequence
    "return the escape sequence used to switch to kanji in jis7 encoded strings.
     This happens to be the same as ISO2022-JP's escape sequence."

    Jis7KanjiEscapeSequence isNil ifTrue:[
        Jis7KanjiEscapeSequence := Character esc asString , '$B'.
    ].
    ^ Jis7KanjiEscapeSequence.

    "Created: 26.2.1996 / 17:38:08 / cg"
    "Modified: 30.6.1997 / 16:03:16 / cg"
!

jis7KanjiOldEscapeSequence
    "return the escape sequence used to switch to kanji in some old jis7 encoded strings."

    Jis7KanjiOldEscapeSequence isNil ifTrue:[
        Jis7KanjiOldEscapeSequence := Character esc asString , '$@'.
    ].
    ^ Jis7KanjiOldEscapeSequence.
!

jis7RomanEscapeSequence
    "return the escape sequence used to switch to roman in jis7 encoded strings"

    Jis7RomanEscapeSequence isNil ifTrue:[
        Jis7RomanEscapeSequence := Character esc asString , '(J'.
    ].
    ^ Jis7RomanEscapeSequence.

    "Created: 26.2.1996 / 17:38:08 / cg"
    "Modified: 30.6.1997 / 16:03:16 / cg"
!

jisISO2022EscapeSequence
    "return the escape sequence used to switch to kanji in iso2022 encoded strings"

    JisISO2022EscapeSequence isNil ifTrue:[
        JisISO2022EscapeSequence := Character esc asString , '&@' , Character esc asString , '$B'.
    ].
    ^ JisISO2022EscapeSequence.
! !

!CharacterEncoder class methodsFor:'encoding & decoding'!

decode:aCodePoint
    ^ self new decode:aCodePoint
!

decodeString:aString
    ^ self new decodeString:aString
!

decodeString:aString from:oldEncoding
    ^ self encodeString:aString from:oldEncoding into:#'unicode'
!

encode:aCodePoint
    ^ self new encode:aCodePoint

    "
     ISO8859_1 encode:16r00FF   
     ISO8859_1 decodeString:'hello'
     ISO8859_1 encodeString:(ISO8859_1 decodeString:'hello') 

     ISO8859_5 decodeString:(String 
                                with:(Character value:16rE4)
                                with:(Character value:16rE0)) 
    "
!

encode:codePoint from:oldEncodingArg into:newEncodingArg
    |oldEncoding newEncoding encoder|

    oldEncoding := oldEncodingArg ? #'unicode'.
    oldEncoding == #'iso10646-1' ifTrue:[ oldEncoding :=  #'unicode'].
    newEncoding := newEncodingArg ? #'unicode'.
    newEncoding == #'iso10646-1' ifTrue:[ newEncoding :=  #'unicode'].

    oldEncoding == newEncoding ifTrue:[^ codePoint].

    oldEncoding == #'unicode' ifTrue:[
        newEncoding == #'iso8859-1' ifTrue:[
            codePoint <= 16rFF ifTrue:[
                ^ codePoint
            ]
        ]
    ].
    newEncoding == #'unicode' ifTrue:[
        oldEncoding == #'iso8859-1' ifTrue:[
            codePoint <= 16rFF ifTrue:[
                ^ codePoint
            ]
        ]
    ].
    encoder := self encoderToEncodeFrom:oldEncoding into:newEncoding.
    ^ encoder encode:codePoint.
!

encodeString:aUnicodeString
    "given a string in unicode, return a string in my encoding for it"

    ^ self new encodeString:aUnicodeString

    "
     ISO8859_1 decodeString:'hello'
    "
!

encodeString:aString from:oldEncodingArg into:newEncodingArg
    |oldEncoding newEncoding encoder|

    "/ some hard coded aliases
    oldEncoding := oldEncodingArg ? #'unicode'.
    oldEncoding == #'iso10646-1' ifTrue:[ oldEncoding :=  #'unicode'].
    oldEncoding == #'ms-default' ifTrue:[ oldEncoding :=  #'unicode'].

    newEncoding := newEncodingArg ? #'unicode'.
    newEncoding == #'iso10646-1' ifTrue:[ newEncoding :=  #'unicode'].
    newEncoding == #'ms-default' ifTrue:[ newEncoding :=  #'unicode'].

    oldEncoding == newEncoding ifTrue:[^ aString].

    "/ for single-byte strings, iso8859-1 and unicode (up to FF) have the same encoding
    oldEncoding == #'unicode' ifTrue:[
        (newEncoding == #'iso8859-1') ifTrue:[
            aString isWideString ifFalse:[
                ^ aString
            ]
        ].
    ].
    newEncoding == #'unicode' ifTrue:[
        (oldEncoding == #'iso8859-1') ifTrue:[
            aString isWideString ifFalse:[
                ^ aString
            ]
        ]
    ].

    encoder := self encoderToEncodeFrom:oldEncoding into:newEncoding.
    ^ encoder encodeString:aString.
!

encodeString:aString into:newEncoding
    ^ self encodeString:aString from:#'unicode' into:newEncoding

    "
     self encodeString:'hello' into:#ebcdic

     self encodeString:(self encodeString:'hello' into:#ebcdic) from:#ebcdic into:#ascii    
     self encodeString:(self encodeString:'hello' into:#ebcdic) from:#ebcdic into:#unicode    
    "
! !

!CharacterEncoder class methodsFor:'private'!

flushCode
    self initialize.

    self isAbstract ifFalse:[
        (self mapFileURL1_relativePathName notNil
        or:[ self mapFileURL2_relativePathName notNil]) ifTrue:[
            self class removeSelector:#mapping.
        ].
    ].

    "
     self flushCode
    "
! !

!CharacterEncoder class methodsFor:'private-mapping setup'!

generateCode
    (CharacterEncoderCodeGenerator new targetClass:self) generateCode.
!

generateSubclassCode
    (CharacterEncoderCodeGenerator new targetClass:self) generateSubclassCode.
!

mapFileURL1_codeColumn
    ^ 1
!

mapFileURL1_relativePathName
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ nil
!

mapFileURL2_relativePathName
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ nil
!

mappingURL1
    "raise an error: must be redefined in concrete subclass(es)"
    
    |rel|

    rel := self mapFileURL1_relativePathName.
    rel isNil ifTrue:[
        ^ nil
    ].
    ^ 'http://www.unicode.org/Public/MAPPINGS/' , rel
!

mappingURL2
    "raise an error: must be redefined in concrete subclass(es)"
    
    |rel|

    rel := self mapFileURL2_relativePathName.
    rel isNil ifTrue:[
        ^ nil
    ].
    ^ 'http://std.dkuug.dk/i18n/charmaps/' , rel
! !

!CharacterEncoder class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for CharacterEncoder here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == CharacterEncoder
!

isEncoding:subSetEncodingArg subSetOf:superSetEncodingArg
    "return true, if superSetEncoding encoding includes all characters of subSetEncoding.
     (this means: characters are included - not that they have the same encoding)"

    |subSetEncoding superSetEncoding|

    subSetEncodingArg = superSetEncodingArg ifTrue:[^ true].
    subSetEncoding := subSetEncodingArg asLowercase.
    superSetEncoding := superSetEncodingArg asLowercase.

    (subSetEncoding match:superSetEncoding) ifTrue:[^ true].

    (('iso10646*' match:superSetEncoding) 
    or:[superSetEncoding = 'unicode'
    or:[superSetEncoding = 'ms-ansi']]) ifTrue:[
        "/ assume that any character is in unicode
        ^ true.
    ].

    "/ if the subSet is iso8859-*, that means ascii (i.e. the lower 7 bits of iso8859 only).
    ((subSetEncoding = 'iso8859*') or:[subSetEncoding = 'iso8859-*']) ifTrue:[
        ('ascii*' match:superSetEncoding) ifTrue:[^ true].
        ('ms-ansi*' match:superSetEncoding) ifTrue:[^ true].
    ].
    (subSetEncoding = 'ascii') ifTrue:[
        ('iso8859*' match:superSetEncoding) ifTrue:[^ true].
        ('ms-ansi*' match:superSetEncoding) ifTrue:[^ true].
    ].

    "/ TODO: check the charSets mappingTables...
    "/ self halt.
    ^ false.
!

nameOfDecodedCode
    "Most coders decode from their code into unicode / encode from unicode into their code.
     There are a few exceptions to this, though - these must redefine this."
    
    ^ #'unicode'
!

nameOfEncoding
    ^ (self nameWithoutPrefix asLowercase copyReplaceAll:$_ with:$-) asSymbol
!

supportedExternalEncodings
    "return an array of arrays containing the names of supported
     encodings which are supported for external resources (i.e. files).
     The first element contains the internally used symbolic name,
     the second contains a user-readable string (description).
     More than one external name may be mapped onto the same symbolic."

    ^ #( 
         ('utf8'        'Unicode as 8Bit characters'    )  
         ('utf16BE'     'Unicode as 16Bit big-endian'    )  
         ('utf16LE'     'Unicode as 16Bit little-endian' )  
"/         ('utf7'        'Unicode as 7Bit characters'    ) 
"/       nil
         ('ascii'       'Common 7bit subset of iso8859' )
         ('iso8859-1'   'Western'                       )
         ('iso8859-2'   'Central European'              )
         ('iso8859-3'   'South European'                )
         ('iso8859-4'   'Baltic'                        )
         ('iso8859-5'   'Cyrillic'                      )
         ('iso8859-6'   'Arabic'                        )
         ('iso8859-7'   'Greek'                         )
         ('iso8859-8'   'Hebrew'                        )
         ('iso8859-15'  'Western with Euro'             )
         ('iso8859-16'  'South European with Euro'      )
"/       nil
         ('macintosh'   'MAC Western'      )
"/       nil
         ('koi7'        'Cyrillic (Old)'                )
         ('koi8-r'      'Cyrillic'                      )
         ('koi8-u'      'Cyrillic (Ukraine)'            )
"/       nil
         ('cp437'       'Windows US / codepage 437'       )
         ('cp850'       'Windows Latin1 / codepage 850'   )
         ('cp1250'      'Windows Latin2 / codepage 1250'  )
         ('cp1251'      'Windows Cyrillic / codepage 1251')
"/         ('mac'         'macintosh 8 bit'               )
         ('next'        'NeXT 8 bit'                    )
"/         ('hp'          'hpux 8 bit'                    )
"/       nil
         ('euc'         'EUC - extended unix code (japanese)'     )
         ('jis7'        'JIS7 - jis 7bit escape codes (japanese)' )
         ('iso-2022-jp' 'Same as jis 7bit'                        )
         ('sjis'        'SJIS - shift jis 8bit codes (japanese)'  )
"/       nil
         ('gb'          'GB - mainland china'                   )
         ('big5'        'BIG5 - taiwan'                         )
"/         ('ksc'         'korean'                        )
         ('sgml'        'SGML (XML/HTML) character escapes'     )
         ('java'        'JavaText (\uXXXX) character escapes'   )
       )

    "Modified: / 23-10-2006 / 13:27:48 / cg"
!

userFriendlyNameOfEncoding
    ^ self nameOfEncoding asUppercaseFirst
! !

!CharacterEncoder class methodsFor:'utilities'!

guessEncodingOfBuffer:buffer
    "try to guess a string-buffer's encoding.
     Basically looks for a string of the form
            encoding #name
     or:
            encoding: name
     within the given buffer 
     (which is usually within the first few bytes of a textFile)."

    buffer size < 4 ifTrue:[
        "not enough bytes to determine the contents"
        ^ nil.
    ].
    EncodingDetectors isNil ifTrue:[
        self initializeEncodingDetectors.
    ].    
    EncodingDetectors do:[:each |
        |guess|

        (guess := each value:buffer) notNil ifTrue:[
            ^ guess
        ].
    ].    
    ^ nil
!

guessEncodingOfFile:aFilename
    "look for a string
        encoding #name
     or:
        encoding: name
     within the given buffer 
     (which is usually the first few bytes of a textFile).
     If that's not found, use heuristics (in CharacterArray) to guess.
     Return a symbol like #utf8."

    |s buffer n "{Class: SmallInteger }"|

    s := aFilename asFilename readStreamOrNil.
    s isNil ifTrue:[^ nil].

    buffer := String new:512.
    n := s nextBytes:buffer size into:buffer.
    s close.

    ^ self guessEncodingOfBuffer:buffer.

    "
     self guessEncodingOfFile:'../../libview/resources/de.rs' asFilename
     self guessEncodingOfFile:'../../libview/resources/ru.rs' asFilename
     self guessEncodingOfFile:'../../libview/resources/th.rs' asFilename
    "

    "Modified: / 31-05-2011 / 15:45:19 / cg"
!

guessEncodingOfStream:aStream
    "look for a string of the form
            encoding #name
     or:
            encoding: name
     in the first few bytes of aStream.
     Return a symbol like #utf8."

    |oldPosition buffer n|

    "/ must be able to position back
    aStream isPositionable ifFalse:[^ nil].
    
    buffer := String new:512.

    oldPosition := aStream position.
    n := aStream nextBytes:buffer size into:buffer.
    aStream position:oldPosition.

    ^ self guessEncodingOfBuffer:buffer

    "Modified: / 31-05-2011 / 15:45:23 / cg"
!

initializeEncodingDetectors
    "setup the list of encoding detectors.
     This is a list of blocks, which get a buffer as argument,
     and return an encoding symbol or nil.
     Can be customized for more detectors 
     (used to be hard-coded in guessEncodingOfBuffer:)"

    EncodingDetectors := OrderedCollection new.

    "check for Unicode Byte Order Marks (BOM)"
    EncodingDetectors
        add:[:buffer |
            |guess byte1 byte2|
            
            byte1 := (buffer at:1) codePoint.
            byte2 := (buffer at:2) codePoint.
            byte1 < 16rFE ifTrue:[
                (byte1 = 16rEF
                    and:[byte2 = 16rBB 
                    and:[(buffer at:3) codePoint = 16rBF]]) ifTrue:[
                    guess := #utf8
                ] ifFalse:[
                    (byte1 = 0 
                        and:[byte2 = 0 
                        and:[(buffer at:3) codePoint = 16rFE 
                        and:[(buffer at:4) codePoint = 16rFF]]]) ifTrue:[
                        "00-00-FE-FF big endian utf32"
                        guess := #utf32be
                    ].
                ]    
            ] ifFalse:[
                byte1 = 16rFF ifTrue:[
                    byte2 = 16rFE ifTrue:[
                        "FF-FE little endian utf16 or utf32"
                        ((buffer at:3) codePoint = 0 and:[(buffer at:4) codePoint = 0]) ifTrue:[
                            "FF-FE-00-00 little endian utf32"
                            guess := #utf32le.   
                        ] ifFalse:[
                            guess := #utf16le
                        ]    
                    ].
                ] ifFalse:["byte1 = 16rFE"
                    "FE-FF big endian utf16"
                    byte2 = 16rFF ifTrue:[
                        "big endian"
                        guess := #utf16be
                    ].
                ]
            ].
            guess
        ].
        
    "check for an inline encoding markup (charset= / encoding=) substring"
    EncodingDetectors
        add:[:buffer |
            |guess lcBuffer quote peek|

            lcBuffer := buffer asLowercase.

            guess :=
                #(charset encoding) doWithExit:[:keyWord :exit |
                    |encoderOrNil idx s w enc|

                    guess isNil ifTrue:[
                    (idx := lcBuffer findString:keyWord) ~~ 0 ifTrue:[
                        s := ReadStream on:buffer.
                        s position:idx-1.
                        s skip:keyWord size.
                        s skipSeparators. 

                        "do not include '=' here, otherwise
                         files containing xml code (<?xml charset='utf8'> will be parsed as UTF-8"

                        [':#=' includes:s peek] whileTrue:[
                            s next.
                            s skipSeparators. 
                        ].
                        s skipSeparators.
                        ('"''' includes:s peek) ifTrue:[
                            quote := s next.
                            w := s upTo:quote.
                        ] ifFalse:[
                            w := s upToElementForWhich:[:ch | ch isSeparator or:[ch == $" or:[ch == $' or:[ch == $> ]]]].
                        ].
                        w notNil ifTrue:[
                            enc := w withoutQuotes.
                            (enc startsWith:'x-') ifTrue:[
                                enc := enc copyFrom:3.
                            ].
                            encoderOrNil := self encoderFor:enc ifAbsent:nil.
                            encoderOrNil notNil ifTrue:[
                                exit value:(encoderOrNil nameOfEncoding)
                            ].
                        ].
                    ].
                ].
                nil
            ].
            guess
        ].
        
    "/ check for JIS7 encoding
    EncodingDetectors
        add:[:buffer |
            (buffer findString:self jisISO2022EscapeSequence) ~~ 0 ifTrue:[
                #'iso2020-jp'
            ] ifFalse:[
                (buffer findString:self jis7KanjiEscapeSequence) ~~ 0 ifTrue:[
                    #jis7
                ] ifFalse:[
                    (buffer findString:self jis7KanjiOldEscapeSequence) ~~ 0 ifTrue:[
                        #jis7
                    ] ifFalse:[
                        nil
                    ]
                ]
            ]    
        ].

    "/ TODO: look for EUC, SJIS etc.
    "/ Disabled, due to too many false positives.
    "/ if required, think about it, fix it and uncomment it
"/    EncodingDetectors
"/        add:[:buffer |
"/            |guess idx|
"/
"/            idx := buffer 
"/                        findFirst:[:char | 
"/                            |code|
"/                            code := char codePoint.
"/                            code between:16rA1 and: 16rFE
"/                        ].
"/            ((idx ~~ 0) 
"/                and:[ (buffer at:(idx + 1)) codePoint between:16rA1 and: 16rFE ])
"/            ifTrue:[
"/                guess := #euc
"/            ] ifFalse:[
"/                "/ look for SJIS ...
"/            ]
"/        ].
!

showCharacterSet
    |font|

    font := View defaultFont.
"/    font := (Font family:'courier' face:'medium' style:'roman' size:12 encoding:'iso10646-1').

    CharacterSetView
        openOn:font
        label:'Characters of ',self nameWithoutPrefix
        clickLabel:nil
        asInputFor:nil
        encoder:self

    "
     CharacterEncoderImplementations::MS_Ansi showCharacterSet
     CharacterEncoderImplementations::ISO8859_1 showCharacterSet
     CharacterEncoderImplementations::ISO8859_2 showCharacterSet
     CharacterEncoderImplementations::ISO8859_3 showCharacterSet
     CharacterEncoderImplementations::ISO8859_4 showCharacterSet
     CharacterEncoderImplementations::ISO8859_5 showCharacterSet
     CharacterEncoderImplementations::ISO8859_6 showCharacterSet
     CharacterEncoderImplementations::ISO8859_7 showCharacterSet
     CharacterEncoderImplementations::ISO8859_8 showCharacterSet
     CharacterEncoderImplementations::ISO8859_9 showCharacterSet
    "
! !

!CharacterEncoder methodsFor:'encoding & decoding'!

decode:anEncoding
    "given an integer in my encoding, return a unicode codePoint for it"

    self subclassResponsibility
!

decodeString:anEncodedString
    "given a string in my encoding, return a unicode-string for it"

    |newString myCode uniCodePoint bits|

    newString := String new:(anEncodedString size).
    bits := newString bitsPerCharacter.

    1 to:anEncodedString size do:[:idx |
        uniCodePoint := (anEncodedString at:idx) codePoint.
        myCode := self decode:uniCodePoint.
        myCode > 16rFF ifTrue:[
            myCode > 16rFFFF ifTrue:[
                bits < 32 ifTrue:[
                    newString := Unicode32String fromString:newString.
                    bits := 32.
                ]
            ] ifFalse:[
                bits < 16 ifTrue:[
                    newString := Unicode16String fromString:newString.
                    bits := 16.
                ]
            ]
        ].
        newString at:idx put:(Character value:myCode).
    ].
    ^ newString

    "
     ISO8859_1 decodeString:'hello'
    "
!

encode:aCodePoint
    "given a codePoint in unicode, return a byte in my encoding for it"

    self subclassResponsibility
!

encodeString:aUnicodeString
    "given a string in unicode, return a string in my encoding for it"

    |newString myCode uniCodePoint bits 
     stringSize "{ Class: SmallInteger }"|

    stringSize := aUnicodeString size.
    newString := String new:stringSize.
    bits := newString bitsPerCharacter.

    1 to:stringSize do:[:idx |
        uniCodePoint := (aUnicodeString at:idx) codePoint.
        myCode := self encode:uniCodePoint.
        myCode > 16rFF ifTrue:[
            myCode > 16rFFFF ifTrue:[
                bits < 32 ifTrue:[
                    newString := Unicode32String fromString:newString.
                    bits := 32.
                ]
            ] ifFalse:[
                bits < 16 ifTrue:[
                    newString := Unicode16String fromString:newString.
                    bits := 16.
                ]
            ]
        ].
        newString at:idx put:(Character value:myCode).
    ].
    ^ newString
!

encodeString:aUnicodeString on:aStream
    "given a string in unicode, encode it onto aStream.
     Subclasses can redefine this to avoid allocating many new string instances.
     (but must then also redefine encodeString:aUnicodeString to collect the characters)"

    aStream nextPutAll:(self encodeString:aUnicodeString).
! !

!CharacterEncoder methodsFor:'error handling'!

decodingError 
    "report an error that there is no unicode-codePoint for a given codePoint in this encoding.
     (which is unlikely) or that the encoding is undefined for that value
     (for example, holes in the ISO-8859-3 encoding)"

    |badCodePoint sender|

    sender := thisContext sender.
    ((sender selector == #encode:) or:[sender selector == #decode:]) ifFalse:[
        badCodePoint := sender methodHome argAt:1
    ].
    ^ (DecodingError new)
        defaultValue:(self defaultDecoderValue);
        parameter:badCodePoint;
        messageText:'invalid code'; 
        suspendedContext:sender;
        raiseRequest.
!

defaultDecoderValue
    "placed into a decoded string, in case there is no unicode codePoint
     for a given encoded codePoint.
     (typically 16rFFFF)."
    
    ^ 16rFFFF
!

defaultEncoderValue
    "placed into an encoded string, in case there is no codePoint
     for a given unicode codePoint.
     (typically $?)."

    ^ $? codePoint
!

encodingError
    "report an error that some unicode-codePoint cannot be represented by this encoder"

    |badCodePoint sender|

    sender := thisContext sender.
    ((sender selector == #encode:) or:[sender selector == #decode:]) ifFalse:[
        badCodePoint := sender methodHome argAt:1
    ].
    ^ (EncodingError new)
        defaultValue:(self defaultEncoderValue);
        parameter:badCodePoint;
        messageText:'unrepresentable code (some character cannot be represented)'; 
        suspendedContext:sender;
        raiseRequest

    "Modified: / 12-07-2012 / 20:36:37 / cg"
! !

!CharacterEncoder methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:(self nameOfDecodedCode);
        nextPutAll:'->';
        nextPutAll:(self nameOfEncoding)
! !

!CharacterEncoder methodsFor:'queries'!

characterSize:codePoint
    "return the number of bytes required to encode codePoint"

    ^ self subclassResponsibility

    "Created: / 15-06-2005 / 15:11:04 / janfrog"
!

isEncoderFor:encoding
    "does this encode to encoding?"

    |encodingNameSymbol|

    encodingNameSymbol := encoding asLowercase.
    encodingNameSymbol = #'iso10646-1' ifTrue:[ encodingNameSymbol := #unicode].

    ^ encodingNameSymbol = self nameOfEncoding
!

isNullEncoder
    ^ false
!

nameOfDecodedCode
    "Most coders decode from their code into unicode / encode from unicode into their code.
     There are a few exceptions to this, though - these must redefine this."
    
    ^ self class nameOfDecodedCode
!

nameOfEncoding
    ^ self class nameOfEncoding
!

userFriendlyNameOfEncoding
    ^ self class userFriendlyNameOfEncoding
! !

!CharacterEncoder methodsFor:'stream support'!

readNext:charactersToRead charactersFrom:stream 
    ^ self decodeString:(stream next:charactersToRead)
!

readNextCharacterFrom:aStream

    | c |

    c := aStream next.

    ^ c isNil 
        ifTrue: [nil]
        ifFalse: [(self decode:c asInteger) asCharacter]

    "Created: / 14-06-2005 / 17:03:21 / janfrog"
    "Modified: / 15-06-2005 / 15:27:49 / janfrog"
    "Modified: / 20-06-2005 / 13:13:52 / masca"
!

readNextInputCharacterFrom:aStream
    ^ aStream next
! !

!CharacterEncoder::CompoundEncoder class methodsFor:'documentation'!

documentation
"
    A compoundEncoder uses two real encoders;
    to encode:
        string -> decoder(encode) -> encoder -> result
    to decode:
        string -> encoder -> decoder -> result

    |e|

    e := CompoundEncoder new.
    e encoder:ISO8859_5 decoder:KOI8_R.
    e decode:16rB0.  'CYRILLIC CAPITAL LETTER A; 16rB0 in 8859-5; 16rE1 in KOI8-R'.
    e encode:16rE1.  
"
! !

!CharacterEncoder::CompoundEncoder methodsFor:'accessing'!

encoder:encoderArg decoder:decoderArg  
    "set instance variables (automatically generated)"

    decoder := decoderArg.
    encoder := encoderArg.
! !

!CharacterEncoder::CompoundEncoder methodsFor:'encoding & decoding'!

decode:aCode
    ^ decoder encode:(encoder decode:aCode)
!

decodeString:aString
    ^ decoder encodeString:(encoder decodeString:aString)
!

encode:aCode
    ^ encoder encode:(decoder decode:aCode)
!

encodeString:aString
    ^ encoder encodeString:(decoder decodeString:aString)
! !

!CharacterEncoder::CompoundEncoder methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:(decoder nameOfEncoding);
        nextPutAll:'->'.
"/        nextPutAll:(decoder nameOfDecodedCode);
"/        nextPutAll:'->';
"/        nextPutAll:(encoder nameOfEncoding)
    encoder printOn:aStream
! !

!CharacterEncoder::DefaultEncoder class methodsFor:'documentation'!

documentation
"
    That is only a dummy for ST80 compatibility
"
! !

!CharacterEncoder::InverseEncoder class methodsFor:'documentation'!

documentation
"
    An inverseEncoder does the inverse - i.e. encode is really a decode
    and decode is really an encode.
"
! !

!CharacterEncoder::InverseEncoder methodsFor:'accessing'!

decoder:something
    decoder := something.
! !

!CharacterEncoder::InverseEncoder methodsFor:'encoding & decoding'!

decode:aCode
    ^ decoder encode:aCode
!

decodeString:aString
    ^ decoder encodeString:aString
!

encode:aCode
    ^ decoder decode:aCode
!

encodeString:aString
    ^ decoder decodeString:aString
! !

!CharacterEncoder::InverseEncoder methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:(decoder nameOfEncoding);
        nextPutAll:'->';
        nextPutAll:(decoder nameOfDecodedCode)
! !

!CharacterEncoder::InverseEncoder methodsFor:'queries'!

characterSize:charOrcodePoint
    "return the number of bytes required to encode codePoint"

    ^ decoder characterSize:charOrcodePoint
! !

!CharacterEncoder::InverseEncoder methodsFor:'stream support'!

readNext:charactersToRead charactersFrom:stream 
    ^ decoder readNext:charactersToRead charactersFrom:stream

    "Created: / 05-10-2015 / 09:05:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readNextCharacterFrom:aStream
    ^ decoder readNextCharacterFrom:aStream

    "Created: / 05-10-2015 / 09:05:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readNextInputCharacterFrom:aStream
    ^ decoder readNextInputCharacterFrom:aStream
! !

!CharacterEncoder::NullEncoder class methodsFor:'documentation'!

documentation
"
    A NullEncoder does nothing.
"
! !

!CharacterEncoder::NullEncoder methodsFor:'encoding & decoding'!

decode:aCode
    ^ aCode
!

decodeString:aString
    ^ aString
!

encode:aCode
    ^ aCode
!

encodeString:aString
    ^ aString
! !

!CharacterEncoder::NullEncoder methodsFor:'queries'!

isNullEncoder
    ^ true
! !

!CharacterEncoder::OtherEncoding class methodsFor:'private'!

flushCode
!

generateEncoderCode
! !

!CharacterEncoder::TwoStepEncoder class methodsFor:'documentation'!

documentation
"
    A twoStepEncoder uses two real encoders;
    to encode:
        string -> encoder1(encode) -> encoder2(encode) -> result
    to decode:
        string -> encoder2(decode) -> encoder1(decode) -> result
"
! !

!CharacterEncoder::TwoStepEncoder methodsFor:'accessing'!

encoder1:encoder1Arg encoder2:encoder2Arg
    "set instance variables (automatically generated)"

    encoder1 := encoder1Arg.
    encoder2 := encoder2Arg.
! !

!CharacterEncoder::TwoStepEncoder methodsFor:'encoding & decoding'!

decode:aCode
    ^ encoder1 decode:(encoder2 decode:aCode)
!

decodeString:aString
    ^ encoder1 decodeString:(encoder2 decodeString:aString)
!

encode:aCode
    ^ encoder2 encode:(encoder1 encode:aCode)
!

encodeString:aString
    ^ encoder2 encodeString:(encoder1 encodeString:aString)
! !

!CharacterEncoder::TwoStepEncoder methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:(encoder1 nameOfDecodedCode);
        nextPutAll:'->';
        nextPutAll:(encoder1 nameOfEncoding);
        nextPutAll:'->';
        nextPutAll:(encoder2 nameOfEncoding)
! !

!CharacterEncoder::TwoStepEncoder methodsFor:'queries'!

characterSize:codePoint
    "return the number of bytes required to encode codePoint"

    "/ naive; actually, we have to do a real encoding to get this info proper
    ^ (encoder2 characterSize:codePoint)

    "Created: / 22-11-2012 / 13:07:47 / cg"
!

nameOfEncoding
    ^ "encoder1 nameOfEncoding , '-' ," encoder2 nameOfEncoding
















! !

!CharacterEncoder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


CharacterEncoder initialize!
