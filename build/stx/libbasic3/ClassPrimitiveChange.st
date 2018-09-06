"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

ClassChange subclass:#ClassPrimitiveChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassPrimitiveChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Abstract superclass for all primitive code changes
"
! !

!ClassPrimitiveChange methodsFor:'accessing'!

class:aClass source:newSource
    self assert:(newSource isString).

    className := aClass name.
    source := newSource

    "Created: 3.12.1995 / 14:02:40 / cg"
    "Modified: 3.12.1995 / 14:06:33 / cg"
! !

!ClassPrimitiveChange methodsFor:'applying'!

apply
    "apply the change"

    |class|

    class := self changeClass.
    class isNil ifTrue:[
        self error:('Cannot apply change for missing class: ' , className) mayProceed:true.
        ^ self
    ].
    class autoload.         "Most changes cannot be applied to unloaded classes"
    Class nameSpaceQuerySignal answer:self nameSpace do:[
        self privateApply
    ].

    "Created: / 28-06-2011 / 22:58:53 / cg"
!

privateApply
    self subclassResponsibility

    "Created: / 28-06-2011 / 22:58:59 / cg"
! !

!ClassPrimitiveChange methodsFor:'comparing'!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    (self isForSameAs:changeB) ifFalse:[^ false].
    ^ self sameSourceAs:changeB

! !

!ClassPrimitiveChange methodsFor:'testing'!

isPrimitiveChange
    ^ true
! !

!ClassPrimitiveChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassPrimitiveChange.st,v 1.8 2014-02-19 13:05:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassPrimitiveChange.st,v 1.8 2014-02-19 13:05:43 cg Exp $'
! !

