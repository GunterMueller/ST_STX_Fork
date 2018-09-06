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

HTMLMarkup variableSubclass:#HTMLAnchor
	instanceVariableNames:'anchorText color'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLAnchor class methodsFor:'documentation'!

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
    an anchor element.
    Please read the warning in HTMLElement.
    
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLAnchor methodsFor:'accessing'!

anchorText
    ^ anchorText

    "Created: 20.5.1996 / 16:19:07 / cg"
!

anchorText:aString
    anchorText := aString

    "Created: 20.5.1996 / 16:19:16 / cg"
!

color
    ^ color

    "Created: 21.5.1996 / 23:04:10 / cg"
!

color:something
    color := something.

    "Created: 21.5.1996 / 23:04:10 / cg"
!

hrefString
    |value|

    value := self parameterFor:#'HREF'.
    value isNil ifTrue:[^ nil].
    ^ HTMLUtilities unEscape:value.

    "Created: / 17-05-1996 / 18:29:50 / cg"
    "Modified: / 16-11-2016 / 17:12:04 / cg"
!

hrefString:aString
    self parameterFor:#'HREF' put:aString
!

srcString
    |value|

    value := self parameterFor:#'SRC'.
    ^ HTMLUtilities unEscape:value.

    "Created: / 17-05-1996 / 16:52:08 / cg"
    "Modified: / 14-11-2016 / 14:25:14 / cg"
!

srcString:aString
    self parameterFor:#'SRC' put:aString
! !

!HTMLAnchor methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "put a printed representation of the receiver for displaying onto aGCOrStream"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].
    
    aGCOrStream 
        nextPutAll:self classNameWithArticle;
        nextPutAll:'(<'.
    type printOn:aGCOrStream.
    aGCOrStream space.
    self hrefString printOn:aGCOrStream.
    aGCOrStream nextPutAll:'>)'.

    "Created: / 17-05-1996 / 14:20:51 / cg"
    "Modified: / 22-02-2017 / 16:56:06 / cg"
! !

!HTMLAnchor methodsFor:'queries'!

isCommandExample
    "is this an example which should be executed in a terminal?"
    
    |t|

    t := self typeString.
    ^ t notNil and:[t asLowercase = 'commandexample']
!

isCopyableExample
    "is this a code example to copy into a workspace"

    |t|

    t := self typeString.
    ^ t notNil and:[t asLowercase = 'copyexample']. 
!

isExample
    "is this an executable smalltalk-code example"
    
    |t|

    t := self typeString.
    ^ t notNil and:[t asLowercase = 'example']

    "Modified: 17.5.1996 / 16:55:41 / cg"
    "Created: 17.5.1996 / 18:30:25 / cg"
! !

!HTMLAnchor methodsFor:'testing'!

isAnchor
    ^ true

    "Modified: 17.5.1996 / 16:55:41 / cg"
    "Created: 17.5.1996 / 18:30:25 / cg"
! !

!HTMLAnchor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLAnchor.st,v 1.22 2017-02-22 18:10:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLAnchor.st,v 1.22 2017-02-22 18:10:02 cg Exp $'
! !

