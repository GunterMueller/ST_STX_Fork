"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TTransport
	instanceVariableNames:'socket'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Transport'
!


!TTransport methodsFor:'accessing'!

socket
    ^ socket
!

socket:something
    socket := something.
! !

!TTransport methodsFor:'initialization & release'!

close
    socket notNil ifTrue:[
        socket close.
        socket := nil.
    ].
! !

!TTransport methodsFor:'logging'!

log:message
    "
     Transcript showCR:message.
    "
! !

!TTransport methodsFor:'misc'!

isOpen
	self subclassResponsibility
!

open
	self subclassResponsibility
! !

!TTransport methodsFor:'reading'!

read: anInteger
	self subclassResponsibility
!

readAll: anInteger
	^ String streamContents: [:str |
		[str size < anInteger] whileTrue:
			[str nextPutAll: (self read: anInteger - str size)]]
! !

!TTransport methodsFor:'writing'!

flush
	self subclassResponsibility
!

write: aString
	self subclassResponsibility
! !

!TTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TTransport.st,v 1.3 2013-03-25 01:12:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TTransport.st,v 1.3 2013-03-25 01:12:56 cg Exp $'
!

version_MC
    ^ '§stx:goodies/communication/thrift-ClausGittinger.19 67819420-789f-4576-b3ee-7ef1c4e9ce1c 2013-03-25T02:09:44 ClausGittinger§'
! !

