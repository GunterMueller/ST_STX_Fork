"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAStringDescription subclass:#MAPasswordDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAPasswordDescription comment:'I am a description of a password string, possible values are instances of ==String==. My visual representation could be a password field, where there are stars printed instead of the characters the user enters.'
!




!MAPasswordDescription class methodsFor:'accessing'!

label
	^ 'Password'
! !

!MAPasswordDescription methodsFor:'operators'!

obfuscated: anObject
	^ String new: (self toString: anObject) size withAll: $*
! !

!MAPasswordDescription methodsFor:'testing'!

isObfuscated: anObject
	^ anObject notNil
		and: [ anObject isString
		and: [ anObject isEmpty not
		and: [ anObject allSatisfy: [ :each | each = $* ] ] ] ]
!

isSortable
	^ false
! !

!MAPasswordDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitPasswordDescription: self
! !

!MAPasswordDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAPasswordDescription.st,v 1.3 2009-08-14 20:09:10 cg Exp $'
! !
