"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

Object subclass:#MAMockAddress
	instanceVariableNames:'place street plz'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Mocks'
!


!MAMockAddress class methodsFor:'descriptions'!

descriptionPlace
	^ MAStringDescription new
		accessor: #place;
		label: 'Place';
		yourself
!

descriptionPlz
	^ MANumberDescription new
		accessor: #plz;
		label: 'PLZ';
		yourself
!

descriptionStreet
	^ MAStringDescription new
		accessor: #street;
		label: 'Street';
		yourself
! !

!MAMockAddress class methodsFor:'descriptions-extensions'!

descriptionNilled1
	^ nil
!

descriptionNilled1: aDescription
	^ aDescription beRequired
!

descriptionNilled2
	^ MAStringDescription new
!

descriptionNilled2: aDescription
	^ nil
!

descriptionPlace: aDescription
	^ aDescription beRequired
!

descriptionPlaceOther: aDescription
	^ aDescription beHidden
! !

!MAMockAddress methodsFor:'accessing-generated'!

place
	^ place
!

place: anObject
	place := anObject
!

plz
	^ plz
!

plz: anObject
	plz := anObject
!

street
	^ street
!

street: anObject
	street := anObject
! !

!MAMockAddress methodsFor:'comparing'!

= anObject
	^ self species = anObject species
		and: [ self street = anObject street
		and: [ self plz = anObject plz
		and: [ self place = anObject place ] ] ]
!

hash
	^ self street hash
! !

!MAMockAddress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAMockAddress.st,v 1.1 2009-07-29 15:16:31 cg Exp $'
! !
