"
 COPYRIGHT (c) 2012-2014 by Jan Vrany & eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MiniLogger
	instanceVariableNames:''
	classVariableNames:'ALL DEBUG ENTER ERROR FATAL INFO Instance LEAVE NONE Severities
		TRACE TRACE0 TRACE1 TRACE2 TRACE3 Threshold WARN WARNING
		LogOnTranscript LogOnStderr LogFormat TimestampFormat'
	poolDictionaries:''
	category:'System-Debugging-Support'
!

Magnitude subclass:#Severity
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MiniLogger
!

!MiniLogger class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012-2014 by Jan Vrany & eXept Software AG
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
    A very simple logger for Smalltalk/X. This one is always present.
    It mimics the protocol of the loggers found in stx:goodies/loggia,
    which can be activated by setting the global 'Logger' to an instance of
    one of them.
    
    All 
        'Transcript show: 'Processor [info]: xxx' 
    should be rewritten over time to use the Logger.

    'Object infoPrint' and 'Object debugPrint' have been changed to
    forward their message to the global 'Logger' if not nil.
    
    Usage:
        Logger info: 'Hello world'.
        Logger debug: 'Hello world'.
        Logger warning: 'Hello world'.
        Logger error: 'Hello world'.

    to disable logging:
        MiniLogger logOnTranscript:false.
        MiniLogger logOnStderr:false.

    for selective logging:
        Logger loggingThreshold: Logger severityALL.
        Logger loggingThreshold: Logger severityINFO.
        Logger loggingThreshold: Logger severityNONE.
    
    For more examples, see #examples.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        Loggia logging framrwork (stx:goodies/loggia)

"
!

