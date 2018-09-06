"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

HTMLElement variableSubclass:#HTMLMarkup
	instanceVariableNames:'type'
	classVariableNames:'MarkTypes'
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLMarkup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Attention: Please read the warning in HTMLElement.

    a generic markup element.
    Provides access to the element's attributes (parameters).
    Also, provides parsing support to extract those from the
    elements string i.e. to read them from the remaining string 
    after the 'foo' in <foo ....>

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLMarkup class methodsFor:'initialization'!

markTypes
    MarkTypes isNil ifTrue:[
        MarkTypes  := IdentityDictionary new.

        MarkTypes at:#a        put:#HTMLAnchor.
        MarkTypes at:#img      put:#HTMLImage.
        MarkTypes at:#ul       put:#HTMLList.
        MarkTypes at:#ol       put:#HTMLList.
        MarkTypes at:#dl       put:#HTMLList.
        MarkTypes at:#dir      put:#HTMLList.
        MarkTypes at:#menu     put:#HTMLList.

        MarkTypes at:#li       put:#HTMLBullet.

        MarkTypes at:#form           put:#HTMLForm.
        MarkTypes at:#input          put:#HTMLWidget.
        MarkTypes at:#textarea       put:#HTMLWidget.
        MarkTypes at:#select         put:#HTMLWidget.
        MarkTypes at:#applet         put:#HTMLApplet.
        MarkTypes at:#app            put:#HTMLApplet.
        MarkTypes at:#jwssuperapplet put:#HTMLApplet.
        MarkTypes at:#table          put:#HTMLTable.
        MarkTypes at:#script         put:#HTMLScript.
        MarkTypes at:#style          put:#HTMLStyle.
    ].
    ^ MarkTypes

    "
     HTMLMarkup initialize
    "

    "Modified: / 10-02-2007 / 14:40:59 / cg"
! !

!HTMLMarkup class methodsFor:'instance creation'!

