"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#GDBInternalPipeStreamTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Support-Tests'
!

!GDBInternalPipeStreamTests class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!GDBInternalPipeStreamTests methodsFor:'tests'!

test_01
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPut:$x.
    pipe nextPut:$y.
    self assert:pipe next == $x.
    self assert:pipe next == $y.

    "Created: / 07-06-2014 / 00:52:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01a
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPutAll:'xy'.
    self assert:(pipe next:2) = 'xy'.

    "Created: / 09-06-2014 / 21:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01c
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPut:$x.
    pipe nextPut:$y.
    self assert:(pipe next:2) = 'xy'.

    "Created: / 09-06-2014 / 21:46:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPut:$x.
    pipe nextPut:$y.
    pipe nextPut:$z.
    self assert:pipe next == $x.
    self assert:pipe next == $y.
    pipe nextPut:$a.
    pipe nextPut:$b.
    self assert:pipe next == $z.
    self assert:pipe next == $a.
    self assert:pipe next == $b.

    "Created: / 07-06-2014 / 00:53:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02b
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPutAll:'xyz'.
    self assert:pipe next == $x.
    self assert:pipe next == $y.
    pipe nextPutAll:'ab'.
    self assert:pipe next == $z.
    self assert:pipe next == $a.
    self assert:pipe next == $b.

    "Created: / 09-06-2014 / 22:42:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02c
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPutAll:'xy'.
    self assert:pipe next == $x.
    pipe nextPutAll:'ab'.
    self assert:pipe next == $y.
    self assert:pipe next == $a.
    self assert:pipe next == $b.

    "Created: / 09-06-2014 / 22:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPut:$x.
    pipe nextPut:$y.
    pipe nextPut:$z.
    self assert:pipe next == $x.
    self assert:pipe next == $y.
    pipe nextPut:$a.
    pipe nextPut:$b.
    self assert:pipe next == $z.
    self assert:pipe next == $a.
    pipe nextPut:$1.
    pipe nextPut:$2.
    self assert:pipe next == $b.
    self assert:pipe next == $1.
    self assert:pipe next == $2.

    "Created: / 07-06-2014 / 00:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04
    | pipe |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    pipe nextPut:$x.
    pipe nextPut:$y.
    pipe close.
    self should:[ pipe nextPut:$X ] raise:Stream writeErrorSignal.
    self assert:pipe atEnd not.
    self assert:pipe next == $x.
    self assert:pipe next == $y.
    self assert:pipe next isNil.
    self assert:pipe atEnd.

    "Created: / 07-06-2014 / 01:06:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05a
    | pipe  buffer |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    buffer := String new:10.
    pipe nextPutAll:'xy'.
    pipe nextPut:$z.
    self 
        assert:(pipe 
                nextAvailableBytes:3
                into:buffer
                startingAt:1) == 3.
    self assert:(buffer at:1) == $x.
    self assert:(buffer at:2) == $y.
    self assert:(buffer at:3) == $z.

    "Created: / 10-06-2014 / 00:01:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05b
    | pipe  buffer |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    buffer := String new:10.
    pipe nextPutAll:'xy'.
    pipe nextPut:$z.
    self 
        assert:(pipe 
                nextAvailableBytes:30
                into:buffer
                startingAt:1) == 3.
    self assert:(buffer at:1) == $x.
    self assert:(buffer at:2) == $y.
    self assert:(buffer at:3) == $z.

    "Created: / 10-06-2014 / 00:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05c
    | pipe  buffer |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    buffer := String new:10.
    pipe nextPutAll:'xy'.
    pipe nextPut:$z.
    self 
        assert:(pipe 
                nextAvailableBytes:2
                into:buffer
                startingAt:1) == 2.
    self assert:(buffer at:1) == $x.
    self assert:(buffer at:2) == $y.
    self 
        assert:(pipe 
                nextAvailableBytes:2
                into:buffer
                startingAt:3) == 1.
    self assert:(buffer at:3) == $z.

    "Created: / 10-06-2014 / 00:01:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05d
    | pipe  buffer |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    buffer := String new:10.
    pipe nextPutAll:'xy'.
    pipe next.
    pipe nextPutAll:'ab'.
    self 
        assert:(pipe 
                nextAvailableBytes:3
                into:buffer
                startingAt:1) == 2.
    self assert:(buffer at:1) == $y.
    self assert:(buffer at:2) == $a.
    self assert:(buffer at:3) == $b.

    "Created: / 10-06-2014 / 00:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05e
    | pipe  buffer |

    pipe := GDBInternalPipeStream newWithBufferSize:3.
    buffer := String new:10.
    pipe nextPutAll:'xy'.
    pipe next.
    pipe nextPutAll:'ab'.
    self 
        assert:(pipe 
                nextAvailableBytes:3
                into:buffer
                startingAt:1) == 2.
    self assert:(buffer at:1) == $y.
    self assert:(buffer at:2) == $a.
    self assert:(buffer at:3) == $b.

    "Created: / 10-06-2014 / 00:28:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_06a
    | pipe  buffer |

    pipe := GDBInternalPipeStream newWithBufferSize:15.
    buffer := String new:10.
    pipe nextPutAll:'xy'.
    pipe nextPut:Character nl.
    self assert:pipe nextLine = 'xy'.
    pipe nextPutAll:'ayz z'.
    pipe nextPut:Character nl.
    self assert:pipe nextLine = 'ayz z'.

    "Created: / 11-06-2014 / 13:06:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_06b
    | pipe |

    pipe := GDBInternalPipeStream new.
    pipe nextPutAll:'show inferior-tty'.
    pipe nextPut:Character cr.
    self assert:pipe nextLine = 'show inferior-tty'.
    pipe nextPutAll:'ayz z'.
    pipe nextPut:Character nl.
    self assert:pipe nextLine = 'ayz z'.

    "Created: / 11-06-2014 / 13:19:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2014 / 21:39:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_07a
    | pipe t1 t1stepper t1blocker t2 t2stepper t2blocker c |

    pipe := GDBInternalPipeStream newWithBufferSize:5.
    t1stepper := Semaphore new.
    t1blocker := Semaphore new.
    t2stepper := Semaphore new.
    t2blocker := Semaphore new.


    t1 := [ 
        t1stepper wait.
        pipe nextPutAll: '123456'.
    ] newProcess.
    t1 addExitAction:[t1blocker signal].            

    t2 := [ 
        t2stepper wait.
        c := pipe next.
    ] newProcess.
    t2 addExitAction:[t2blocker signal].            

    t1 resume.
    t2 resume.

    t1stepper signal.
    Delay waitForMilliseconds:100.  
    t2stepper signal.

    t1blocker wait.
    t2blocker wait.

    self assert: c = $1.
    self assert: t1 isDead.  
    self assert: t2 isDead.

    "Created: / 07-09-2014 / 07:45:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_07b
    | pipe t1 t1stepper t1blocker t2 t2stepper t2blocker c |

    pipe := GDBInternalPipeStream newWithBufferSize:5.
    t1stepper := Semaphore new.
    t1blocker := Semaphore new.
    t2stepper := Semaphore new.
    t2blocker := Semaphore new.


    t1 := [ 
        t1stepper wait.
        pipe nextPutAll: '123456'.
        t1blocker signal.
    ] newProcess.

    t2 := [ 
        t2stepper wait.
        c := pipe next.
        t2blocker signal.
    ] newProcess.

    t1 resume.
    t2 resume.

    t2stepper signal.
    Delay waitForMilliseconds:100.  
    t1stepper signal.


    t1blocker wait.
    t2blocker wait.

    self assert: c = $1.
    self assert: t1 isDead.  
    self assert: t2 isDead.

    "Created: / 07-09-2014 / 07:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_08a
    | pipe t1 t1stepper t1blocker t2 t2stepper t2blocker c |

    pipe := GDBInternalPipeStream newWithBufferSize:5.
    t1stepper := Semaphore new.
    t1blocker := Semaphore new.
    t2stepper := Semaphore new.
    t2blocker := Semaphore new.


    t1 := [ 
        t1stepper wait.
        pipe nextPutAll: '123456'.
        t1blocker signal.
    ] newProcess.
    t1 addExitAction:[t1blocker signal].   

    t2 := [ 
        t2stepper wait.
        c := pipe next:6.
    ] newProcess.
    t2 addExitAction:[t2blocker signal].   

    t1 resume.
    t2 resume.

    t1stepper signal.
    Delay waitForMilliseconds:100.  
    t2stepper signal.


    t1blocker wait.
    t2blocker wait.

    self assert: c = '123456'.
    self assert: t1 isDead.  
    self assert: t2 isDead.

    "Created: / 07-09-2014 / 07:48:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_08b
    | pipe t1 t1stepper t1blocker t2 t2stepper t2blocker c |

    pipe := GDBInternalPipeStream newWithBufferSize:5.
    t1stepper := Semaphore new.
    t1blocker := Semaphore new.
    t2stepper := Semaphore new.
    t2blocker := Semaphore new.


    t1 := [ 
        t1stepper wait.
        pipe nextPutAll: '123456'.
    ] newProcess.
    t1 addExitAction:[t1blocker signal].            

    t2 := [ 
        t2stepper wait.
        c := pipe next:6.
    ] newProcess.
    t2 addExitAction:[t2blocker signal].            

    t1 resume.
    t2 resume.

    t2stepper signal.
    Delay waitForMilliseconds:100.  
    t1stepper signal.


    t1blocker wait.
    t2blocker wait.

    self assert: c = '123456'.
    self assert: t1 isDead.  
    self assert: t2 isDead.

    "Created: / 07-09-2014 / 07:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_09a
    | pipe t1 t1stepper t1blocker t2 t2stepper t2blocker c |

    pipe := GDBInternalPipeStream newWithBufferSize:5.
    t1stepper := Semaphore new.
    t1blocker := Semaphore new.
    t2stepper := Semaphore new.
    t2blocker := Semaphore new.


    t1 := [ 
        t1stepper wait.
        pipe nextPutAll: '1234567'.
    ] newProcess.
    t1 addExitAction:[t1blocker signal].            

    t2 := [ 
        t2stepper wait.
        c := pipe next:7.
    ] newProcess.
    t2 addExitAction:[t2blocker signal].            

    t1 resume.
    t2 resume.

    t1stepper signal.
    Delay waitForMilliseconds:100.  
    t2stepper signal.


    t1blocker wait.
    t2blocker wait.

    self assert: c = '1234567'.
    self assert: t1 isDead.  
    self assert: t2 isDead.

    "Created: / 07-09-2014 / 07:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_09b
    | pipe t1 t1stepper t1blocker t2 t2stepper t2blocker c |

    pipe := GDBInternalPipeStream newWithBufferSize:5.
    t1stepper := Semaphore new.
    t1blocker := Semaphore new.
    t2stepper := Semaphore new.
    t2blocker := Semaphore new.


    t1 := [ 
        t1stepper wait.
        pipe nextPutAll: '1234567'.
    ] newProcess.
    t1 addExitAction:[t1blocker signal].

    t2 := [ 
        t2stepper wait.
        c := pipe next:7.
    ] newProcess.
    t2 addExitAction:[t2blocker signal].

    t1 resume.
    t2 resume.

    t2stepper signal.
    Delay waitForMilliseconds:100.  
    t1stepper signal.


    t1blocker wait.
    t2blocker wait.

    self assert: c = '1234567'.
    self assert: t1 isDead.  
    self assert: t2 isDead.

    "Created: / 07-09-2014 / 07:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_10
    | pipe |

    pipe := GDBInternalPipeStream new.
    pipe nextPutAll:'12345'.
    pipe close.
    self assert: pipe atEnd not.
    self assert: pipe next == $1.
    self assert: (pipe next:4) = '2345'.    
    self assert: pipe atEnd.

    "Created: / 07-09-2014 / 21:59:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStreamTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

