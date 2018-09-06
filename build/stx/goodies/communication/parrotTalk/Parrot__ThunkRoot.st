"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#ThunkRoot
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

ThunkRoot comment:''
!


!ThunkRoot methodsFor:'control'!

close
	"Perform any additional actions when stopping the protocol (i.e., just after data transfer ends)."
!

install
	"Perform any additional actions when the protocol is installed."
!

isConnected

	^ true
!

run
	"Perform any additional actions when starting the protocol running (i.e., just before data transfer begins)."
!

shutdown
! !

!ThunkRoot methodsFor:'stack'!

downcall: frame

	self doesPush
		ifTrue: [
			frame payload: (self downThunk value: frame).
			frame header: (self headerMakerThunk value: frame) ]
		ifFalse: [ self downThunk value: frame ]
!

upcall: frame

	self doesPop 
		ifTrue: [	frame readFrom: (self upThunk value: frame) readStream ]
		ifFalse: [ self upThunk value: frame ].
! !

!ThunkRoot methodsFor:'thunk - accessing'!

doesPop
 
	^ false
!

doesPopPayload

	^ false
!

doesPopReplace

	^ false
!

doesPush

	^ false
!

downThunk

	^ [:frame | frame asByteArray ].
!

headerMakerThunk

	^ [:frame | frame header ].
!

pushHeaderThunk

	^ [:frame | frame header ].
!

upThunk

	^ [:frame | frame payload ].
! !

!ThunkRoot class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ThunkRoot.st,v 1.1 2018-05-14 00:17:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ThunkRoot.st,v 1.1 2018-05-14 00:17:46 cg Exp $'
! !

