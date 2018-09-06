"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#OperatingSystemTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!


!OperatingSystemTest methodsFor:'release'!

tearDown
    '/tmp/lsOut' asFilename delete.
! !

!OperatingSystemTest methodsFor:'tests'!

testActorStream
    |expected outStr errStr exitStatus|

    OperatingSystem executeCommand:'ls > /tmp/lsOut'.
    expected := '/tmp/lsOut' asFilename contentsOfEntireFile.

    outStr := ActorStream new.
    outStr nextPutLineBlock:[:line | Transcript normal; showCR:line ].
    errStr := ActorStream new.
    outStr nextPutLineBlock:[:line | Transcript bold; showCR:line ].

    OperatingSystem
	executeCommand:'ls'
	inputFrom:nil
	outputTo:outStr
	errorTo:errStr
	inDirectory:nil
	lineWise:true
	onError:[:status | exitStatus := status].

    "
     self new testActorStream
    "
!

testCommandOutput1
    |expected outStr errStr exitStatus|

    OperatingSystem executeCommand:'ls > /tmp/lsOut'.
    expected := '/tmp/lsOut' asFilename contentsOfEntireFile.

    1 to:50 do:[:counter |
"/ Transcript show:counter; showCR:':'.
	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | exitStatus := status].
	self assert:(outStr contents = expected).
	self assert:(errStr contents isEmpty).
	self assert:(exitStatus isNil).
    ].

    "
     self new testCommandOutput1
    "
!

testCommandOutput2
    |outStr errStr exitStatus|

    1 to:50 do:[:counter |
"/ Transcript show:counter; showCR:':'.
	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | exitStatus := status].
	self assert:(outStr contents isEmpty).
	self assert:(errStr contents notEmpty).
	self assert:(exitStatus success not).
	self assert:(exitStatus stillAlive not).
	self assert:(exitStatus couldNotExecute not).
    ].

    "
     self new testCommandOutput2
    "
!

testInvalidCommand
    |outStr errStr exitStatus|

    1 to:50 do:[:counter |
"/ Transcript show:counter; showCR:':'.
	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'blabla /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | exitStatus := status].
	self assert:(exitStatus success not).
	self assert:(exitStatus stillAlive not).
	self assert:(exitStatus couldNotExecute).
	self assert:(outStr contents isEmpty).
	self assert:(errStr contents notEmpty).
    ].

    "
     self new testInvalidCommand
    "
! !

!OperatingSystemTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

