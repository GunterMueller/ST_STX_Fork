"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkRoot subclass:#ThunkLayer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

ThunkLayer comment:''
!


!ThunkLayer methodsFor:'control'!

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

!ThunkLayer methodsFor:'thunk - accessing'!

doesPop

	^ true
!

doesPush

	^ true
!

headerMakerThunk

	^ [:frame | frame header ].
! !

!ThunkLayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ThunkLayer.st,v 1.1 2018-05-14 00:17:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ThunkLayer.st,v 1.1 2018-05-14 00:17:38 cg Exp $'
! !

