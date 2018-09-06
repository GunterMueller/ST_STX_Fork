"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPEntity
	instanceVariableNames:'stream contentLength contentType'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPEntity comment:'I am an HTTP Entity sent with an HTTP Request used with requests that send a body (ie POST, PUT)

Instance Variables:
	stream		<ReadStream>
	contentLength	<Integer>
	contentType	<String>'
!


!SptHTTPEntity class methodsFor:'instance creation'!

fromByteObject: aByteObject
        ^(self new)
                stream: aByteObject "asByteArray" readStream contentLength: aByteObject size;
                yourself

    "Modified: / 23-09-2011 / 22:06:30 / cg"
!

fromString: aString
	^self fromByteObject: aString
!

onFileStream: aFileStream
	"The FileStream should be opened in the text: false mode"

	^(self new)
		stream: aFileStream contentLength: aFileStream size;
		yourself
!

onStream: aByteReadStream contentLength: anInteger
	^(self new)
		stream: aByteReadStream contentLength: anInteger;
		yourself
! !

!SptHTTPEntity methodsFor:'accessing'!

contentLength
	^contentLength ifNil: [0]
!

contentType
	^contentType
!

contentType: aString
	contentType := aString
!

stream
	^stream
!

stream: aReadStream contentLength: anInteger
	stream := aReadStream.
	contentLength := anInteger
! !

!SptHTTPEntity methodsFor:'content types'!

beAppOctetStream
	contentType := 'application/octet-stream'
!

beTextHtml
	contentType := 'text/html'
!

beTextPlain
	contentType := 'text/plain'
!

beTextXml
	contentType := 'text/xml'
! !

!SptHTTPEntity methodsFor:'testing'!

hasContentType
	^contentType notNil
! !

!SptHTTPEntity class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPEntity.st,v 1.3 2011-09-23 20:21:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPEntity.st,v 1.3 2011-09-23 20:21:47 cg Exp $'
! !
