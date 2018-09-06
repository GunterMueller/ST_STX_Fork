"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDSmalltalkPlatform subclass:#WDPharoPlatform
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Platforms'
!

WDPharoPlatform comment:'Pharo Smalltalk'
!


!WDPharoPlatform class methodsFor:'initialization'!

initialize
    Smalltalk isSmalltalkX ifFalse:[
        super initialize.
    ].

    "Modified: / 17-06-2018 / 09:03:40 / Claus Gittinger"
! !

!WDPharoPlatform methodsFor:'facade - http'!

handleRequest: aBlock

	| response contents|
	response := aBlock value.
	contents := response contents.
	^(WDHttpResponse new)
		httpStatus: response status ;
		headers: response headers;
		contents: contents;
		yourself
!

httpClient

	"For compatibility with an older version of Zinc:"
	Smalltalk at: #ZnNeoClient ifPresent: [ :class | ^ class new beOneShot; yourself ].
	^ ZnClient new beOneShot; followRedirects: false; yourself.
!

httpDelete: url

	^self handleRequest: [ self httpClient url: url; delete; response ]
!

httpGet: url

	^self handleRequest: [ self httpClient url: url; get; response ]
!

httpPost: url data: data timeout: seconds

	| data2 httpClient response |
	data2 := ZnEntity with: data
				type: (ZnMimeType main: 'application' sub: 'json') setCharSetUTF8.
	httpClient := self httpClient.
	seconds isNil ifFalse: [httpClient timeout: seconds].
	response := httpClient
				url: (ZnUrl fromString: url);
				entity: data2;
				post;
				response.
	^self handleRequest: [ response ]
!

httpPost: url timeout: seconds

	| httpClient response |	
	httpClient := self httpClient.
	seconds isNil ifFalse: [httpClient timeout: seconds].
	response := httpClient
				url: (ZnUrl fromString: url);
				post;
				response.
	^self handleRequest: [ response ]
! !

!WDPharoPlatform methodsFor:'facade - json'!

jsonRead: aString 

	^NeoJSONReader fromString: aString
!

jsonWrite: anObject

	^NeoJSONWriter toString: anObject
! !

!WDPharoPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDPharoPlatform.st,v 1.2 2018-06-17 07:04:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDPharoPlatform.st,v 1.2 2018-06-17 07:04:01 cg Exp $'
! !


WDPharoPlatform initialize!
