"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HTTPInterface
	instanceVariableNames:'socket url host port useSSL proxySettings status userAgent
		transferTimeout connectTimeout chunked mimeType contentLength
		contentEncoding doRetry canDoRanges request response
		acceptedMimeTypes xFerEncoding data dataStream dataFile
		suppressUnicode acceptedEncodings acceptedLanguages
		acceptedCharsets additionalHeaderLines contentType contents
		referer userName password destinationFile
		maxContentsLengthForDirectData cookies provideTransferInformation
		provideTransferProgress sslVersion sslSuite bindAddress
		keepConnection'
	classVariableNames:'ReturnCodes Methods HttpPort HttpsPort Verbose Logging CRNL
		USEREL0_9 USEREL1_0 TransferInformationSignal
		UnsupportedOperationNotificationSignal
		ContentTypeInformationSignal WrongContentTypeNotificationSignal
		ShortTransferNotificationSignal DefaultConnectTimeout
		DefaultTransferTimeout DefaultUserAgent KeepAliveConnections
		KeepAliveConnectionsSema MaxNumberOfKeptConnections
		CookieStoreRequestSignal SuppressReferer KeepConnections'
	poolDictionaries:''
	category:'Net-Communication-HTTP-Client'
!

Object subclass:#HTTPCookie
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTTPInterface
!

Object subclass:#HTTPResponse
	instanceVariableNames:'url response responseCode responseText rawHeader headerInfo
		rawData mimeType encoding data dataFile suppressUnicode'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTTPInterface
!

Object subclass:#KeptSocketInfo
	instanceVariableNames:'hostName port socket timeOfLastUse'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTTPInterface
!

Notification subclass:#RequestInformationSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTTPInterface
!

Notification subclass:#TransferProgressNotificationSignal
	instanceVariableNames:'overAllSize transferSize transferRate overallTransferRate'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTTPInterface
!

Notification subclass:#TransferTimeoutNotificationSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTTPInterface
!

!HTTPInterface class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    An HTTP interface (i.e. a client) which is able to fetch documents using
    HTTP GET, HEAD and POST commands.

    - can use HTTP 0.9, HTTP 1.0 or HTTP 1.1 (default)
        HTTP 1.1 is defined in RFC2068.

    - keeps track of open socket connections and can keep busy connections open.

    - long contents (with configurable size limit) are stored into a temporary file
      and the fileName is provided instead of the contents.
      This is useful if huge files are to be transferred.

    - define a proxy by answering to HTTPProxyQuery with an instance of HTTPProxySettings.
      (or use the withProxy:do: entry)

    Caveat:
        I cannot guarantee that all HTTP 1.1 features are correctly implemented (as usual).
        However, it seems to work for our applications.


    [author:]
        Claus Gittinger

    [class variables:]
        USEREL0_9                               - if true, HTTP 0.9 protocol is used
        USEREL1_0                               - if true, HTTP 1.0 protocol is used
                                                  if both are false, HTTP 1.1 is used.

        Logging                                 - if true, protocol info is sent to Transcript

        TransferInformationSignal               - raised to pass transfer information; param is ASCII text telling
                                                  caller what is currently been done (connecting etc.)
                                                  Can be used by GUI to show connection state.

        TransferProgressNotificationSignal      - raised to pass transfer information; param is percentage of xferred data
                                                  Can be used by GUI to show progress info.

        UnsupportedOperationNotificationSignal  - HTTP server does not support operation
        ContentTypeInformationSignal            - content-type of document as about to be xferred.
        WrongContentTypeNotificationSignal      - content of document is not as specified in allowedMimeTypes arg.
                                                  If proceeded, the document is xferred as usual.
        TransferTimeoutNotificationSignal       - xfer timeout
        ShortTransferNotificationSignal         - short document
        CookieStoreRequestSignal                - HTTP server wants to install a cookie

        DefaultTransferTimeout                  - various defaults
        KeepAliveConnections
        MaxNumberOfKeptConnections

    [see also:]
        HTTPServer
        HTTPService
        http://www.w3.org/Protocols/rfc2616/rfc2616.html
"
!

examples
"
  simple fetch:
                                                        [exBegin]
    |rply document|

    rply := HTTPInterface get:'/' fromHost:'www.exept.de'.
    (rply notNil and:[rply isErrorResponse not]) ifTrue:[
        document := rply data asString.
        HTMLDocumentView openOnText:document.
    ]
                                                        [exEnd]


  alternative:
                                                        [exBegin]
     |h reply|

     h := HTTPInterface connectTo:'www.exept.de' port:80.
     (h requestGET:'/') inspect.
     h closeSocket.
                                                        [exEnd]

  write data to a temp file:  
                                                        [exBegin]
     |h reply|

     h := HTTPInterface connectTo:'www.exept.de' port:443 useSSL:true.
     h maxContentsLengthForDirectData:0.
     reply := h requestGET:'/'.
     reply inspect.
     reply dataStream inspect.
     h closeSocket.
                                                        [exEnd]


  via a proxy:
                                                        [exBegin]
    |rply document|

    HTTPInterface 
        withProxy:(HTTPProxySettings useHost:'sixtyfour' port:3128)
        do:[
            rply := HTTPInterface get:'http://www.exept.de/'.
        ].
    (rply notNil and:[rply isErrorResponse not]) ifTrue:[
        document := rply data.
        HTMLDocumentView openOnText:document.
    ] ifFalse:[
        rply inspect.
    ].
                                                        [exEnd]

  via https (requires the SSL support package to be loaded):
                                                        [exBegin]
    |rply document|

    rply := HTTPInterface get:'https://www.exept.de/'.
    (rply notNil and:[rply isErrorResponse not]) ifTrue:[
        document := rply rawData.
        HTMLDocumentView openOnText:document.
    ]
                                                        [exEnd]


"
! !

!HTTPInterface class methodsFor:'initialization'!

closeKeptConnections
    |toClose|

    KeepAliveConnectionsSema critical:[
        [KeepAliveConnections notEmptyOrNil] whileTrue:[
            Logging ifTrue:[
                Transcript showCR:'****** shutDown old socket'.
            ].
            toClose := KeepAliveConnections removeFirst.
            toClose socket shutDown.
        ]
    ]
!

initialize
    Verbose := false.
    KeepAliveConnectionsSema isNil ifTrue:[
        KeepAliveConnectionsSema := Semaphore forMutualExclusion.
        KeepConnections := true.
        MaxNumberOfKeptConnections := 3.
        DefaultTransferTimeout := 60.
        DefaultConnectTimeout := 20.

        "/ for now, simulate a Mozilla;
        "/ the reason is that some servers return different html depending
        "/ on the userAgent (caring for special features, which we do not want).

        DefaultUserAgent := 'Mozilla/3.0N'.
"/        DefaultUserAgent := 'Mozilla/3.0N (actually ST/X)'.
"/        DefaultUserAgent := 'Mozilla/4.5 [en] (STX)'.

        USEREL0_9 := false.     "/ stupid - should be associated to connections
        USEREL1_0 := false.

        TransferInformationSignal := QuerySignal new.
        TransferInformationSignal nameClass:self message:#transferInformationSignal.

        ShortTransferNotificationSignal := QuerySignal new.
        ShortTransferNotificationSignal nameClass:self message:#shortTransferNotificationSignal.

        UnsupportedOperationNotificationSignal := QuerySignal new.
        UnsupportedOperationNotificationSignal nameClass:self message:#unsupportedOperationNotificationSignal.

        CookieStoreRequestSignal := QuerySignal new.
        CookieStoreRequestSignal nameClass:self message:#cookieStoreRequestSignal.

        ContentTypeInformationSignal := QuerySignal new.
        ContentTypeInformationSignal nameClass:self message:#documentTypeInformationSignal.

        WrongContentTypeNotificationSignal := QuerySignal new.
        WrongContentTypeNotificationSignal nameClass:self message:#wrongContentTypeNotificationSignal.

        CRNL := String with:(Character return) with:(Character nl).
        HttpPort := (Socket portOfService:#http protocol:#tcp) ? 80.
        HttpsPort := (Socket portOfService:#https protocol:#tcp) ? 443.
        Logging := false.
        "/ Logging := true.

        ReturnCodes := IdentityDictionary
                            withKeysAndValues:#(
                                  0 OK                  

                                100 CONTINUE            
                                101 SWITCHING_PROTOCOLS 

                                200 DOCUMENT_FOLLOWS    
                                201 CREATED             
                                202 ACCEPTED            
                                204 NO_CONTENT          

                                301 MOVED_PERM          
                                302 MOVED_TEMP          
                                303 SEE_OTHER          
                                304 USE_LOCAL_COPY      

                                400 BAD_REQUEST         
                                401 AUTH_REQUIRED       
                                402 PAYMENT_REQUIRED    
                                403 FORBIDDEN           
                                404 NOT_FOUND           
                                405 METHOD_NOT_ALLOWED  
                                406 NOT_ACCEPTABLE      
                                408 REQUEST_TIMEOUT    

                                500 SERVER_ERROR        
                                501 NOT_IMPLEMENTED     
                                503 SERVICE_UNAVAILABLE 
                                505 VERSION_UNSUPPORTED 

                                900 ERROR_badURL          
                                901 ERROR_writeError      
                                902 ERROR_unknownHost     
                                903 ERROR_unreachableHost 
                                904 ERROR_noResponse      
                                905 ERROR_readError       

                                6992 NO_MEMORY           
                            ).

        Methods := IdentityDictionary
                       withKeysAndValues:#(
                            #M_Get        0
                            #M_Put        1
                            #M_Post       2
                            #M_Delete     3
                       ).
    ].

    "
     HTTPInterface initialize
    "

    "Modified: / 16.1.1998 / 15:03:07 / stefan"
    "Modified: / 14.4.1998 / 16:56:14 / cg"
! !

!HTTPInterface class methodsFor:'instance creation'!

connectTo:hostName port:portNrOrNil
    "create an instance to myself and connect it to portNr on hostName.
     If portNr is nil, the default http port will be used."

     ^ self new connectTo:hostName port:portNrOrNil useSSL:false sslVersion:nil sslSuite:nil.

    "
     |h|

     h := HTTPInterface connectTo:'www.exept.de' port:nil.
     Transcript showCR:(h requestGET:'/').
     h destroy.
    "

    "
     |h|

     h := HTTPInterface connectTo:'www.exept.de' port:33333.        'should not exist'.
     Transcript showCR:(h requestGET:'/') .
     h destroy.
    "

    "
     |h|

     h := HTTPInterface connectTo:'bla.nowhere' port:nil.
     Transcript showCR:(h requestGET:'/') .
     h destroy.
    "

    "Modified: / 16.1.1998 / 10:01:26 / stefan"
!

connectTo:hostName port:portNrOrNil useSSL:useSSL
    "create an instance to myself and connect it to portNr on hostName.
     If portNr is nil, the default http port will be used."

     ^ self new connectTo:hostName port:portNrOrNil useSSL:useSSL sslVersion:nil sslSuite:nil.

    "
     |h|

     h := HTTPInterface connectTo:'www.exept.de' port:nil.
     Transcript showCR:(h requestGET:'/').
     h destroy.
    "

    "
     |h|

     h := HTTPInterface connectTo:'www.exept.de' port:33333.        'should not exist'.
     Transcript showCR:(h requestGET:'/') .
     h destroy.
    "

    "
     |h|

     h := HTTPInterface connectTo:'bla.nowhere' port:nil.
     Transcript showCR:(h requestGET:'/') .
     h destroy.
    "

    "Modified: / 16.1.1998 / 10:01:26 / stefan"
!

connectTo:hostName port:portNrOrNil useSSL:sslRequested sslVersion:sslVersionOrNil sslSuite:sslSuiteOrNil
    "create an instance to myself and connect it to portNr on hostName.
     If portNr is nil, the default http port will be used."

    |newHTTPConnection|

    newHTTPConnection := self new.
    newHTTPConnection connectTo:hostName port:portNrOrNil useSSL:sslRequested sslVersion:sslVersionOrNil sslSuite:sslSuiteOrNil.
    newHTTPConnection isConnected ifFalse:[^ nil].
    ^ newHTTPConnection.

    "
     |h|

     h := HTTPInterface connectTo:'www.exept.de' port:nil.
     Transcript showCR:(h requestGET:'/').
     h destroy.
    "

    "
     |h|

     h := HTTPInterface connectTo:'www.exept.de' port:33333.        'should not exist'.
     Transcript showCR:(h requestGET:'/') .
     h destroy.
    "

    "
     |h|

     h := HTTPInterface connectTo:'bla.nowhere' port:nil.
     Transcript showCR:(h requestGET:'/') .
     h destroy.
    "

    "Modified: / 16.1.1998 / 10:01:26 / stefan"
!

new
    ^ self basicNew initialize

    "Created: / 16.1.1998 / 09:36:26 / stefan"
! !

!HTTPInterface class methodsFor:'Signal constants'!

contentTypeInformationSignal
    ^ ContentTypeInformationSignal
!

cookieStoreRequestSignal
    ^ CookieStoreRequestSignal
!

shortTransferNotificationSignal
    ^ ShortTransferNotificationSignal
!

transferInformationSignal
    ^ TransferInformationSignal
!

transferProgressNotificationSignal
    ^ TransferProgressNotificationSignal
!

transferTimeoutNotificationSignal
    ^ TransferTimeoutNotificationSignal
!

unsupportedOperationNotificationSignal
    ^ UnsupportedOperationNotificationSignal
!

wrongContentTypeNotificationSignal
    ^ WrongContentTypeNotificationSignal
! !

!HTTPInterface class methodsFor:'debugging'!

