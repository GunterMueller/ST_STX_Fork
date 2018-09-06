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

PrimaryNode subclass:#SelfNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!SelfNode class methodsFor:'documentation'!

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
    node for parse-trees, representing self
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!SelfNode class methodsFor:'instance creation'!

value:val
    ^ (self basicNew) value:val
! !

!SelfNode methodsFor:'accessing'!

name
    ^ 'self'

    "Created: 19.6.1997 / 17:20:22 / cg"
!

value:val
    type := #Self.
    value := val.
! !

!SelfNode methodsFor:'code generation'!

codeForSimpleReturnOn:aStream inBlock:b lineNumber:lineNrOrNil for:aCompiler
    lineNrOrNil notNil ifTrue:[
        self codeLineNumber:lineNrOrNil on:aStream for:aCompiler
    ].
    aStream nextPut:#retSelf
!

codeOn:aStream inBlock:codeBlock for:aCompiler
    aStream nextPut:#pushSelf
!

codeStoreOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    "not reached - parser has already checked this"

    ^ self error:'store into self - cannot happen'
! !

!SelfNode methodsFor:'enumerating'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doVariable:self name:'self'

    "Created: 19.6.1997 / 17:20:02 / cg"
! !

!SelfNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    anEnvironment notNil ifTrue:[
        ^ anEnvironment receiver.
    ].
    ^ value
!

store:aValue
    "not reached - parser has already checked this"

    self error:'store into self - cannot happen'
! !

!SelfNode methodsFor:'printing & storing'!

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
        nextPutAll:'InterpreterVariable(self)'.

    "Modified (comment): / 22-02-2017 / 16:50:05 / cg"
!

printOn:aStream indent:i
    aStream nextPutAll:'self'
! !

!SelfNode methodsFor:'testing'!

isSelf
    "return true, if this is a self-node"

    ^ self class == SelfNode


! !

!SelfNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitSelfNode:self
! !

!SelfNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

