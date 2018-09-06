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

HTMLElement variableSubclass:#HTMLText
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLText class methodsFor:'documentation'!

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

    a text element.
"
! !

!HTMLText methodsFor:'accessing'!

text
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!HTMLText methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "put a printed representation of the receiver for displaying onto aGCOrStream"

    |text|

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    text := self text.
    text isNil ifTrue:[
        aGCOrStream nextPutAll:'an empty HTMLMarkupText'.
    ] ifFalse:[
        aGCOrStream
            nextPutAll:self classNameWithArticle;
            nextPutAll:'(''';
            nextPutAll:text asStringCollection asString;
            nextPutAll:''')'.
    ].

    "Modified: / 22-02-2017 / 16:56:51 / cg"
!

printHTMLOn:aStream
    self text isString ifFalse:[
        self text do:[:eachPart | aStream nextPutAll:eachPart].
        ^ self.
    ].    
    aStream nextPutAll:self text.
! !

!HTMLText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLText.st,v 1.9 2017-02-22 18:10:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLText.st,v 1.9 2017-02-22 18:10:12 cg Exp $'
! !

