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

TestCase subclass:#ByteCodeCompilerWithBreakpointSupportTests
	instanceVariableNames:'breakpoints method'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Debugging'
!

!ByteCodeCompilerWithBreakpointSupportTests class methodsFor:'documentation'!

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
! !

!ByteCodeCompilerWithBreakpointSupportTests methodsFor:'accessing'!

breakpoints
    ^ breakpoints
! !

!ByteCodeCompilerWithBreakpointSupportTests methodsFor:'running'!

tearDown

    self class removeSelector: #foo.
    breakpoints := nil.

    "Created: / 16-06-2011 / 14:58:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 09:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteCodeCompilerWithBreakpointSupportTests methodsFor:'tests'!

test_01

    |source|

    source := 'foo ^ #foo'.

    breakpoints := Array with:(Breakpoint new position:4).

    self compile:source.

    self should:[ self foo ] raise:HaltInterrupt.

    "Created: / 16-06-2011 / 14:17:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 09:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 21:08:33 / cg"
!

test_02

    | source |

    source := 'foo | a | a := 1. ^ a + 1'.

    breakpoints := Array with: (Breakpoint new position:19).

    self compile:source.

    self should:[self foo] raise: HaltInterrupt.

    "Created: / 16-06-2011 / 15:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 09:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03a

    | source |

    source := 'foo ^ true ifTrue:[ #true ] ifFalse:[ #false ]' .
              "12345678901234567890123456789012345678901234567890"

    breakpoints := Array with: (Breakpoint new position:20).

    self compile:source.

    self should:[self foo] raise: HaltInterrupt.

    "Created: / 17-06-2011 / 09:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03b

    | source ret |

    source := 'foo ^ true ifTrue:[ #true ] ifFalse:[ #false ]' .
              "12345678901234567890123456789012345678901234567890"
              "         1         2         3         4"

    breakpoints := Array with: (Breakpoint new position:28).

    self compile:source.
    "/ method inspect.

    self shouldnt:[self foo] raise: HaltInterrupt.

    HaltInterrupt ignoreIn:[
        ret := self foo.
    ].
    self assert:(ret == #true)

    "Created: / 17-06-2011 / 09:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 22:54:08 / cg"
!

test_03c

    | source ret |

    source := 'foo ^ false ifTrue:[ #true ] ifFalse:[ #false ]' .
              "12345678901234567890123456789012345678901234567890"
              "         1         2         3         4"

    breakpoints := Array with: (Breakpoint new position:28).

    self compile:source.
    "/ method inspect.

    self shouldnt:[self foo] raise: HaltInterrupt.

    HaltInterrupt ignoreIn:[
        ret := self foo.
    ].
    self assert:(ret == #false)

    "Created: / 17-06-2011 / 09:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-07-2011 / 22:54:54 / cg"
!

test_04

    | source block |

    source := 'foo ^ [ #true ]' .
              "12345678901234567890123456789012345678901234567890"

    breakpoints := Array with: (Breakpoint new position:8).

    self compile:source.

    self shouldnt:[block := self foo] raise: HaltInterrupt.
    self should:[block value] raise: HaltInterrupt.

    "Created: / 17-06-2011 / 09:10:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05

    | source got result |

    source := 'foo | a | a := 100. ^a between: a-a and: a+a' .
              "12345678901234567890123456789012345678901234567890"
              "         1         2         3         4"

    breakpoints := Array with: (Breakpoint new position:32).

    self compile:source.
    "/ method inspect.

    got := false.
    [ result := self foo ] 
        on: HaltInterrupt do:
            [:halt|
            got := true.
            halt proceed].

    self assert: got.
    self assert: result

    "Created: / 17-06-2011 / 09:14:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 22:20:25 / cg"
!

test_06

    | source nbreaks result |

    source := 'foo |a| 1 to: 10 do:[:x| a := x * x ]. ^a ' .
              "12345678901234567890123456789012345678901234567890"

    breakpoints := Array with: (Breakpoint new position:30).

    self compile:source.
    "/ method inspect.

    nbreaks := 0.
    [ result := self foo ] 
        on: HaltInterrupt do:
            [:halt|
            nbreaks := nbreaks + 1.
            halt proceed].

    self assert: nbreaks == 10.
    self assert: result == 100

    "Created: / 17-06-2011 / 11:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 22:40:31 / cg"
! !

!ByteCodeCompilerWithBreakpointSupportTests methodsFor:'utils'!

compile:source 
    Class withoutUpdatingChangesDo:[
        method := 
            ByteCodeCompilerWithBreakpointSupport 
                compile:source
                forClass:self class
                notifying:self
    ].
    ^ method

    "Modified: / 17-06-2011 / 09:15:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 21:36:29 / cg"
! !

!ByteCodeCompilerWithBreakpointSupportTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/ByteCodeCompilerWithBreakpointSupportTests.st,v 1.2 2011-07-05 21:25:22 cg Exp $'
!

version_SVN
    ^ '§ Id §'
! !
