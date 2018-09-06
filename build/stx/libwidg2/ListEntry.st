"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ListEntry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!ListEntry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    ListEntry is an abstract superclass for objects which can be used
    in place of strings in ListViews or SelectionInListViews.

    If you want to create new subclasses, implement (at least) the methods
    found in the 'required protocol' category.

    [author:]
        Claus Gittinger

    [see also:]
        ListView
"
! !

!ListEntry methodsFor:'comparing'!

< aString
    "behave like a string when comparing"

    ^ self asString < aString asString

    "Created: 8.2.1996 / 12:01:29 / cg"
!

= aString
    "behave like a string when comparing"

    self == aString ifTrue:[^ true].
    ^ self asString = aString asString
!

hash
    "return an integer useful for hashing"

    ^ self asString hash
! !

!ListEntry methodsFor:'printing & storing'!

printOn:aStream

    aStream nextPutAll:self asString.

    "Created: / 20.1.1998 / 14:11:02 / stefan"
!

printString
    ^ self asString

    "Created: 8.2.1996 / 11:56:14 / cg"
! !

!ListEntry methodsFor:'queries'!

hasIcon
    ^ false
!

hasImage
    ^ false
!

includes:aCharacter 
    "behave like a string when testing"

    ^ self string includes:aCharacter

    "Modified: / 30.10.1997 / 15:42:32 / cg"
!

size
    "behave like a string when asked for the size"

    ^ self string size

    "Created: / 8.2.1996 / 12:54:45 / cg"
    "Modified: / 30.10.1997 / 15:42:19 / cg"
!

species
    ^ String

    "Created: 8.2.1996 / 12:52:38 / cg"
!

string
    ^ self asString
! !

!ListEntry methodsFor:'required protocol'!

asString
    "return the receiver as a string (for example, to store it in a file)"

    ^ self subclassResponsibility
!

displayOn:aGC x:x y:y opaque:opaque
    "display the receiver on a GC"

    ^ self subclassResponsibility
!

heightOn:aGC
    "return the height of the receiver when displayed in aGC.
     Assume the GC's font is taken. If that is not the case in a
     particular subclass, this method is to be redefined there."

    ^ aGC font heightOn:(aGC device) 

    "Created: 12.5.1996 / 20:37:06 / cg"
!

sameStringAndEmphasisAs:aStringOrText

    ^ self subclassResponsibility
!

widthOn:aGC
    "return the width (in device units) of the receiver when displayed in aGC"

    ^ self subclassResponsibility

    "Created: 12.5.1996 / 20:53:09 / cg"
! !

!ListEntry methodsFor:'string protocol'!

at:index
    "behave like a string when accessing characters"

    ^ self string at:index

    "Created: / 8.2.1996 / 12:53:06 / cg"
    "Modified: / 30.10.1997 / 15:41:47 / cg"
!

do:aBlock
    "behave like a string when enumerating characters"

    ^ self string do:aBlock

    "Created: / 8.2.1996 / 12:56:06 / cg"
    "Modified: / 30.10.1997 / 15:42:06 / cg"
! !

!ListEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

