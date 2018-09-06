"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkRoot subclass:#Thunk
	instanceVariableNames:'upThunk downThunk headerMakerThunk doesPop doesPush'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

Thunk comment:''
!


!Thunk class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Thunk methodsFor:'control'!

close
	"Perform any additional actions when stopping the protocol (i.e., just after data transfer ends)."
!

isConnected

	^ true
!

run
	"Perform any additional actions when starting the protocol running (i.e., just before data transfer begins)."
!

shutdown
! !

!Thunk methodsFor:'initialize-release'!

initialize

	self doesPop: true.
	self upThunk: [:frame | frame payload ].

	self doesPush: true.
	self headerMakerThunk: [:frame | frame header ].
	self downThunk: [:frame | frame asByteArray ].
! !

!Thunk methodsFor:'thunk - accessing'!

doesPop

	^ doesPop
!

doesPush

	^ doesPush
!

downThunk

	^ downThunk
!

headerMakerThunk

	^ headerMakerThunk
!

upThunk

	^ upThunk
! !

!Thunk methodsFor:'thunk - mutating'!

doesPop: anObject

	doesPop := anObject
!

doesPush: anObject

	doesPush := anObject
!

downThunk: anObject

	downThunk := anObject
!

headerMakerThunk: anObject

	headerMakerThunk := anObject
!

upThunk: anObject

	upThunk := anObject
! !

!Thunk class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Thunk.st,v 1.2 2018-05-14 00:39:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Thunk.st,v 1.2 2018-05-14 00:39:22 cg Exp $'
! !

