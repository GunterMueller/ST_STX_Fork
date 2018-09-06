"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXConnectionSettingsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXConnectionSettingsTest class methodsFor:'as yet unclassified'!

packageNamesUnderTest
	^ #('OpenDBX-Core')
!

resources
	^Array with: FacilityTestResource
! !

!DBXConnectionSettingsTest methodsFor:'tests'!

testValidateMethod
	"The method is distinct to zero"
	| settings |
	settings := DBXConnectionSettings host: '123.4.7.2' port: '54'.
	settings method: 5.
	self
		should: [settings validateMethod]
		raise: DBXError.
	"The method is distinct to zero"
	settings := DBXConnectionSettings host: '123.4.7.2' port: '54'.
	settings method: -5.
	self
		should: [settings validateMethod]
		raise: DBXError.
	"The method is distinct to zero"
	settings := DBXConnectionSettings host: '123.4.7.2' port: '54'.
	settings method: 'nothing'.
	self
		should: [settings validateMethod]
		raise: DBXError.
	"The method is distinct to zero"
	settings := DBXConnectionSettings host: '123.4.7.2' port: '54'.
	settings method: 0.
	self
		shouldnt: [settings validateMethod]
		raise: DBXError
!

xtestValidatePort
	| settings |
	
	self flag: #todo. "Validate port is not working with Pharo... so we are disabling this test for a while"
	
	"The port is negative but must be positive"
	settings := DBXConnectionSettings host: '127.0.0.1' port: '-1'. 
	self should: [ settings validatePort ] raise: DBXError.
	
	"The port is zero but must be positive"
	settings := DBXConnectionSettings host: '127.0.0.1' port: '0'. 
	self shouldnt: [settings validatePort] raise: DBXError.
	
	"The not a number but must be positive number"
	settings := DBXConnectionSettings host: '127.0.0.1' port: 'invalidPort'. 
	self should: [ settings validatePort ] raise: DBXError.
	
	"The port is correct"
	settings := DBXConnectionSettings host: '127.0.0.1' port: '88'. 
	self shouldnt: [settings validatePort] raise: DBXError.
		
! !

!DBXConnectionSettingsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionSettingsTest.st,v 1.2 2013-04-15 13:18:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionSettingsTest.st,v 1.2 2013-04-15 13:18:44 cg Exp $'
! !

