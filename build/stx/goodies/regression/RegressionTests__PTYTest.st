"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#PTYTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'TTYConstants'
	category:'tests-Regression-Streams'
!

!PTYTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PTYTest methodsFor:'running'!

setUp
    self skipIf: OperatingSystem supportsTTYs not description: 'No TTY / PTY support'

    "Created: / 01-06-2017 / 21:25:55 / jv"
! !

!PTYTest methodsFor:'tests'!

testEOLMode01
    |ptyPair master slave data |

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    master nextPutLine:'1234'.
    master nextPutLine:'ABCD'.  

    self assert:(data := slave  nextLine) = '1234'.      
    self assert:(data := master nextLine) = '1234'.      

    self assert:(data := slave  nextLine) = 'ABCD'.      
    self assert:(data := master nextLine) = 'ABCD'.      

    master close.
    slave close.

    "Created: / 31-05-2017 / 09:52:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 31-05-2017 / 11:35:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testEOLMode02
    "
    Turn off CR-LF on PTY (i.e., make sure lines are NL only)
    "
    |ptyPair master slave data attrs |

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    attrs := master getTTYAttributes.
    attrs c_oflag: (attrs c_oflag bitClear: ONLCR).
    master setTTYAttributes: attrs.


    master nextPutLine:'1234'.
    master nextPutLine:'ABCD'.  

    self assert:(data := slave  next:4) = '1234'.      
    self assert:(data := master next:4) = '1234'.      

    self assert: (data := slave next) == Character linefeed.
    self assert: (data := master next) == Character linefeed.

    self assert: (data := slave next: 4) = 'ABCD'.
    self assert: (data := master next: 4) = 'ABCD'.

    master close.
    slave close.

    "Created: / 31-05-2017 / 09:53:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2017 / 15:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 21:23:35 / jv"
!

testEchoOff
    |ptyPair master slave attrs data |

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    attrs := master getTTYAttributes.
    attrs c_lflag: attrs c_lflag | ECHO.
    master setTTYAttributes: attrs.

    master nextPutLine:'1234567890'.
    self assert:(data := slave  nextLine) = '1234567890'.      
    self assert:(data := master nextAvailable:10+1"CR"+1"NL") notEmpty.

    attrs := master getTTYAttributes.
    attrs c_lflag: (attrs c_lflag bitClear: ECHO).
    master setTTYAttributes: attrs.

    master nextPutLine:'1234567890'.
    self assert:(data := slave  nextLine) = '1234567890'.      
    self assert:(data := master nextAvailable: 11) isEmpty.      
    



    master close.
    slave close.

    "Created: / 31-05-2017 / 07:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2017 / 08:46:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 21:23:55 / jv"
!

testGetSetAttributes
    |ptyPair master slave attrs |

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    attrs := master getTTYAttributes.
    master setTTYAttributes: attrs.

    attrs := slave getTTYAttributes.
    slave setTTYAttributes: attrs. 


    master close.
    slave close.

    "Created: / 31-05-2017 / 07:39:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 21:24:09 / jv"
!

testIsTTY
    |ptyPair master slave|

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    self assert: master isTTY.
    self assert: slave isTTY.

    master close.
    slave close.

    "Created: / 31-05-2017 / 07:38:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPTY1
    |ptyPair master slave|

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    master nextPutLine:'1234567890'.
    '1234567890' do:[:ch |
	self assert:(slave next = ch).
    ].
    self assert:(slave next = Character linefeed).

    master close.
    slave close.

    "
     self new testPTY1
    "
!

testPTY2
    |ptyPair master slave|

    ptyPair := NonPositionableExternalStream makePTYPair.
    master := ptyPair at:1.
    slave := ptyPair at:2.

    master nextPutLine:'1234567890'.
    self assert:(slave nextLine = '1234567890').

    slave nextPutLine:'1234567890'.
    self assert:(master nextLine = '1234567890').

    master close.
    slave close.

    "
     self new testPTY2
    "
! !

!PTYTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

