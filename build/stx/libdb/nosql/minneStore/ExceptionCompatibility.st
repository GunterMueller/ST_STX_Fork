"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

Object subclass:#ExceptionCompatibility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-GG-Patch'
!


!ExceptionCompatibility class methodsFor:'As yet unclassified'!

DOInvalidVersionError

        ^ DOInvalidVersionError
!

DOLockStuckError

    ^ DOLockStuckError
!

FailedCheck
    "Used by the testing framework"

    ^FailedCheck
!

MSBranchAboutToMorph

        ^MSBranchAboutToMorph
!

MSDeletedLeafException

        ^MSDeletedLeafException
!

MessageNotUnderstood

        ^ Object messageNotUnderstoodSignal
!

MinneStoreCompatibility
	"Dummy method for file-out purposes"
!

anyError
    "Answer the top level exception to watch for."

    ^Error
!

during: block1 ensure: block2
    "Whatever happens in block 1, block 2 will be executed.
    Note: If an exception happens in the during block, the method
    using this will not continue."

	^block1 ensure: block2
!

error: aString
    "This method just for documentation purposes."
	"Sosituito halt a error:"
	^super halt: aString.
!

exceptionNamed: exceptionName

    ^self perform: exceptionName
!

on: exceptionName during: actionBlock do: handleBlock
    "Watch for an exception in the action block.
    If it happens, execute the handle block."

	^actionBlock
	on: (self exceptionNamed: exceptionName)
	do: handleBlock
!

pass: anException
    "Pass the exception so something above can handle it."

	^anException pass
!

resume: anException
    "Keep the code executing from where the exception was signaled."

	^anException resume
!

return: anException
    "Stop the execution of the code where the exception was signaled."

	^anException return
!

signal: exceptionName
    "Let it be known that an exception happened."

	"^(self exceptionNamed: exceptionName) signal"
	^(self exceptionNamed: exceptionName) raiseSignal
!

signal: exceptionName with: anObject
    "Let it be known that an exception happened."
	"VW pach: signal -> raiseSignal"
	(self exceptionNamed: exceptionName) raiseSignal: anObject
!

testEnsure
    "Test the ensure block code.
    'Exception Handled' should be printed to the Transcript.
    Then a walkback window should open.  When you close it,
    'Ensure block executed' should show on the transcript."
	"VW Ok, ma ora l' error: consente un proceed..."
    ExceptionCompatibility
	during:
	    [Transcript cr; show: 'ExceptionHandled.'.
	    ExceptionCompatibility error: 'Error occurred.']
	ensure: [Transcript cr; show: 'Ensure block executed'].
!

testExample1
	"self testExample1"
    "An example where the exception is returned (processing is not resumed).
    Before...During... should be printed on the Transcript."
	"VW OK"
    ExceptionCompatibility
	on: #testException
	during:
	    [Transcript show: 'Before...'.
	    ExceptionCompatibility signal: #testException.
	    Transcript show: 'After'.]
	do: [: excp |
	    Transcript show: 'During...'.
	    ExceptionCompatibility return: excp ]
!

testExample2
    "An example where the exception is resumed.
    Before...During...After  should be printed on the Transcript."
	"VW OK"
    ExceptionCompatibility
	on: #testException
	during:
	    [Transcript show: 'Before...'.
	    ExceptionCompatibility signal: #testException.
	    Transcript show: 'After']
	do: [: excp |
	    Transcript show: 'During...'.
	    ExceptionCompatibility resume: excp ]
!

testExample3
    "An example where the exception is passed up to be handled by something else.
    Before...During...  should be printed on the Transcript, then a walkback opened"
	"VW OK"
    ExceptionCompatibility
	on: #testException
	during:
	    [Transcript show: 'Before...'.
	    ExceptionCompatibility signal: #testException.
	    Transcript show: 'After']
	do: [: excp |
	    Transcript show: 'During...'.
	    ExceptionCompatibility pass: excp ]
!

testException
    "Answer a test exception to be watched for."

    ^ DOTestException
! !

!ExceptionCompatibility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/ExceptionCompatibility.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
