"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiPollItemV4
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!


!ZmqApiPollItemV4 class methodsFor:'field definition'!

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

!ZmqApiPollItemV4 methodsFor:'accessing'!

events
        "This method was automatically generated"
        ^ self "handle" unsignedShortAt: 9
!

events: anObject
        "This method was automatically generated"
        self "handle"  unsignedShortAt: 9 put: anObject
!

filedescriptor
        "This method was automatically generated"
        ^self "handle"  unsignedLongAt: 5
!

filedescriptor: anObject
        "This method was automatically generated"
        self "handle"  unsignedLongAt: 5 put: anObject
!

revents
        "This method was automatically generated"
        ^self "handle"  unsignedShortAt: 11
!

revents: anObject
        "This method was automatically generated"
        self "handle"  unsignedShortAt: 11 put: anObject
!

zmqSocket
        "This method was automatically generated"
        ^ZmqApiSocket fromHandle: (self "handle"  pointerAt: 1)
!

zmqSocket: anObject
        "This method was automatically generated"
        self "handle"  pointerAt: 1 put: (anObject address) "getHandle".
! !

!ZmqApiPollItemV4 methodsFor:'as yet unclassified'!

isPollIn
	^ self hasEventMask: ZmqPollIn eventMask.
!

isPollOut
	^ self hasEventMask: ZmqPollOut eventMask.
! !

!ZmqApiPollItemV4 methodsFor:'testing'!

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

!ZmqApiPollItemV4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiPollItemV4.st,v 1.2 2018-05-11 07:56:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiPollItemV4.st,v 1.2 2018-05-11 07:56:08 cg Exp $'
! !

