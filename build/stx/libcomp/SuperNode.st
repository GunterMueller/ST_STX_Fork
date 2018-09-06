"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

SelfNode subclass:#SuperNode
	instanceVariableNames:'class isHere'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!SuperNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    node for parse-trees, representing super
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!SuperNode class methodsFor:'instance creation'!

value:val inClass:cls 
    ^ (self basicNew) value:val inClass:cls here:false
!

value:val inClass:cls here:isHere
    ^ (self basicNew) value:val inClass:cls here:isHere
! !

!SuperNode methodsFor:'accessing'!

definingClass
    ^ class
!

value:val inClass:cls here:h
    type := #Super.
    value := val.
    class := cls.
    isHere := h
! !

!SuperNode methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
      append a printed desription on some stream (Dolphin,  Squeak)
     OR:
      display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:(isHere ifTrue:['InterpreterVariable(here)'] ifFalse:['InterpreterVariable(super)']).

    "Modified (comment): / 22-02-2017 / 16:52:49 / cg"
!

printOn:aStream indent:i
    isHere ifTrue:[
	aStream nextPutAll:'here'
    ] ifFalse:[
	aStream nextPutAll:'super'
    ]
! !

!SuperNode methodsFor:'testing'!

isHere
    ^ isHere
!

isSuper
    "return true, if this is a super-node"

    ^ true
!

name
    ^ self isHere ifTrue:['here'] ifFalse:['super'].
! !

!SuperNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitSuperNode:self
! !

!SuperNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