examples
"   
    Simple logging (make sure logging threshold is lower or equal then
    Logger severityDEBUG, see #loggingThreshold:)
                                                                        [exBegin]    
        Logger debug: 'Hello world!!'
                                                                        [exEnd]

    You may use #<severity>:with:with: utility to format log message:
                                                                        [exBegin]    
        | hostname port |

        hostname := 'www.google.com'.
        port := 80.
        Logger error: 'Cannot connect to %1 port %2' with: hostname with: port
                                                                        [exEnd]

    When a log message is costly to construct, you may pass a block returning
    the message instead of string. Then the log message creation os deferred until
    really needed (i.e., if the severity is not logged, block is not evaluated.
    Useful for trace messages (severities DEBUG and TRACE?):
                                                                        [exBegin]    
        | hostname port |

        hostname := 'www.google.com'.
        Logger trace: [ 'Connecting to %1' bindWith: (IPSocketAddress hostName:hostname) address ]
                                                                        [exEnd]

"
! !

!MiniLogger class methodsFor:'initialization'!

initialize
    LogOnStderr := true.
    LogOnTranscript := true.

    ALL := Severity new initializeWithName:#all value:0.
    ENTER := Severity new initializeWithName:#enter value:10.
    LEAVE := Severity new initializeWithName:#leave value:10.
    TRACE3 := Severity new initializeWithName:#trace3 value:20.
    TRACE2 := Severity new initializeWithName:#trace2 value:30.
    TRACE1 := Severity new initializeWithName:#trace1 value:40.
    TRACE0 := Severity new initializeWithName:#trace0 value:50.
    TRACE := Severity new initializeWithName:#trace value:50.
    DEBUG := Severity new initializeWithName:#debug value:60.
    INFO := Severity new initializeWithName:#info value:70.
    WARN := Severity new initializeWithName:#warn value:88.
    WARNING := Severity new initializeWithName:#warning value:88.
    ERROR := Severity new initializeWithName:#error value:99.
    FATAL := Severity new initializeWithName:#fatal value:100.
    NONE := Severity new initializeWithName:#none value:65535.

    Severities := {ENTER. LEAVE. TRACE3. TRACE2. TRACE1. TRACE0. TRACE. DEBUG. INFO. WARN. WARNING. ERROR. FATAL.}.
    Threshold := InfoPrinting ifTrue:[INFO] ifFalse:[WARN].

    (Smalltalk at:#Logger) isNil ifTrue:[
        Smalltalk at:#Logger put:self
    ].

    "Modified: / 13-08-2014 / 14:36:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'accessing-log format'!

logFormat
    "will be used for the log message as:
        %1 [%2] (%3): %4
    with %1: facility (area)
    with %2: secerity (area)
    with %3: timestamp 
    with %4: caller/originator 
    with %5: message"
    
    ^ LogFormat ? '%1 [%2] (%3): %5'

    "
     MiniLogger logFormat:'%1 [%2]: %5'.
     'hello' errorPrintCR.
     MiniLogger logFormat:'%3 %1 [%2]: %5'.
     'hello' errorPrintCR.
     MiniLogger logFormat:nil.
     'hello' errorPrintCR.
    "
!

logFormat:aFormatString
    "will be used for the log message as:
        %1 [%2] (%3): %4
            with %1: facility (area)
            with %2: secerity (area)
            with %3: timestamp 
            with %4: caller/originator 
            with %5: message.
     Pass anil argument to return to the default format.        
    "
    
    LogFormat := aFormatString

    "
     MiniLogger logFormat:'%1 [%2]: %5'.
     'hello' errorPrintCR.
     MiniLogger logFormat:'%3 %1 [%2]: %5'.
     'hello' errorPrintCR.
     MiniLogger logFormat:nil.
     'hello' errorPrintCR.
    "
!

logOnStderr 
    ^ LogOnStderr
!

logOnStderr:aBoolean
    "enable/disable loggin on stderr"
    
    LogOnStderr := aBoolean

    "
     MiniLogger logOnStderr:false
     MiniLogger logOnTranscript:false

     MiniLogger logOnStderr:true
     MiniLogger logOnTranscript:true
    "
!

logOnTranscript
    ^ LogOnTranscript 
!

logOnTranscript:aBoolean
    "enable/disable loggin on the Transcript"

    LogOnTranscript := aBoolean

    "
     MiniLogger logOnStderr:false
     MiniLogger logOnTranscript:false

     MiniLogger logOnStderr:true
     MiniLogger logOnTranscript:true
    "
!

timestampFormat
    "will be used for the log message"
    
    ^ TimestampFormat ? '%(year)-%(mon)-%(day) %h:%m:%s.%i'.
!

timestampFormat:aTimestampFormatString
    "will be used for the log message"
    
    TimestampFormat := aTimestampFormatString
! !

!MiniLogger class methodsFor:'accessing-severities'!

severities
    ^ Severities.
!

severityDEBUG
    ^ DEBUG

    "Created: / 13-08-2014 / 14:15:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityENTER
    ^ ENTER

    "Created: / 13-08-2014 / 14:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityERROR
    ^ ERROR

    "Created: / 13-08-2014 / 14:15:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityFATAL
    ^ FATAL

    "Created: / 13-08-2014 / 14:15:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityINFO
    ^ INFO

    "Created: / 13-08-2014 / 14:15:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityLEAVE
    ^ LEAVE

    "Created: / 13-08-2014 / 14:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityTRACE
    ^ TRACE

    "Created: / 13-08-2014 / 14:15:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityTRACE0
    ^ TRACE0

    "Created: / 13-08-2014 / 14:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityTRACE1
    ^ TRACE1

    "Created: / 13-08-2014 / 14:14:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityTRACE2
    ^ TRACE2

    "Created: / 13-08-2014 / 14:14:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityTRACE3
    ^ TRACE3

    "Created: / 13-08-2014 / 14:14:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityWARN
    ^ WARN

    "Created: / 13-08-2014 / 14:15:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'accessing-severities-special'!

severityALL
    ^ ALL

    "Created: / 13-08-2014 / 14:14:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityNONE
    ^ NONE

    "Created: / 13-08-2014 / 14:15:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'configuration'!

loggingThreshold
    "Return the logging threshold. No messages with severity lower than 
     threshold will be logged."
    
    ^ Threshold

    "Created: / 13-08-2014 / 14:36:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loggingThreshold:severity 
    "Sets logging threshold. No severity lower than given one will be logged.
     Use `Logger severityNONE` to suppress logging completely or
     `Logger severityALL` to log all messages"
    
    ((Severities includes:severity) 
        or:[ severity == ALL or:[ severity == NONE ] ]) 
            ifFalse:[
                self error:'Invalid severity. Use of Logger severityXXX'.
                ^ self.
            ].
    Threshold := severity

    "
    Logger loggingThreshold: Logger severityALL.
    Logger loggingThreshold: Logger severityINFO.
    Logger loggingThreshold: Logger severityNONE.
    "

    "Created: / 13-08-2014 / 14:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-08-2014 / 08:23:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 09-10-2014 / 09:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'logging'!

log: message
    self log: message severity: DEBUG originator: thisContext sender receiver.

    "Created: / 15-09-2011 / 10:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 10:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message facility: facility
    self log: message severity: DEBUG facility: facility originator: thisContext sender receiver

    "Created: / 14-09-2011 / 21:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 10:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity
    self log: message severity: severity originator: thisContext sender receiver

    "Created: / 15-09-2011 / 10:25:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 10:53:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity attachment: attachment
    | originator |

    originator := thisContext sender receiver.
    self log: message severity: severity facility: (self facilityOf: originator) originator: originator attachment: attachment

    "Created: / 15-09-2011 / 11:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2013 / 11:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-08-2014 / 08:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity facility: facility
    self log: message severity: severity facility: facility originator: thisContext sender receiver

    "Created: / 14-09-2011 / 21:20:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity facility: facility originator: originator
    self log: message severity: severity facility: facility originator: originator attachment: nil

    "Created: / 14-09-2011 / 21:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity facility: facility originator: originator attachment: attachment
    "Pricipal logging method. This mimics VM __stxLog__()"

    | severityXlated messageXlated logOnStderr logOnTranscript prevLogOnTranscript |

    logOnStderr := self logOnStderr.
    logOnTranscript := self logOnTranscript and:[Transcript isView].
                        
    (logOnStderr or:[logOnTranscript]) ifFalse:[^ self].

    severityXlated := severity.

    "/ Be backward compatible, allow for symbolic severities
    "/ but when encountered, issue a warning...
    severity isSymbol ifTrue:[
        severityXlated := Severities detect:[:each| each name == severity] ifNone:[].

        "/ This will be enabled later, so far it generates
        "/ way to much warnings. at least stx:libjava & exept:jdi has to be rewritten
        
        "/ self log: 'using symbols as severity is deprecated, use Logger severityXXX to get severity object' severity: WARN facility: 'STX' originator: self.
        "/ caller := thisContext sender.
        "/ [ caller notNil and: [ caller receiver ~~ originator ] ] whileTrue:[ caller := caller sender ].
        "/ self log: 'caller is ', caller printString severity: INFO facility: 'STX' originator: self.
    ].

    "/ Now check whether the severity is one of the predefined ones,
    "/ if not, issue an error
    (Severities includesIdentical: severityXlated) ifFalse:[ 
        | caller |

        caller := thisContext sender.
        [caller notNil and:[caller receiver ~~ originator]] whileTrue:[ 
            caller := caller sender
        ].
        self log:('no such severity (%1, called from %2), use one from predefined severities. Original message will be logged as INFO' bindWith:severityXlated with:caller) 
             severity: ERROR facility: 'STX' originator: self.
        severityXlated := INFO.
    ].

    severityXlated < Threshold ifTrue:[ ^ self ].
    messageXlated := message value asString.

    "/ to avoid recursion, turn off logOnTranscript while logging
    "/ had this problem with RecursionLock, which wanted to issue a warning
    "/ ("cleanup for dead process") from inside Transcript code.
    [
        prevLogOnTranscript := LogOnTranscript.
        LogOnTranscript := false.
        
        logOnStderr ifTrue:[
            self log:messageXlated severity:severityXlated facility:facility 
                 originator:originator attachment:attachment on:Stderr.
        ].
        logOnTranscript ifTrue:[
            Transcript nextPutLine:messageXlated.
        ].
    ] ensure:[
        LogOnTranscript := prevLogOnTranscript.
    ].
    
    "
     Logger log:'test message' severity:self severityINFO facility: 'TEST'
     Logger log:'test message' severity:#info facility: 'TEST'
     Logger log:'test message' severity:#bla facility: 'TEST'
     Logger log:'test message' severity:123 facility: 'TEST'
    "

    "Created: / 14-09-2011 / 21:18:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-01-2015 / 18:40:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity originator: originator
    self log: message severity: severity facility: (self facilityOf: originator) originator: originator

    "Created: / 15-09-2011 / 10:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2013 / 11:20:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'logging - utils'!

debug: message
    DEBUG < Threshold ifTrue:[ ^ self ].
    self log: message severity: DEBUG originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: format with: arg1
    DEBUG < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: DEBUG originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: format with: arg1 with: arg2
    DEBUG < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: DEBUG originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: format with: arg1 with: arg2 with:arg3
    DEBUG < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: DEBUG originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: message
    ENTER < Threshold ifTrue:[ ^ self ].
    self log: message severity: ENTER originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: format with: arg1
    ENTER < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: ENTER originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: format with: arg1 with: arg2
    ENTER < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: ENTER originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: format with: arg1 with: arg2 with:arg3
    ENTER < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: ENTER originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: message
    ERROR < Threshold ifTrue:[ ^ self ].
    self log: message severity: ERROR originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: format with: arg1
    ERROR < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: ERROR originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: format with: arg1 with: arg2
    ERROR < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: ERROR originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: format with: arg1 with: arg2 with:arg3
    ERROR < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: ERROR originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: message
    FATAL < Threshold ifTrue:[ ^ self ].
    self log: message severity: FATAL originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: format with: arg1
    FATAL < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: FATAL originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: format with: arg1 with: arg2
    FATAL < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: FATAL originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: format with: arg1 with: arg2 with:arg3
    FATAL < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: FATAL originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: message
    INFO < Threshold ifTrue:[ ^ self ].
    self log: message severity: INFO originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: format with: arg1
    INFO < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: INFO originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: format with: arg1 with: arg2
    INFO < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: INFO originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: format with: arg1 with: arg2 with:arg3
    INFO < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: INFO originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: message
    LEAVE < Threshold ifTrue:[ ^ self ].
    self log: message severity: LEAVE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: format with: arg1
    LEAVE < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: LEAVE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: format with: arg1 with: arg2
    LEAVE < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: LEAVE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: format with: arg1 with: arg2 with:arg3
    LEAVE < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: LEAVE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: message
    TRACE0 < Threshold ifTrue:[ ^ self ].
    self log: message severity: TRACE0 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: format with: arg1
    TRACE0 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: TRACE0 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: format with: arg1 with: arg2
    TRACE0 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: TRACE0 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: format with: arg1 with: arg2 with:arg3
    TRACE0 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE0 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: message
    TRACE1 < Threshold ifTrue:[ ^ self ].
    self log: message severity: TRACE1 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: format with: arg1
    TRACE1 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: TRACE1 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: format with: arg1 with: arg2
    TRACE1 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: TRACE1 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: format with: arg1 with: arg2 with:arg3
    TRACE1 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE1 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: message
    TRACE2 < Threshold ifTrue:[ ^ self ].
    self log: message severity: TRACE2 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: format with: arg1
    TRACE2 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: TRACE2 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: format with: arg1 with: arg2
    TRACE2 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: TRACE2 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: format with: arg1 with: arg2 with:arg3
    TRACE2 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE2 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: message
    TRACE3 < Threshold ifTrue:[ ^ self ].
    self log: message severity: TRACE3 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: format with: arg1
    TRACE3 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: TRACE3 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:55:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: format with: arg1 with: arg2
    TRACE3 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: TRACE3 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: format with: arg1 with: arg2 with:arg3
    TRACE3 < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE3 originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: message
    TRACE < Threshold ifTrue:[ ^ self ].
    self log: message severity: TRACE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: format with: arg1
    TRACE < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: TRACE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: format with: arg1 with: arg2
    TRACE < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: TRACE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: format with: arg1 with: arg2 with:arg3
    TRACE < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: message
    WARN < Threshold ifTrue:[ ^ self ].
    self log: message severity: WARN originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: format with: arg1
    WARN < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1) severity: WARN originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning:format with:arg1 with:arg2
    WARN < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith: arg1 with: arg2) severity: WARN originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning:format with:arg1 with:arg2 with:arg3
    WARN < Threshold ifTrue:[ ^ self ].
    self log: (format bindWith:arg1 with:arg2 with:arg3) severity: WARN originator: thisContext sender receiver

    "Modified: / 02-12-2014 / 10:56:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'private'!

