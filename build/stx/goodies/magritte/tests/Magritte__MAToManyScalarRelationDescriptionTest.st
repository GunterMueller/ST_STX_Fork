"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAToManyRelationDescriptionTest subclass:#MAToManyScalarRelationDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAToManyScalarRelationDescriptionTest methodsFor:'private'!

actualClass
	^ MAToManyScalarRelationDescription
!

includedInstance
	^ Array with: '1' with: '2'
! !

!MAToManyScalarRelationDescriptionTest methodsFor:'running'!

setUp
	super setUp.
	self description
		reference: (MAStringDescription new
			accessor: MANullAccessor new;
			yourself);
		classes: (Array with: String)
! !

!MAToManyScalarRelationDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAToManyScalarRelationDescriptionTest.st,v 1.1 2009-07-29 15:23:08 cg Exp $'
! !
