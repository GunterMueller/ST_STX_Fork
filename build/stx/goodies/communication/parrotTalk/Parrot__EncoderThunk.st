"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkRoot subclass:#EncoderThunk
	instanceVariableNames:'encoderName materializeThunk serializeThunk'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

EncoderThunk comment:''
!


!EncoderThunk class methodsFor:'instance creation'!

newName: short serializeThunk: serialThunk materializeThunk: materialThunk

	^ self new
		initializeName: short 
		serializeThunk: serialThunk 
		materializeThunk: materialThunk;
	yourself
! !

!EncoderThunk methodsFor:'accessing'!

encoderName

	^ encoderName
!

materializeThunk

	^ materializeThunk
!

serializeThunk

	^ serializeThunk
! !

!EncoderThunk methodsFor:'initialize-release'!

initializeName: short serializeThunk: serialThunk materializeThunk: materialThunk

	encoderName := short.
	serializeThunk := serialThunk.
	materializeThunk := materialThunk.
! !

!EncoderThunk methodsFor:'stack'!

downcall: frame

	frame payload: (serializeThunk value: frame payload).
	frame header: Encoded new.
!

upcall: frame

	frame payload: (materializeThunk value: frame payload).
	frame header: RawData new.
! !

!EncoderThunk methodsFor:'thunk'!

makeThunkOnFarKey: farKey

	^ self copy
! !

!EncoderThunk class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__EncoderThunk.st,v 1.1 2018-05-14 00:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__EncoderThunk.st,v 1.1 2018-05-14 00:18:47 cg Exp $'
! !