logging:aBoolean
    "enable/disable logging"
    
    Logging := aBoolean

    "
     self logging:true
     self logging:false
    "

    "Modified (comment): / 17-06-2018 / 23:21:42 / Claus Gittinger"
! !

!HTTPInterface class methodsFor:'defaults'!

defaultConnectTimeout
    "return the default connect timeout"
    
    ^ DefaultConnectTimeout

    "
     HTTPInterface defaultConnectTimeout
     HTTPInterface defaultConnectTimeout:120
     HTTPInterface defaultConnectTimeout:30
    "

    "Modified (comment): / 17-06-2018 / 23:21:59 / Claus Gittinger"
!

defaultConnectTimeout:seconds
    "set the default connect timeout"

    DefaultConnectTimeout := seconds

    "
     HTTPInterface defaultConnectTimeout
     HTTPInterface defaultConnectTimeout:120
     HTTPInterface defaultConnectTimeout:30
    "

    "Modified (comment): / 17-06-2018 / 23:22:08 / Claus Gittinger"
!

defaultTransferTimeout
    "return the default transfer timeout; 
     that is the max. time from request to data xmission start"

    ^ DefaultTransferTimeout

    "
     HTTPInterface defaultTransferTimeout
     HTTPInterface defaultTransferTimeout:120
     HTTPInterface defaultTransferTimeout:30
    "

    "Modified (comment): / 17-06-2018 / 23:24:49 / Claus Gittinger"
!

defaultTransferTimeout:seconds
    "set the default transfer timeout; 
     that is the max. time from request to data xmission start"

    DefaultTransferTimeout := seconds

    "
     HTTPInterface defaultTransferTimeout
     HTTPInterface defaultTransferTimeout:120
     HTTPInterface defaultTransferTimeout:30
    "

    "Modified (comment): / 17-06-2018 / 23:24:57 / Claus Gittinger"
!

maxContentsLengthForDirectData
    "if a files size is smaller than the value returned by this method, then a bytearray-buffer
     is used for the data; otherwise, the data is stored in a temporary file and
     the dataFile is passed in the response object."

    ^ 1024*1024*4
!

maxNumberOfKeptConnections
    "return the max. number of kept connections"
    
    ^ MaxNumberOfKeptConnections ? 0

    "Modified (comment): / 17-06-2018 / 23:17:12 / Claus Gittinger"
!

maxNumberOfKeptConnections:numKept
    "set the max. number of kept connections"

    MaxNumberOfKeptConnections := numKept

    "
     self maxNumberOfKeptConnections
     self maxNumberOfKeptConnections:3
     self maxNumberOfKeptConnections:1
    "

    "Modified (comment): / 17-06-2018 / 23:17:19 / Claus Gittinger"
! !

!HTTPInterface class methodsFor:'helpers'!

extractCharSetEncodingFromContentType:arg
    <resource: #obsolete>

    self obsoleteMethodWarning:'use HTMLUtilities extractCharSetEncodingFromContentType:'.
    ^ HTMLUtilities extractCharSetEncodingFromContentType:arg
!

extractMimeTypeFromContentType:arg
    ^ HTMLUtilities extractMimeTypeFromContentType:arg
!

logInfo:msg
    Logging ifTrue:[
        Transcript show:'HTTPInterface [info]: '; showCR:msg.
    ].

    "
     Logging := false
     Logging := true
    "

    "Modified: / 20-03-2012 / 21:38:12 / cg"
!

numericReturnCodeForSymbol:aSymbolicHttpReturnCode 
    "given a symbolic error code, return the corresponding HTTP code"
    
    ^ ReturnCodes keyAtValue:aSymbolicHttpReturnCode ifAbsent:999

    "
     self numericReturnCodeForSymbol:#'NOT_FOUND' -> 404
     self symbolForReturnCode:404 -> #'NOT_FOUND'
    "

    "Modified (comment): / 17-06-2018 / 23:19:21 / Claus Gittinger"
!

symbolForReturnCode:aNumericHttpReturnCode 
    ^ ReturnCodes at:aNumericHttpReturnCode ifAbsent:#unknown
! !

!HTTPInterface class methodsFor:'private'!

generateFieldDataFrom:nameValueAssociations
    |fieldDataStream key val|

    fieldDataStream := WriteStream on:''.

    nameValueAssociations keysAndValuesDo:[:nameKey :value |
        "allow for both dictionaries and seqColls of associations"
        (nameKey isNumber and:[ value isAssociation ]) ifTrue:[
            key := value key.
            val := value value.
        ] ifFalse:[
            key := nameKey.
            val := value.
        ].
        val notNil ifTrue:[
            fieldDataStream notEmpty ifTrue:[
                fieldDataStream nextPut:$&.
            ].
            HTMLUtilities urlEncode:key on:fieldDataStream.
            fieldDataStream nextPut:$=.
            HTMLUtilities urlEncode:val on:fieldDataStream.
        ].
    ].

    ^ fieldDataStream contents.

    "Modified: / 18-07-2007 / 23:16:06 / cg"
!

multiPartBoundaryPost:url filename:aFilename fileNameFieldName:aFilenameFieldName contents:contents otherValues:aValueDict
    "a post request with field values in a smalltalk-friendly form"

    |fieldDataStream|

    fieldDataStream := WriteStream on:''.
    aFilename notEmpty ifTrue:[
        fieldDataStream
            nextPutAll:'------------0xKhTmLbOuNdArY' , String crlf;
            nextPutAll:'Content-Disposition: form-data; name="' , aFilenameFieldName
                        , '"; filename="' , aFilename
                        , '"' , String crlf;
            nextPutAll:'Content-Type: text/html' , String crlf, String crlf;
            nextPutAll:contents , String crlf.
    ].
    aValueDict notNil ifTrue:[
        aValueDict keysAndValuesDo:[:nameKey :value |
            fieldDataStream
                nextPutAll:'------------0xKhTmLbOuNdArY' , String crlf;
                nextPutAll:'Content-Disposition: form-data; name="' , nameKey , '"'
                            , String crlf;
                nextPutAll:value , String crlf, String crlf.
        ].
    ].
    fieldDataStream nextPutAll:'------------0xKhTmLbOuNdArY' , String crlf.
    ^ self
        request:'POST' url:url
        fromHost:nil port:nil
        accept:#( '*/*' )
        fromDocument:nil
        userName:nil password:nil
        contentType:'multipart/form-data; boundary=----------0xKhTmLbOuNdArY'
        contents:fieldDataStream contents
!

request:getOrPost url:urlOrPath fromHost:host port:portNrOrNil accept:acceptedMimeTypes fromDocument:documentURL userName:user password:passwd
    <resource: #obsolete>

    ^ self
        request:getOrPost
        url:urlOrPath
        fromHost:host port:portNrOrNil
        accept:acceptedMimeTypes
        fromDocument:documentURL
        userName:user password:passwd
        contentType:nil contents:nil
! !

!HTTPInterface class methodsFor:'request API'!

delete:url
    "a delete request. Usually only useful against a Rest service.
     returns a response object"

    ^ self
        request:#DELETE
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:nil
        contents:nil

     "
      HTTPInterface
        delete:'http://someURL'.
     "
!

delete:url userName:aUserName password:aPassword 
    "a delete request. Usually only useful against a Rest service.
     returns a response object"

    ^ self
        request:#DELETE
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:aUserName password:aPassword
        contentType:nil
        contents:nil
!

get:url
    "get url; 
     returns a response-object"

    ^ self
        request:#GET
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface get:'http://www.exept.de/'
      HTTPInterface get:'http://foo.bar.baz/'
     "

    "Modified: / 26-01-2007 / 16:31:51 / cg"
    "Modified (comment): / 08-01-2012 / 17:34:52 / cg"
!

get:url accept:acceptedMimeTypes
    "get url, accepting types in acceptedMimeTypes.
     Returns a response-object."

    ^ self
        request:#GET
        url:url fromHost:nil port:nil
        accept:acceptedMimeTypes
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface
        get:'http://www.exept.de/'
        accept:#('image/gif' 'image/xbm' 'text/html')

      HTTPInterface
        get:'http://www.google.de/'
        accept:#('image/gif')
     "

    "Modified (format): / 05-10-2011 / 23:30:12 / cg"
!

get:url destinationFile:destinationFilename
    "get url; 
     returns a response-object. 
     Data is stored in destinationFile"

    ^ self
        request:#GET
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:destinationFilename

     "
      HTTPInterface get:'http://www.exept.de/'
      HTTPInterface get:'http://foo.bar.baz/'
     "

    "Modified: / 26-01-2007 / 16:31:51 / cg"
    "Modified (comment): / 13-09-2017 / 16:51:34 / cg"
!

get:url fromDocument:referrer
    "get url with referrer; 
     returns a response-object"

    ^ self
        request:#GET
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:referrer
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface get:'http://www.exept.de/'
      HTTPInterface get:'http://foo.bar.baz/'
     "

    "Modified: / 26-01-2007 / 16:31:51 / cg"
    "Modified (comment): / 08-01-2012 / 17:35:19 / cg"
!

get:path fromHost:host
    "get path from host.
     Returns a response-object."

    ^ self
        request:#GET
        url:path
        fromHost:host port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface
        get:'/'
        fromHost:'www.exept.de'
     "

    "Modified: 23.6.1997 / 09:37:48 / cg"
!

get:path fromHost:host port:portNr
    "get path from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     Returns a response-object."

    ^ self
        request:#GET
        url:path
        fromHost:host port:portNr
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface
        get:'/'
        fromHost:'www.exept.de'
        port:8080
     "

    "Modified: 23.6.1997 / 09:37:48 / cg"
!

get:path fromHost:host port:portNrOrNil accept:acceptedMimeTypes fromDocument:documentURL
    "get path from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:#GET
        url:path
        fromHost:host port:portNrOrNil
        accept:acceptedMimeTypes
        fromDocument:documentURL
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil
!

get:urlOrPath fromHost:host port:portNrOrNil accept:acceptedMimeTypes fromDocument:documentURL userName:user password:passwd
    "get url from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:#GET
        url:urlOrPath
        fromHost:host port:portNrOrNil
        accept:acceptedMimeTypes
        fromDocument:documentURL
        userName:user password:passwd
        contentType:nil contents:nil
        destinationFile:nil

    "
     HTTPInterface get:'/' fromHost:'porty'
                   port:nil fromDocument:'http://murks'
    "
!

get:urlOrPath fromHost:host port:portNrOrNil accept:acceptedMimeTypes fromDocument:documentURL userName:user password:passwd cookies:aCollectionOfCookiesOrNil
    "get url from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:#GET
        url:urlOrPath
        fromHost:host port:portNrOrNil
        accept:acceptedMimeTypes
        fromDocument:documentURL
        userName:user password:passwd
        cookies:aCollectionOfCookiesOrNil
        contentType:nil contents:nil
        destinationFile:nil

    "
     HTTPInterface get:'/' fromHost:'porty'
                   port:nil fromDocument:'http://murks'
    "

    "Created: / 10-06-2012 / 16:33:29 / cg"
    "Modified (format): / 25-11-2017 / 22:17:48 / cg"
!

get:urlOrPath fromHost:host port:portNrOrNil accept:acceptedMimeTypes 
    fromDocument:documentURL userName:user password:passwd cookies:aCollectionOfCookiesOrNil
    maxCountFollowMoved:maxCountFollowed
    
    "get url from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     If the response is a moved-file response, follow the indirection, but at most maxCountFollowed times.
     Returns a response-object."

    |httpResponse newURL count|
    
    httpResponse := self 
                        get:urlOrPath fromHost:host port:portNrOrNil 
                        accept:acceptedMimeTypes 
                        fromDocument:documentURL userName:user password:passwd cookies:aCollectionOfCookiesOrNil.

    [httpResponse notNil and:[httpResponse isMovedResponse]] whileTrue:[
        newURL := httpResponse location.
        newURL isNil ifTrue:[
            ^ nil.
        ].
        httpResponse := self 
                        get:newURL fromHost:host port:portNrOrNil 
                        accept:acceptedMimeTypes 
                        fromDocument:documentURL userName:user password:passwd cookies:aCollectionOfCookiesOrNil.
        count := (count ? 0) + 1. 
        count > maxCountFollowed ifTrue:[
            ^ nil
        ].    
    ].
    ^ httpResponse

    "Created: / 25-11-2017 / 22:15:16 / cg"
!

get:urlOrPath fromHost:host port:portNrOrNil accept:acceptedMimeTypes 
    fromDocument:documentURL userName:user password:passwd maxCountFollowMoved:maxCountFollowed
    
    "get url from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     If the response is a moved-file response, follow the indirection, but at most maxCountFollowed times.
     Returns a response-object."

    ^ self
        get:urlOrPath 
        fromHost:host port:portNrOrNil 
        accept:acceptedMimeTypes 
        fromDocument:documentURL 
        userName:user password:passwd 
        cookies:nil 
        maxCountFollowMoved:maxCountFollowed

    "Created: / 25-11-2017 / 22:15:06 / cg"
!

get:path fromHost:host port:portNrOrNil fromDocument:documentURL
    "get path from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:#GET
        url:path
        fromHost:host port:portNrOrNil
        accept:#('*/*')
        fromDocument:documentURL
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil
!

get:url port:portNr
    "get url; 
     returns a response-object"

    ^ self
        request:#GET
        url:url
        fromHost:nil port:portNr
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface get:'http://www.exept.de/'
      HTTPInterface get:'http://foo.bar.baz/'
     "

    "Created: / 22-09-2010 / 00:46:30 / cg"
!

