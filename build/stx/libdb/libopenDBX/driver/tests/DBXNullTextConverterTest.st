"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXNullTextConverterTest
	instanceVariableNames:'converter'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Encoding'
!


!DBXNullTextConverterTest methodsFor:'as yet unclassified'!

setUp
	converter := DBXNullTextConverter new.
!

testConvertFromSystemString
	| string result |
	string := 'дц!!¤%/'.
	result := converter convertFromSystemString: string.
	self should: [string = result] value.
!

testConvertToSystemString
	| string result |
	string := 'дц!!¤%/'.
	result := converter convertToSystemString: string.
	self should: [string = result] value.
!

testNextFromStream
	| string |
	string := 'дц'.
	self should: [$д = (converter nextFromStream: (ReadStream on: string))].
!

testNextPutToStream
	| string |
	string := String new: 1.
	converter nextPut: $д toStream: (WriteStream on: string).
	self should: [string = 'д'] value.
! !

!DBXNullTextConverterTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXNullTextConverterTest.st,v 1.2 2013-04-15 13:18:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXNullTextConverterTest.st,v 1.2 2013-04-15 13:18:17 cg Exp $'
! !

