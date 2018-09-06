"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

Object subclass:#HTMLDocument
	instanceVariableNames:'markup fileName url'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLDocument class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!HTMLDocument methodsFor:'accessing'!

fileName
    "return the value of the instance variable 'fileName' (automatically generated)"

    ^ fileName
!

fileName:something
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := something.
!

markup
    "return the value of the instance variable 'markup' (automatically generated)"

    ^ markup
!

markup:something
    "set the value of the instance variable 'markup' (automatically generated)"

    markup := something.
!

url
    ^ url
!

url:something
    url := something.
! !

!HTMLDocument methodsFor:'enumeration'!

markUpElementsDo:aBlock
    |m|

    m := markup.
    [m notNil] whileTrue:[
        aBlock value:m.
        m := m next.
    ].
! !

!HTMLDocument methodsFor:'printing'!

printHTMLOn:aStream
    |el|

    el := markup.
    [el notNil] whileTrue:[
        el printHTMLOn:aStream.
        el := el next
    ].
! !

!HTMLDocument methodsFor:'queries'!

anchorElements
    "return a collection of anchors-elements"

    |anchorElements|

    anchorElements := OrderedCollection new.

    self markUpElementsDo:[:eachElement |
        eachElement isAnchor ifTrue:[
            anchorElements add:eachElement
        ]
    ].
    ^ anchorElements
!

documentTitle
    "return the documents title (from the head).
     This is a q&d hack."

    |inHead next|

    inHead := false.
    self markUpElementsDo:[:eachElement |
        eachElement tag = 'head' ifTrue:[ inHead := true. ].
        eachElement tag = '/head' ifTrue:[ ^ nil. ].
        eachElement tag = 'title' ifTrue:[
            inHead ifTrue:[
                next := eachElement next.
                next isTextElement ifTrue:[
                    ^ next text
                ]
            ].
        ].
    ].
    ^ nil
!

elementsForWhich:aFilter
    "return a collection which satisfy aFilter"

    |elements|

    elements := OrderedCollection new.

    self markUpElementsDo:[:eachElement |
        (aFilter value:eachElement) ifTrue:[
            elements add:eachElement
        ]
    ].
    ^ elements
!

formElements
    "return a collection of FORM-elements"

    ^ self elementsForWhich:[:el | el isFormElement]
!

imageElements
    "return a collection of IMG-elements"

    ^ self elementsForWhich:[:el | el isImageElement]
!

imageFilenames
    "return a collection of referenced IMG-filenames"

    |imageElements|

    imageElements := self imageElements.
    ^ imageElements collect:[:eachImageElement |
            |imgURL url fn|

            imgURL := eachImageElement urlString.
            url := URL fromString:imgURL.
            (url method isNil or:[url method = 'file']) ifTrue:[
                fn := url file.
                fn := fn asFilename.
                fn isAbsolute ifFalse:[
                    fn := (self fileName asFilename directory construct:fn) pathName asFilename                
                ].
            ] ifFalse:[
                self halt:'unhandled method in url'.
            ].
            fn
"/        self fileName asFilename construct:    
        ].

    "
     |p in document|

     p := HTMLParser new.
     in := '../../doc/online/english/tools/newbrowser/TOP.html' asFilename readStream.
     document := p parseText:in.
     in close.
     document imageFilenames      
    "
!

isFormElement
    ^ false
!

isFormEndElement
    ^ false
! !

!HTMLDocument class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocument.st,v 1.10 2008-10-21 22:19:09 cg Exp $'
! !
