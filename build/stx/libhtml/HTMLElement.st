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

Array variableSubclass:#HTMLElement
	instanceVariableNames:'next parent sourcePosition bounds'
	classVariableNames:'ColorSpecs'
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLElement class methodsFor:'documentation'!

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
    Notice & Warning: 
        this HTML markup framework and the corresponding parser
        started as a quick hack (in the 90's) when replacing a buggy mosaic
        X-widget with a Smalltalk written HTML viewer. 
        Its goals were to be fast enough for typical uses, to be not too memory hungry
        and to provide the functionality required to display simple help documents.
        It was NOT meant to become a full featured web-browser replacement.

        The viewer and htmlElement framework are still in use as the document viewer inside ST/X,
        and supported to the extent that simple online help documents and html-tooltips are to be displayed.
        However, there are no plans to further enhance or spend other time on its maintenance.

        If you need more sophisticated html/dom/doc functionality, you may want to use either
        the HTMLTree framework or one of the free frameworks found in the goodies folder.


    a generic element (both TAGS and text-fragments).
    This is an abstract class, providing support to handle
    a document as a linked list of elements..

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLElement class methodsFor:'helpers'!

colorForSpec:aSpec
    "returns the color for a spec or nil
    "
    |clr|

    aSpec notNil ifTrue:[
        ColorSpecs notNil ifTrue:[
            (clr := ColorSpecs at:aSpec ifAbsent:nil) isNil ifTrue:[
                (clr := Color name:aSpec ifIllegal:nil) isNil ifTrue:[
                    "/
                    "/ netscape seems to accept xxxx instead of #xxxx as well ...
                    "/
                    clr := Color name:('#' , aSpec)
                            ifIllegal:[ ('HTML[info]: invalid color aSpec: ' , aSpec) infoPrintCR. #NIL ].
                ].
                ColorSpecs at:aSpec put:clr.
            ].
            clr isColor ifTrue:[ ^ clr ]
        ].
    ].
    ^ nil

! !

!HTMLElement class methodsFor:'instance release'!

lowSpaceCleanup
    "cleanup in low-memory situations"

    self releaseColors

    "Created: / 10-02-2007 / 14:42:01 / cg"
    "Modified (comment): / 20-07-2017 / 12:06:34 / cg"
!

releaseColors
    "release cached colors"

    ColorSpecs := Dictionary new

    "Modified: / 10-02-2007 / 14:41:36 / cg"
! !

!HTMLElement methodsFor:'accessing'!

bounds
    "return bounds; a rectangle or rectangle collection"

    ^ bounds

    "Created: 21.5.1996 / 16:03:04 / cg"
!

bounds:aRectangleOrRectangleCollection
    "set bounds; a rectangle or rectangle collection"

    bounds := aRectangleOrRectangleCollection.

    "Created: 21.5.1996 / 16:03:04 / cg"
!

colorParameter:keyword
    "return the color of a color parameter - or nil, if there is none"

    |slot s v|

    slot := self parameterSlotIndexFor:keyword.

    slot ~~ 0 ifTrue:[
	s := self at:slot.
	s isString ifFalse:[^ s].

	v := self class colorForSpec:s.
	v notNil ifTrue:[
	    self at:slot put:v.
	    ^ v
	].
	"/ ('HTMLMarkup [info]: invalid color in: ' , (self text ? '')) infoPrintCR.
    ].
    ^ nil

    "Modified: / 23-08-2011 / 07:48:36 / cg"
!

hasParameterFor:keyword 
    ^ (self parameterSlotIndexFor:keyword) ~~ 0

    "Modified (format): / 19-11-2016 / 15:48:22 / cg"
!

id
    ^ self parameterFor:#'ID'
!

name
    ^ self parameterFor:#'NAME'
!

next
    ^ next

    "Created: 9.10.1996 / 16:43:32 / cg"
!

next:something
    next := something.

    "Created: 9.10.1996 / 16:43:32 / cg"
!

numericParameterFor:keyword
    "return the value of a number parameter - or nil, if there is none"

    ^ self numericParameterFor:keyword default:nil
!

numericParameterFor:keyword default:default
    "return the value of a number parameter - or the default, if there is none"

    |slot s v|

    slot := self parameterSlotIndexFor:keyword.

    slot ~~ 0 ifTrue:[
        s := self at:slot.
        s isString ifFalse:[^ s ? default].

        s := s readStream.
        (v := Integer readFrom:s onError:nil) notNil ifTrue:[
            s next == $% ifTrue:[v := v asFloat].
            self at:slot put:v.    
            ^ v
        ].
        ('HTML [warning]: invalid number in: ' , (self text ? 'nil')) infoPrintCR.
    ].
    ^ default

    "Modified: / 12.8.1998 / 11:24:35 / cg"
!

parameterFor:keyword
    |slotIndex|

    slotIndex := self parameterSlotIndexFor:keyword.
    slotIndex ~~ 0 ifTrue:[
        ^ self at:slotIndex
    ].
    ^ nil
!

parameterFor:keyword put:newValue
    |slotIndex|

    slotIndex := self parameterSlotIndexFor:keyword.
    slotIndex ~~ 0 ifTrue:[
        ^ self at:slotIndex put:newValue
    ].
    self error:'no such slot'.
    ^ nil
!

parameterSlotIndexFor:keyword
    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to:sz by:2 do:[:i|
        ((self at:i) sameAs: keyword) ifTrue:[
            ^ (i + 1)
        ]
    ].
    ^ 0
!

parent
    ^ parent
!

parent:something
    parent := something.
!

sourcePosition
    ^ sourcePosition
!

sourcePosition:something
    sourcePosition := something.
!

styleParameterFor:keyword
    "limited style= value extraction.
     Does not handle all cases (currently); no escaped quotes, for example.
     Just a quick hack to allow for <img style=''width:w; height:h''> to be parsed."
     
    |style s key rest|

    (style := self parameterFor:'STYLE') notNil ifTrue:[
        s := style readStream.
        [s atEnd] whileFalse:[
            s skipSeparators.
            key := s upTo:$:.
            s skipSeparators.
            s peek == $" ifTrue:[
                rest := s upTo:$".
                s skipSeparators.
                s peek == $; ifTrue:[ s next ].
            ] ifFalse:[
                rest := s upTo:$;.
            ].    
            rest := rest withoutSeparators.
            (key sameAs: keyword) ifTrue:[
                ^ rest
            ].    
        ].    
    ].    
    ^ nil

    "Created: / 29-03-2017 / 13:10:00 / cg"
!

tag
    "return the markup's tag, a symbol or nil"

    ^ nil
!

type
    "return the markup's type, a symbol or nil"

    ^ nil
! !

!HTMLElement methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for myself and all remaining elements"

    |m|

    m := self.
    [m notNil] whileTrue:[
        aBlock value:m.
        m := m next
    ].

    "Created: / 27.5.1998 / 13:09:58 / cg"
!

printElementsDo:aBlock
    "redefined to show only the attributes contained within the array
    "
    ^ super do:aBlock

    "Created: / 20.1.1998 / 14:11:02 / stefan"
! !

!HTMLElement methodsFor:'printing'!

displayOn:aStream
    self printHTMLOn:aStream

    "Created: / 26-01-2007 / 12:47:24 / cg"
!

printHTMLOn:aStream
    self subclassResponsibility
!

printOn:aStream
    self printHTMLOn:aStream

    "Created: / 26-01-2007 / 12:47:24 / cg"
! !

!HTMLElement methodsFor:'queries'!

boundsTop
    |firstRectangle|
    
    bounds isNil ifTrue:[^ nil].
    bounds size == 0 ifTrue:[
        firstRectangle := bounds
    ] ifFalse:[
        firstRectangle := bounds first
    ].
    ^ firstRectangle top
    
    "Modified: 21.5.1996 / 10:16:12 / cg"
    "Created: 21.5.1996 / 11:15:57 / cg"
! !

!HTMLElement methodsFor:'testing'!

isAnchor
    ^ false
!

isEndTag
    ^ false
!

isFormElement
    ^ false
!

isFormEndElement
    ^ false
!

isHead
    ^ false
!

isHeading
    ^ false
!

isImageElement
    ^ false
!

isInputElement
    ^ false
!

isOptionElement
    ^ false

    "Created: / 26-01-2007 / 15:09:46 / cg"
!

isSelectElement
    ^ false

    "Created: / 26-01-2007 / 11:44:41 / cg"
!

isSelectEndElement
    ^ false

    "Created: / 26-01-2007 / 15:08:56 / cg"
!

isTextElement
    ^ false
! !

!HTMLElement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLElement.st,v 1.30 2017-07-20 10:06:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLElement.st,v 1.30 2017-07-20 10:06:52 cg Exp $'
! !

