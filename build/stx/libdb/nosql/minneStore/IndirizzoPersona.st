"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSExample subclass:#IndirizzoPersona
	instanceVariableNames:'email note indirizzo'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-GG-Patch'
!

IndirizzoPersona comment:'This class is used for examples and for building a small TelephonBook Application.

Instance Variables:

email   <String>        
note    <String>        
indirizzo       <String>        '
!


!IndirizzoPersona class methodsFor:'inst creation'!

nome: aString numero: anInteger 
	"DEPRECATED!!!!"

	^self new
		name: aString;
		number: anInteger
! !

!IndirizzoPersona methodsFor:'accessing'!

email
	^email.
!

email: aString
	email := aString.
!

indirizzo
	^indirizzo
!

indirizzo: aStr
	indirizzo:= aStr.
!

note
	^note
!

note: aString
	note := aString.
! !

!IndirizzoPersona methodsFor:'printing'!

printOn: aStream
	aStream 
		print: 'IndirizzoPersona';
		nextPut: $< ;
		print: name ;cr;
		print:' Tel. ';
		print: number; cr ;
		print: 'Email '; print: email;cr;
		print:'Via '; print: indirizzo;
		nextPut: $>.
! !

!IndirizzoPersona class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/IndirizzoPersona.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
