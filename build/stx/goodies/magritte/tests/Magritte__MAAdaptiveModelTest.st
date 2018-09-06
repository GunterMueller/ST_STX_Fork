"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MAAdaptiveModelTest
	instanceVariableNames:'scaffolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Models'
!


!MAAdaptiveModelTest methodsFor:'accessing'!

descriptions
	^ self scaffolder description children
!

scaffolder
	^ scaffolder
! !

!MAAdaptiveModelTest methodsFor:'running'!

setUp
	scaffolder := MAAdaptiveModel new.
	scaffolder description
		add: MAStringDescription new;
		add: MANumberDescription new.
	scaffolder write: 'foo' using: self descriptions first.
	scaffolder write: 123 using: self descriptions second
! !

!MAAdaptiveModelTest methodsFor:'testing'!

testRead
	self assert: (self scaffolder readUsing: self descriptions first) = 'foo'.
	self assert: (self scaffolder readUsing: self descriptions second) = 123
!

testWrite
	self scaffolder write: 'bar' using: self descriptions first.
	self scaffolder write: 321 using: self descriptions second.

	self assert: (self scaffolder readUsing: self descriptions first) = 'bar'.
	self assert: (self scaffolder readUsing: self descriptions second) = 321
! !

!MAAdaptiveModelTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAAdaptiveModelTest.st,v 1.1 2009-07-29 15:21:22 cg Exp $'
! !