facilityOf:originator 
    ^ originator class 
        perform:#logFacility
        ifNotUnderstood:[
            |pkg|

            pkg := originator class package.
            (pkg startsWith:'stx') ifTrue:[
                'STX'
            ] ifFalse:[
                pkg copyFrom:((pkg lastIndexOf:$:) + 1)
            ]
        ]

    "
     Logger facilityOf: Object
     Logger facilityOf: Expecco::Browser
    "

    "Created: / 15-09-2011 / 10:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity facility: facilityArg originator: originator attachment: attachment on:aStream
    "Principal logging method. This mimics VM __stxLog__()"

    |facility severityName words messageAsSent secondWord|

    thisContext isRecursive ifTrue:[
        'STX [error]: recursive logger invocation.' _errorPrintCR.
        ^ self.
    ].
    
    facility := facilityArg.
    messageAsSent := message.
    severityName := severity name.

    "/ hack to allow calls from infoPrint/errorPrint.
    "/ if this is an oldStyle infoPrint or errorPrint, do not append another facility and severity
    words := messageAsSent asCollectionOfWords.
    (words size >= 2
     and:[words first isAlphaNumeric
     and:[((secondWord := words second) startsWith:$[ )
     and:[(secondWord endsWith:$]) or:[(secondWord endsWith:']:')]]]]) ifTrue:[
        facility := words first.
        severityName := secondWord copyButFirst.
        severityName := severityName copyTo:(severityName indexOf:$])-1.
        messageAsSent := messageAsSent copyFrom:(messageAsSent indexOf:$])+1.
        "/ messageAsSent := messageAsSent withoutSeparators.
        (messageAsSent startsWith:$:) ifTrue:[
            messageAsSent := messageAsSent copyFrom:2.
            "/ messageAsSent := messageAsSent withoutSeparators.
            (messageAsSent startsWith:Character space) ifTrue:[
                messageAsSent := messageAsSent copyFrom:2.
            ].
        ].
    ].

    messageAsSent := 
            self logFormat
                bindWith:(facility ? 'STX')
                with:severityName
                with:(Timestamp now printStringFormat:(self timestampFormat))
                with:originator
                with:messageAsSent.

    "/ If the message is Unicode 16/32 string and stream is external,
    "/ we have to recode the message using locale-specific encoding
    aStream isExternalStream ifTrue:[
        messageAsSent := messageAsSent string.  "take care of Texts"
        messageAsSent containsNon7BitAscii ifTrue:[
            OperatingSystem isMSWINDOWSlike ifTrue:[
                messageAsSent := messageAsSent utf8Encoded.
            ] ifFalse:[
                messageAsSent := OperatingSystem encodePath:messageAsSent.
            ].
        ].
    ].

    aStream nextPutLine: messageAsSent

    "
     'hello' infoPrintCR.

     Logger log:'test message' severity: DEBUG facility: 'TEST'
     Logger log:'test message' severity: INFO facility: 'TEST'
     Logger log:'test message' asUnicode16String severity: INFO facility: 'TEST'
     Logger log:'test message äöüß' severity: INFO facility: 'TEST'
     Logger log:'test message' severity: WARNING facility: 'TEST'
     Logger log:'test message' severity: ERROR facility: 'TEST'
     'test message' infoPrintCR
     'test message' errorPrintCR
    "
    "backward compatibility with infoPrint/errorPrint callers:
     'foo [info] test message' infoPrintCR
     'bar [error] test message' errorPrintCR
     'foo [info]: test message' infoPrintCR
     'bar [error]: test message' errorPrintCR
    "

    "Created: / 14-09-2011 / 21:18:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 10:50:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityThresholdOf:originator
    "allow each class to define an individual threshold for Logging"

    ^ originator class 
        perform:#logSeverityThreshold
        ifNotUnderstood:[
            ^ Threshold.
        ]

    "
     Logger severityThresholdOf: Object
     Logger severityThresholdOf: Expecco::Browser
    "

    "Created: / 15-09-2011 / 10:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger::Severity methodsFor:'accessing'!

