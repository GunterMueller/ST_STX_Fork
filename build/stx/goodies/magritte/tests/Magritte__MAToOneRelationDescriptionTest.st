"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MARelationDescriptionTest subclass:#MAToOneRelationDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAToOneRelationDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAToOneRelationDescriptionTest methodsFor:'private'!

actualClass
	^ MAToOneRelationDescription
!

includedInstance
	^ self addressInstance1
! !

!MAToOneRelationDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAToOneRelationDescriptionTest.st,v 1.1 2009-07-29 15:21:56 cg Exp $'
! !
