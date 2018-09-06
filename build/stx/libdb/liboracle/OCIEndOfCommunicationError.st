"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIError subclass:#OCIEndOfCommunicationError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!


!OCIEndOfCommunicationError methodsFor:'queries'!

isEndOfFileCommunication
"
test returns true, because instance is an OCIEndOfFileCommunicationSignal

<return: Boolean>
"
    ^true




! !

!OCIEndOfCommunicationError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIEndOfCommunicationError.st,v 1.3 2003-12-17 12:27:15 cg Exp $'
! !