get:url userName:user password:password
    "get url; 
     Returns a response-object."

    ^ self
        request:#GET
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:user password:password
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface
        get:'http://www.exept.de/'
        userName:'foo'
        password:'bar'
     "

    "Modified (comment): / 08-01-2012 / 17:35:44 / cg"
!

get:url with:data
    "a get request with field values in HTTP-request form (&nameKey=value;).
     returns a response-object"

    ^ self
        request:#GET
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:'text/plain' contents:data
        destinationFile:nil
!

get:url withFields:nameValueAssociations
    "a get request with field values.
     returns a response-object"

    |fieldData|

    fieldData := self generateFieldDataFrom:nameValueAssociations.

    ^ self
        request:#GET
        url:url
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:'application/x-www-form-urlencoded'
        contents:fieldData
        destinationFile:nil
!

getFile:url
    "a get request, 
     returning the data if present, or else raising an error."

    |response|

    response := self processRedirectsFor:url with:[:anUrl | self get:anUrl].
    ^ response data.

    "
     self getFile:'http://www.exept.de/'
     self getFile:'http://www.google.com/'
     self getFile:'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
    "

    "Modified: / 08-01-2012 / 17:45:13 / cg"
!

getFile:url userName:aUserName password:aPassword
    "a get request, 
     returning the data if present, or else raising an error."

    |response|

    response := self processRedirectsFor:url with:[:anUrl | self get:anUrl userName:aUserName password:aPassword].
    ^ response data.
!

getStreamFor:url
    "a get request, 
     returning a stream on the data if present, or else raising an error."

    |response|

    response := self processRedirectsFor:url with:[:anUrl | self get:anUrl].
    ^ response dataStream.

    "
     self getStreamFor:'http://www.exept.de/'
     self getStreamFor:'http://www.google.com/'
     self getStreamFor:'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
    "

    "Created: / 08-01-2012 / 17:43:24 / cg"
!

head:url accept:acceptedMimeTypes
    "get a documents head (i.e. without body) url from host.
     Returns a response-object."

    ^ self
        request:#HEAD
        url:url fromHost:nil port:nil
        accept:acceptedMimeTypes
        fromDocument:nil
        userName:nil password:nil
        contentType:nil contents:nil
        destinationFile:nil

     "
      HTTPInterface
        head:'http://www.exept.de/'
        accept:#('image/gif' 'image/xbm' 'text/html')

      HTTPInterface
        head:'http://www.google.de/'
        accept:#('image/gif')
     "
!

head:urlOrPath fromHost:host port:portNrOrNil accept:acceptedMimeTypes fromDocument:documentURL userName:user password:passwd cookies:aCollectionOfCookiesOrNil
    "get a documents head (i.e. without body) url from host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:#HEAD
        url:urlOrPath
        fromHost:host port:portNrOrNil
        accept:acceptedMimeTypes
        fromDocument:documentURL
        userName:user password:passwd
        cookies:aCollectionOfCookiesOrNil
        contentType:nil contents:nil
        destinationFile:nil

    "
     HTTPInterface head:'/' fromHost:'www.exept.de'
                   port:nil accept:#('*') fromDocument:'/'
                   userName:nil password:nil cookies:nil 

     HTTPInterface get:'/' fromHost:'www.exept.de'
                   port:nil accept:#('*') fromDocument:'/'
                   userName:nil password:nil cookies:nil 
    "

    "Created: / 17-11-2012 / 09:12:04 / cg"
    "Modified (format): / 25-11-2017 / 22:18:11 / cg"
!

multiPartBoundaryPost:url fromHost:host port:port userName:userName password:password attributes:aValueDict
    "a post request with field values in a smalltalk-friendly for;
     returns a response object"

    |stream boundary crlf isFirst contents|

    stream   := WriteStream on:''.
    boundary := '------------0x%1%' bindWith:UUID genRandomUUID.
"/    boundary := '------------0xKhTmLbOuNdArY'.
    crlf     := String crlf.
    isFirst  := true.

    stream nextPutAll:boundary; crlf.

    aValueDict keysAndValuesDo:[:nameKey :value|
        stream nextPutAll:'Content-Disposition: form-data; name="',(nameKey asString),'"'; crlf; crlf.
        stream nextPutAll:(value asString); crlf; crlf.
        stream nextPutAll:boundary; crlf.
    ].
    contents := stream contents.

    ^ self
        request:'POST'
        url:url
        fromHost:host
        port:port
        accept:#( '*/*' )
        fromDocument:nil
        userName:userName
        password:password
        contentType:('multipart/form-data; boundary=%1' bindWith:boundary)
        contents:contents

    "Modified: / 18-07-2007 / 23:15:39 / cg"
    "Modified (comment): / 08-01-2012 / 17:36:34 / cg"
!

post:path host:host port:port with:data
    "a post request with field values in HTTP-request form (&nameKey=value;);
     returns a response object"

    ^ self
        request:#POST
        url:path 
        fromHost:host port:port
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:'text/plain'
        contents:data

     "
      HTTPInterface
        post:'/m5?a=1&s=USD&t=EUR' 
        host:'se.finance.yahoo.com'
        port:80
        with:'foo=1&bar=2'
     "

    "Created: / 29-04-2011 / 17:24:11 / cg"
!

post:path host:host port:port withFields:nameValueAssociations
    "returns a response object"

    |fieldData|

    fieldData := self generateFieldDataFrom:nameValueAssociations.

    ^ self
        request:#POST
        url:path 
        fromHost:host port:port
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:'application/x-www-form-urlencoded'
        contents:fieldData

     "
      HTTPInterface
        post:'/m5?a=1&s=USD&t=EUR' 
        host:'se.finance.yahoo.com'
        port:80
        withFields:(Dictionary new at:'foo' put:'1'; at:'bar' put:'2'; yourself)
     "

    "Created: / 07-11-2011 / 12:31:02 / cg"
!

post:url userName:aUserName password:aPassword with:data
    "a post request with field values in HTTP-request form (&nameKey=value;);
     returns a response object"

    ^ self
        request:#POST
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:aUserName password:aPassword
        contentType:'text/plain'
        contents:data
!

post:url userName:aUserName password:aPassword with:data contentType:aType
    "a post request with field values in HTTP-request form (&nameKey=value;);
     returns a response object"

    ^ self
        request:#POST
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:aUserName password:aPassword
        contentType:aType
        contents:data
!

post:url with:data
    "a post request with field values in HTTP-request form (&nameKey=value;);
     returns a response object"

    ^ self
        request:#POST
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:'text/plain'
        contents:data

     "
      HTTPInterface
        post:'http://se.finance.yahoo.com/m5?a=1&s=USD&t=EUR' with:'foo=1&bar=2'
     "

    "Modified (comment): / 08-01-2012 / 17:40:42 / cg"
!

post:url with:data contentType:mimeType
    "a post request with field values in HTTP-request form (&nameKey=value;);
     returns a response object"

    ^ self
        request:#POST
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:mimeType
        contents:data

     "
      HTTPInterface
        post:'http://se.finance.yahoo.com/m5?a=1&s=USD&t=EUR' with:'foo=1&bar=2'
     "

    "Modified (comment): / 08-01-2012 / 17:40:42 / cg"
!

post:url withFields:nameValueAssociations
    "returns a response object"

    |fieldData|

    fieldData := self generateFieldDataFrom:nameValueAssociations.

    ^ self
        request:#POST
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:'application/x-www-form-urlencoded'
        contents:fieldData

     "
      HTTPInterface
        post:'http://se.finance.yahoo.com/m5?a=1&s=USD&t=EUR' 
        withFields:(Dictionary new at:'foo' put:'1'; at:'bar' put:'2'; yourself)
     "

    "Modified (comment): / 08-01-2012 / 17:40:49 / cg"
!

processRedirectsFor:anUrl with:fetchBlock
    "utility:
     evaluate fetchBlock with anUrl, if error, raise it. If moved, get the moved document;
     answer the response."

    |response url redirectCount|

    url := anUrl.
    redirectCount := 0.
    [
        response := fetchBlock value:url.
        response isErrorResponse ifTrue:[
            OpenError raiseErrorString:'http-request failed: "',response responseText,'" (code:',response responseCode asString,')'.
        ].
        response isMovedResponse ifTrue:[
            redirectCount > 10 ifTrue:[
                OpenError raiseErrorString:'http-request failed: too many redirects (>10) from: ', url printString.
            ].
            response location isNil ifTrue:[
                OpenError raiseErrorString:'http-request failed: empty redirect location from: ', url printString.
            ].
            redirectCount := redirectCount + 1.
            url := response location.
        ].
    ] doWhile:[response isMovedResponse].

    ^ response
!

put:url userName:aUserName password:aPassword with:data contentType:mimeTypeOfData
    "a put request with data;
     returns a response object"

    ^ self
        request:#PUT
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:aUserName password:aPassword
        contentType:mimeTypeOfData
        contents:data

     "
      HTTPInterface
        put:'http://someURL' with:'someData' contentType:'text/plain'.

      HTTPInterface
        put:'http://someURL' with:'someData' contentType:nil.
     "
!

put:url with:data contentType:mimeTypeOfData
    "a put request with data;
     returns a response object"

    ^ self
        request:#PUT
        url:url 
        fromHost:nil port:nil
        accept:#('*/*')
        fromDocument:nil
        userName:nil password:nil
        contentType:mimeTypeOfData
        contents:data

     "
      HTTPInterface
        put:'http://someURL' with:'someData' contentType:'text/plain'.

      HTTPInterface
        put:'http://someURL' with:'someData' contentType:nil.
     "
!

request:getOrPost url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
    accept:acceptedMimeTypes fromDocument:documentURL
    userName:userOrNil password:passwordOrNil
    contentType:contentType contents:contents

    "send a get/post request to host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:getOrPost 
        url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
        accept:acceptedMimeTypes 
        fromDocument:documentURL
        userName:userOrNil password:passwordOrNil
        contentType:contentType contents:contents
        destinationFile:nil

    "
     HTTPInterface get:'/' fromHost:'www.exept.de'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'193.141.12.50'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'127.0.0.1'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'www.iuwqhqipougheorighwpoeghw.de'
                   port:nil fromDocument:'http://murks'
    "

    "Modified: / 05-10-2011 / 17:40:24 / cg"
!

request:getOrPost url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil 
    accept:acceptedMimeTypes fromDocument:documentURL 
    userName:userOrNil password:passwordOrNil 
    contentType:contentType contents:contents 
    destinationFile:destinationFilenameOrNil 

    "send a get/post request to host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."
    
    ^ self 
        request:getOrPost
        url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
        proxy:(HTTPProxyQuery isNil ifTrue:[nil] ifFalse:[HTTPProxyQuery query])
        accept:acceptedMimeTypes fromDocument:documentURL
        userName:userOrNil password:passwordOrNil
        contentType:contentType contents:contents
        destinationFile:destinationFilenameOrNil

    "Modified: / 12-04-2011 / 09:35:30 / sr"
    "Modified: / 10-10-2011 / 11:55:43 / cg"
!

request:getOrPost url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil 
    accept:acceptedMimeTypes fromDocument:documentURL 
    userName:userOrNil password:passwordOrNil 
    cookies:aCollectionOfCookiesOrNil
    contentType:contentType contents:contents 
    destinationFile:destinationFilenameOrNil 

    "send a get/post request to host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."
    
    ^ self 
        request:getOrPost
        url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
        proxy:(HTTPProxyQuery isNil ifTrue:[nil] ifFalse:[HTTPProxyQuery query])
        accept:acceptedMimeTypes fromDocument:documentURL
        userName:userOrNil password:passwordOrNil
        cookies:aCollectionOfCookiesOrNil
        contentType:contentType contents:contents
        destinationFile:destinationFilenameOrNil
        additionalHeaderLines:nil

    "Modified: / 12-04-2011 / 09:35:30 / sr"
    "Modified: / 10-10-2011 / 11:55:43 / cg"
    "Created: / 10-06-2012 / 16:33:06 / cg"
    "Modified (format): / 25-11-2017 / 22:18:20 / cg"
!

request:getOrPost url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
    proxy:proxySettingsOrNil
    accept:acceptedMimeTypes fromDocument:documentURL
    userName:userOrNil password:passwordOrNil
    contentType:contentType contents:contents
    destinationFile:destinationFilenameOrNil

    "send a get/post request to host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:getOrPost 
        url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
        proxy:proxySettingsOrNil
        accept:acceptedMimeTypes fromDocument:documentURL
        userName:userOrNil password:passwordOrNil
        cookies:#()
        contentType:contentType contents:contents
        destinationFile:destinationFilenameOrNil
        additionalHeaderLines:nil

    "Modified: / 12-04-2011 / 09:35:30 / sr"
    "Created: / 05-10-2011 / 17:32:19 / cg"
!

request:getOrPost url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
    proxy:proxySettingsOrNil
    accept:acceptedMimeTypes fromDocument:documentURL
    userName:userOrNil password:passwordOrNil
    cookies:aCollectionOfCookiesOrNil
    contentType:contentType contents:contents
    destinationFile:destinationFilenameOrNil

    "send a get/post request to host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    ^ self
        request:getOrPost 
        url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
        proxy:proxySettingsOrNil
        accept:acceptedMimeTypes fromDocument:documentURL
        userName:userOrNil password:passwordOrNil
        cookies:aCollectionOfCookiesOrNil
        contentType:contentType contents:contents
        destinationFile:destinationFilenameOrNil
        additionalHeaderLines:nil

    "
     HTTPInterface get:'/' fromHost:'www.exept.de'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'193.141.12.50'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'127.0.0.1'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'www.iuwqhqipougheorighwpoeghw.de'
                   port:nil fromDocument:'http://murks'
    "

    "Modified: / 12-04-2011 / 09:35:30 / sr"
    "Created: / 10-06-2012 / 16:21:39 / cg"
    "Modified (format): / 25-11-2017 / 22:18:39 / cg"
