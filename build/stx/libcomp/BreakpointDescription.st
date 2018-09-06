"
 COPYRIGHT (c) 2006 by eXept Software AG
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

Object subclass:#BreakpointDescription
	instanceVariableNames:'state condition icon'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Debugging'
!

!BreakpointDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    I describe a breakpoint: its state (enabled/disabled),
    condition, etc.

    I may be shared by multiple instances of Breakpoint,
    since there may be multiple version of same method
    with breakpoints on different position but representing
    the same logical breakpoint (the one set by the user).

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!BreakpointDescription class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!BreakpointDescription methodsFor:'accessing'!

condition
    ^ condition
!

condition:something
    condition := something.
! !

!BreakpointDescription methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    state := #enabled

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 17-06-2011 / 13:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointDescription methodsFor:'support'!

beInvisible
    state := #hidden.
!

beTracepoint
    state := #tracing.

    "Created: / 27-01-2012 / 13:55:20 / cg"
!

disable
    state == #deleted ifTrue:[^self].

    state := #disabled.
!

shouldBreakIn: aContext
    state ~~ #enabled ifTrue:[^false].

    ^ condition isNil or:[condition value: thisContext sender]

    "Created: / 11-07-2011 / 18:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-01-2012 / 13:42:28 / cg"
!

shouldTraceIn: aContext
    state ~~ #tracing ifTrue:[^false].

    ^ condition isNil or:[condition value: thisContext sender]

    "Created: / 27-01-2012 / 13:41:58 / cg"
!

toggle
    state == #deleted ifTrue:[^self].

    (state == #enabled) ifTrue:[
        state := #disabled.
    ] ifFalse:[
        state := #enabled
    ].

    "Created: / 17-06-2011 / 13:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-01-2012 / 13:52:54 / cg"
!

toggleTracing
    state == #deleted ifTrue:[^self].

    (state == #tracing) ifTrue:[ 
        state := #disabled 
    ] ifFalse:[
        state := #tracing.
    ].

    "Created: / 27-01-2012 / 13:52:41 / cg"
! !

!BreakpointDescription methodsFor:'testing'!

isEnabled

    "Bad coding here, state should be full object"

    ^ state == #enabled or:[ state == #tracing ]

    "Created: / 28-06-2011 / 08:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTracepoint
    ^ condition isNil and:[state == #tracing]
!

isVisible
    "Bad coding here, state should be full object"

    ^state ~~ #hidden
! !

!BreakpointDescription class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

