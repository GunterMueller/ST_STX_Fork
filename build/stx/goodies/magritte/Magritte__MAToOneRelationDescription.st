"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MARelationDescription subclass:#MAToOneRelationDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAToOneRelationDescription comment:'I am a description of an one-to-one relationship.'
!



!MAToOneRelationDescription class methodsFor:'accessing'!

label
	^ '1:1 Relation'
! !

!MAToOneRelationDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAToOneRelationDescription methodsFor:'validating'!

validateKind: anObject
	super validateKind: anObject.
	(self classes anySatisfy: [ :class | anObject species = class ])
		ifFalse: [ MAKindError description: self signal: self kindErrorMessage ]
! !

!MAToOneRelationDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitToOneRelationDescription: self
! !

!MAToOneRelationDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAToOneRelationDescription.st,v 1.2 2009-08-14 20:08:16 cg Exp $'
! !
