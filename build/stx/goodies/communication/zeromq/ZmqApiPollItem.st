"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiPollItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!


!ZmqApiPollItem class methodsFor:'class initialization'!

initialize
    OFFSET_ZMQSOCKET := 1.
    OFFSET_FILEDESCRIPTOR := OFFSET_ZMQSOCKET + ExternalBytes sizeofPointer.
    OFFSET_EVENTS := OFFSET_FILEDESCRIPTOR + ExternalAddress uintSize.
    OFFSET_REVENTS := OFFSET_EVENTS + ExternalAddress ushortSize. 
! !

!ZmqApiPollItem class methodsFor:'field definition'!

fields
        ^#(#(#'zmqSocket' 'ZmqApiSocket*') 
            (#'filedescriptor' 'ulong') 
            (#'events' 'ushort') 
            (#'revents' 'ushort')
        )
!

sizeof
    ^ (ExternalBytes sizeofPointer
        + ExternalAddress ulongSize
        + ExternalAddress ushortSize
        + ExternalAddress ushortSize) nextMultipleOf:ExternalBytes sizeofPointer
    
"/        ^#(#(#'zmqSocket' 'ZmqApiSocket*') 
"/            (#'filedescriptor' 'ulong') 
"/            (#'events' 'ushort') 
"/            (#'revents' 'ushort')
"/        )

    "
     self sizeof
    "
! !

!ZmqApiPollItem methodsFor:'accessing'!

events
        "This method was automatically generated"
        ^ self "handle" unsignedShortAt: OFFSET_EVENTS
!

events: anObject
        "This method was automatically generated"
        self "handle"  unsignedShortAt: OFFSET_EVENTS put: anObject
!

filedescriptor
        "This method was automatically generated"
        ^self "handle"  unsignedLongAt: OFFSET_FILEDESCRIPTOR
!

filedescriptor: anObject
        "This method was automatically generated"
        self "handle"  unsignedLongAt: OFFSET_FILEDESCRIPTOR put: anObject
!

revents
        "This method was automatically generated"
        ^self "handle"  unsignedShortAt: OFFSET_REVENTS
!

revents: anObject
        "This method was automatically generated"
        self "handle"  unsignedShortAt: OFFSET_REVENTS put: anObject
!

zmqSocket
        "This method was automatically generated"
        ^ZmqApiSocket fromHandle: (self "handle"  pointerAt: OFFSET_ZMQSOCKET)
!

zmqSocket: anObject
        "This method was automatically generated"
        self "handle"  pointerAt: OFFSET_ZMQSOCKET put: (anObject address) "getHandle".
! !

!ZmqApiPollItem methodsFor:'as yet unclassified'!

isPollIn
	^ self hasEventMask: ZmqPollIn eventMask.
!

isPollOut
	^ self hasEventMask: ZmqPollOut eventMask.
! !

!ZmqApiPollItem methodsFor:'testing'!

hasEventMask: anInteger
	^(self revents bitAnd: anInteger) = anInteger
!

ifEvent: bitMask occuredDo:  aBlock
	^(self hasEventMask: bitMask) ifTrue: aBlock.
!

ifHasEvents:aBlock
	^self revents > 0 ifTrue: aBlock.
!

ifReadEvent:aBlock
	^self ifEvent: ZmqApiConstants zmqPollIn occuredDo: aBlock.
! !

!ZmqApiPollItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiPollItem.st,v 1.5 2018-05-11 07:56:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiPollItem.st,v 1.5 2018-05-11 07:56:14 cg Exp $'
! !


ZmqApiPollItem initialize!
