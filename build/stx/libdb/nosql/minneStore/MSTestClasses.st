"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSTestClasses
	instanceVariableNames:'name number description'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSTestClasses class methodsFor:'As yet unclassified'!

name: aString number: anInteger



	^self new

		name: aString;

		number: anInteger
! !

!MSTestClasses methodsFor:'As yet unclassified'!

description



	^description
!

description: aString



	description := aString
!

name



	^name
!

name: aString



	name := aString
!

number



	^number
!

number: anInteger



	number := anInteger
!

printOn: aStream



	super printOn: aStream.

	aStream 

		nextPut: $( ;

		print: name ;

		space;

		print: number;

		nextPut: $).
! !

!MSTestClasses class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSTestClasses.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
