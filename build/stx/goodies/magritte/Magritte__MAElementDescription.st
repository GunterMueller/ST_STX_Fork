"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MADescription subclass:#MAElementDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAElementDescription comment:'I am an abstract description for all basic description types.'
!



!MAElementDescription methodsFor:'*magritte-seaside-accessing'!

checkboxLabel
	^ self propertyAt: #checkboxLabel ifAbsent: [ self label ]
!

checkboxLabel: aString
	self propertyAt: #checkboxLabel put: aString
! !

!MAElementDescription methodsFor:'accessing'!

default
	^ self propertyAt: #default ifAbsent: [ self class defaultDefault ]
!

default: anObject
	self propertyAt: #default put: anObject
! !

!MAElementDescription methodsFor:'converting'!

asContainer
	^ MAContainer with: self
! !

!MAElementDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitElementDescription: self
! !

!MAElementDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAElementDescription.st,v 1.4 2009-08-14 20:08:38 cg Exp $'
! !
