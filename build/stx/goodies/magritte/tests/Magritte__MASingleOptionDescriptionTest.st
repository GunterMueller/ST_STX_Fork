"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAOptionDescriptionTest subclass:#MASingleOptionDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MASingleOptionDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MASingleOptionDescriptionTest methodsFor:'private'!

actualClass
	^ MASingleOptionDescription
!

includedInstance
	^ self optionInstances first
! !

!MASingleOptionDescriptionTest methodsFor:'testing'!

testOptionsAndLabelsFromString
	self description 
		undefined: 'void';
		optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two').

	self assert: (self description fromString: 'void') isNil.
	self assert: (self description fromString: 'one') = 1.
	self assert: (self description fromString: 'two') = 2
!

testOptionsAndLabelsToString
	self description 
		undefined: 'void';
		optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two').

	self assert: (self description toString: nil) = 'void'.
	self assert: (self description toString: 1) = 'one'.
	self assert: (self description toString: 2) = 'two'.
	self assert: (self description toString: 3) = '3'
! !

!MASingleOptionDescriptionTest methodsFor:'testing-accessing'!

testAllOptionsOptional
	self description beOptional; beSorted; options: #( c b a ).
	self assert: self description allOptions = #( nil a b c ).

	self description beOptional; beUnsorted; options: #( c b a ).
	self assert: self description allOptions = #( nil c b a )
!

testAllOptionsWithExtensible
	self description beRequired; beUnsorted; beLimited; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( c d a ).

	self description beRequired; beUnsorted; beExtensible; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( c d a b ).

	self description beRequired; beSorted; beLimited; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( a c d ).

	self description beRequired; beSorted; beExtensible; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( a b c d )
!

testAllOptionsWithOptional
	self description beOptional; beSorted; beExtensible; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( nil a b c d ).

	self description beOptional; beSorted; beLimited; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( nil a c d ).

	self description beOptional; beUnsorted; beExtensible; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( nil c d a b ).

	self description beOptional; beUnsorted; beLimited; options: #( c d a ).
	self assert: (self description allOptionsWith: #b) = #( nil c d a )
! !

!MASingleOptionDescriptionTest methodsFor:'testing-properties'!

testExtensible
	self description beExtensible.
	self assert: self description isExtensible.
	self assert: self description extensible.

	self description beLimited.
	self deny: self description isExtensible.
	self deny: self description extensible
!

testGroupBy
	self deny: self description isGrouped.
	self description groupBy: #grouping.
	self assert: self description isGrouped.
!

testGroupOf
	self assert: MADateDescription grouping = 'Magnitude'.
! !

!MASingleOptionDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MASingleOptionDescriptionTest.st,v 1.1 2009-07-29 15:18:38 cg Exp $'
! !
