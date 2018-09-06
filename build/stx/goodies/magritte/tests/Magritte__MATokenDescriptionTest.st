"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAReferenceDescriptionTest subclass:#MATokenDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MATokenDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATokenDescriptionTest methodsFor:'private'!

actualClass
	^ MATokenDescription
!

includedInstance
	^ #( 'foo' 'bar' )
! !

!MATokenDescriptionTest methodsFor:'testing-strings'!

testFromStringInvalid
	"There is no invalid string input."
! !

!MATokenDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MATokenDescriptionTest.st,v 1.1 2009-07-29 15:19:03 cg Exp $'
! !
