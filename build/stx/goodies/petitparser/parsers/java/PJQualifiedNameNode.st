"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJNameNode subclass:#PJQualifiedNameNode
	instanceVariableNames:'qualifier simpleName'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJQualifiedNameNode class methodsFor:'instance creation'!

name: aPJSimpleName qualifier: aPJName

	^(self new) simpleName: aPJSimpleName ; qualifier: aPJName; yourself
! !

!PJQualifiedNameNode methodsFor:'accessing'!

fullyQualifiedName
	^ (self qualifier fullyQualifiedName ) , '.' , self simpleName fullyQualifiedName
!

qualifier
	^ qualifier
!

qualifier: anObject
	qualifier := anObject
!

simpleName
	^ simpleName
!

simpleName: anObject
	simpleName := anObject
! !

