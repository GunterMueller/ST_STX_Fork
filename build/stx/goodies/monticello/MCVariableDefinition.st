"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVariableDefinition
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCVariableDefinition class methodsFor:'as yet unclassified'!

name: aString
	^ self new name: aString
	
! !

!MCVariableDefinition methodsFor:'accessing'!

name
	^ name
!

name: aString
	name := aString
! !

!MCVariableDefinition methodsFor:'comparing'!

= other
	^ (self species = other species)
		and: [self name = other name]
!

hash
	^ name hash
! !

!MCVariableDefinition methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; nextPutAll: self name; nextPut: $)
! !

!MCVariableDefinition methodsFor:'testing'!

isClassInstanceVariable
	^ false
!

isClassInstanceVariableDefinition
	^ false
!

isClassVariable
	^ false
!

isInstanceVariable
	^ false
!

isInstanceVariableDefinition
	^ false
!

isPoolImport
	^ false
! !

!MCVariableDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVariableDefinition.st,v 1.5 2013-01-18 13:02:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVariableDefinition.st,v 1.5 2013-01-18 13:02:44 cg Exp $'
!

version_SVN
    ^ '§Id: MCVariableDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

