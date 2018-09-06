"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDSmalltalkPlatform subclass:#WDSmalltalkXPlatform
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Platforms'
!


!WDSmalltalkXPlatform class methodsFor:'initialization'!

initialize
    Smalltalk isSmalltalkX ifTrue:[
        super initialize.
    ].

    "Modified: / 17-06-2018 / 09:03:54 / Claus Gittinger"
! !

!WDSmalltalkXPlatform methodsFor:'facade - http'!

handleRequest: aBlock

        | response |
        response := aBlock value.
        ^(WDHttpResponse new)
                httpStatus: response status ;
                headers: response headers;
                contents: response contents;
                yourself

    "Modified: / 21-07-2018 / 15:39:27 / Claus Gittinger"
!

httpClient
    self halt:'should not be called'.
    
        "For compatibility with an older version of Zinc:"
        Smalltalk at: #ZnNeoClient ifPresent: [ :class | ^ class new beOneShot; yourself ].
        ^ ZnClient new beOneShot; followRedirects: false; yourself.

    "Modified: / 16-07-2018 / 21:57:08 / Claus Gittinger"
!

httpDelete: url
    |response|
    
    response := HTTPInterface 
                    delete:url userName:nil password:nil.

    ^self handleRequest: [ response ]

    "/     ^self handleRequest: [ self httpClient url: url; delete; response ]

    "Modified: / 16-07-2018 / 21:56:50 / Claus Gittinger"
!

httpGet: url
    |response|
    
    response := HTTPInterface 
                    get:url userName:nil password:nil.

    ^self handleRequest: [ response ]

    "Modified: / 22-06-2018 / 03:30:21 / Claus Gittinger"
!

httpPost: url data: data timeout: seconds
    |tryAgain startTime response |

    "/ the service might not yet be up and running...
    startTime := Timestamp now.
    [
        response := HTTPInterface 
                        post:url
                        userName:nil password:nil
                        with:data
                        contentType:'application/json'.
        tryAgain := response notNil
                    and:[response isErrorResponse
                    and:[response responseCode >= 900
                    and:[(Timestamp now secondDeltaFrom:startTime) < seconds]]].
        tryAgain ifTrue:[
            Delay waitForSeconds:0.01
        ].
        tryAgain
    ] whileTrue.
    
"/    data2 := ZnEntity with: data
"/                            type: (ZnMimeType main: 'application' sub: 'json') setCharSetUTF8.
"/    httpClient := self httpClient.
"/    seconds isNil ifFalse: [httpClient timeout: seconds].
"/    response := httpClient
"/                            url: (ZnUrl fromString: url);
"/                            entity: data2;
"/                            post;
"/                            response.
    (response isNil
     or:[response isErrorResponse
     or:[response data isEmptyOrNil]]) ifTrue:[
        WDException 
            raiseErrorString:('Error sending request: ',
                   (response responseText isEmptyOrNil 
                        ifTrue:[('responseCode: %1 (%2)' bindWith:response responseCode with:response response)]
                        ifFalse:[response responseText])).
        ^ nil                
    ].
    ^ self handleRequest: [ response ]

    "Modified: / 22-07-2018 / 08:57:39 / Claus Gittinger"
!

httpPost: url timeout: seconds
    |response|

"/    | httpClient response | 
"/    httpClient := self httpClient.
"/    seconds isNil ifFalse: [httpClient timeout: seconds].
"/    response := httpClient
"/                            url: (ZnUrl fromString: url);
"/                            post;
"/                            response.
    response := HTTPInterface post:url userName:nil password:nil with:nil.
    ^self handleRequest: [ response ]

    "Modified: / 20-07-2018 / 10:10:37 / Claus Gittinger"
    "Modified (format): / 22-07-2018 / 08:48:25 / Claus Gittinger"
! !

!WDSmalltalkXPlatform methodsFor:'facade - json'!

jsonRead: aString 
    JSONReader notNil ifTrue:[^ JSONReader fromJSON:aString ].
    NeoJSONReader notNil ifTrue:[ ^NeoJSONReader fromString: aString ].
    ^ self error:'no JSON support'.

    "Modified: / 20-06-2018 / 07:20:26 / Claus Gittinger"
!

jsonWrite: anObject
    JSONReader notNil ifTrue:[ ^ JSONReader toJSON:anObject ].
    NeoJSONWriter notNil ifTrue:[ ^NeoJSONWriter toString: anObject ].
    self error:'no JSON support'.

    "Modified: / 20-06-2018 / 07:15:11 / Claus Gittinger"
! !

!WDSmalltalkXPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDSmalltalkXPlatform.st,v 1.8 2018-07-22 09:57:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDSmalltalkXPlatform.st,v 1.8 2018-07-22 09:57:20 cg Exp $'
! !


WDSmalltalkXPlatform initialize!
