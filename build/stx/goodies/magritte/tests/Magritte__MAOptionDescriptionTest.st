"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAReferenceDescriptionTest subclass:#MAOptionDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAOptionDescriptionTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAOptionDescriptionTest methodsFor:'private'!

actualClass
	^ MAOptionDescription
!

optionInstances
	^ Array with: 'foo' with: 'bar' with: 'zork'
! !

!MAOptionDescriptionTest methodsFor:'running'!

setUp
	super setUp.
	self description options: self optionInstances
! !

!MAOptionDescriptionTest methodsFor:'testing'!

testReferencePrinting
	self description reference: MAStringDescription new.
	self assert: (self description labelForOption: 1) = '1'.
	self assert: (self description labelForOption: 1 @ 2) = '1@2'.
	self assert: (self description labelForOption: 1 -> 2) = '1->2'
! !

!MAOptionDescriptionTest methodsFor:'testing-accessing'!

testAllOptions
	self description beRequired; beSorted; options: #( c b a ).
	self assert: self description allOptions = #( a b c ).

	self description beRequired; beUnsorted; options: #( c b a ).
	self assert: self description allOptions = #( c b a )
!

testAllOptionsWithExisting
	self description beRequired; options: #( a b c ).
	self assert: (self description allOptionsWith: #a) = #( a b c )
!

testAllOptionsWithNil
	self description beRequired; options: #( a b c ).
	self assert: (self description allOptionsWith: nil) = #( a b c )
!

testOptions
	self description options: #( a b c ).
	self assert: self description options = #( a b c )
!

testOptionsTextual
	self description optionsTextual: 'a' , (String with: Character cr) , 'b'.
	self assert: self description optionsTextual = ('a' , (String with: Character cr) , 'b').
	self assert: self description options = #( 'a' 'b' )
! !

!MAOptionDescriptionTest methodsFor:'testing-copying'!

testCopyOptions
	self deny: self description copy options == self description options.
	self assert: self description copy options = self description options
! !

!MAOptionDescriptionTest methodsFor:'testing-properties'!

testSorted
	self description beSorted.
	self assert: self description isSorted.
	self assert: self description sorted.

	self description beUnsorted.
	self deny: self description isSorted.
	self deny: self description sorted
! !

!MAOptionDescriptionTest methodsFor:'testing-strings'!

testFromStringInvalid
	"There is no invalid string input."
!

testOptionsAndLabels
	self description reference: MANumberDescription new.
	self assert: (self description labelForOption: 1) = '1'.

	self description optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two').
	self assert: (self description labelForOption: 1) = 'one'.
	self assert: (self description labelForOption: 2) = 'two'.
	self assert: (self description labelForOption: 3) = '3'
! !

!MAOptionDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAOptionDescriptionTest.st,v 1.1 2009-07-29 15:20:54 cg Exp $'
! !
