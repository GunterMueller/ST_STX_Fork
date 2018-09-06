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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Block variableSubclass:#CheapBlock
	instanceVariableNames:'selfValue method'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!CheapBlock class methodsFor:'documentation'!

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
    CheapBlocks are blocks which do not need their home-context
    (i.e. blocks that do not access any method arguments 
     or method locals).

    CheapBlocks are never created explicitely; the only creation
    is done by the compilers, when some sourceCode is compiled to either
    machine or byteCode, and the generated block is found to neither access
    any variables from its homeContext nor does a method-return.
    CheapBlocks create less overhead to the runtime system, in that they
    do not keep the creating context from being reclaimed (but, don't expect
    too much of a difference ;-)

    Since they have no reference to the home, they must store their
    creating method explicitely - otherwise, the system had no 
    chance of finding the source-position of the block.

    [Instance variables:]

      selfValue   <Object>          copied self value
                                    (if its a copying block)

      method      <Method>          method where block was created 

    NOTICE: layout known by runtime system and compiler - do not change

    [author:]
        Claus Gittinger

    [see also:]
        Block Context Method
        ( contexts, stacks & unwinding :html: programming/contexts.html )
"
! !

!CheapBlock class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == CheapBlock

    "Created: 16.4.1996 / 11:25:23 / cg"
    "Modified: 23.4.1996 / 15:56:46 / cg"
! !

!CheapBlock methodsFor:'accessing'!

homeMethod
    "return the receiver's home method.
     That's the method where the block was created."

    ^ method

    "Created: 19.6.1997 / 16:14:35 / cg"
    "Modified: 19.6.1997 / 16:15:44 / cg"
!

method
    "return the receiver's home method.
     That's the method where the block was created.
     Obsolete: use #homeMethod for ST80 compatibility."

    ^ method

    "Modified: 19.6.1997 / 16:15:58 / cg"
!

selfValue
    "return the copied self"

    ^ selfValue
!

setMethod:aMethod
    "set the receiver's home method.
     This is a private entry for the compiler"

    method := aMethod

    "Created: 21.10.1996 / 13:58:29 / cg"
! !

!CheapBlock methodsFor:'conversion'!

asVarArgBlock
    "convert myself into a varArg block;
     this one has 1 formal argument, which gets the list
     of actual arguments when evaluated."

    nargs ~~ 1 ifTrue:[
        self error:'vararg blocks must take exactly 1 argument - the arg list'.
        ^ nil
    ].

    self changeClassTo:VarArgCheapBlock.
    ^ self

    "
     |b|

     b := [:argList | argList printCR] asVarArgBlock.
     b value.
     b value:'arg1' value:'arg2' value:'arg3' value:'arg4'
    "

    "Created: 23.1.1997 / 13:35:28 / cg"
    "Modified: 23.1.1997 / 13:35:48 / cg"
! !

!CheapBlock methodsFor:'printing & storing'!

printOn:aStream
    "append a a printed representation of the block to aStream"

    |who|

    "
     cheap blocks have no home context, but a method instead
    "

    aStream nextPutAll:'[] in '.
    "
     find out, for which class this method was for ...
    "
    method notNil ifTrue:[
        who := method who.
        who notNil ifTrue:[
            aStream nextPutAll:(who methodClass name , '>>' , who methodSelector).
            aStream nextPutAll:' (optimized)'.
            ^ self
        ].
    ].
    "
     currently, some cheap blocks don't know where they have been created
    "
    aStream nextPutAll:' ??? (optimized)'.
    ^ self

    "Modified: 1.11.1996 / 16:21:19 / cg"
! !

!CheapBlock methodsFor:'testing'!

isCheapBlock
    ^ true
! !

!CheapBlock class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

