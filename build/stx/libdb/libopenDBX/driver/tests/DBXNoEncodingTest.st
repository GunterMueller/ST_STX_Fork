"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXNoEncodingTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Encoding'
!


!DBXNoEncodingTest methodsFor:'as yet unclassified'!

testEncoderFor
	| encoder result string |
	string := String with: (Character value: 1234).
	encoder := DBXNoEncoding new encoderFor: Object new.
	result := encoder convertToSystemString: (String with: (Character value: 1234)).
	self should: [string = result]. 
! !

!DBXNoEncodingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXNoEncodingTest.st,v 1.2 2013-04-15 13:18:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXNoEncodingTest.st,v 1.2 2013-04-15 13:18:45 cg Exp $'
! !

