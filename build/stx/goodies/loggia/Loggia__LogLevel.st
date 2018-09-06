"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

Object subclass:#LogLevel
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:'Loggia::LogLevels'
	category:'System-Support-Loggia'
!


!LogLevel class methodsFor:'accessing-severities'!

levelDEBUG
    ^ DEBUG

    "Created: / 22-09-2014 / 15:05:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelENTER
    ^ ENTER

    "Created: / 22-09-2014 / 15:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelERROR
    ^ ERROR

    "Created: / 22-09-2014 / 15:06:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelFATAL
    ^ FATAL

    "Created: / 22-09-2014 / 15:06:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelINFO
    ^ INFO

    "Created: / 22-09-2014 / 15:06:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelLEAVE
    ^ LEAVE

    "Created: / 22-09-2014 / 15:06:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelTRACE
    ^ TRACE

    "Created: / 22-09-2014 / 15:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelTRACE0
    ^ TRACE0

    "Created: / 22-09-2014 / 15:05:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelTRACE1
    ^ TRACE1

    "Created: / 22-09-2014 / 15:05:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelTRACE2
    ^ TRACE2

    "Created: / 22-09-2014 / 15:05:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelWARN
    ^ WARN

    "Created: / 22-09-2014 / 15:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogLevel class methodsFor:'accessing-severities-special'!

levelALL
    ^ ALL

    "Created: / 22-09-2014 / 15:04:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

levelNONE
    ^ NONE

    "Created: / 22-09-2014 / 15:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogLevel class methodsFor:'utilities'!

symbolToLevel:severitySymbol 
    | severity  nseverities  i |

    severity := severitySymbol.
    i := 1.
    nseverities := Levels size.
    [ i <= nseverities ] whileTrue:[
        | s |

        (s := Levels at:i) name = severitySymbol ifTrue:[
            | caller |

            severity := s.
            i := nseverities + 1.
            
            "/ This will be enabled later, so far it generates
            "/ way to much warnings. at least stx:libjava & exept:jdi has to be rewritten
            "/ self log: 'using symbols as severity is deprecated, use Logger severityXXX to get severity object' severity: WARN facility: 'STX' originator: self.
            "/ caller := thisContext sender.
            "/ [ caller notNil and: [ caller receiver ~~ originator ] ] whileTrue:[ caller := caller sender ].
            "/ self log: 'caller is ', caller printString severity: INFO facility: 'STX' originator: self.
        ].
        i := i + 1.
    ].
    
    "/ Now check whether the severity is one of the predefined ones,
    "/ if not, issue an error
    
    (Levels includesIdentical:severity) ifFalse:[
        Smalltalk::Logger 
            log:('no such severity (%1), use one from predefined severities. Original message will be logged as INFO' 
                    bindWith:severity)
            severity:Smalltalk::Logger severityERROR
            facility:'STX'
            originator:self.
        severity := INFO.
    ].
    ^ severity

    "Created: / 22-09-2014 / 15:31:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogLevel methodsFor:'accessing'!

name
    ^ name
!

value
    ^ value
! !

!LogLevel methodsFor:'initialization'!

initializeWithName: aString value: anInteger
    name := aString.
    value := anInteger

    "Created: / 13-08-2014 / 13:00:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogLevel methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    name printOn: aStream.

    "Modified: / 13-08-2014 / 13:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogLevel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogLevel.st,v 1.2 2016-08-08 18:29:49 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogLevel.st,v 1.2 2016-08-08 18:29:49 mawalch Exp $'
! !