name
    ^ name
!

value
    ^ value
! !

!MiniLogger::Severity methodsFor:'arithmethic'!

+ aNumber
    |next|

    next := value + aNumber.
    aNumber negative ifTrue:[
        ^ MiniLogger severities detectLast:[:each| each = next or:[each < next]] ifNone:[self class new initializeWithName:#nil value:next]
    ].

    ^ MiniLogger severities detect:[:each| each >= next] ifNone:[self class new initializeWithName:#nil value:next]

    "
        MiniLogger severityINFO + 1
        MiniLogger severityTRACE to:MiniLogger severityFATAL do:[:each| Transcript showCR:each].
        MiniLogger severityFATAL downTo:MiniLogger severityTRACE do:[:each| Transcript showCR:each].
    "
! !

!MiniLogger::Severity methodsFor:'comparing'!

< aSeverity
    ^ value < aSeverity value
!

= aSeverity
    ^ self == aSeverity or:[value = aSeverity value]
!

hash
    "instances, for which #= answers true must answer the same hash"

    ^ value hash
! !

!MiniLogger::Severity methodsFor:'initialization'!

initializeWithName: aString value: anInteger
    name := aString.
    value := anInteger

    "Created: / 13-08-2014 / 13:00:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger::Severity methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    name printOn: aStream.

    "Modified: / 13-08-2014 / 13:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MiniLogger class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


MiniLogger initialize!
