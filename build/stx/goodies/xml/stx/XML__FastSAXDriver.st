"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/xml/stx' }"

"{ NameSpace: XML }"

Object subclass:#FastSAXDriver
	instanceVariableNames:'inStream hereChar characters emptyDict'
	classVariableNames:'EmptyDictionary'
	poolDictionaries:''
	category:'XML-STX-SAX'
!

!FastSAXDriver class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    A stripped-down, but much faster abstract superclass for XML-Parsers.
    To use: subclass from this (FastSAXDriver) instead of from SAXDriver.
    (whitebox API is the same).

    Disadvantages:
        no namespaces;
        no defined entities;
        ignores processing instructions
        all hard coded.
        treats '.' and ':' as alpha-characters within a tag.

    Advantages:
        super fast


    Use at your own risk, and only for XML which is known to be valid (i.e., your own).

    [author:]
        Claus Gittinger
"
!

examples
"
    |decoder artefact|

    decoder := NewXMLArtifactDecoder 
                    on:(theArtifact at:2) asString readStream
                    beforeScanDo:[:parser | 
                        parser builder driver dataBase:self.
                        parser validate:false
                    ].
    artefact := decoder decodedObject.
"
! !

!FastSAXDriver class methodsFor:'initialization'!

initialize
    EmptyDictionary isNil ifTrue:[
        EmptyDictionary := Dictionary new.
    ].

    "Created: / 30-11-2017 / 17:41:47 / cg"
! !

!FastSAXDriver class methodsFor:'instance creation'!

on:aStream
    ^ self new on:aStream beforeScanDo:[:driver |]
!

on:aStream beforeScanDo:aOneArgBlock
    ^ self new on:aStream beforeScanDo:aOneArgBlock

    "Created: / 17-11-2007 / 17:00:07 / cg"
! !

!FastSAXDriver methodsFor:'accessing'!

inStream:aStream
    inStream := aStream.
! !

!FastSAXDriver methodsFor:'api'!

characterEncoding:encoding
    "use encoding to decode the stream's contents"

    |in|

    (encoding ~= #ascii and:[encoding ~= #'iso8859-1']) ifTrue:[
        (in := inStream) isEncodedStream ifTrue:[
            "no double-decode: if already encoded - go back to unencoded stream"
            in := in inputStream.
        ].
        self inStream:(EncodedStream 
                        stream:in 
                        encoder:(CharacterEncoder encoderFor:encoding ifAbsent:[
                            self error:'XML::FastSAXDriver: no decoder for ' , encoding mayProceed:true.
                            "proceed to use inStream without decoder"
                            ^ self.   
                         ])).
    ].
!

characters:characters
"/    self halt.

    "Created: / 18-11-2007 / 13:58:35 / cg"
!

decodeAttributeValue:value
    ^ value
!

endElement:tag namespace:alwaysNil1 prefix:alwaysNil2 
"/    self halt.

    "Created: / 18-11-2007 / 14:04:11 / cg"
!

startElement:tag namespace:alwaysNil1 prefix:alwaysNil2 attributes:attsOrNil
"/    self halt.

    "Created: / 18-11-2007 / 13:55:46 / cg"
! !

!FastSAXDriver methodsFor:'api-dummy'!

builder 
    ^ self

    "Created: / 18-11-2007 / 14:39:00 / cg"
!

documentLocator:ignored
!

driver
    ^ self

    "Created: / 18-11-2007 / 14:39:02 / cg"
!

tagPosition:aStreamPosition
    "can be redefined to remember the startPosition"
!

validate:doValidate
    self assert:(doValidate == false).

    "Created: / 18-11-2007 / 14:39:37 / cg"
! !

!FastSAXDriver methodsFor:'error handling'!

parseError:message
    MalformedSignal raiseErrorString:message

    "Modified: / 26-04-2010 / 18:39:21 / cg"
! !

!FastSAXDriver methodsFor:'parsing'!

on:aStream beforeScanDo:aOneArgBlock
    emptyDict := EmptyDictionary. "/ passed as empty attributes collection

    self inStream:aStream.
    aOneArgBlock value:self.
    ^ self readNextObject.

    "Created: / 17-11-2007 / 17:00:38 / cg"
    "Modified (comment): / 30-11-2017 / 17:43:41 / cg"
!

processingInstruction:tag attributes:attrDictionary
    |encoding|

    (tag sameAs:'xml') ifTrue:[
        "utf-8 is default per XML standard"
        encoding := attrDictionary at:'encoding' ifAbsent:#'utf-8'.
        encoding notNil ifTrue:[
            self characterEncoding:encoding.    
        ].
        ^ self
    ].

    self halt:'FastSAXDriver: unknown processing instruction with tag: ', tag.

    "Created: / 04-11-2014 / 13:41:27 / sr"
!