classForType:aTypeSymbol
    "internal interface - return a markup elements class, given a typeSymbol
     (such as #b, #pre or #'/pre')"

    |clsSym cls myName|

    aTypeSymbol isNil ifTrue:[^ self].
    self assert:aTypeSymbol isSymbol.

    myName := self name.

    "/ only the very first word counts ...
    clsSym := self markTypes at:aTypeSymbol ifAbsent:myName.
    self assert:clsSym notNil.

    cls := Smalltalk at:clsSym ifAbsent:self.
    ^ cls
!

for:aString
    "given a mark's string (such as 'b', 'pre' or '/pre'),
     return a new markup instance"

    |sym idx tag lcTag s rest cls nWanted params markup|

    "/ only the very first word counts ...

    s := aString withoutSeparators.
    idx := s indexOfSeparatorStartingAt:1.
    idx == 0 ifTrue:[
        tag := s
    ] ifFalse:[
        tag := s copyTo:(idx-1).
        rest := s copyFrom:idx+1.
    ].

    lcTag := tag asLowercase.
    sym := lcTag asSymbolIfInterned.
    cls := self classForType:sym.
    rest isNil ifTrue:[
        ^ (cls new) type:(sym ? lcTag) text:rest
    ].
    params := self collectParametersFrom:rest.
    nWanted := params size.
    nWanted == 0 ifTrue:[
        ^ (cls new) type:(sym ? lcTag) text:rest
    ].

    markup := cls new:nWanted.
    markup replaceFrom:1 to:nWanted with:params startingAt:1.
    markup type:(sym ? lcTag) text:rest.
    ^ markup

    "/
    "/  HTMLMarkup for:'IMG border=0 SRC="internal-gopher-unknown"'
    "/

    "Modified: 16.10.1996 / 13:25:42 / cg"
!

type:aTypeSymbol
    "internal interface - create a markup element, given a typeSymbol
     (such as #b, #pre or #'/pre'), return a new markup instance"

    |cls|

    cls := self classForType:aTypeSymbol.
    ^ cls new type:aTypeSymbol text:nil

    "Modified: 16.10.1996 / 13:15:49 / cg"
    "Created: 16.10.1996 / 13:19:18 / cg"
! !

!HTMLMarkup class methodsFor:'helpers'!

collectParametersFrom:text
    |inStream w value next rest params ch|

    text isNil ifTrue:[^ nil].

    params := OrderedCollection new.

    inStream := text readStream.
    inStream skipSeparators.
    [inStream atEnd] whileFalse:[
        w := inStream nextAlphaNumericWord.
        "/ sigh; '-' and underline are allowed ...
        [(ch := inStream peekOrNil) == $- or:[ch == $_]] whileTrue:[
            inStream next.
            w := w , ch.
            ((ch := inStream peekOrNil) notNil and:[ch isLetterOrDigit]) ifTrue:[
                rest := inStream nextAlphaNumericWord.
                rest notNil ifTrue:[
                    w := w , rest.
                ]
            ]
        ].
        w isNil ifTrue:[
            ^ params
        ].

        value := nil.
        inStream skipSeparators.
        inStream peekOrNil == $= ifTrue:[
            inStream next.
            inStream skipSeparators.
            next := inStream peekOrNil.
            ((next == $") or:[next == $']) ifTrue:[
                inStream next.
                value := inStream upTo:next.
            ] ifFalse:[
                value := inStream upToSeparator.
            ].
            "/ this is wrong!!
            "/ value := HTMLUtilities unEscape:value.
            value := HTMLUtilities unescapeCharacterEntities:value.
        ].
        params add:(w asUppercase asSymbol); add:value.
        inStream skipSeparators.
    ].
    ^ params.

    "
     (HTMLParser new) parseText:'<font size=''+2''>world</font>'  
     (HTMLParser new) parseText:'<font size=+2>world</font>'  
    "

    "Created: / 12-06-1996 / 19:32:04 / cg"
    "Modified: / 05-08-1996 / 09:05:22 / stefan"
    "Modified: / 23-03-2017 / 12:18:27 / cg"
    "Modified: / 23-08-2018 / 00:16:33 / Claus Gittinger"
!

parameterFor:keyword from:text
    "look for the value of a keyword parameter; return
     it as a string or nil, if no value given, or parameter is not present.
     Notice: returns nil if parameter is there, but without a value."

    ^ self parameterFor:keyword orLowerCase:keyword asLowercase from:text

    "Created: 12.6.1996 / 19:33:13 / cg"
    "Modified: 4.1.1997 / 23:32:49 / cg"
!

parameterFor:keyword orLowerCase:lcKeyword from:text
    "look for the value of a keyword parameter; return
     it as a string or nil, if no value given, or parameter is not present.
     Notice: returns nil if parameter is there, but without a value."

    |inStream sIdx eIdx found i w value next rest|

    text isNil ifTrue:[^ nil].

    "/ first, a quick check, if that keyword is contained
    "/ in the string at all. (avoid decomposing if possible)

    (     (text findString:keyword) == 0
     and:[(text asLowercase findString:lcKeyword) == 0]
    ) ifTrue:[
        ^ nil
    ].

    inStream := text readStream.
    inStream skipSeparators.
    [inStream atEnd] whileFalse:[
        w := inStream nextAlphaNumericWord.
        "/ sigh; '-' is allowed ...
        [inStream peekOrNil == $-] whileTrue:[
            inStream next.
            w := w , '-'.
            rest := inStream nextAlphaNumericWord.
            rest notNil ifTrue:[
                w := w , rest.
            ]
        ].
        w isNil ifTrue:[
            ^ nil
        ].

        found := (w = keyword) or:[w = lcKeyword or:[w asLowercase = lcKeyword]].

        value := nil.
        inStream skipSeparators.
        inStream peekOrNil == $= ifTrue:[
            inStream next.
            inStream skipSeparators.
            next := inStream peekOrNil.
            ((next == $") or:[next == $']) ifTrue:[
                inStream next.
                value := inStream upTo:next.
            ] ifFalse:[
                value := inStream upToSeparator.
            ]
        ].
        found ifTrue:[
            ^ value
        ].
        inStream skipSeparators.
    ].
    ^ nil.
"/
"/ old code - wrong.
"/
"/    "/ avoid detecting a substring as parameter
"/
"/    idx ~~ 1 ifTrue:[
"/        found := false.
"/
"/        [found] whileFalse:[
"/            previousCharacter := text at:(idx - 1).
"/            previousCharacter isLetter ifFalse:[
"/                found := true
"/            ] ifTrue:[
"/                (i := text findString:keyword startingAt:idx+1) == 0 ifTrue:[
"/                    (i := text findString:lcKeyword startingAt:idx+1) == 0 ifTrue:[
"/                        ^ nil
"/                    ]
"/                ].
"/                idx := i
"/            ]
"/        ]
"/    ].
"/
"/    "/ look for more
"/    idx := idx+keyword size.
"/    [idx < text size and:[(text at:idx) isSeparator]] whileTrue:[
"/        idx := idx + 1
"/    ].
"/    (idx > text size or:[(text at:idx) ~= $=]) ifTrue:[
"/        ^ nil
"/    ].
"/    idx := idx + 1.
"/
"/    nm := (text copyFrom:idx) withoutSeparators.
"/    (nm startsWith:$") ifTrue:[
"/        eIdx := nm indexOf:$" startingAt:2.
"/        sIdx := 2.
"/    ] ifFalse:[
"/        (nm startsWith:$') ifTrue:[
"/            eIdx := nm indexOf:$' startingAt:2.
"/            sIdx := 2.
"/        ] ifFalse:[
"/            eIdx := nm indexOfSeparatorStartingAt:1.
"/            sIdx := 1.
"/        ].
"/    ].
"/    eIdx == 0 ifTrue:[
"/        eIdx := nm size + 1.
"/    ].
"/    nm := nm copyFrom:sIdx to:eIdx-1.
"/
"/    ^ nm.

    "Created: / 12.6.1996 / 19:32:04 / cg"
    "Modified: / 5.8.1996 / 09:05:22 / stefan"
    "Modified: / 14.4.1998 / 18:53:29 / cg"
! !

!HTMLMarkup methodsFor:'accessing'!

tag
    "return the markup's type, a symbol"

    ^ type

    "Created: 16.5.1996 / 13:05:14 / cg"
    "Modified: 16.5.1996 / 13:05:25 / cg"
!

text
    "return the markup's text, if any.
     Notice: we removed the text storing capability of the general markup
     and only allow for the HTMLText to store it."

    "/ self halt:'method is no longer valid'.
    ^ nil

    "Created: / 20.5.1996 / 12:21:41 / cg"
    "Modified: / 28.4.1998 / 17:59:26 / cg"
!

text:aString
    "ignored here - for protocol completeness"

    "/ self warn:'text ignored'.
    "/ text := aString

    "Created: 20.5.1996 / 12:21:53 / cg"
    "Modified: 4.1.1997 / 23:24:41 / cg"
!

type
    "return the markup's type, a symbol"

    ^ type

    "Created: 16.5.1996 / 13:05:14 / cg"
    "Modified: 16.5.1996 / 13:05:25 / cg"
!

type:aSymbol
    "set the markup's type to aSymbol"

    type := aSymbol.

    "Created: 16.5.1996 / 13:05:14 / cg"
    "Modified: 16.5.1996 / 13:05:41 / cg"
!

type:aSymbol text:aString
    "set the markup's type to aSymbol and textInfo to aString"

    type := aSymbol.
    self text:aString

    "Created: 16.5.1996 / 13:05:14 / cg"
    "Modified: 4.1.1997 / 23:21:56 / cg"
! !

!HTMLMarkup methodsFor:'printing'!

printHTMLOn:aStream
    aStream nextPut:$<;  nextPutAll:type.
    1 to:self size by:2 do:[:i|
        |kw val|

        aStream space.
        kw := self at:i.
        val := self at:i+1.
        aStream nextPutAll:kw.
        val notNil ifTrue:[
            aStream nextPutAll:'="'.
            val printOn:aStream.
            aStream nextPut:$".
        ].
    ].
    aStream nextPut:$>.
    self text notNil ifTrue:[ aStream nextPutAll:self text ].

    "Modified: / 17-02-2017 / 09:50:32 / stefan"
! !

!HTMLMarkup methodsFor:'queries'!

actionString

    ^ self parameterFor:#ACTION

    "Created: 21.5.1996 / 19:08:10 / cg"
    "Modified: 5.3.1997 / 18:08:39 / cg"
!

alignSymbol
    "return the align parameter - or nil, if there is none"

    |slot s v|

    slot := self parameterSlotIndexFor:#ALIGN.

    slot ~~ 0 ifTrue:[
        s := self at:slot.
        s isString ifFalse:[^ s].

        v := s asLowercase asSymbol.
        self at:slot put:v.    
        ^ v
    ].
    ^ nil

!

nameString

    ^ self parameterFor:#NAME

    "Created: 18.6.1996 / 20:59:14 / cg"
    "Modified: 5.3.1997 / 18:08:46 / cg"
!

typeString
    ^ self parameterFor:#TYPE

    "Created: 20.5.1996 / 18:39:52 / cg"
    "Modified: 5.3.1997 / 18:08:48 / cg"
!

valignSymbol
    "return the valign parameter - or nil, if there is none"

    |slot s v|

    slot := self parameterSlotIndexFor:#VALIGN.

    slot ~~ 0 ifTrue:[
        s := self at:slot.
        s isString ifFalse:[^ s].

        v := s asLowercase asSymbol.
        self at:slot put:v.    
        ^ v
    ].
    ^ nil

!

valueString
    ^ self parameterFor:#VALUE

    "Created: 4.1.1997 / 23:29:22 / cg"
    "Modified: 5.3.1997 / 18:08:51 / cg"
! !

!HTMLMarkup methodsFor:'testing'!

isEndTag
    ^ type notEmptyOrNil and:[ (type at:1) = $/ ]
!

isFormEndElement
    ^ type = '/form'
!

isHeading
    "true if the receiver is one of the <hI> tags"

    ^ type size == 2 and:[(type at:1) asLowercase = $h and:[ (type at:2) isDigit ]]
!

isOptionElement
    ^ type = 'option'

    "Created: / 26-01-2007 / 15:09:42 / cg"
!

isPrintable
    "answer true, if element can be printed"

    |p|

    "we do not support cSS, but we suppose,
     that the noprint class should not be printed - 
     without looking at CSS"

    p := self parameterFor:#CLASS.
    p notNil ifTrue:[
        p = 'noprint' ifTrue:[
            ^ false.
        ]
    ].

    "NOPRINT and PRINT is not valid HTML (4), bu supported for
     backward compatibility"

    (self hasParameterFor:#NOPRINT) ifTrue:[^ false].
    p := self parameterFor:#PRINT.
    p notNil ifTrue:[
        p asLowercase = 'no' ifTrue:[
            ^ false.
        ]
    ].

    ^ true
!

isSelectEndElement
    ^ type = '/select'

    "Created: / 26-01-2007 / 15:09:01 / cg"
!

isSelected
    self isOptionElement ifTrue:[
        ^ self hasParameterFor:'SELECTED'
    ].
    ^ false.

    "Created: / 26-01-2007 / 15:11:27 / cg"
! !

!HTMLMarkup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLMarkup.st,v 1.60 2018-08-22 22:17:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLMarkup.st,v 1.60 2018-08-22 22:17:00 cg Exp $'
! !

