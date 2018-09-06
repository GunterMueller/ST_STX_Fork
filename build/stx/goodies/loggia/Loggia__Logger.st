"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

Object subclass:#Logger
	instanceVariableNames:'facilities'
	classVariableNames:'DefaultLogger PreviousLogger ConfiguredTransports'
	poolDictionaries:'Loggia::LogLevels'
	category:'System-Support-Loggia'
!

!Logger class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!Logger class methodsFor:'instance creation'!

new

    ^self basicNew initialize
! !

!Logger class methodsFor:'accessing'!

addTransport: aLogTransport

    (self transports includes: aLogTransport)
	ifFalse: [self transports add: aLogTransport].

    ^aLogTransport

    "Modified: / 05-05-2005 / 15:28:42 / masca"
!

inMemoryTransports

    ^self transports select:[:t|t isInMemoryTransport]

    "Created: / 17-11-2005 / 12:15:23 / janfrog"
!

nullTransport

    ^self transports
	detect:
	    [:t|t isNullTransport]
	ifNone:
	    [|null|
	    null := NullTransport new.
	    null name:'NULL transport [default]'.
	    self addTransport: null.
	    null].

    "
	self nullTransport
    "

    "Created: / 27-09-2007 / 08:14:43 / janfrog"
!

removeTransport: aLogTransport

    aLogTransport close.
    self transports
	remove: aLogTransport
	ifAbsent: [self error: 'Given log transport not registered.']
!

systemFacilityName
    ^ #system
!

transports

    ConfiguredTransports isNil ifTrue:[
          ConfiguredTransports := Set new
    ].
    ^ConfiguredTransports

    "Modified: / 28-10-2014 / 15:46:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger class methodsFor:'accessing - defaults'!

default

    DefaultLogger isNil ifTrue:[
          DefaultLogger := self new
    ].
    ^DefaultLogger

    "Modified: / 28-10-2014 / 15:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransport
    "Return a default transport - the one which always exists"

    | default |

    default := TranscriptTransport default.

    ^self transports 
        detect: [:e | e = default]
        ifNone: [
            default name: 'Transcript (default)'. 
            self addTransport: default. 
            default
        ]

    "Created: / 05-05-2005 / 14:04:50 / masca"
    "Modified: / 28-10-2014 / 16:09:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransportLogToBinaryFile
    "Return a default transport that stores messages in binary file. This file can be
     later opened by Loggia::LogMessagesBrowserUI.
     If no such transport is found (by name) then nil is returned"

    ^ self defaultTransportLogToBinaryFileCreateIfAbsent: false.

    "Created: / 28-10-2014 / 16:20:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransportLogToBinaryFileCreateIfAbsent: create
    "Return a default transport that stores messages in binary file. This file can be
     later opened by Loggia::LogMessagesBrowserUI.
     If no such transport is found (by name) then if `create` is `true` the transport
     is created and returned, otherwise nil is returned"

    | transportName |

    transportName := 'Log to binary file (loggia.bin)'.

    ^self transports 
        detect: [:e | e name = transportName ]
        ifNone: [
            | transport |

            transport := BOSSFileTransport new.
            transport name: transportName.
            transport filename: 'loggia.bin'.
            self addTransport: transport. 
            transport
        ]

    "Created: / 28-10-2014 / 16:14:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransportLogToMemory
    "Return a default transport that stores messages in memory (as Smalltalk objects).
     If no such transport is found (by name) then nil is returned"

    ^ self defaultTransportLogToMemoryCreateIfAbsent: false

    "Created: / 28-10-2014 / 16:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransportLogToMemoryCreateIfAbsent: create
    "Return a default transport that stores messages in memory (as Smalltalk objects).
     If no such transport is found (by name) then if `create` is `true` the transport
     is created and returned, otherwise nil is returned"

    | nm |

    nm := 'Log to memory'.

    ^self transports 
        detect: [:e | e name = nm ]
        ifNone: [
            | t |

            t := InMemoryTransport new.
            t name: nm.
            self addTransport: t. 
            t
        ]

    "Created: / 28-10-2014 / 16:13:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransportLogToTextFile
    "Return a default transport that stores messages text file.
     If no such transport is found (by name) then if nil is returned"

    ^ self defaultTransportLogToTextFileCreateIfAbsent: false.

    "Created: / 28-10-2014 / 16:24:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTransportLogToTextFileCreateIfAbsent: create
    "Return a default transport that stores messages text file.
     If no such transport is found (by name) then if `create` is `true` the transport
     is created and returned, otherwise nil is returned"

    | transportName |

    transportName := 'Log to text file (loggia.txt)'.

    ^self transports 
        detect: [:e | e name = transportName ]
        ifNone: [
            | transport |

            transport := LogFileTransport new.
            transport name: transportName.
            transport filename: 'loggia.txt'.
            self addTransport: transport. 
            transport
        ]

    "Created: / 28-10-2014 / 16:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 18:33:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger class methodsFor:'class initialization'!