readAttributeAndAddTo:attributesInDictionaryOrNil
    "read an attribute and add it to attributesInDictionaryOrNil.
     If attributesInDictionaryOrNil is nil, create a new Dictionary"

    |key atts|

    key := self readTagOrAttributeName.
    inStream skipSeparators.
    inStream next == $= ifFalse:[
        self parseError:'= expected'
    ].
    inStream skipSeparators.

    atts := attributesInDictionaryOrNil.
    atts isNil ifTrue:[
        atts := Dictionary new.
    ].
    atts at:key put:self readQuotedValue.
    ^ atts.

    "Created: / 17-02-2017 / 12:46:34 / stefan"
!

readElements
    "read xml elements."

    |tag peekc endTag atts isEnd nextChar|

    tag := self readTagOrAttributeName.
    inStream skipSeparators.
    [peekc := inStream peek. peekc ~~ $> and:[peekc ~~ $/]] whileTrue:[
        atts := self readAttributeAndAddTo:atts.
        inStream skipSeparators.
    ].
    isEnd := (peekc == $/).
    isEnd ifFalse:[
        "/ leave instream positioned after the '>' (for CDATA handling)
        inStream next.
    ].

    self startElement:tag namespace:nil prefix:nil attributes:(atts ? emptyDict).

    isEnd ifTrue:[
        "we got a <element />"
        inStream next.      "/ skip over '/'
        
        nextChar := inStream next.
        nextChar ~~ $> ifTrue:[
            self parseError:'> expected'.
        ].
        self endElement:tag namespace:nil prefix:nil.
        ^ self.
    ].

    [
        "read element's cdata. read until end tag or start tag of child element"
        characters := self upTo:$< from:inStream.
        characters notEmpty ifTrue:[
            (characters includes:$&) ifTrue:[
                characters := self unEscape:characters.
            ].
            self characters:characters
        ].
        self tagPosition:(inStream position - 1).

        "here we got a <"
        peekc := inStream peek.
        peekc == $!! ifTrue:[
            "skip comment"
            inStream throughAll:'-->'.
        ] ifFalse:[
            peekc == $/ ifTrue:[
                "end of element"
                inStream next.
                endTag := self readTagOrAttributeName.
                endTag ~= tag ifTrue:[
                    self parseError:'endTag does not match startTag'.
                ].
                nextChar := inStream next.
                nextChar ~~ $> ifTrue:[
                    nextChar isSeparator ifTrue:[
                        inStream skipSeparators.
                        nextChar := inStream next.
                    ].
                    nextChar ~~ $> ifTrue:[
                        self parseError:'> expected'.
                    ].
                ].
                self endElement:tag namespace:nil prefix:nil.
                ^ self.
            ].

            "read child elements"
            self readElements
        ].
    ] loop.

    "Created: / 18-11-2007 / 12:21:53 / cg"
    "Modified (format): / 17-02-2017 / 13:49:01 / stefan"
    "Modified: / 30-11-2017 / 17:43:13 / cg"
!

readNextObject
    |tag atts ch|

    inStream skipSeparators.
    ch := inStream next.
    ch ~~ $< ifTrue:[
        self parseError:(ch isNil 
                            ifTrue:['"<" expected (start of element-tag) - got EOF'] 
                            ifFalse:['"<" expected (start of element-tag) - got "%1"' bindWith:ch asString]).
    ].

    [((ch := inStream peek) == $!!) or:[ch == $?]] whileTrue:[
        "process entity definitions and processing instructions"
        ch == $!! ifTrue:[
            "/ skip...
            inStream next.
            tag := self readTagOrAttributeName.
            inStream skipSeparators.
            [(ch := inStream peek) ~~ $> ] whileTrue:[
                ch == $" ifTrue:[
                    self readQuotedValue.
                ] ifFalse:[
                    self readTagOrAttributeName.
                ].
                inStream skipSeparators.
            ].
            inStream next; skipSeparators.
            inStream next ~~ $< ifTrue:[
                self parseError:'"<" expected (start of element-tag)'.
            ].
        ] ifFalse:[
            "/ process processing instructions...
            inStream next.
            tag := self readTagOrAttributeName.
            inStream skipSeparators.
            [ inStream peek ~~ $? ] whileTrue:[
                atts := self readAttributeAndAddTo:atts.
                inStream skipSeparators.
            ].
            inStream next.
            inStream next ~~ $> ifTrue:[
                self parseError:'">" expected (end of element-tag)'.
            ].
            self processingInstruction:tag attributes:atts.
            inStream skipSeparators.
            inStream next ~~ $< ifTrue:[
                self parseError:'"<" expected (start of element-tag)'.
            ].
        ].
    ].

    ^ self readElements

    "Modified: / 18-11-2007 / 13:53:45 / cg"
    "Modified: / 04-11-2014 / 13:41:10 / sr"
    "Modified: / 17-02-2017 / 13:40:45 / stefan"
