"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAToManyRelationDescription subclass:#MAToManyScalarRelationDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAToManyScalarRelationDescription comment:'Like MAToManyRelationDescription but for scalar values.'
!



!MAToManyScalarRelationDescription class methodsFor:'accessing'!

label
	^ '1:m scalar Relation'
! !

!MAToManyScalarRelationDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitToManyScalarRelationDescription: self
! !

!MAToManyScalarRelationDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAToManyScalarRelationDescription.st,v 1.2 2009-08-14 20:07:12 cg Exp $'
! !
