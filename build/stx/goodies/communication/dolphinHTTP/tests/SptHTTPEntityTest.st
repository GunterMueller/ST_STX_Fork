"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPEntityTest
	instanceVariableNames:'entity'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPEntityTest methodsFor:'unit tests'!

setUp
	super setUp.
	entity := SptHTTPEntity fromString: 'foo'
!

testBeAppOctetStream
	entity beAppOctetStream.
	self assert: entity contentType = 'application/octet-stream'
!

testBeTextHtml
	entity beTextHtml.
	self assert: entity contentType = 'text/html'
!

testBeTextPlain
	entity beTextPlain.
	self assert: entity contentType = 'text/plain'
!

testBeTextXml
	entity beTextXml.
	self assert: entity contentType = 'text/xml'
!

testConstructionBytes
        entity := SptHTTPEntity fromByteObject: 'foo'.
        self assert: entity stream contents = 'foo' "asByteArray".
        self assert: entity contentLength = 3

    "Modified: / 23-09-2011 / 22:30:03 / cg"
!

testConstructionString
        self assert: entity stream contents = 'foo' "asByteArray".
        self assert: entity contentLength = 3

    "Modified: / 23-09-2011 / 22:30:10 / cg"
!

testHasContentType
	self deny: entity hasContentType.
	entity contentType: 'text/xml'.
	self assert: entity hasContentType
! !

!SptHTTPEntityTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPEntityTest.st,v 1.2 2011-09-23 20:39:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPEntityTest.st,v 1.2 2011-09-23 20:39:08 cg Exp $'
! !
