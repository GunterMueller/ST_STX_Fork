"{ Package: 'stx:clients/Demos/foxCalcApplication' }"

"{ NameSpace: CodingExamples_GUI }"

StandaloneStartup subclass:#FoxCalcCloneStartup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-foxCalc'
!


!FoxCalcCloneStartup class methodsFor:'startup'!

main:argvArg
    NoHandlerError
	emergencyHandler:(NoHandlerError notifyingEmergencyHandler).

    self startStartBlockProcess.
    Smalltalk openDisplay.

    GUIDemoFoxCalculatorClone open
!

startStartBlockProcess
    |p|

    p :=
	[
	    |startBlocks|

	    startBlocks := Smalltalk startBlocks.
	    startBlocks notNil ifTrue:[
		startBlocks do:[:aBlock|
		    aBlock value
		].
	    ].
	] newProcess.

    p priority:(Processor userSchedulingPriority).
    p name:'start block handler'.
    p beGroupLeader.
    p resume.

    "Created: / 31-10-2007 / 14:05:14 / cg"
! !

!FoxCalcCloneStartup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/foxCalcApplication/CodingExamples_GUI__FoxCalcCloneStartup.st,v 1.5 2008-11-22 01:58:23 cg Exp $'
! !
