"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqResource subclass:#ZmqPoller
	instanceVariableNames:'pollItemStructure positionToSocketLookup socketToPositionLookup
		pollItemExternalAddress zmqApi pollItemClass'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

!ZmqPoller class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!ZmqPoller class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ZmqPoller methodsFor:'as yet unclassified'!

context
	^ ZmqContext current.
!

finalize
	pollItemExternalAddress ifNotNil:[pollItemExternalAddress free].
	super finalize.
!

initialize 
	super initialize.
	self initializeLookups.
	self context register: self.
!

initializeLookups
        positionToSocketLookup ifNotNil: [ 
            positionToSocketLookup removeAll 
        ] ifNil: [ 
            positionToSocketLookup := Dictionary new 
        ].
        
        socketToPositionLookup ifNotNil: [ 
            socketToPositionLookup removeAll 
        ] ifNil: [ 
            socketToPositionLookup := IdentityDictionary new 
        ]
!

poll
	^self pollNonBlocking.
!

pollEventsAndSocketsDo: aBlockClosure
	^ self pollFor: 0 milliSecond asDelay withEventsAndSocketsDo: aBlockClosure.
!

pollFor: aDuration 
	^ self poll.
!

pollFor:aDuration withEventsAndSocketsDo:aBlockClosure 
    ^ self 
        critical:[
            |events eventsLeft position|

            position := 0.
            events := self pollFor:aDuration.
            eventsLeft := events.
            [
                eventsLeft > 0 and:[ position <= positionToSocketLookup size ]
            ] whileTrue:[
                |item|

                position := position + 1.
                item := self pollItemAt:position.
                item ifHasEvents:[
                    eventsLeft := eventsLeft - 1.
                    aBlockClosure value:item value:(self socketAt:position)
                ]
            ].
            events
        ].
!

pollInSocket: aZmqSocket
        | position newPollItemStructure item |
        self
                critical: [ 
                        position := self
                                positionOfSocket: aZmqSocket
                                ifAbsent: [ socketToPositionLookup at: aZmqSocket put: socketToPositionLookup size + 1 ].
                        positionToSocketLookup at: position put: aZmqSocket.
                        newPollItemStructure := ExternalAddress allocate: self pollItemClass byteSize * positionToSocketLookup size.
                        pollItemExternalAddress
                                ifNotNil: [ 
                                        newPollItemStructure
                                                structAt: 1
                                                put: pollItemExternalAddress
                                                length: self pollItemClass byteSize * (positionToSocketLookup size - 1).
                                        pollItemExternalAddress free ].
                        pollItemExternalAddress := newPollItemStructure.
                        item := self pollItemAt: position.
                        item zmqSocket: aZmqSocket socketPointer.
                        item events: ZmqApiConstants zmqPollIn.
                        pollItemStructure := ExternalStructure fromHandle: pollItemExternalAddress ]
!

pollItemAt: anInteger
    " Creates struct* for poll item at given position. Positions start from 1."

    Smalltalk isSmalltalkX ifTrue:[    
        "/ cg: warning: this creates a pointer into an external heap data-block;
        "/ the block is gc'd, thus the returned pointer becomes invalid, as soon as the outer
        "/ is freed. (and there is no verification!!)
        "/ so we return a protected pointer, and you have to really really know what you're doing here
        ^ self pollItemClass 
                address:(pollItemExternalAddress address + ((anInteger - 1) * self pollItemClass sizeof))
                size:self pollItemClass sizeof    
    ] ifFalse:[        
        ^ self pollItemClass fromHandle: pollItemExternalAddress + ((anInteger - 1) * self pollItemClass byteSize).
    ].
!

pollItemClass
    pollItemClass isNil ifTrue:[
        pollItemClass := self zmqApi pollItemClass.
    ].
    ^ pollItemClass
!

pollNonBlocking
        ^ self
                critical: [ 
                        |api events|

                        api := self zmqApi.
                        events := api
                                executeApiCall: [ api apiZmqPollSockets: pollItemStructure ofLenght: positionToSocketLookup size withTimeout: 0 ].
                        events < 0 ifTrue: [ 
                            self logError: 'Poller encountered error: ' , api lastZmqError 
                        ].     
                        "/ Transcript show:'Polled ', updated asString,' items updated'.
                        events ]
!

