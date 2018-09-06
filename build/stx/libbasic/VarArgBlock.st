"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Block variableSubclass:#VarArgBlock
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!VarArgBlock class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    VarArgBlocks are much like blocks, but can accept a variable
    number of arguments. They must be defined as a regular block,
    with 1 argument. When executed, the actual argument list is
    passed in that single argument (as a collection).

    Create a variableArgument block by sending #asVarArgBlock to a regular
    block.

    This is a goody add-on, which may not be available/possible in other 
    smalltalk implementations. Do not use it if cross-platform
    portability is required.


    [author:]
        Claus Gittinger

    [see also:]
        Block
"
!

examples
"
   the same block, evaluated with 2 or 5 arguments:
                                                                [exBegin]
     |b|

     b := [:args | Transcript show:'wow: '; showCR:args] asVarArgBlock.

     b value:'hi' value:'there'. 
     b value:'hello' value:'there' value:'how' value:'about' value:'this'.
                                                                [exEnd]


   does it accept a variable number of arguments ?:
                                                                [exBegin]
     |b|

     b := [:args | Transcript showCR:args].
     Transcript showCR:(b isVarArgBlock).

     b := [:args | Transcript showCR:args] asVarArgBlock.
     Transcript showCR:(b isVarArgBlock)
                                                                [exEnd]
"

    "Created: 23.1.1997 / 04:57:26 / cg"
! !

!VarArgBlock class methodsFor:'initialization'!

initialize
    "must clear the is-block flag bit in the class
     (otherwise, the VM might try to inline value-messages)"

    |newFlags|

    newFlags := (self flags 
                    bitClear:(Behavior flagBlock))
                        bitOr:(Behavior flagBlockLike).
    self flags:newFlags.

    "
     self flags.       
     self initialize.
     self flags.      
    "
! !

!VarArgBlock methodsFor:'evaluation'!

value
    "evaluate the receiver with no block args."

    ^ super value:#()

    "Created: 23.1.1997 / 04:57:49 / cg"
!

value:arg
    "evaluate the receiver with a single argument."

    ^ super value:(Array with:arg)

    "Created: 23.1.1997 / 04:57:57 / cg"
!

value:arg1 value:arg2
    "evaluate the receiver with two arguments."

    ^ super value:(Array with:arg1 with:arg2)

    "Created: 23.1.1997 / 04:58:03 / cg"
!

value:arg1 value:arg2 value:arg3
    "evaluate the receiver with three arguments."

    ^ super value:(Array with:arg1 with:arg2 with:arg3)

    "Created: 23.1.1997 / 04:58:09 / cg"
!

value:arg1 value:arg2 value:arg3 value:arg4
    "evaluate the receiver with four arguments."

    ^ super value:(Array 
		    with:arg1 
		    with:arg2 
		    with:arg3 
		    with:arg4)

    "Modified: 22.1.1997 / 19:41:22 / cg"
    "Created: 23.1.1997 / 04:58:14 / cg"
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5
    "evaluate the receiver with five arguments."

    ^ super value:(Array 
		    with:arg1 
		    with:arg2 
		    with:arg3 
		    with:arg4
		    with:arg5)

    "Modified: 22.1.1997 / 19:41:26 / cg"
    "Created: 23.1.1997 / 04:58:18 / cg"
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6
    "evaluate the receiver with six arguments."

    ^ super value:(Array 
		    with:arg1 
		    with:arg2 
		    with:arg3 
		    with:arg4
		    with:arg5
		    with:arg6)

    "Modified: 22.1.1997 / 19:41:29 / cg"
    "Created: 23.1.1997 / 04:58:22 / cg"
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7
    "evaluate the receiver with seven arguments."

    ^ super value:(Array 
		    with:arg1 
		    with:arg2 
		    with:arg3 
		    with:arg4
		    with:arg5
		    with:arg6
		    with:arg7)

    "Modified: 22.1.1997 / 19:41:33 / cg"
    "Created: 23.1.1997 / 04:58:26 / cg"
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8
    "evaluate the receiver with eight arguments."

    ^ super value:(Array 
		    with:arg1 
		    with:arg2 
		    with:arg3 
		    with:arg4
		    with:arg5
		    with:arg6
		    with:arg7
		    with:arg8)

    "Created: 23.1.1997 / 04:58:30 / cg"
!

valueWithArguments:argArray
    "evaluate the receiver with all arguments in argArray."

    ^ super value:argArray

    "Created: 23.1.1997 / 04:59:16 / cg"
! !

!VarArgBlock methodsFor:'testing'!

isVarArgBlock
    "return true, if this block accepts a variable number of arguments"

    ^ true

    "Created: 23.1.1997 / 05:00:18 / cg"
! !

!VarArgBlock class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/VarArgBlock.st,v 1.8 2013-04-16 12:44:14 cg Exp $'
! !


VarArgBlock initialize!
