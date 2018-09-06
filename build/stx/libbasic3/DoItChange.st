"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

Change subclass:#DoItChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!DoItChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    I represent a doIt (typically #initialize-messages) within a changeSet
"
! !

!DoItChange methodsFor:'applying'!

apply
    "apply the change"

    Compiler evaluate:source.
! !

!DoItChange methodsFor:'comparing'!

isInitialize
    "return true, if the given change represents a #initialize message."

    |tree|

    tree := Parser parseExpression:source.
    ^ tree isMessage and:[tree selector == #initialize]
!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    changeB isDoIt ifFalse:[^ false].
    ^ self sameSourceAs:changeB


! !

!DoItChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'DoIt: '.
    aStream nextPutAll:source.
! !

!DoItChange methodsFor:'queries'!

receiverClassName
    |tree|

    tree := Parser parseExpression:source.
    (tree isNil or:[tree isSymbol]) ifTrue:[^ nil].
    tree isMessage ifFalse:[^ nil].
    tree receiver isVariable ifFalse:[^ nil].
    ^ tree receiver name
! !

!DoItChange methodsFor:'testing'!

isDoIt
    ^ true
! !

!DoItChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitDoItChange:self.

    "Created: / 25-11-2011 / 17:15:07 / cg"
! !

!DoItChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/DoItChange.st,v 1.13 2014-02-19 13:05:08 cg Exp $'
! !