!

readQuotedValue
    | value  peekC|

    ((peekC := inStream next) == $" or:[ peekC == $' ]) ifFalse:[
        self parseError:'" or '' expected'
    ].

    value := self upTo:peekC from:inStream.
    value := self decodeAttributeValue:value.
    (value includes:$&) ifTrue:[
        value := self unEscape:value.
    ].
    ^ value
!

readTagOrAttributeName
    "a tag consists of:
        alphaNumericWords separated by '-', '.' or ':'s"

    |tag next|

    [
        next := inStream nextAlphaNumericWord.
        tag isNil ifTrue:[
            tag := next.
        ] ifFalse:[
            tag := tag , next
        ].
        next := inStream peek.
        (next == $- or:[next == $. or:[next == $:]]) ifFalse:[
            ^ tag.
        ].
        inStream next.
        tag := tag copyWith:next.
    ] loop.

    "Created: / 18-11-2007 / 13:33:29 / cg"
    "Modified: / 17-02-2017 / 13:44:32 / stefan"
!

unEscape:characters
    |in out|

    out := CharacterWriteStream on:''.
    in := characters readStream.
    [in atEnd] whileFalse:[
        |w part code|

        part := self upTo:$& from:in.
        out nextPutAll:part.
        in atEnd ifFalse:[
            in peek == $# ifTrue:[
                in next.
                in peek == $x ifTrue:[
                    "/ hex code
                    in next.
                    code := Integer readFrom:in radix:16.
                ] ifFalse:[
                    code := Integer readFrom:in.
                ].
                out nextPut:(Character value:code).
                in next == $; ifFalse:[
                    self parseError:'; expected after character code'
                ].
            ] ifFalse:[
                w := self upTo:$; from:in.
                w = 'amp' ifTrue:[
                    out nextPut:$&
                ] ifFalse:[
                    w = 'lt' ifTrue:[
                        out nextPut:$<
                    ] ifFalse:[
                        w = 'gt' ifTrue:[
                            out nextPut:$>
                        ] ifFalse:[
                            w = 'apos' ifTrue:[
                                out nextPut:$'
                            ] ifFalse:[
                                w = 'quot' ifTrue:[
                                    out nextPut:$"
                                ] ifFalse:[
        "/                    w = 'nbsp' ifTrue:[
        "/                        out nextPut:(Character value:160).
        "/                    ] ifFalse:[
                                  self breakPoint:#cg.
        "/                    ].
                                ]
                            ]
                        ].
                    ].
                ]
            ].
        ].
    ].
    ^ out contents

    "Created: / 18-11-2007 / 14:27:41 / cg"
    "Modified (format): / 06-03-2017 / 16:01:40 / stefan"
!

upTo: aCharacter from:inStream
    | newStream element collection pos1 pos2 string1|

    "/ special tuning for the common case, when reading a string-stream
    (inStream isPositionable and:[(collection := inStream collection) isString]) ifTrue:[
        pos1 := inStream position + 1.
        pos2 := collection indexOf:aCharacter startingAt:pos1.
        pos2 == 0 ifTrue:[
            string1 := collection copyFrom:pos1 to:(collection size min:inStream readLimit).
            inStream setToEnd.
            ^ string1.
        ].
        pos2 := pos2 min:inStream readLimit.
        string1 := collection copyFrom:pos1 to:pos2-1.
        inStream skip:string1 size+1.
        ^ string1.
    ].

    newStream := CharacterWriteStream on:(String new: 64).
    [(element := inStream next) notNil] whileTrue:[
        element = aCharacter ifTrue: [^newStream contents].
        newStream nextPut: element.
    ].
    ^ newStream contents.

    "
     |s d|
     s := '12345678901234567890' readStream.
     s readLimit:5.
     d := self basicNew.
     d upTo:$x from:s.    
     s position.   
     s atEnd    
    "
    "
     |s d|
     s := '12345678901234567890' readStream.
     s readLimit:5.
     d := self basicNew.
     d upTo:$3 from:s.    
     d upTo:$x from:s.    
     s position.     
     s atEnd         
    "
    "
     |s d|
     s := '12345678901234567890' readStream.
     d := self basicNew.
     d upTo:$x from:s.    
    "
    "
     |s d|
     s := '12345678901234567890' readStream.
     d := self basicNew.
     d upTo:$0 from:s. 
     d upTo:$a from:s. 
     d upTo:$x from:s.    
    "
    "
     |s d|
     s := '12345678901234567890' readStream.
     d := self basicNew.
     d upTo:$0 from:s. 
     d upTo:$a from:s. 
    "
! !

!FastSAXDriver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XML__FastSAXDriver.st,v 1.32 2017-11-30 16:44:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XML__FastSAXDriver.st,v 1.32 2017-11-30 16:44:13 cg Exp $'
! !


FastSAXDriver initialize!
