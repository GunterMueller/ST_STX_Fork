"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAContainerTest subclass:#MAPriorityContainerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAPriorityContainerTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAPriorityContainerTest methodsFor:'private'!

actualClass
	^ MAPriorityContainer
! !

!MAPriorityContainerTest methodsFor:'testing-moving'!

testMoveDown
	self should: [ super testMoveDown ] raise: Error
!

testMoveUp
	self should: [ super testMoveUp ] raise: Error
! !

!MAPriorityContainerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAPriorityContainerTest.st,v 1.1 2009-07-29 15:17:15 cg Exp $'
! !
