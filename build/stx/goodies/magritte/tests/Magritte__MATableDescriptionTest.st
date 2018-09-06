"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAReferenceDescriptionTest subclass:#MATableDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MATableDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATableDescriptionTest methodsFor:'private'!

actualClass
	^ MATableDescription
!

includedInstance
	^ MATableModel rows: 3 columns: 3 contents: #( '1' '2' '3' '2' '4' '6' '3' '6' '9' )
!

shouldSkipStringTests
	^ true
! !

!MATableDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MATableDescriptionTest.st,v 1.1 2009-07-29 15:23:51 cg Exp $'
! !
