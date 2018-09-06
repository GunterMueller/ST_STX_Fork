"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

SharedPool subclass:#LogLevels
	instanceVariableNames:''
	classVariableNames:'ALL ENTER LEAVE TRACE3 TRACE2 TRACE1 TRACE0 TRACE DEBUG INFO WARN
		ERROR FATAL NONE WARNING Levels'
	poolDictionaries:''
	category:'System-Support-Loggia'
!


!LogLevels class methodsFor:'class initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."
    "/ please change as required (and remove this comment)

    ALL := LogLevel new initializeWithName:#all value:0.
    ENTER := LogLevel new initializeWithName:#enter value:10.
    LEAVE := LogLevel new initializeWithName:#leave value:10.
    TRACE3 := LogLevel new initializeWithName:#trace3 value:20.
    TRACE2 := LogLevel new initializeWithName:#trace2 value:30.
    TRACE1 := LogLevel new initializeWithName:#trace1 value:40.
    TRACE0 := LogLevel new initializeWithName:#trace0 value:50.
    TRACE := LogLevel new initializeWithName:#trace value:50.
    DEBUG := LogLevel new initializeWithName:#debug value:60.
    INFO := LogLevel new initializeWithName:#info value:70.
    WARN := WARNING := LogLevel new initializeWithName:#warning value:88.
    ERROR := LogLevel new initializeWithName:#error value:99.
    FATAL := LogLevel new initializeWithName:#fatal value:100.
    NONE := LogLevel new initializeWithName:#none value:65535.

    Levels := Array new:12.
    Levels at:1 put:ENTER.
    Levels at:2 put:LEAVE.
    Levels at:3 put:TRACE3.
    Levels at:4 put:TRACE2.
    Levels at:5 put:TRACE1.
    Levels at:6 put:TRACE0.
    Levels at:7 put:TRACE.
    Levels at:8 put:DEBUG.
    Levels at:9 put:INFO.
    Levels at:10 put:WARNING.
    Levels at:11 put:ERROR.
    Levels at:12 put:FATAL.

    "Created: / 22-09-2014 / 15:03:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogLevels class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogLevels.st,v 1.2 2016-09-30 15:56:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogLevels.st,v 1.2 2016-09-30 15:56:06 cg Exp $'
! !


LogLevels initialize!
