"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAStringDescriptionTest subclass:#MAMemoDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAMemoDescriptionTest methodsFor:'private'!

actualClass
	^ MAMemoDescription
! !

!MAMemoDescriptionTest methodsFor:'testing-properties'!

testLineCount
	self description lineCount: 123.
	self assert: self description lineCount = 123
! !

!MAMemoDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAMemoDescriptionTest.st,v 1.1 2009-07-29 15:23:18 cg Exp $'
! !
