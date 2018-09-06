"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAStringDescriptionTest subclass:#MAPasswordDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAPasswordDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAPasswordDescriptionTest methodsFor:'private'!

actualClass
	^ MAPasswordDescription
! !

!MAPasswordDescriptionTest methodsFor:'testing'!

testIsObfuscated
	self deny: (self description isObfuscated: '').
	self deny: (self description isObfuscated: nil).
	self deny: (self description isObfuscated: 123).
	self deny: (self description isObfuscated: '**1').
	self assert: (self description isObfuscated:  '******')
!

testObfuscated
	self assert: (self description obfuscated: nil) = ''.
	self assert: (self description obfuscated: 'zork') = '****'.
	self assert: (self description obfuscated: 'foobar') = '******'
! !

!MAPasswordDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAPasswordDescriptionTest.st,v 1.1 2009-07-29 15:20:08 cg Exp $'
! !
