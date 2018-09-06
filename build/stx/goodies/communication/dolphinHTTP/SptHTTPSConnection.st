"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPConnection subclass:#SptHTTPSConnection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptHTTPSConnection class methodsFor:'public'!

initialize
	"
	self initialize
	"

	super initialize
!

uninitialize
	"
	self uninitialize
	"

	super uninitialize
! !

!SptHTTPSConnection methodsFor:'private'!

connectSocket
        | address |
        address := (SptHTTPHostCache current ipAddressFor: self host). "/ InternetAddress fromString: self host.
        socket := (self class environment at: #OpenSSLSocket
                                ifAbsent: [self error: 'The HTTPClient is not configured for HTTPS']) port: self port
                                        address: address.
        socket connect.
        ^socket

    "Modified: / 23-09-2011 / 22:56:19 / cg"
! !

!SptHTTPSConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPSConnection.st,v 1.2 2011-09-23 20:56:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPSConnection.st,v 1.2 2011-09-23 20:56:30 cg Exp $'
! !

SptHTTPSConnection initialize!