pollSocket: aZmqSocket eventMask: events
    ^ self
        critical: [ 
            | position newPollItemStructure item |

            position := self
                    positionOfSocket: aZmqSocket
                    ifAbsent: [ socketToPositionLookup at: aZmqSocket put: socketToPositionLookup size + 1 ].
            positionToSocketLookup at: position put: aZmqSocket.
            Smalltalk isSmalltalkX ifTrue:[
                newPollItemStructure := ExternalStructure new: self pollItemClass sizeof * positionToSocketLookup size.
            ] ifFalse:[    
                newPollItemStructure := ExternalAddress allocate: self pollItemClass byteSize * positionToSocketLookup size.
            ].
            pollItemExternalAddress ifNotNil: [ 
                Smalltalk isSmalltalkX ifTrue:[
                    newPollItemStructure replaceBytesFrom:1 to:(self pollItemClass byteSize * (positionToSocketLookup size - 1))
                                         with:pollItemExternalAddress startingAt:1.    
                ] ifFalse:[    
                    newPollItemStructure
                            structAt: 1
                            put: pollItemExternalAddress
                            length: self pollItemClass byteSize * (positionToSocketLookup size - 1).
                ].
                pollItemExternalAddress free 
            ].
            pollItemExternalAddress := newPollItemStructure.
            item := self pollItemAt: position.
            item zmqSocket: aZmqSocket socketPointer.
            item events: events.
            item filedescriptor: 0.
            Smalltalk isSmalltalkX ifTrue:[
                pollItemStructure := ExternalStructure address: pollItemExternalAddress.
                pollItemStructure size:pollItemExternalAddress size.
            ] ifFalse:[    
                pollItemStructure := ExternalStructure fromHandle: pollItemExternalAddress.
            ].
            position 
        ]
!

pollSocket: aZmqSocket forEvents: aZmqEventFilter
        ^ self critical: [ 
            self pollSocket: aZmqSocket eventMask: aZmqEventFilter eventMask 
        ]
!

positionOfSocket: aZmqSocket
	^ self positionOfSocket: aZmqSocket ifAbsent: [ Error signal: 'Unkown socket' ]
!

positionOfSocket: aZmqSocket ifAbsent: aBlock
        ^ self critical: [ socketToPositionLookup at: aZmqSocket ifAbsent: aBlock ]
!

rebuildPollItemStructure
        | item |
        self logDebug:'Rebuilding poll item structure for ', socketToPositionLookup size asString, ' sockets.'.
        pollItemExternalAddress
                ifNotNil: [ 
                        [ pollItemExternalAddress free ]
                                on: PrimitiveFailed
                                do: [ 
                                        "Address was faulty because of process just started"
                                         ] ].
        pollItemExternalAddress := ExternalAddress allocate: self pollItemClass byteSize * positionToSocketLookup size.
        positionToSocketLookup
                keysAndValuesDo: [ :position :socket | 
                        item := self pollItemAt: position.
                        item zmqSocket: socket socketPointer.
                        item events: ZmqApiConstants zmqPollIn.
                        pollItemStructure := ExternalStructure fromHandle: pollItemExternalAddress ]
!

reinitialize
	self rebuildPollItemStructure.
	super reinitialize.
!

removeSocket: aZmqSocket
	| sockets |
	self
		critical: [ 
			| oldSockets |
			oldSockets := socketToPositionLookup keys.
			sockets := oldSockets copyWithout: aZmqSocket.
			self logDebug: 'Before removal ', oldSockets size asString, ' after removal ', sockets size asString,'.'.
			self initializeLookups.
			sockets asArray
				keysAndValuesDo: [ :i :v | 
					socketToPositionLookup at: v put: i.
					positionToSocketLookup at: i put: v.
					 ].
				self rebuildPollItemStructure.
				 ]
!

size
        ^ self critical: [ positionToSocketLookup size ]
!

socketAt: anInteger
        ^ self critical: [ 
            self socketAt: anInteger ifAbsent: [ Error signal: 'Unkown socket' ] 
        ]
!

socketAt: anInteger ifAbsent: aBlock
        ^ self critical: [ positionToSocketLookup at: anInteger ifAbsent: aBlock ]
!

zmqApi
    zmqApi isNil ifTrue:[
        zmqApi := self context zmqApi.
    ].
    ^ zmqApi
! !

!ZmqPoller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPoller.st,v 1.5 2018-05-11 01:36:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPoller.st,v 1.5 2018-05-11 01:36:17 cg Exp $'
! !

