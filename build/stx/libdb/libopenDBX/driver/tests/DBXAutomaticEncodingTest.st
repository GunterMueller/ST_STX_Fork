"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXAutomaticEncodingTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Encoding'
!


!DBXAutomaticEncodingTest methodsFor:'as yet unclassified'!

testUTF8IsDetected
	|encoder string| 
		string := 'äö!!#¤%'.
		encoder := DBXAutomaticEncoding new encoderFor: (DBXTestObject new encoding: #utf8).
		self should: [(encoder convertToSystemString: string) = ((TextConverter newForEncoding: #utf8) convertToSystemString: string)]. 
		encoder := DBXAutomaticEncoding new encoderFor: (DBXTestObject new encoding: #latin1).
		self should: [(encoder convertToSystemString: string) = ((TextConverter newForEncoding: #latin1) convertToSystemString: string)]. 
	
! !

!DBXAutomaticEncodingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXAutomaticEncodingTest.st,v 1.2 2013-04-15 13:18:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXAutomaticEncodingTest.st,v 1.2 2013-04-15 13:18:23 cg Exp $'
! !