!

request:getOrPost url:urlOrPathArg fromHost:hostOrNil port:portNrOrNil
    proxy:proxySettingsOrNil
    accept:acceptedMimeTypes fromDocument:documentURL
    userName:userOrNil password:passwordOrNil
    cookies:aCollectionOfCookiesOrNil
    contentType:contentType contents:contents
    destinationFile:destinationFilenameOrNil
    additionalHeaderLines:additionalHeaderLinesOrNil

    "send a get/post request to host.
     If port is not nil, it is a SmallInteger used instead of the default port.
     DocumentUrl may be nil or a String containing the url of the referring document.
     Returns a response-object."

    |host port urlOrPath url httpInterface
     userAndPasswordFromHost userFromHost passwordFromHost
     user password useSSL|

    host := hostOrNil.
    port := portNrOrNil.
    urlOrPath := urlOrPathArg asString.
    useSSL := false.    "until proven otherwise"

    host isEmptyOrNil ifTrue:[
        url := urlOrPath asURL.
        url host isNil ifTrue:[^ HTTPResponse error:#ERROR_badURL ].
        urlOrPath := url requestString ? '/'.
        host := url host.
        port := url port.
        useSSL :=  url scheme = #https.
    ].
    (host includes:$@) ifTrue:[
        userAndPasswordFromHost := host upTo:$@.
        host := host copyFrom:(userAndPasswordFromHost size + 2).
        (userAndPasswordFromHost includes:$:) ifTrue:[
            userFromHost := userAndPasswordFromHost upTo:$:.
            passwordFromHost := userAndPasswordFromHost copyFrom:(userFromHost size + 2).
        ] ifFalse:[
            userFromHost := userAndPasswordFromHost.
        ].
    ].
    user := userOrNil ? userFromHost.
    password := passwordOrNil ? passwordFromHost.

    NameLookupError
        handle:[:ex |            
            self logInfo:'Unknown host.'.
            ^ HTTPResponse error:#ERROR_unknownHost responseText:'Cannot resolve host address: ',host printString.
        ] do:[
            [
                httpInterface := self new.
                (proxySettingsOrNil notNil and:[proxySettingsOrNil useProxy]) ifTrue:[
                    "when using a proxy, we need the full url and not only the path component"    
                    urlOrPath := urlOrPathArg asString.
                    httpInterface proxySettings:proxySettingsOrNil.
                ].
                self logInfo:('connect to %1:%2 (ssl:%3)' bindWith:host with:port with:useSSL).
                httpInterface connectTo:host port:port useSSL:useSSL sslVersion:nil sslSuite:nil.
            ] on:OsError do:[:ex|
                self logInfo:'OsError: ',ex description.
                Logging ifTrue:[
                    thisContext fullPrintAllOn:Transcript.
                ].
                (OSErrorHolder peerFaultSignal handles:ex) ifTrue:[
                    self logInfo:'Unreachable host.'.
                    ^ (HTTPResponse error:#ERROR_unreachableHost) responseText:ex description
                ].
                self logInfo:'No response.'.
                ^ HTTPResponse error:#ERROR_noResponse
            ].
        ].

    httpInterface
        acceptedEncodings:'chunked';
        "/ acceptedEncodings:'gzip';
        "/ acceptedEncodings:'gzip,chunked';
        acceptedLanguages:(Smalltalk languageAndTerritory ? 'en'), ',*';
        acceptedCharsets:'iso-8859-1,utf-8,*';
        acceptedMimeTypes:acceptedMimeTypes;
        contentType:contentType;
        contents:contents;
        destinationFile:destinationFilenameOrNil;
        referer:documentURL;
        cookies:aCollectionOfCookiesOrNil;
        additionalHeaderLines:additionalHeaderLinesOrNil;
        userName:user;
        password:password.

    ^ httpInterface request:getOrPost url:urlOrPath.

    "
     HTTPInterface get:'/' fromHost:'www.exept.de'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'193.141.12.50'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'127.0.0.1'
                   port:nil fromDocument:'http://murks'

     HTTPInterface get:'/' fromHost:'www.iuwqhqipougheorighwpoeghw.de'
                   port:nil fromDocument:'http://murks'
    "

    "Modified: / 12-04-2011 / 09:35:30 / sr"
    "Created: / 10-06-2012 / 16:21:39 / cg"
    "Modified (format): / 25-11-2017 / 22:18:39 / cg"
    "Modified: / 27-08-2018 / 09:26:10 / Claus Gittinger"
!

withProxy:proxySettingsOrNil do:aBlock
    "utility function:
     perform the request through the proxy defined in proxySettingsOrNil"

    ^ HTTPProxyQuery answer:proxySettingsOrNil do:aBlock

    "
     self withProxy:(HTTPProxySettings useHost:'fooBar' port:1234) do:[ HTTPInterface get:'http://www.exept.de' ]

     self withProxy:nil do:[ HTTPInterface get:'http://www.exept.de' ]
    "

    "Created: / 05-10-2011 / 17:36:50 / cg"
! !

!HTTPInterface class methodsFor:'validation'!

validateAStringOnW3Org:aString

    |url aFilename aFilenameFieldName aValueDict response stream|

    url := 'http://validator.w3.org/check?uri='.
    aFilename := 'test.html'.
    aFilenameFieldName := 'uploaded_file'.
    aValueDict := Dictionary new.
    aValueDict at:'' put:''.
    response := self multiPartBoundaryPost:url
            filename:aFilename
            fileNameFieldName:aFilenameFieldName
            contents:aString
            otherValues:nil.

    response isErrorResponse ifTrue:[
        self error:'validation failed'
    ].

    stream := FileStream newTemporaryWithSuffix:'html'.
    stream 
        nextPutAllUtf8:response data;
        close.

    OperatingSystem openApplicationForDocument:stream pathName operation:#open mimeType:'text/html'.
    "/ do not remove, application runs asynchronous"
    "/ stream fileName remove.

"
    self validateAStringOnW3Org:'<html></html>'
"
! !

!HTTPInterface methodsFor:'accessing'!

acceptedCharsets
    ^ acceptedCharsets
!

acceptedCharsets:something
    acceptedCharsets := something.
!

acceptedEncodings
    ^ acceptedEncodings
!

acceptedEncodings:something
    acceptedEncodings := something.
!

acceptedLanguages
    ^ acceptedLanguages
!

acceptedLanguages:something
    acceptedLanguages := something.
!

acceptedMimeTypes
    ^ acceptedMimeTypes
!

acceptedMimeTypes:something
    acceptedMimeTypes := something.
!

additionalHeaderLines
    ^ additionalHeaderLines
!

additionalHeaderLines:something
    additionalHeaderLines := something.
!

bindTo:anIpSocketAddress
    "use anIpSocketAddress as originating IP address"

    bindAddress := anIpSocketAddress.
!

connectTimeout
    "the connectionTimeout in seconds"

    ^ connectTimeout

    "Modified (comment): / 05-10-2011 / 18:12:11 / cg"
!

connectTimeout:something
    "set the connectionTimeout in seconds"

    connectTimeout := something.
!

contentType
    ^ contentType
!

contentType:something
    contentType := something.
!

contents
    ^ contents
!

contents:something
    contents := something.
!

cookies
    ^ cookies

    "Created: / 10-06-2012 / 16:23:17 / cg"
!

cookies:aCollectionOfCookiesOrNil
    "the cookies to send"
    
    cookies := aCollectionOfCookiesOrNil.

    "Created: / 10-06-2012 / 16:23:08 / cg"
    "Modified (comment): / 25-11-2017 / 22:17:19 / cg"
!

destinationFile:aFilename
    "if given, received data will be stored there, instead of being returned
     as string/byteAray. use this for big file transfers"

    destinationFile := aFilename.

    "Modified (comment): / 09-07-2013 / 00:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keepConnection
    ^ keepConnection ? false
!

keepConnection:aBoolean
    "if aBoolean is false, the connection will be closed
     after request is finished.
     If aBoolean is true, the server determines if the connection
     is kept in a connection cache."

    keepConnection := aBoolean.
!

maxContentsLengthForDirectData:anInteger
    "if given, that is the maximum size of received data to be returned directly as
     ByteArray/String. If the received document is larger, it will be stored into a 
     tempfile and that file's name is found in the dataFile slot of the response data.
     If left undefined, a default value (currently 4Mb) is used as a maximum"

    maxContentsLengthForDirectData := anInteger.
!

password
    ^ password
!

password:something
    password := something.
!

proxySettings
    ^ proxySettings
!

proxySettings:something
    proxySettings := something.
!

referer
    "Notice the misspelling - due to the fact that the misspelling made it into
     the HTTP standard"

    ^ referer

    "Modified (comment): / 02-08-2017 / 18:40:35 / cg"
!

referer:something
    "Notice the misspelling - due to the fact that the misspelling made it into
     the HTTP standard"
     
    referer := something.

    "Modified (comment): / 02-08-2017 / 18:40:30 / cg"
!

referrer
    "Notice the misspelling below - due to the fact that the misspelling made it into
     the HTTP standard"

    ^ referer

    "Created: / 02-08-2017 / 18:40:07 / cg"
!

referrer:something
    "Notice the misspelling below - due to the fact that the misspelling made it into
     the HTTP standard"

    referer := something.

    "Created: / 02-08-2017 / 18:40:11 / cg"
!

request:aRequestString
    request := aRequestString
!

socket
    ^ socket

    "Modified: 12.9.1996 / 14:36:31 / cg"
    "Created: 12.9.1996 / 17:10:43 / cg"
!

socket:aSocket
    socket := aSocket

    "Created: 12.9.1996 / 14:36:19 / cg"
    "Modified: 12.9.1996 / 14:36:31 / cg"
!

sslSuite
    ^ sslSuite
!

sslSuite:something
    sslSuite := something.
!

sslVersion
    "the ssl version used (i.e. SSL::SSLProtocolVersion tls12).
     If left undefined, the current default version is used"    

    ^ sslVersion

    "Modified (comment): / 13-06-2018 / 02:32:55 / Claus Gittinger"
!

sslVersion:anSSLProtocolVersionOrNil
    "set the ssl version (i.e. SSL::SSLProtocolVersion tls12).
     If left undefined, the current default version is used"    
     
    sslVersion := anSSLProtocolVersionOrNil.

    "Modified (comment): / 13-06-2018 / 02:32:31 / Claus Gittinger"
!

suppressUnicode:aBoolean
    suppressUnicode := aBoolean.
!

transferTimeout
    "the transferTimeout in seconds"

    ^ transferTimeout

    "Modified (comment): / 05-10-2011 / 18:11:54 / cg"
!

transferTimeout:seconds
    "set the transferTimeout in seconds"

    transferTimeout := seconds
!

userAgent
    ^ userAgent

    "Created: / 16.1.1998 / 09:34:22 / stefan"
!

userAgent:something
    userAgent := something.

    "Created: / 16.1.1998 / 09:34:22 / stefan"
!

userName
    ^ userName
!

userName:something
    userName := something.
! !

!HTTPInterface methodsFor:'helpers'!

acceptString:aStringOrCollection for:what
    |s|

    aStringOrCollection isNil ifTrue:[^ ''].
    aStringOrCollection isString ifTrue:[
        ^ what , ': ' , aStringOrCollection utf8Encoded, CRNL
    ].

    s := ''.
    aStringOrCollection do:[:eachPart |
        s isEmpty ifTrue:[
            s := what , ': ' , eachPart utf8Encoded
        ] ifFalse:[
           s := s , ', ' , eachPart utf8Encoded
        ]
    ].
    ^ s , CRNL

    "
     self new acceptString:nil for:'Accept-Encoding'
     self new acceptString:'gzip' for:'Accept-Encoding'
     self new acceptString:#('gzip') for:'Accept-Encoding'
     self new acceptString:#('gzip' 'tar' 'bzip') for:'Accept-Encoding'
    "
!

authenticationStringForUser:user password:passwd
    |encoded|

    encoded := 'Authorization: Basic ' , (Base64Coder encode:(user , ':' , (passwd?''))), CRNL.
    ^ encoded

"
|s|
s := Base64Coder encode:('ca' , ':' , 'ca').
^ (Base64Coder decode:s) asString
"
!

basicDoRequest:getOrPostOrWhat
    "Send a request and expect a response. Return nil or a response.
     The retrieved data is provided as:
        - destinationFile's contents, if a destinationFile was given
        - direct data (in response data), if the retrieved data is not too big
        - a temporary dataFile, for large files."

    <context: #return>

    |info info2 didReconnect sizeLimit|

    Logging ifTrue:[
        Transcript showCR:'HTTPInterface [info]: Sending:'.
        (request conform:[:ch | ch isPrintable]) ifTrue:[
            Transcript showCR:request.
        ] ifFalse:[
            Transcript showCR:('...%1 binary bytes...' bindWith:request size).
        ].
        Transcript showCR:'----------------------------------------------------'.
    ].

    didReconnect := false.
    Socket streamErrorSignal handle:[:ex |
        self logInfo:ex description.

        self closeSocket.
        "/ reconnect one time ...
        didReconnect ifFalse:[
            self logInfo:'close & reconnect...'.
            (OsError, NameLookupError) handle:[:ex| ] 
                do:[
                    self connect.
                    didReconnect := true.
                    ex restart.
                ].
        ].
        provideTransferInformation ifTrue:[
            TransferInformationSignal raiseRequestWith:'Broken connection...'.
        ].
        ^ ex reject.
    ] do:[
        socket isNil ifTrue:[
            "socket might have been closed by server request (Connection: close).
             Our error handler tries to re-open..."
            Socket writeErrorSignal raiseRequest.
        ].
        provideTransferInformation ifTrue:[
            TransferInformationSignal raiseRequestWith:'Sending request...'.
        ].
        "/ no longer send the initial CRLF - not all servers like it.
        "/ socket nextPutAll:CRNL.

        socket nextPutAll:request.
        provideTransferInformation ifTrue:[
            TransferInformationSignal raiseRequestWith:'Waiting for response...'.
        ].
        info := self getResponse.
        info size == 0 ifTrue:[
            didReconnect ifFalse:[
                socket writeError.
            ]
        ]
    ].

    info size == 0 ifTrue:[
        self logInfo:'Empty response...'.
        provideTransferInformation ifTrue:[
            TransferInformationSignal raiseRequestWith:'Empty Document...'.
        ].
        ^ nil.
    ].

    Logging ifTrue:[
        Transcript showCR:'HTTPInterface [info]: Response:'.
        info do:[:line |
            Transcript showCR:line.
        ].
        Transcript showCR:'----------------------------------------------------'.
    ].

    self extractTransferParametersFromInfo:info.
    response := HTTPResponse new
                        url:(URL method:'http' host:host port:port path:url);
                        setupFromRawHeader:info;
                        mimeType:mimeType;
                        suppressUnicode:suppressUnicode.

    "/ response rawHeader:info.
    response mimeType:mimeType encoding:contentEncoding rawData:nil.

    getOrPostOrWhat == #HEAD ifTrue:[
        ^ response 
    ].

    sizeLimit := maxContentsLengthForDirectData.
    sizeLimit isNil ifTrue:[ sizeLimit := self class maxContentsLengthForDirectData].

    (contentLength isNil 
    or:[ destinationFile notNil
    or:[ contentLength > sizeLimit ]]) ifTrue:[        
        destinationFile notNil ifTrue:[ 
            dataFile := destinationFile.
            dataStream := dataFile newReadWriteStream
        ] ifFalse:[ 
            dataStream := FileStream newTemporary.
            dataFile := dataStream fileName asAutoDeletedFilename.
        ].
        dataStream binary.
    ] ifFalse:[
        data := ByteArray uninitializedNew:contentLength.
    ].

    provideTransferInformation ifTrue:[
        TransferInformationSignal raiseRequestWith:'Receiving Document...'.
    ].

    (self receiveDocument) ifFalse:[
        ^ nil
    ].

    chunked ifTrue:[
"/        Logging true ifTrue:[
"/            Transcript showCR:'care for trailer'
"/        ].
        "/ care for trailer
        info2 := self getResponse.
        info2 notEmptyOrNil ifTrue:[
            info addAll:info2.
            Logging ifTrue:[
                Transcript showCR:'**** as yet untested code (trailer handling) ****'.
            ].
            response setupFromRawHeader:info.
        ].
    ].

"/    Logging ifTrue:[
"/        Transcript showCR:'received all.'
"/    ].

    provideTransferInformation ifTrue:[
        TransferInformationSignal raiseRequestWith:'Done.'.
    ].

    dataStream notNil ifTrue:[
        destinationFile notNil ifTrue:[
            "/ keep the target file
        ] ifFalse:[
            "/ if it turned out to be a small file after all,
            "/ return it as direct data
            dataStream fileSize <= sizeLimit ifTrue:[
                dataStream reset.
                data := dataStream contents.
                dataStream close.
                dataFile remove.
                dataFile := nil.    
            ].
        ].
        dataStream close.
        dataStream := nil.
    ].

    response mimeType:mimeType encoding:contentEncoding rawData:data.
    mimeType notNil ifTrue:[
        ContentTypeInformationSignal raiseRequestWith:mimeType.

        (acceptedMimeTypes isNil
        or:[acceptedMimeTypes contains:[:anyMatchedType | anyMatchedType match:mimeType]]) ifFalse:[
            "/ Transcript showCR:('wrong content mimeType:' , mimeType printString).
            self logInfo:('wrong mimeType error: ' , mimeType).
            WrongContentTypeNotificationSignal 
                raiseRequestWith:mimeType errorString:'Wrong mimeType'.
        ]
    ].

    data isNil ifTrue:[
        response dataFile:dataFile.
        dataFile := nil. "/ now, only a reference from the response object.
    ].

    Logging ifTrue:[
        data notNil ifTrue:[
            Transcript showCR:'HTTPInterface [info]: Data:'.
            Transcript showCR:(response data copyTo:(1000 min:data size)).
        ] ifFalse:[
            Transcript show:'HTTPInterface [info]: DataFile: '.
            Transcript showCR:response dataFile pathName.
        ].
        Transcript cr.
    ].
    ^ response

    "Modified: / 16-01-1998 / 10:11:38 / stefan"
    "Modified: / 24-07-2011 / 08:27:43 / cg"
    "Modified (format): / 19-03-2012 / 13:45:57 / cg"
    "Modified (comment): / 28-09-2017 / 11:50:50 / stefan"
!

close
    self closeSocket
!

closeSocket
    socket notNil ifTrue:[
        socket close.
        socket := nil.
    ].
!

doRequest
    "Send a request and expect a response. Return nil or a response.
     The retrieved data is provided as:
        - destinationFile's contents, if a destinationFile was given
        - direct data (in response data), if the retrieved data is not too big
        - a temporary dataFile, for large files."

    ^ self basicDoRequest:nil

    "Modified: / 16-01-1998 / 10:11:38 / stefan"
    "Modified: / 24-07-2011 / 08:27:43 / cg"
    "Modified (format): / 19-03-2012 / 13:45:57 / cg"
    "Modified (comment): / 28-09-2017 / 11:50:50 / stefan"
!

doRequest:getOrPostOrWhat
    <context: #return>

    |req try postData urlData isGet isHead isPost isPut loggingEnabled|

    loggingEnabled := (Verbose == true) or:[UserPreferences current logHTTPRequests].
    
    isGet := (getOrPostOrWhat = #GET).
    isHead := (getOrPostOrWhat = #HEAD).
    isPost := (getOrPostOrWhat = #POST).
    isPut := (getOrPostOrWhat = #PUT).

    urlData := url.
    contents notEmptyOrNil ifTrue:[
        (isPost or:[isPut]) ifTrue:[
            postData := contents.
        ] ifFalse:[
            urlData := urlData,'?',contents.
        ]
    ].

    provideTransferInformation := TransferInformationSignal isHandled.
    provideTransferProgress := TransferProgressNotificationSignal isHandled.

    USEREL0_9 == true ifTrue:[
        urlData isEmpty ifTrue:[
            urlData := '?'
        ].
        req := getOrPostOrWhat , ' ' , urlData , CRNL.
    ] ifFalse:[
        req := getOrPostOrWhat , ' ' , urlData , ' '
                , (USEREL1_0 == true ifTrue:['HTTP/1.0'] ifFalse:['HTTP/1.1'])
                , CRNL.

        self class maxNumberOfKeptConnections > 0 ifTrue:[
            "/ with HTTP-rel < 1.1, the default is close - need explicit 'Keep-Alive'
            true "(USEREL1_0 == true or:[USEREL0_9 == true])" ifTrue:[
                req := req
"/                      , 'Keep-Alive: timeout=30' , CRNL
                      , 'Connection: Keep-Alive' , CRNL.
            ].
        ] ifFalse:[
            "/ with HTTP-rel >= 1.1, the default is keep - need explicit 'Close'
            (USEREL1_0 == true or:[USEREL0_9 == true]) ifFalse:[
                req := req , 'Connection: Close' , CRNL
            ]
        ].
        userAgent notNil ifTrue:[ req := req , 'User-Agent: ', userAgent , CRNL ].
        req := req , 'Host: ', host.
        port notNil ifTrue:[ req := req , $: , port printString].
        req := req , CRNL.
"/        req := req , 'Pragma: no-cache' , CRNL.
        SuppressReferer ~~ true ifTrue:[
            req := req , (self acceptString:referer for:'Referer').
        ].
        req := req , (self acceptString:acceptedEncodings for:'Accept-Encoding').
        req := req , (self acceptString:acceptedLanguages for:'Accept-Language').
        req := req , (self acceptString:acceptedCharsets for:'Accept-Charset').
        req := req , (self acceptString:acceptedMimeTypes for:'Accept').
        userName notEmptyOrNil ifTrue:[
            req := req , (self authenticationStringForUser:userName password:password).
        ].
        (cookies ? #()) do:[:eachCookie |
            req := req , (eachCookie httpString), CRNL.
        ].
        postData notNil ifTrue:[ req := req , 'Content-Length: ' , postData size printString , CRNL ].
        req := req , (self acceptString:contentType for:'Content-Type').
        additionalHeaderLines notNil ifTrue:[ req := req , additionalHeaderLines ].
        req := req , CRNL.
        postData notNil ifTrue:[ req := req , postData ].
    ].

    doRetry := isGet or:[ isHead ].
    request := req.

    loggingEnabled ifTrue:[
        Transcript showCR:'------------------------------'.
        Transcript showCR:'HTTPInterface [info]: request:'.
        Transcript showCR:request.
    ].

    provideTransferInformation ifTrue:[
        TransferInformationSignal raiseRequestWith:'Sending request...'.
    ].
    RequestInformationSignal new
        request:request;
        originator:self;
        messageText:'Sending request...'; 
        raiseRequest.

    try := 0.
    [
        self basicDoRequest:getOrPostOrWhat.
        response isNil ifTrue:[
            response := HTTPResponse error:#ERROR_noResponse
        ].
    ] on:StreamError do:[:ex |
        ex creator == Socket readErrorSignal ifTrue:[
            self closeSocket.
            Logging ifTrue:[ Transcript showCR:'HTTPInterface [info]: Read error.' ].
            response := HTTPResponse error:#ERROR_readError
        ] ifFalse:[ex creator == Socket writeErrorSignal ifTrue:[
            Logging ifTrue:[ Transcript showCR:'HTTPInterface [info]: write error.'].
            response := HTTPResponse error:#ERROR_writeError.
        ] ifFalse:[
            ex reject.
        ]].
    ] ensure:[
        self socketHandlingAfterRequestWithResponse:response.
    ].

    loggingEnabled ifTrue:[
        Transcript showCR:'------------------------------'.
        Transcript showCR:'HTTPInterface [info]: response:'.
        Transcript showCR:response.
        Transcript showCR:response rawHeader asString.
        Transcript showCR:(response rawData asString contractAtEndTo:512).
    ].
    ^ response

    "Created: / 26-01-2007 / 15:44:59 / cg"
    "Modified: / 10-06-2012 / 16:42:19 / cg"
    "Modified: / 31-01-2017 / 17:04:37 / stefan"
    "Modified: / 27-08-2018 / 09:27:33 / Claus Gittinger"
!

extractTransferParametersFromInfo:info
    canDoRanges := false.
    mimeType := nil.
    contentEncoding := nil.

    info do:[:line |
        |lcLine contentTypeLine|

        lcLine := line asLowercase.

        (lcLine startsWith:'content-length: ') ifTrue:[
            contentLength := Integer readFromString:(line copyFrom:(line indexOf:$:)+1) onError:nil.
        ] ifFalse:[
            (lcLine startsWith:'content-type: ') ifTrue:[
                contentTypeLine := lcLine.
                mimeType := HTMLUtilities extractMimeTypeFromContentType:contentTypeLine.
                contentEncoding := HTMLUtilities extractCharSetEncodingFromContentType:contentTypeLine.
            ] ifFalse:[
                (lcLine startsWith:'accept-ranges: bytes') ifTrue:[
                    canDoRanges := true
                ] ifFalse:[
                    (lcLine startsWith:'transfer-encoding:') ifTrue:[
                        xFerEncoding := (line copyFrom:(line indexOf:$:)+1) withoutSeparators.
                    ]
                ]
            ]
        ].
    ].
!

getResponse
    |responseLines line|

    responseLines := StringCollection new.
    [
        line := [socket nextLine] 
            valueWithWatchDog:[TransferTimeoutNotificationSignal raiseRequest. nil] 
            afterMilliseconds:transferTimeout * 1000.
        line notEmptyOrNil
    ] whileTrue:[
        self logInfo:'received: ',line.
        responseLines add:line.
    ].
    Verbose == true ifTrue:[
        Transcript showCR:'HTTPInterface [info]: response:'.
        Transcript showCR:(responseLines asString).
    ].
    ^ responseLines

    "Modified: / 04-08-2011 / 16:04:14 / sr"
    "Modified: / 20-03-2012 / 21:37:35 / cg"
!

logInfo:arg
    ^ self class logInfo:arg
!

receiveDocument
    |regetSignal anyProgressSinceLastReget numRegets remaining nRead
     info2 numTimeOut nReadNow percentage msg lastProgress
     chunkInfo remainingInChunk t0 tLast t nReadLast deltaT tRemain
     recentBytesTransferedPerSecond overAllBytesTransferedPerSecond buffer|

    dataStream notNil ifTrue:[
        buffer := ByteArray uninitializedNew:(self dataBufferSize).
    ].

    remaining := contentLength.
    t0 := tLast := Timestamp now.
    nRead := nReadLast := 0.
    numTimeOut := 0.

    chunked := xFerEncoding = 'chunked'.
    chunked ifTrue:[
        canDoRanges := false.
    ] ifFalse:[
        (xFerEncoding notNil and:[xFerEncoding includesString:'chunked']) ifTrue:[
            self error:'xFerEncoding includesString chunked or nil'
        ].
    ].

    regetSignal := Signal new.
    (SignalSet
        with:Socket readErrorSignal
        with:regetSignal
    ) handle:[:ex |
        |regetRequest|

        (doRetry and:[canDoRanges]) ifTrue:[
            "/ post a rangeGet ...

            self logInfo:'REGET...'.
            self closeSocket.
            (OsError, NameLookupError) handle:[:ex|
                    self logInfo:'REGET error.'.
                    ^ false
                ] do:[
                    self connect.
                ].
            regetRequest := request copy.
            [regetRequest endsWith:CRNL] whileTrue:[
                regetRequest := regetRequest copyButLast:2.
            ].
            regetRequest := regetRequest , CRNL ,
                            ('Range: bytes=' , nRead printString , '-') ,
                            CRNL ,
                            CRNL.

            socket nextPutAll:regetRequest.

            (info2 := self getResponse) isNil ifTrue:[
                self logInfo:'HTTPInterface [info]: REGET error.'.
                ^ false
            ].
            Logging ifTrue:[
                Transcript showCR:'HTTPInterface [info]: REGET response:'.
                info2 do:[:l | Transcript showCR:l].
                Transcript showCR:'--------------------'.
            ].
            ex restart.
        ].
        ex reject.
    ] do:[
        anyProgressSinceLastReget := false.
        numRegets := 0.
        remainingInChunk := nil.

        [remaining isNil or:[remaining > 0]] whileTrue:[
            [socket readWaitWithTimeout:transferTimeout] whileTrue:[ "/ sr - seconds
                self logInfo:'transfer timeout'.
                canDoRanges ifTrue:[
                    anyProgressSinceLastReget ifFalse:[
                        numRegets := numRegets + 1.
                    ] ifTrue:[
                        numRegets := 0
                    ].
                    numRegets <= 30 ifTrue:[
                        self logInfo:'automatic REGET'.
                        regetSignal raise.
                    ]
                ].
                self logInfo:'timeout.'.
                TransferTimeoutNotificationSignal raiseRequest.
                numTimeOut := numTimeOut + 1.
                numTimeOut > 1 ifTrue:[
                    ^ ReadError
                        raiseRequestWith:self
                        errorString:' : timeout while reading'
                ].
            ].

            (chunked or:[remaining isNil]) ifTrue:[
                (remainingInChunk isNil or:[remainingInChunk == 0]) ifTrue:[
                    chunked ifTrue:[
                        remainingInChunk == 0 ifTrue:[ "/ after first chunk
                            socket next.  "/ skip CR
                            socket next.  "/ skip CR
                        ].
                        chunkInfo := socket upTo:Character return.
                        socket next. "/ skip NL
                        chunkInfo := chunkInfo withoutSeparators.
                        (chunkInfo includes:$;) ifTrue:[
                            chunkInfo := chunkInfo copyTo:(chunkInfo indexOf:$;)-1.
                        ].
                        remainingInChunk := Integer readFrom:chunkInfo radix:16.
                        remainingInChunk == 0 ifTrue:[
                            remaining := 0
                        ]
                    ].
                ].
                remaining == 0 ifTrue:[
                    nReadNow := 0
                ] ifFalse:[
                    remainingInChunk notNil ifTrue:[
                        nReadNow := socket nextAvailableBytes:(buffer size min:remainingInChunk) into:buffer startingAt:1.
                    ] ifFalse:[
                        buffer notNil ifTrue:[
                            nReadNow := socket nextAvailableBytes:(buffer size) into:buffer startingAt:1.
                        ] ifFalse:[
                            nReadNow := socket nextAvailableBytes:(data size) into:data startingAt:1.
                        ].
                        nRead := 0.
                    ].
                ]
            ] ifFalse:[
                buffer notNil ifTrue:[
                    nReadNow := socket nextAvailableBytes:(remaining min:buffer size) into:buffer startingAt:1.
                ] ifFalse:[
                    nReadNow := socket nextAvailableBytes:remaining into:data startingAt:(nRead+1).
                ].
            ].

            nReadNow > 0 ifTrue:[
                dataStream notNil ifTrue:[
                    dataStream nextPutBytes:nReadNow from:buffer startingAt:1
                ].
                anyProgressSinceLastReget := true.
                nRead := nRead + nReadNow.
                remaining isNil ifTrue:[
                    remainingInChunk notNil ifTrue:[
                        remainingInChunk := remainingInChunk - nReadNow.
                    ].
                ] ifFalse:[
                    remaining := remaining - nReadNow.
                ].

                (provideTransferInformation or:[provideTransferProgress]) ifTrue:[
                    contentLength notNil ifTrue:[
                        percentage := nRead * 100 // contentLength.
                    ].

                    t := Timestamp now.
                    deltaT := t millisecondDeltaFrom:tLast.
                    (deltaT >= 1000) ifTrue:[
                        recentBytesTransferedPerSecond := (((nRead - nReadLast) * 1000) / deltaT).
                        tLast := t.
                        nReadLast := nRead.
                    ].
                    deltaT := t millisecondDeltaFrom:t0.
                    (deltaT >= 1000) ifTrue:[
                        overAllBytesTransferedPerSecond := ((nRead * 1000) / (t millisecondDeltaFrom:t0)).
                    ] ifFalse:[
                        overAllBytesTransferedPerSecond := 0.
                    ].

                    provideTransferProgress ifTrue:[
                        TransferProgressNotificationSignal new
                            percentage:percentage ? 0
                            overAllSize:contentLength 
                            transferSize:nRead 
                            transferRate:recentBytesTransferedPerSecond
                            overallTransferRate:overAllBytesTransferedPerSecond;
                            raiseRequest.
                    ].
                    lastProgress := percentage.

                    provideTransferInformation ifTrue:[
                        msg := 'Received ' , (percentage ? 0) printString , '%'.

                        msg := msg , ' (' , (UnitConverter fileSizeStringFor:nRead).

                        contentLength notNil ifTrue:[
                            msg := msg , ' of ' , (UnitConverter fileSizeStringFor:contentLength).
                        ].
                        recentBytesTransferedPerSecond notNil ifTrue:[
                            msg := msg , ' | Rate: ' , (self transferRateStringFor:recentBytesTransferedPerSecond) printString , 'b/s'
                        ].
                        msg := msg , ' | OverAll: ' , (self transferRateStringFor:overAllBytesTransferedPerSecond) printString , 'b/s'.
                        msg := msg , ')'.

                        contentLength notNil ifTrue:[
                            recentBytesTransferedPerSecond notNil ifTrue:[
                                tRemain := TimeDuration fromSeconds:(remaining / overAllBytesTransferedPerSecond "recentBytesTransferedPerSecond") rounded.
                                "/ msg := msg , ' Time Remaining: ' , (tRemain printStringFormat:'%h:%m:%s').
                                "/ msg := msg , (tRemain printStringFormat:'%h:%m:%s'),' remaining'.
                                msg := msg , (tRemain printStringForApproximation),' remaining'.
                            ].
                        ].

                        TransferInformationSignal raiseRequestWith:msg.
                    ].
                ].
            ].

            nReadNow == 0 ifTrue:[
                socket atEnd ifTrue:[
                    remaining isNil ifTrue:[
                        remaining := 0.
                    ].
                    (remaining ~~ 0) ifTrue:[
                        self logInfo:('Short file (Connection broken with ' , remaining printString , ' bytes still to receive.').
                        (doRetry and:[canDoRanges]) ifFalse:[
                            ^ false
                        ].
                        anyProgressSinceLastReget ifFalse:[
                            numRegets := numRegets + 1.
                        ] ifTrue:[
                            numRegets := 0
                        ].
                        numRegets <= 30 ifTrue:[
                            self logInfo:'automatic REGET'.
                            regetSignal raise.
                        ]
                    ]
                ]
            ].
            self logInfo:('received ' , nReadNow printString , ' bytes; remaining: ' , remaining printString).
        ].
    ].
    ^ true

    "Modified: / 29-04-2011 / 19:20:26 / cg"
    "Modified (format): / 04-08-2011 / 16:04:27 / sr"
    "Modified: / 22-06-2018 / 14:21:02 / Claus Gittinger"
!

socketHandlingAfterRequestWithResponse:responseArg
    "cache the connection/socket for future requests.
     Whether we do caching, depends on the returned HTTP response"

    |keep keepStringInHeader toClose hdrInfo info|

    socket isNil ifTrue:[
        "nothing to cache"
        ^ self.
    ].

    keep := self keepConnection.

    keep ifTrue:[
        "consider caching of the connection, but the server has the last word"

        (response isNil
        or:[ (hdrInfo := response headerInfo) isNil ]) ifTrue:[
            keep := false.
        ] ifFalse:[
            self logInfo:(hdrInfo at:'response' ifAbsent:'').
            keepStringInHeader := (hdrInfo at:'connection' ifAbsent:'') asLowercase.
            self logInfo:('keep info is:<' , keepStringInHeader , '>').
        ].

        "/ 1.1 default is to keep (if not told otherwise);
        "/ 1.0 default is to close (if not told otherwise)
        hdrInfo isNil ifTrue:[
            keep := false
        ] ifFalse:[    
            ((hdrInfo at:'response' ifAbsent:'') includesString:'HTTP/1.1') ifTrue:[
                keep := (keepStringInHeader startsWith:'close') not
            ] ifFalse:[
                keep := (keepStringInHeader startsWith:'keep')
            ].
        ].
    ].

    (keep and:[socket isOpen and:[MaxNumberOfKeptConnections notNil]]) ifFalse:[
        KeepAliveConnectionsSema critical:[
            KeepAliveConnections notEmptyOrNil ifTrue:[
                KeepAliveConnections removeAllSuchThat:[:eachKeptSocketInfo|
                    eachKeptSocketInfo socket == socket
                ].
            ].
        ].
        self logInfo:'close socket'.
        self closeSocket.
        ^ self
    ].

    self logInfo:'keep socket'.

    KeepAliveConnectionsSema critical:[
        KeepAliveConnections isNil ifTrue:[
            KeepAliveConnections := OrderedCollection new.
        ] ifFalse:[
            "keep only one connection to the same host/port"
            info := KeepAliveConnections
                        detect:[:eachKeptSocketInfo|
                            eachKeptSocketInfo hostName = host and:[eachKeptSocketInfo port = port]]
                        ifNone:nil.
        ].

        info notNil ifTrue:[
            "cache the newest socket"
            info socket ~~ socket ifTrue:[
                self logInfo:'replace cached socket'.
                info socket close.
                info socket:socket.
                info timeOfLastUse:Timestamp now.
            ].
        ] ifFalse:[
            "add this socket to the cache"
            info := KeptSocketInfo new hostName:host port:port socket:socket.

            KeepAliveConnections addLast:info.
            KeepAliveConnections size > MaxNumberOfKeptConnections ifTrue:[
                self logInfo:'remove an old connection from the cache'.
                toClose := KeepAliveConnections removeFirst.
                toClose socket close.
            ].
        ].
    ]

    "Modified: / 29-03-2007 / 13:17:03 / cg"
!

transferRateStringFor:bytesTransferedPerSecond
    |kb mb|

    bytesTransferedPerSecond < 300 ifTrue:[
        ^ (bytesTransferedPerSecond asFixedPoint:0) printString
    ].
    kb := bytesTransferedPerSecond / 1024.
    kb < 300 ifTrue:[
        ^ (kb asFixedPoint:1) printString , ' K'
    ].
    mb := bytesTransferedPerSecond / 1024 / 1024.
    ^ (mb asFixedPoint:1) printString , ' M'
! !

!HTTPInterface methodsFor:'initialization'!

connect
    |keptConnection errorHolder connected connectHost connectPort socketAddressList|

    port isNil ifTrue:[
        port := useSSL ifTrue:[HttpsPort] ifFalse:[HttpPort].
    ].

    socket notNil ifTrue:[
        KeepAliveConnectionsSema critical:[
            (KeepAliveConnections notEmptyOrNil
             and:[(KeepAliveConnections contains:[:info | info socket == socket]) not]
            ) ifTrue:[
                self logInfo:'close socket'.
                self closeSocket.
            ] ifFalse:[
                self logInfo:'do NOT close socket (is a kept-alive socket)'.
            ]
        ]
    ].

    KeepAliveConnections notEmptyOrNil ifTrue:[
        KeepAliveConnectionsSema critical:[
            keptConnection := KeepAliveConnections
                    detect:[:eachKeptConnectionInfo |
                        (eachKeptConnectionInfo hostName = host)
                         and:[port isNil or:[eachKeptConnectionInfo port = port]]
                    ] ifNone:nil.
            keptConnection notNil ifTrue:[
                KeepAliveConnections remove:keptConnection.
            ].
        ].
        keptConnection notNil ifTrue:[
            socket := keptConnection socket.
            socket isOpen ifTrue:[
                self logInfo:'reuse socket'.
                ^ self
            ].
            self logInfo:'connect: socket is already closed'.
        ] ifFalse:[
            self logInfo:'connect: no reusable socket found'.
        ]
    ].

    TransferInformationSignal raiseRequestWith:'Connecting...'.
    proxySettings notNil ifTrue:[
        connectHost := proxySettings proxyHost.
        connectPort := proxySettings proxyPort.
    ] ifFalse:[
        connectHost := host.
        connectPort := port.
    ].


    "connectHost may resolve to more than a single address. Try all until the first success"
    socketAddressList := SocketAddress allForHostName:connectHost serviceName:connectPort type:#SOCK_STREAM.
    socketAddressList 
        doWithExit:[:eachSocketAddress :exitBlock|
            socket := Socket newTCP.
            [
                bindAddress notNil ifTrue:[
                    socket bindTo:bindAddress.
                ].
                connected := socket 
                                connectTo:eachSocketAddress
                                withTimeout:(connectTimeout ? 10) * 1000.      "milliseconds"
            ] on:Error do:[:ex|
                connected := false.
                Logging ifTrue:[
                    self logInfo:('could not connect to: ' , eachSocketAddress printString , ' error:', ex description).
                ].
            ] ifCurtailed:[
                Logging ifTrue:[
                    self logInfo:('connect aborted to: ' , eachSocketAddress printString).
                ].
                self closeSocket.
                "nothing reached after this point"
            ].
            connected ifTrue:[
                exitBlock value:true.
            ] ifFalse:[
                Logging ifTrue:[
                    self logInfo:('could not connect to: ' , eachSocketAddress printString , ' errno:', socket lastErrorSymbol).
                ].
                socket close.
            ].
        ].

    connected ifFalse:[
        Logging ifTrue:[
            self logInfo:('could not connect (no more tries) to: ' , connectHost printString , ':' , connectPort printString, ' errno:', socket lastErrorSymbol).
        ].
        errorHolder := OperatingSystem errorHolderForNumber:socket lastErrorNumber.
        errorHolder parameter:('could not connect to: ' , connectHost printString , ':' , connectPort printString).
        self closeSocket.
        errorHolder reportError.
        "not reached"
        ^ nil
    ].

    useSSL ifTrue:[
        |peerCertificate|

        SSL::SSLSocket isNil ifTrue:[
            Smalltalk loadPackage:'exept:libcrypt/ssl'.
        ].
        [
            |alerts alert info|
            
            proxySettings notNil ifTrue:[
                "Request a tunnel through the proxy. This is defined in http://www.ietf.org/rfc/rfc2817.txt Sect. 5.2."

                request := ('CONNECT %1:%2 HTTP/1.1' bindWith:host with:port), CRNL,
                           'Proxy-Connection: keep-alive', CRNL, 
                           'Connection: keep-alive', CRNL, 
                           ('Host: %1:%2' bindWith:host with:port), CRNL, CRNL.
                contentLength := 0.     "The response does not contain a content length, but we know that there is no data"
                self doRequest.
                contentLength := nil.
                response isErrorResponse ifTrue:[
                    OpenError raiseWith:socket 
                              errorString:('SSL proxy connect failed via: %1:%2 - %3 (%4)' 
                                            bindWith:connectHost 
                                            with:connectPort 
                                            with:response responseText 
                                            with:response responseCode).
                    ^ nil.
                ].
            ].

            socket := SSL::SSLSocket
                        newOnSocket:socket
                        version:sslVersion     "SSL::SSLProtocolVersion tls11" 
                        suite:sslSuite         "SSL::TlsDheRsaWith3DesEdeCbcSha new"   
                        serverNameIndication:host.       

            connected := socket waitForConnectionUntil: (Timestamp now + (connectTimeout ? 10) seconds).
            connected ifFalse:[
                (alerts := socket alerts) notEmptyOrNil ifTrue:[
                    alert := alerts detectLast:[:alert | alert isFatal] ifNone:[nil].
                ]. 
                alert isNil ifTrue:[
                    info := '?'
                ] ifFalse:[
                    info := alert description
                ].    
                OpenError 
                    raiseRequestWith:socket 
                    errorString:('SSL failed to connect to: %1:%2 (%3)' bindWith:host with:port with:info).
                ^ nil
            ].
            "verify, that the certificate (which is valid) really belongs to the server"
            peerCertificate := socket peerCertificate.
            peerCertificate isNil ifTrue:[
                OpenError raiseRequestWith:socket errorString:'Peer does not provide a valid certificate'.
            ] ifFalse:[
                ((peerCertificate subject valueAt:#cn ifNone:[]) = host
                  or:[(peerCertificate subjectAltNameExtension 
                        ?+ [:ext| ext includesDnsName:host]) == true]) ifFalse:[
                    OpenError raiseRequestWith:socket errorString:('SSL certificate is not for host: ' , peerCertificate subject printString).
                ].
            ].
        ] ifCurtailed:[
            self closeSocket.
        ].
    ].
    socket buffered:false.
    self logInfo:'connect: connected'.
"/    TransferInformationSignal raiseRequestWith:'Connected.'.

    "
     |reply|
     Transcript showCR:(Time millisecondsToRun:[
         |h|

         h := HTTPInterface new 
                connectTo:'exept.de' port:nil
                useSSL:true 
                sslVersion: SSL::SSLProtocolVersion tls11
                sslSuite:SSL::TlsRsaWithAes256CbcSha new.

         reply := h requestGET:'/'.
         h close.
     ]).
     reply inspect.
    "

    "Created: / 16-01-1998 / 09:40:03 / stefan"
    "Modified: / 27-03-2017 / 00:07:58 / cg"
    "Modified: / 28-09-2017 / 11:47:34 / stefan"
    "Modified: / 12-06-2018 / 23:07:48 / Claus Gittinger"
!

connectTo:hostName port:portNrOrNil
    ^ self connectTo:hostName port:portNrOrNil useSSL:(portNrOrNil = 443) sslVersion:nil sslSuite:nil

    "
     |h|

     h := HTTPInterface new connectTo:'exept.de' port:nil.
     Transcript showCR:(h requestGET:'/').
     h close.
    "
!

connectTo:hostName port:portNrOrNil useSSL:sslRequested
    ^ self connectTo:hostName port:portNrOrNil useSSL:sslRequested sslVersion:nil sslSuite:nil

    "
     |h reply|

     h := HTTPInterface new connectTo:'www.google.de' port:nil useSSL:true.
     reply := h requestGET:'/'.
     h close.
     reply inspect.
    "

    "Created: / 16.1.1998 / 09:40:03 / stefan"
    "Modified: / 16.1.1998 / 10:02:10 / stefan"
!

connectTo:hostName port:portNrOrNil useSSL:sslRequested sslVersion:sslProtocolVersionOrNil sslSuite:sslSuiteOrNil

    port := portNrOrNil.
    host := hostName.
    useSSL := sslRequested.
    sslVersion := sslProtocolVersionOrNil.
    sslSuite := sslSuiteOrNil.

    ^ self connect.


    "
     |reply|
     Transcript showCR:(Time millisecondsToRun:[
         |h|

         h := HTTPInterface new 
                connectTo:'exept.de' port:nil
                useSSL:true 
                sslVersion: SSL::SSLProtocolVersion tls11
                sslSuite:SSL::TlsRsaWithAes256CbcSha new.

         reply := h requestGET:'/'.
         h close.
     ]).
     reply inspect.
    "

    "Modified (format): / 13-06-2018 / 02:33:08 / Claus Gittinger"
!

initialize
    useSSL := false.
    suppressUnicode := false.
    connectTimeout  := DefaultConnectTimeout.
    transferTimeout := DefaultTransferTimeout.
    userAgent       := DefaultUserAgent.
    keepConnection  := KeepConnections.

    "
     DefaultUserAgent := 'Mozilla/4.5 [en] (STX)'
     DefaultConnectTimeout  := 30
     DefaultTransferTimeout := 30
    "
! !

!HTTPInterface methodsFor:'queries'!

dataBufferSize
    ^ 16384 * 2
    "/ ^ 16384
!

isConnected
    ^ socket notNil and:[socket isConnected]
! !

!HTTPInterface methodsFor:'release'!

destroy
    socket notNil ifTrue:[
        self logInfo:'close socket'.
        self closeSocket.
    ].
! !

!HTTPInterface methodsFor:'requests'!

request:getOrPostOrDeleteOrWhateverUppercaseHTTPCommand url:urlArg
    "perform any HTTP request, possibly through a proxy"

    url := urlArg.
    ^ self doRequest:getOrPostOrDeleteOrWhateverUppercaseHTTPCommand

    "Created: / 26-01-2007 / 15:46:58 / cg"
!

requestDELETE:args url:urlArg 
    "perform an HTTP DELETE-request"

    contents := args.
    ^ self request:#DELETE url:urlArg

    "Modified: / 05-10-2011 / 18:18:11 / cg"
!

requestGET:urlArg 
    ^ self request:#GET url:urlArg

    "Modified (format): / 05-10-2011 / 18:18:00 / cg"
!

requestHEAD:urlArg 
    ^ self request:#HEAD url:urlArg

    "Modified (format): / 05-10-2011 / 18:17:45 / cg"
!

requestPOST:args url:urlArg 
    contents := args.
    ^ self request:#POST url:urlArg.

    "Modified: / 26-01-2007 / 15:47:27 / cg"
    "Modified (format): / 05-10-2011 / 18:17:34 / cg"
!

requestPUT:args url:urlArg 
    contents := args.
    ^ self request:#PUT url:urlArg .

    "Modified: / 26-01-2007 / 15:50:13 / cg"
    "Modified (format): / 05-10-2011 / 18:17:24 / cg"
! !

!HTTPInterface methodsFor:'requests - obsolete backward compatibility'!

request:getOrPost url:urlArg
        acceptedEncodings:acceptedEncodingsArg
        acceptedLanguages:acceptedLanguagesArg
        acceptedCharsets:acceptedCharsetsArg
        acceptedMimeTypes:acceptedMimeTypesArg
        additionalHeaderLines:additionalHeaderLinesArg
        contentType:contentTypeArg
        contents:contentsArg
        from:currentURL
    <resource: #obsolete>

    acceptedEncodings := acceptedEncodingsArg.
    acceptedLanguages := acceptedLanguagesArg.
    acceptedCharsets := acceptedCharsetsArg.
    acceptedMimeTypes := acceptedMimeTypesArg.
    additionalHeaderLines := additionalHeaderLinesArg.
    contentType := contentTypeArg.
    contents := contentsArg.
    referer := currentURL.
    url := urlArg.

    ^ self doRequest:getOrPost

    "Modified: / 26-01-2007 / 15:54:13 / cg"
!

request:getOrPost url:urlArg
        acceptedEncodings:acceptedEncodingsArg
        acceptedLanguages:acceptedLanguagesArg
        acceptedCharsets:acceptedCharsetsArg
        acceptedMimeTypes:acceptedMimeTypesArg
        additionalHeaderLines:additionalHeaderLinesArg
        contentType:contentTypeArg
        contents:contentsArg
        from:refererArg
        userName:userNameArg password:passwordArg
    <resource: #obsolete>

    acceptedEncodings := acceptedEncodingsArg.
    acceptedLanguages := acceptedLanguagesArg.
    acceptedCharsets := acceptedCharsetsArg.
    acceptedMimeTypes := acceptedMimeTypesArg.
    additionalHeaderLines := additionalHeaderLinesArg.
    contentType := contentTypeArg.
    contents := contentsArg.
    referer := refererArg.
    url := urlArg.
    userName := userNameArg.
    password := passwordArg.

    ^ self doRequest:getOrPost

    "Modified: / 26-01-2007 / 15:55:31 / cg"
!

request:getOrPost url:urlArg
        acceptedEncodings:acceptedEncodingsArg
        acceptedLanguages:acceptedLanguagesArg
        acceptedCharsets:acceptedCharsetsArg
        acceptedMimeTypes:acceptedMimeTypesArg
        from:refererArg
    <resource: #obsolete>

    acceptedEncodings := acceptedEncodingsArg.
    acceptedLanguages := acceptedLanguagesArg.
    acceptedCharsets := acceptedCharsetsArg.
    acceptedMimeTypes := acceptedMimeTypesArg.
    referer := refererArg.
    url := urlArg.

    ^ self doRequest:getOrPost

    "Modified: / 26-01-2007 / 15:56:05 / cg"
!

request:getOrPost url:urlArg
        acceptedEncodings:acceptedEncodingsArg
        acceptedLanguages:acceptedLanguagesArg
        acceptedCharsets:acceptedCharsetsArg
        acceptedMimeTypes:acceptedMimeTypesArg
        from:refererArg
        userName:userNameArg password:passwordArg
    <resource: #obsolete>

    acceptedEncodings := acceptedEncodingsArg.
    acceptedLanguages := acceptedLanguagesArg.
    acceptedCharsets := acceptedCharsetsArg.
    acceptedMimeTypes := acceptedMimeTypesArg.
    referer := refererArg.
    url := urlArg.
    userName := userNameArg.
    password := passwordArg.

    ^ self doRequest:getOrPost

    "Modified: / 26-01-2007 / 15:56:43 / cg"
!

requestGET:url accept:acceptedMimeTypes
    <resource: #obsolete>
    "Get url."

    ^ self requestGET:url accept:acceptedMimeTypes from:nil
!

requestGET:url accept:acceptedMimeTypes from:currentURL
    <resource: #obsolete>
    "Get url. If currentUrl is not nil, this is the referer"

    ^ self requestGET:url accept:acceptedMimeTypes from:currentURL userName:nil password:nil

    "Modified: / 26-01-2007 / 15:48:46 / cg"
!

requestGET:url accept:acceptedMimeTypes from:currentURL userName:user password:passwd
    <resource: #obsolete>
    "Get url. If currentUrl is not nil, this is the referer"

    ^ self
        request:'GET' url:url
        acceptedEncodings:'chunked'
        acceptedLanguages:'en,*'
        acceptedCharsets:'iso-8859-1,*,utf-8'
        acceptedMimeTypes:acceptedMimeTypes
        from:currentURL
        userName:user password:passwd

    "Modified: / 26-01-2007 / 15:48:42 / cg"
!

requestGET:urlArg from:refererString
    <resource: #obsolete>
    "Get url. If referer is not nil, this is the referer.
     Notice the wrong spelling of referer, which made it into the W3C standard;
     written this way to make searching easier."

    referer := refererString.
    ^ self requestGET:urlArg

    "Modified: / 26-01-2007 / 15:48:16 / cg"
    "Modified (comment): / 07-08-2017 / 17:11:23 / cg"
! !

!HTTPInterface::HTTPCookie methodsFor:'accessing'!

name
    ^ name
!

name:something
    name := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!HTTPInterface::HTTPCookie methodsFor:'printing'!

httpString
    ^ 'Cookie: ' , name , '=', value

    "Created: / 10-06-2012 / 16:31:31 / cg"
! !

!HTTPInterface::HTTPResponse class methodsFor:'instance creation'!

error:errCode
    "create a synthetic error response.
     Done for errors happening here (i.e. not generated by a contacted server);
     for example: unknown host, etc."
     
    ^ self error:errCode responseText:nil

    "Created: / 17.4.1998 / 19:19:55 / cg"
!

error:errCode responseText:textOrNil
    "create a synthetic error response.
     Done for errors happening here (i.e. not generated by a contacted server);
     for example: unknown host, etc."
     
    |res|

    res := self new.
    errCode isNumber ifTrue:[
        res
            response:#Error;
            responseCode:errCode.
    ] ifFalse:[
        res 
            response:errCode;
            responseCode:(HTTPInterface numericReturnCodeForSymbol:errCode);
            responseText:errCode.
    ].
    textOrNil notNil ifTrue:[
        res responseText:textOrNil
    ].    
    ^ res

    "Created: / 17.4.1998 / 19:19:55 / cg"
! !

!HTTPInterface::HTTPResponse methodsFor:'Compatibility-Squeak'!

contents
    "for squeak ZnRequest compatibility"

    ^ self data

    "Created: / 20-06-2018 / 07:18:45 / Claus Gittinger"
!

headers
    "for squeak ZnRequest compatibility"

    ^ self rawHeader

    "Created: / 20-06-2018 / 07:19:17 / Claus Gittinger"
!

status
    "for squeak ZnRequest compatibility"

    ^ self responseCode

    "Created: / 20-06-2018 / 07:19:05 / Claus Gittinger"
! !

!HTTPInterface::HTTPResponse methodsFor:'accessing'!

contentType
    ^ mimeType
!

contentType:something
    mimeType := something.
!

data
    "return the data converted to a string and decoded by the encoding.
     If you need the undecoded bytes, please use #rawData"

    data notNil ifTrue:[^ data].

    rawData notNil ifTrue:[
        data := rawData.
        (headerInfo at:#'content-transfer-encoding' ifAbsent:'') = 'gzip' ifTrue:[
            data := (ZipStream readOpenOn:data readStream suppressHeaderAndChecksum:true) contents.
        ].
"/        (encoding isNil 
"/         and:[(MIMETypes mimeTypeFromString:mimeType) isTextType not]) ifTrue:[
"/           ^ data
"/        ].
        (encoding isNil or:[encoding = #'iso-8859-1']) ifTrue:[
            data := data asString.
            ^ data
        ].
        encoding = #'utf-8' ifTrue:[
            suppressUnicode == true ifTrue:[
                data := data utf8DecodedWithTwoByteCharactersReplacedBy:(Character value:16rFF).
            ] ifFalse:[
                data := data utf8Decoded.
            ].
            ^ data
        ].
        data := CharacterEncoder decodeString:data from:encoding.
    ].
    ^ data

    "Modified: / 05-03-2018 / 15:26:51 / stefan"
!

data:something
    data := something.

    "Created: / 23.1.1998 / 12:29:04 / cg"
!

dataFile
    ^ dataFile
!

dataFile:something
    dataFile := something.
!

dataFromFileOrData
    "returns the data either from the data file (which is used if too big) or data directly"

    data notNil ifTrue:[
        ^ data.
    ].

    dataFile notNil ifTrue:[
        rawData := dataFile contentsOfEntireFile.
        "convert it in the #data method"
    ].

    ^ self data
!

dataStream
    "in preparation for a future stream interface (i.e. not loading the data into memory
     and returning it, but instead return a stream directly reading from the socket),
     use this interface. 
     However, it is currently not yet avoiding big garbage data in memory."

    |stream|

    dataFile isNil ifTrue:[
        stream := rawData readStream.
    ] ifFalse:[
        stream := dataFile readStream.
    ].

    (headerInfo at:#'content-encoding' ifAbsent:'') = 'gzip' ifTrue:[
        stream := ZipStream readOpenOn:stream suppressHeaderAndChecksum:true.
        stream propagateClose:true.         "close the stream when ZipStream is closed"
    ].
    ((encoding isNil or:[encoding = #'iso-8859-1'])
     and:[stream contentsSpecies == String]) ifTrue:[   "/ take care of ByteStreams
        ^ stream
    ].
    ^ EncodedStream stream:stream encoding:encoding.

    "Modified (format): / 10-01-2018 / 21:30:42 / stefan"
!

encoding
    ^ encoding
!

encoding:something
    encoding := something.
!

headerInfo
    ^ headerInfo

    "Created: / 23.1.1998 / 12:29:04 / cg"
!

headerInfo:something
    headerInfo := something.

    "Created: / 23.1.1998 / 12:29:04 / cg"
!

headerInfoAt:aKeyString
    "get the header info for aKeyString (alway lower case)"

    ^ headerInfo at:aKeyString ifAbsent:[].
!

mimeType
    ^ mimeType
!

mimeType:something
    mimeType := something.
!

mimeType:mimeTypeArg encoding:encodingArg data:dataArg
    "/ soon obsolete
    mimeType := mimeTypeArg.
    encoding := encodingArg.
    data := dataArg.
!

mimeType:mimeTypeArg encoding:encodingArg rawData:dataArg
    mimeType := mimeTypeArg.
    encoding := encodingArg.
    rawData := dataArg.
!

rawData
    "return the data as bytes, as they were received (no decoding by character set, etc)"

    ^ rawData

    "Modified (comment): / 29-06-2018 / 16:43:34 / Claus Gittinger"
!

rawData:aByteArray
    rawData := aByteArray.
!

rawHeader
    ^ rawHeader

    "Created: / 23.1.1998 / 12:29:04 / cg"
!

rawHeader:something
    rawHeader := something.

    "Created: / 23.1.1998 / 12:29:04 / cg"
!

rawHeader:rawHeaderString infoHeader:parsedheader data:dataBytes
    rawHeader := rawHeaderString.
    headerInfo := parsedheader.
    data := dataBytes.

    "Created: / 23.1.1998 / 12:32:17 / cg"
!

response
    ^ response

    "Created: / 23.1.1998 / 13:13:13 / cg"
!

response:something
    response := something.

    "Created: / 23.1.1998 / 13:13:13 / cg"
!

responseCode
    ^ responseCode

    "Created: / 23.1.1998 / 12:46:10 / cg"
!

responseCode:anInteger
    "/ anInteger >= 500 ifTrue:[self breakPoint:#cg].
    responseCode := anInteger.

    "Created: / 23.1.1998 / 12:46:10 / cg"
!

responseText
    "answer the text returned with the response, or the empty string"

    ^ responseText ? ''         

    "Created: / 23.1.1998 / 12:50:04 / cg"
!

responseText:something
    responseText := something.

    "Created: / 23.1.1998 / 12:50:04 / cg"
!

suppressUnicode
    ^ suppressUnicode
!

suppressUnicode:aBoolean
    "set this to true to return only single-byte strings as data"

    suppressUnicode := aBoolean.
!

url
    ^ url
!

url:something
    url := something.
! !

!HTTPInterface::HTTPResponse methodsFor:'inspecting'!

inspectorExtraAttributes
    ^ super inspectorExtraAttributes
        add:'-header (raw)'       -> [ rawHeader asString ];
        add:'-data (raw)'         -> [ rawData asString ];
        yourself
! !

!HTTPInterface::HTTPResponse methodsFor:'parsing'!

setupFromRawHeader:rawHeaderArg
    |lines info s code idx|

    rawHeader := rawHeaderArg.
    lines := rawHeader asStringCollection.
    info := Dictionary new.

    lines keysAndValuesDo:[:nr :line |
        (nr == 1 and:[line startsWith:'HTTP/']) ifTrue:[
            info at:'response' put:line.
            s := line readStream.
            s skipThrough:Character space.
            s skipSpaces.
            code := Integer readFrom:s onError:nil.
            self responseCode:code.
            self response:(HTTPInterface symbolForReturnCode:code).
            s skipSpaces.
            self responseText:(s upToEnd)
        ].

        idx := line indexOf:$:.
        idx ~~ 0 ifTrue:[
            info
                at:(line copyTo:idx-1) withoutSeparators asLowercase
                put:(line copyFrom:idx+1) withoutSeparators
        ]
    ].
    (info includesKey:'set-cookie') ifTrue:[
        HTTPInterface cookieStoreRequestSignal raiseRequestWith:(info at:'set-cookie')
    ].

    self headerInfo:info.

    "Created: / 23.1.1998 / 12:46:02 / cg"
    "Modified: / 23.1.1998 / 13:14:12 / cg"
! !

!HTTPInterface::HTTPResponse methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:self class name.
    aStream nextPut:$(.
    responseCode printOn:aStream.
    aStream nextPut:$-.
    responseText printOn:aStream.
    aStream nextPut:$).

    "Modified: / 02-01-2018 / 18:06:37 / stefan"
! !

!HTTPInterface::HTTPResponse methodsFor:'queries'!

date
    |dateString|

    dateString := headerInfo at:'date' ifAbsent:[^ nil].
    ^ Timestamp readRFC1123FormatFrom:dateString onError:nil.
!

expires
    |dateString|

    dateString := headerInfo at:'expires' ifAbsent:[^ nil].
    ^ Timestamp readRFC1123FormatFrom:dateString onError:nil.
!

isErrorResponse
    "return true, if this is an error-response"

    "/ ^ response == #Error or:[responseCode notNil and:[responseCode >= 500]]
    ^ response == #Error or:[responseCode notNil and:[responseCode >= 400]]

    "Modified: / 14.4.1998 / 18:01:54 / cg"
    "Created: / 17.4.1998 / 19:18:31 / cg"
!

isFileErrorResponse
    "return true, if this is a file-error-response"

    ^ responseCode notNil and:[responseCode >= 400]
!

isMovedResponse
    ^ response == #'MOVED_TEMP'
       or:[response == #'MOVED_PERM'
       or:[response == #'SEE_OTHER']]

    "Created: / 23.1.1998 / 13:40:00 / cg"
    "Modified: / 14.4.1998 / 18:01:54 / cg"
!

location
    ^ headerInfo at:'location' ifAbsent:nil

    "Created: / 23.1.1998 / 13:42:02 / cg"
! !

!HTTPInterface::KeptSocketInfo methodsFor:'accessing'!

hostName
    ^ hostName
!

hostName:hostNameArg port:portArg socket:socketArg
    hostName := hostNameArg.
    port := portArg.
    socket := socketArg.
    timeOfLastUse := Timestamp now.
!

port
    ^ port
!

socket
    ^ socket
!

socket:aSocket
    socket := aSocket.
!

timeOfLastUse
    ^ timeOfLastUse
!

timeOfLastUse:aTimestamp
    timeOfLastUse := aTimestamp.
! !

!HTTPInterface::RequestInformationSignal class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HTTPInterface::RequestInformationSignal methodsFor:'accessing'!

request
    ^ parameter
!

request:something
    parameter := something.
! !

!HTTPInterface::TransferProgressNotificationSignal class methodsFor:'documentation'!

documentation
"
    raised during a document fetch to possibly tell the user about the progress made.
    Provides both an (english) message and individual values.
    Usually this is shown by a UI in an info area (at the bottom of a window)
"
! !

!HTTPInterface::TransferProgressNotificationSignal methodsFor:'accessing'!

overAllSize
    "return the value of the instance variable 'overAllSize' (automatically generated)"

    ^ overAllSize
!

overAllSize:something
    "set the value of the instance variable 'overAllSize' (automatically generated)"

    overAllSize := something.
!

overallTransferRate
    "the overall xfer rate"

    ^ overallTransferRate
!

overallTransferRate:bytesPerSecond
    "the overall xfer rate"

    overallTransferRate := bytesPerSecond.
!

percentage
    ^ parameter
!

percentage:percentage overAllSize:overAllSizeArg transferSize:transferSizeArg transferRate:transferRateArg
    "set instance variables (automatically generated)"

    parameter := percentage.
    overAllSize := overAllSizeArg.
    transferSize := transferSizeArg.
    transferRate := transferRateArg.
!

percentage:percentage overAllSize:overAllSizeArg transferSize:transferSizeArg transferRate:transferRateArg overallTransferRate:overallTransferRateArg
    "set instance variables (automatically generated)"

    parameter := percentage.
    overAllSize := overAllSizeArg.
    transferSize := transferSizeArg.
    transferRate := transferRateArg.
    overallTransferRate := overallTransferRateArg.
!

transferRate
    "the current (recent) xfer rate"

    ^ transferRate
!

transferRate:bytesPerSecond
    "the current (recent) xfer rate"

    transferRate := bytesPerSecond.
!

transferSize
    "return the value of the instance variable 'transferSize' (automatically generated)"

    ^ transferSize
!

transferSize:something
    "set the value of the instance variable 'transferSize' (automatically generated)"

    transferSize := something.
! !

!HTTPInterface class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPInterface.st,v 1.276 2018-08-27 07:37:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPInterface.st,v 1.276 2018-08-27 07:37:54 cg Exp $'
! !


HTTPInterface initialize!
