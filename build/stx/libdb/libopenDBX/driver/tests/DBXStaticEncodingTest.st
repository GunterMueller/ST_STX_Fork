"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXStaticEncodingTest
	instanceVariableNames:'converter'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Encoding'
!


!DBXStaticEncodingTest methodsFor:'as yet unclassified'!

testEncodingFor 
	| strategy encoder encoded |
	strategy := DBXStaticEncoding newForEncoding: #utf8.
	encoder :=strategy encoderFor: (Object new). "any object will do"
	encoded := encoder convertToSystemString: 'ä'.
	self should: [encoded = (String fromByteArray: (ByteArray with: 16rC3 with: 16rA4))].
	
! !

!DBXStaticEncodingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXStaticEncodingTest.st,v 1.2 2013-04-15 13:18:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXStaticEncodingTest.st,v 1.2 2013-04-15 13:18:33 cg Exp $'
! !

