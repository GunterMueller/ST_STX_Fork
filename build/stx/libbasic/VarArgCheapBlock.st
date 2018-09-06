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

CheapBlock variableSubclass:#VarArgCheapBlock
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!VarArgCheapBlock class methodsFor:'documentation'!

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
    read the documentation in VarArgBlocks.


    [author:]
        Claus Gittinger

    [see also:]
        Block CheapBlock
"
! !

!VarArgCheapBlock class methodsFor:'initialization'!

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

!VarArgCheapBlock methodsFor:'evaluation'!

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

!VarArgCheapBlock methodsFor:'testing'!

isVarArgBlock
    "return true, if this block accepts a variable number of arguments"

    ^ true

    "Created: 23.1.1997 / 05:00:18 / cg"
! !

!VarArgCheapBlock class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/VarArgCheapBlock.st,v 1.6 2013-04-16 12:44:09 cg Exp $'
! !


VarArgCheapBlock initialize!
