"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

MSTestClasses subclass:#Employee
	instanceVariableNames:'notes manager'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!


!Employee methodsFor:'As yet unclassified'!

manager



	^manager
!

manager: anEmployee



	manager := anEmployee
!

notes



	^notes
!

notes: aString



	notes := aString
! !

!Employee class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/Employee.st,v 1.4 2014-02-17 21:41:53 cg Exp $'
! !
