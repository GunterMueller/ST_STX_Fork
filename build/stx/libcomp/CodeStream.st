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

WriteStream subclass:#CodeStream
	instanceVariableNames:'class scope requestor'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler ST-80-compatibility'
!

!CodeStream class methodsFor:'documentation'!

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
    This is a pure mimicri class.
    It is not used by ST/X, but provided to support limited
    compatibility for applications which build up codetrees,
    knowing internals of ST-80's compiler class hierarchy.
    This classes protocol is not (not meant to be) fully covering
    the corresponding ST-80's classes protocol. It maps ST-80 messages
    to corresponding ST/X messages (as far as possible).

    NO WARRANTY and GUARANTEE; this class may be removed without notice.
"
! !

!CodeStream class methodsFor:'instance creation'!

new
    ^ super on:(OrderedCollection new:100)
! !

!CodeStream methodsFor:'accessing'!

class:aClass outerScope:aScope
    class := aClass.
    scope := aScope
!

requestor:someOne
    requestor := someOne
! !

!CodeStream methodsFor:'code generation'!

makeMethod:aMethodNode
    "mhmh - kludge-create a compiler and let it generate code"

    |compiler symbolicCodeArray newMethod lits|

    compiler := ByteCodeCompiler new.
    compiler notifying:requestor.
    compiler targetClass:class.

    symbolicCodeArray := self contents.
    (compiler genByteCodeFrom:symbolicCodeArray) == #Error ifTrue:[
        self halt
    ].

    newMethod := Method new.
    newMethod byteCode:(compiler code).
    lits := compiler literalArray.
    lits notNil ifTrue:[
        newMethod literals:lits
    ].
    newMethod numberOfVars:(compiler numberOfMethodVars).
    newMethod numberOfArgs:(compiler numberOfMethodArgs).
    newMethod stackSize:(compiler maxStackDepth).

    Project notNil ifTrue:[
        newMethod package:(Project currentPackageName)
    ].

    class addSelector:aMethodNode selector withMethod:newMethod.
    ^ newMethod

    "Modified: / 4.3.1998 / 14:46:34 / stefan"
! !

!CodeStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/CodeStream.st,v 1.6 1998-03-06 15:38:37 stefan Exp $'
! !