initialize

    (Smalltalk at:#Logger) isNil ifTrue:[Smalltalk at:#Logger put: self default].

    "Created: / 01-09-2011 / 12:26:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 16:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger class methodsFor:'compatibility'!

for: originatorObject withSeverity: severitySymbol log: messageString

    self log: messageString at: severitySymbol for: originatorObject with: nil
! !

!Logger class methodsFor:'processing'!

commit: severitySymbol

    self
	commit: severitySymbol
	for: thisContext sender receiver
!

commit: severitySymbol for: originatorObject

    self default
	commit: severitySymbol
	for: originatorObject
!

log: messageString at: severitySymbol
    "Log the given message at the given severity. To be called directly as the
    originator object is obtained from the message context."

    self
	log: messageString
	at: severitySymbol
	for: thisContext sender receiver
	with: nil
!

log: messageString at: severitySymbol for: originatorObject
    "Log the given message at the given severity. Set message originator."

    self
	log: messageString
	at: severitySymbol
	for: originatorObject
	with: nil
!

log: messageString at: severitySymbol for: originatorObject with: attachedObject
    "Log the given message at the given severity with the given object as log originator.
    Attach the specified object to the message (if a transport can make use of it)."

    self default
	log: messageString
	at: severitySymbol
	for: originatorObject
	with: attachedObject
!

log: messageString at: severitySymbol with: attachment
    "Log the given message at the given severity. To be called directly as the
    originator object is obtained from the message context."

    self
	log: messageString
	at: severitySymbol
	for: thisContext sender receiver
	with: attachment

    "Created: / 01-09-2011 / 13:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset: severitySymbol

    self
	reset: severitySymbol
	for: thisContext sender receiver
!

reset: severitySymbol for: originatorObject

    self default
	reset: severitySymbol
	for: originatorObject
! !

!Logger class methodsFor:'testing'!

hasTransportNamed: aString

    ^self transports contains: [:e | e name = aString]
!

transportNamed: aString

    ^self transports detect: [:e | e name = aString] ifNone:[nil].

    "Created: / 07-04-2012 / 09:00:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger class methodsFor:'utilities'!

flushLogger

    self flushTransports.
    self default reinitialize

    "
	Logger flushLogger
    "

    "Created: / 30-05-2005 / 15:27:20 / masca"
!

flushTransports

    ConfiguredTransports ifNotNil: [
	ConfiguredTransports do: [:e | e close].
	ConfiguredTransports := nil]

    "
	Logger flushTransports
    "
!

install

    DefaultLogger isNil ifTrue:[ 
        self installDefaultTransports.
    ] ifFalse:[
        Logger == DefaultLogger ifTrue:[ ^ self ].
    ].
    PreviousLogger :=  Smalltalk at: #Logger.
    Smalltalk at: #Logger put: self default

    "
        ConfiguredTransports := Set new.
        DefaultLogger := nil.
        Loggia::Logger install
    "

    "Created: / 02-11-2011 / 12:36:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 09:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 29-10-2014 / 10:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installDefaultTransports
    self defaultTransport.
    self defaultTransportLogToMemoryCreateIfAbsent: true.  
    self defaultTransportLogToBinaryFileCreateIfAbsent: true.  
    self defaultTransportLogToTextFileCreateIfAbsent: true

    "Created: / 28-10-2014 / 16:04:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 24-02-2018 / 23:47:08 / stefan"
!

uninstall

    Smalltalk at: #Logger put: (PreviousLogger ? MiniLogger)

    "
        Loggia::Logger install
    "

    "Created: / 08-04-2012 / 09:53:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 15:49:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'accessing'!

addFacility: aLogFacility as: facilitySymbol

    facilities
	at: facilitySymbol
	put: aLogFacility
!

facilities

    ^facilities
!

registeredFacilities

    ^facilities
!

removeFacilityAt: facilitySymbol

    facilitySymbol = self systemFacilityName
	ifTrue: [self error: 'System facility cannot be removed.'].

    facilities
	removeKey: facilitySymbol
	ifAbsent: [self error: 'Facility not registered.']
!

systemFacility
    "Return the system (default) facility (as LogFacility)"

    ^ self facilityFor: self systemFacilityName

    "Created: / 23-09-2014 / 11:18:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'accessing-severities'!

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

!Logger methodsFor:'accessing-severities-special'!

severityALL
    ^ ALL

    "Created: / 13-08-2014 / 14:14:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityNONE
    ^ NONE

    "Created: / 13-08-2014 / 14:15:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'configuration'!

for: aLogLevel use: aLogTransport
    "Tell the logger to log all messages for all facilities with given log level using
     given transport."

    facilities do:[:facility | facility for: aLogLevel use: aLogTransport ]

    "Created: / 29-10-2014 / 10:13:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forAllSeveritiesUse: aLogTransport
    "Tell the logger to log all messages for all facilities using given transport."

    Levels do:[:level | self for: level use: aLogTransport ]

    "Created: / 29-10-2014 / 10:15:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forAllSeveritiesUseBinaryFile
    ^ self forAllSeveritiesUse: (self class defaultTransportLogToBinaryFileCreateIfAbsent: true)

    "Created: / 29-10-2014 / 10:17:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forAllSeveritiesUseMemory
    ^ self forAllSeveritiesUse: (self class defaultTransportLogToMemoryCreateIfAbsent: true)

    "Created: / 29-10-2014 / 10:17:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forAllSeveritiesUseTextFile
    ^ self forAllSeveritiesUse: (self class defaultTransportLogToTextFileCreateIfAbsent: true)

    "Created: / 29-10-2014 / 10:17:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forAllSeveritiesUseTranscript
    ^ self forAllSeveritiesUse: self class defaultTransport

    "Created: / 29-10-2014 / 10:16:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forAllUse: aLogTransport
    "Tell the logger to log all messages for all facilities using given transport."

    "Created: / 29-10-2014 / 10:14:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'initialization'!

initialize

    super initialize.
    self reinitialize

    "Modified: / 30-05-2005 / 15:24:33 / masca"
!

reinitialize

    facilities := IdentityDictionary new.
    self addFacility: LogFacility new as: self systemFacilityName

    "Created: / 30-05-2005 / 15:24:21 / masca"
    "Modified: / 23-09-2014 / 11:18:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setFacilities: facilityDictionary

    facilities := facilityDictionary.
    "Log some message - used to proof that everyting is
     OK"
    self
	log: 'Facilities set directly using #setFacilities:'
	at: #warn
	for: Logger default with: nil

    "Created: / 27-09-2007 / 07:56:54 / janfrog"
! !

!Logger methodsFor:'logging'!

log: message
    self log: message severity: DEBUG

    "Created: / 15-09-2011 / 10:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 14:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message facility: facility
    self log: message severity: DEBUG facility: facility

    "Created: / 14-09-2011 / 21:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 14:12:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity
    | originator |

    originator := thisContext sender receiver.   
    self log: message severity: severity originator: originator

    "Created: / 15-09-2011 / 10:25:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-08-2014 / 08:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

    self process: (LogMessage
        message: message
        at: severity
        from: originator
        with: attachment)

    "Created: / 14-09-2011 / 21:18:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 15:21:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: message severity: severity originator: originator
    self log: message severity: severity facility: (self facilityOf: originator) originator: originator

    "Created: / 15-09-2011 / 10:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2013 / 11:20:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'logging - obsolete'!

log: messageString at: severitySymbol
    "Log the given message at the given severity. To be called directly as the
    originator object is obtained from the message context."

    <resource: #obsolete>

    self
	log: messageString
	at: severitySymbol
	for: thisContext sender receiver
	with: nil

    "Modified: / 15-09-2011 / 10:32:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: messageString at: severitySymbol for: originatorObject
    "Log the given message at the given severity. Set message originator."

    <resource: #obsolete>

    self
	log: messageString
	at: severitySymbol
	for: originatorObject
	with: nil

    "Modified: / 15-09-2011 / 10:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: messageString at: severitySymbol for: originatorObject with: attachedObject

    <resource: #obsolete>

    self log: messageString severity: severitySymbol facility: nil originator: originatorObject attachment: attachedObject

    "Modified: / 15-09-2011 / 10:32:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: messageString at: severitySymbol with: attachment
    "Log the given message at the given severity. To be called directly as the
    originator object is obtained from the message context."

    <resource: #obsolete>

    self
	log: messageString
	at: severitySymbol
	for: thisContext sender receiver
	with: attachment

    "Created: / 01-09-2011 / 13:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'logging - utils'!

debug: message
    self log: message severity: DEBUG

    "Modified: / 22-09-2014 / 15:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: format with: arg1
    self log: (format bindWith: arg1) severity: DEBUG

    "Modified: / 22-09-2014 / 15:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: DEBUG

    "Modified: / 22-09-2014 / 15:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: DEBUG

    "Modified: / 22-09-2014 / 15:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: message
    self log: message severity: ENTER

    "Modified: / 22-09-2014 / 15:18:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: format with: arg1
    self log: (format bindWith: arg1) severity: ENTER

    "Modified: / 22-09-2014 / 15:21:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: ENTER

    "Modified: / 22-09-2014 / 15:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: ENTER

    "Modified: / 22-09-2014 / 15:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: message
    self log: message severity: ERROR

    "Modified: / 22-09-2014 / 15:20:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: format with: arg1
    self log: (format bindWith: arg1) severity: ERROR

    "Modified: / 22-09-2014 / 15:20:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: ERROR

    "Modified: / 22-09-2014 / 15:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: ERROR

    "Modified: / 22-09-2014 / 15:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: message
    self log: message severity: FATAL

    "Modified: / 22-09-2014 / 15:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: format with: arg1
    self log: (format bindWith: arg1) severity: FATAL

    "Modified: / 22-09-2014 / 15:20:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: FATAL

    "Modified: / 22-09-2014 / 15:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fatal: format with: arg1 with: arg2 with:arg3       
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: FATAL

    "Modified: / 22-09-2014 / 15:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: message
    self log: message severity: INFO

    "Modified: / 22-09-2014 / 15:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: format with: arg1
    self log: (format bindWith: arg1) severity: INFO

    "Modified: / 22-09-2014 / 15:20:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: INFO

    "Modified: / 22-09-2014 / 15:20:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: INFO

    "Modified: / 22-09-2014 / 15:20:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: message
    self log: message severity: LEAVE

    "Modified: / 22-09-2014 / 15:20:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: format with: arg1
    self log: (format bindWith: arg1) severity: LEAVE

    "Modified: / 22-09-2014 / 15:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: LEAVE

    "Modified: / 22-09-2014 / 15:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leave: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: LEAVE

    "Modified: / 22-09-2014 / 15:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: message
    self log: message severity: TRACE0

    "Modified: / 22-09-2014 / 15:20:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: format with: arg1
    self log: (format bindWith: arg1) severity: TRACE0

    "Modified: / 22-09-2014 / 15:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: TRACE0

    "Modified: / 22-09-2014 / 15:20:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace0: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE0

    "Modified: / 22-09-2014 / 15:20:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: message
    self log: message severity: TRACE1

    "Modified: / 22-09-2014 / 15:20:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: format with: arg1
    self log: (format bindWith: arg1) severity: TRACE1

    "Modified: / 22-09-2014 / 15:20:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: TRACE1

    "Modified: / 22-09-2014 / 15:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace1: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE1

    "Modified: / 22-09-2014 / 15:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: message
    self log: message severity: TRACE2

    "Modified: / 22-09-2014 / 15:19:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: format with: arg1
    self log: (format bindWith: arg1) severity: TRACE2

    "Modified: / 22-09-2014 / 15:19:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: TRACE2

    "Modified: / 22-09-2014 / 15:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace2: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE2

    "Modified: / 22-09-2014 / 15:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: message
    self log: message severity: TRACE3

    "Modified: / 22-09-2014 / 15:19:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: format with: arg1
    self log: (format bindWith: arg1) severity: TRACE3

    "Modified: / 22-09-2014 / 15:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: TRACE3

    "Modified: / 22-09-2014 / 15:19:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace3: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE3

    "Modified: / 22-09-2014 / 15:19:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: message
    self log: message severity: TRACE

    "Modified: / 22-09-2014 / 15:19:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: format with: arg1
    self log: (format bindWith: arg1) severity: TRACE

    "Modified: / 22-09-2014 / 15:19:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: TRACE

    "Modified: / 22-09-2014 / 15:19:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: TRACE

    "Modified: / 22-09-2014 / 15:19:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: message
    self log: message severity: WARNING

    "Modified: / 22-09-2014 / 15:19:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: format with: arg1
    self log: (format bindWith: arg1) severity: WARNING

    "Modified: / 22-09-2014 / 15:19:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: format with: arg1 with: arg2
    self log: (format bindWith: arg1 with: arg2) severity: WARNING

    "Modified: / 22-09-2014 / 15:19:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: format with: arg1 with: arg2 with:arg3
    self log: (format bindWith: arg1 with: arg2 with:arg3) severity: WARNING

    "Modified: / 22-09-2014 / 15:19:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Logger methodsFor:'private'!

facilityFor: aSymbol

    ^facilities
	at: aSymbol
	ifAbsent: [facilities
	    at: self systemFacilityName
	    ifAbsent: [self error: 'System logging facility undefined, something goes wrong...']]
!

systemFacilityName
    ^ self class systemFacilityName
! !

!Logger methodsFor:'processing'!

commit: severitySymbol

    self
	commit: severitySymbol
	for: thisContext sender receiver
!

commit: severitySymbol for: originatorObject

    (self facilityFor: originatorObject logFacility) commitSeverity: severitySymbol
!

process: aLogMessage

    (self facilityFor: aLogMessage facility) log: aLogMessage

    "Created: / 15-09-2011 / 10:28:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset: severitySymbol

    self
	reset: severitySymbol
	for: thisContext sender receiver
!

reset: severitySymbol for: originatorObject

    (self facilityFor: originatorObject logFacility) resetSeverity: severitySymbol
! !

!Logger methodsFor:'queries'!

allFacilities

    ^facilities keys
!

allSeverities

    ^facilities
	inject: Set new
	into: [:set :facility | set addAll: facility levels keys; yourself]
!

facilityNameFor: aLogFacility

    ^facilities
	keyAtIdentityValue: aLogFacility
	ifAbsent: ['unknown']
!

facilityOf: originator

    ^originator class
	perform: #logFacility
	ifNotUnderstood: [self class systemFacilityName]

    "
	Logger facilityOf: Object
	Logger facilityOf: Expecco::Browser
    "

    "Created: / 15-09-2011 / 10:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usesTransport: aLogTransport
    "Answer whether the given transport is in use by some facility
    or multiplex transport. Used to notify the user when removing
    transports."

    ^((self class transports select: [:e | e isMultiplexTransport])
	anySatisfy: [:e | e transports includes: aLogTransport])
	or: [facilities anySatisfy: [:e | e levels includes: aLogTransport]]

    "Modified: / 05-05-2005 / 14:28:47 / masca"
! !

!Logger methodsFor:'utilities'!

configurationString
    "Answer a string that, when evaluated, configures the Logger and brings
    it to the same state as it's now."

    | config |
    config := String new writeStream.
    self storeConfigurationOn: config.
    ^config contents

    "Created: / 05-05-2005 / 15:27:16 / masca"
    "Modified: / 05-05-2005 / 16:47:44 / masca"
!

storeConfigurationOn: aStream
    "The contents of the stream will, when evaluated, configure the Logger and bring
    it to the same state as it's now."

    | transports |
    transports := Dictionary new.

    self class transports do: [:e | transports at: e put: ('t' , e name select: [:c | c isLetter])].
    aStream nextPutAll: '| '.
    transports do: [:e | aStream nextPutAll: e] separatedBy: [aStream space].
    aStream nextPutAll: ' facility |'; cr.

    aStream nextPutAll: 'Logger flushLogger.'; cr; cr.

    transports keysAndValuesDo: [:transport :variable |
	aStream
	    nextPutAll: variable;
	    nextPutAll: ' := ';
	    nextPutAll: transport class name;
	    space;
	    nextPutAll: (transport class isSingleton ifTrue: ['default'] ifFalse: ['new']);
	    nextPut: $.; cr.
	transport storeConfigurationOf: variable on: aStream.
	aStream
	    nextPutAll: 'Logger addTransport: ';
	    nextPutAll: variable;
	    nextPut: $.; cr; cr.
    ].

    self facilities keysAndValuesDo: [:name :facility |
	aStream
	    nextPutAll: 'facility := LogFacility new.';
	    cr.
	facility levels keysAndValuesDo: [:severity :transport |
	    aStream
		nextPutAll: 'facility for: #';
		nextPutAll: severity printString;
		nextPutAll: ' use: ';
		nextPutAll: (transports at: transport ifAbsent: ['Logger defaultTransport']);
		nextPut: $.; cr
	].
	facility colors keysAndValuesDo: [:severity :color |
	    color ifNotNil: [
		aStream
		    nextPutAll: 'facility for: #';
		    nextPutAll: severity printString;
		    nextPutAll: ' useColor: (Color red: ';
		    nextPutAll: color red printString;
		    nextPutAll: ' green: ';
		    nextPutAll: color green printString;
		    nextPutAll: ' blue: ';
		    nextPutAll: color blue printString;
		    nextPutAll: ').'; cr
	]].
	aStream
	    nextPutAll: 'Logger default addFacility: facility as: #';
	    nextPutAll: name printString;
	    nextPut: $.; cr; cr.
    ].

    aStream nextPut: $!!; cr

    "Created: / 05-05-2005 / 16:45:50 / masca"
    "Modified: / 02-06-2005 / 15:54:55 / masca"
! !

!Logger class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__Logger.st,v 1.16 2018-02-24 22:47:37 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__Logger.st,v 1.16 2018-02-24 22:47:37 stefan Exp $'
!

version_SVN
    ^ '$Id: Loggia__Logger.st,v 1.16 2018-02-24 22:47:37 stefan Exp $'
! !


Logger initialize!
