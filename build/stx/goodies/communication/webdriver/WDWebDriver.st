"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WDWebDriver
	instanceVariableNames:'sessionID session exceptions serverHost serverPort platform
		connectTimeout requestTimeout serverServicePath baseDriverURL'
	classVariableNames:'ServerHost ServerPort'
	poolDictionaries:''
	category:'WebDriver-Core-Base-Drivers'
!

WDWebDriver comment:'A web driver'
!

!WDWebDriver class methodsFor:'documentation'!

documentation
"
    A webDriver (client) interface.    

    [author:]
        Original from Squeak by Torsten Bergmann
        Adapted to ST/X and enhanced by Claus Gittinger

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!WDWebDriver class methodsFor:'instance creation'!

new
        ^ self withCapabilities: self defaultDesiredCapabilities

    "Modified (format): / 21-06-2018 / 08:57:45 / Claus Gittinger"
!

withCapabilities: capabilities

	^ self basicNew initWithCapabilities: capabilities
! !

!WDWebDriver class methodsFor:'accessing'!

serverHost

	^ ServerHost ifNil: [ self defaultServerHost ]
!

serverHost: hostName

	ServerHost := hostName
!

serverPort

	^ ServerPort ifNil: [ self defaultServerPort ]
!

serverPort: portNumber

	ServerPort := portNumber
! !

!WDWebDriver class methodsFor:'defaults'!

defaultConnectTimeout
    ^ 5 "/ seconds

    "Created: / 16-07-2018 / 17:09:26 / Claus Gittinger"
!

defaultDesiredCapabilities 

	^WDDesiredCapabilities firefox 
!

defaultRequestTimeout
    ^ 10 "/ seconds

    "Created: / 16-07-2018 / 17:09:38 / Claus Gittinger"
!

defaultServerHost
	"Returns the default server host"
	
	^'127.0.0.1'
!

defaultServerPort
	"Returns the default server port"
	
	^9515
! !

!WDWebDriver methodsFor:'accessing'!

connectTimeout:something
    connectTimeout := something.
!

requestTimeout:something
    requestTimeout := something.
!

serverHost
    serverHost notNil ifTrue:[^ serverHost].
    ^ self class serverHost

    "Created: / 21-06-2018 / 08:57:03 / Claus Gittinger"
!

serverHost:aHostNameOrNilForDefault
    serverHost := aHostNameOrNilForDefault.
    baseDriverURL := nil.

    "Created: / 21-06-2018 / 08:57:31 / Claus Gittinger"
    "Modified: / 19-07-2018 / 00:40:08 / Claus Gittinger"
!

serverPort
    serverPort notNil ifTrue:[^ serverPort].
    ^ self class serverPort

    "Created: / 21-06-2018 / 08:57:07 / Claus Gittinger"
!

serverPort:aPortNrOrNilForDefault
    serverPort := aPortNrOrNilForDefault.
    baseDriverURL := nil.

    "Created: / 21-06-2018 / 08:57:19 / Claus Gittinger"
    "Modified: / 19-07-2018 / 00:40:15 / Claus Gittinger"
!

serverServicePath
    "/ ^ serverServicePath ? '/wd/hub'
    ^ serverServicePath ? '/'

    "Created: / 16-07-2018 / 21:19:57 / Claus Gittinger"
!

serverServicePath:aRelativePath
    "by default, this should be something like
        /wd/hub/
     or 
        /
     depending on how the rest service is configured"

    (aRelativePath endsWith:'/') ifFalse:[ 
        serverServicePath := aRelativePath,'/'
    ] ifTrue:[
        serverServicePath := aRelativePath
    ].
    baseDriverURL := nil.

    "Created: / 16-07-2018 / 21:21:02 / Claus Gittinger"
    "Modified: / 19-07-2018 / 00:40:22 / Claus Gittinger"
!

serviceURL:aURLString
    baseDriverURL := aURLString.

    "Created: / 20-07-2018 / 03:16:17 / Claus Gittinger"
!

session
	^ session
! !

!WDWebDriver methodsFor:'api'!

alertText
        "Gets the text of the currently displayed JavaScript alert(), confirm(), or prompt() dialog."
        
        ^ self valueFromRequest:'/alert_text'

    "Modified: / 21-07-2018 / 13:11:07 / Claus Gittinger"
!

applicationCacheStatus
        "Get the status of the html5 application cache."
        
        ^ self valueFromRequest:'/application_cache/status'

    "Modified: / 21-07-2018 / 13:11:17 / Claus Gittinger"
!

logFor: aLogType
	"Get the log for a given log type. Log buffer is reset after each request."
	
	^self
		httpPostHandleResponse: self baseSessionURL , '/log'
		jsonData:
			(Dictionary new
				at: 'type' put: aLogType;
				yourself)
!

logTypes
        "Get available log types"
        
        ^ self valueFromRequest:'/log/types'

    "Modified: / 21-07-2018 / 13:11:26 / Claus Gittinger"
!

quit
	^self handleResponse: (self httpDelete: self baseSessionURL)
!

screenshot
    "Take a screenshot of the current page. 
     Returns the screenshot as a base64 encoded PNG."

    ^ self valueFromRequest:'/screenshot'

    "Modified: / 21-07-2018 / 13:11:39 / Claus Gittinger"
!

screenshotForm
    Smalltalk isSmalltalkX ifTrue:[
        ^ PNGReader 
            fromStream:((Base64Coder decode:self screenshot readStream) readStream).
    ] ifFalse:[
        ^ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self screenshot readStream)
    ].

    "Modified: / 18-07-2018 / 12:56:52 / Claus Gittinger"
!

sessions
	^ self
		httpGetHandleResponse: self baseSessionsURL
		onSuccess:
			[ :json | 
			(self jsonRead: json)
				at: #value
				ifPresent: [ :el | el collect: [ :each | WDSession fromDictionary: each ] ]
				ifAbsent: [ #() ] ]
		onFailure: [ ^ #() ]
!

source
        "Get the current page source."
        
    ^ self valueFromRequest:'/source'

    "Modified: / 21-07-2018 / 13:11:47 / Claus Gittinger"
!

status
	^ self
		httpGetHandleResponse: self baseStatusURL
		onSuccess: [ :answer | WDServerStatus fromDictionary: (self platform jsonRead: answer) ]
		onFailure: [ :response | WDStatusNotAvailableException signal ]
!

title
    ^ self valueFromRequest:'/title'

    "Modified: / 21-07-2018 / 13:11:56 / Claus Gittinger"
!

windowHandle
    "Retrieve the current window handle."
        
    ^ self valueFromRequest:'/window_handle'

    "Modified (format): / 21-07-2018 / 13:12:31 / Claus Gittinger"
!

windowHandles
    "Retrieve the list of all window handles available to the session"
        
    ^ self valueFromRequest:'/window_handles'

    "Modified (format): / 21-07-2018 / 13:12:26 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'api - cookies'!

cookies
        "Retrieve all cookies visible to the current page."
        
        ^ (self
                httpGetHandleResponse: self baseSessionURL , '/cookie'
                onSuccess: [ :json | self jsonReadValueFrom: json ])
                        collect: [:each | WDCookie fromDictionary: each ]

    "Modified (format): / 21-07-2018 / 13:05:38 / Claus Gittinger"
!

deleteCookies
	"Delete all cookies visible to the current page."
	
	^ self
		handleResponse: (self httpDelete: self baseSessionURL , '/cookie')
		 
! !

!WDWebDriver methodsFor:'api - elements'!

activeElement
	"Get the element on the page that currently has focus. The element will be returned as a WebElement JSON object."

	^ self handleResponse: (self httpPost: self baseSessionURL , '/element/active')
!

elementWithClassName: className
	^ [ self
		httpPostHandleResponse: self baseSessionURL , '/element'
		jsonData:
			(Dictionary new
				at: 'using' put: 'class name';
				at: 'value' put: className;
				yourself) ]
		on: WDNoSuchElementException
		do: [ nil ]
!

elementWithId:anID
    ^ [ self
            httpPostHandleResponse: self baseSessionURL , '/element'
            jsonData:
                    (Dictionary new
                            at: 'using' put: 'id';
                            at: 'value' put: anID;
                            yourself) ]
            on: WDNoSuchElementException
            do: [ nil ]

    "Modified (format): / 22-07-2018 / 02:14:28 / Claus Gittinger"
!

elementWithTagName: tagName
	^ [ self
		httpPostHandleResponse: self baseSessionURL , '/element'
		jsonData:
			(Dictionary new
				at: 'using' put: 'tag name';
				at: 'value' put: tagName;
				yourself) ]
		on: WDNoSuchElementException
		do: [ nil ]
!

elementsWithClassName: className
	^ [ self
		httpPostHandleResponse: self baseSessionURL , '/elements'
		jsonData:
			(Dictionary new
				at: 'using' put: 'class name';
				at: 'value' put: className;
				yourself) ]
		on: WDNoSuchElementException
		do: [ nil ]
!

elementsWithTagName: tagName
        ^ [ self
                httpPostHandleResponse: self baseSessionURL , '/elements'
                jsonData:
                        (Dictionary new
                                at: 'using' put: 'tag name';
                                at: 'value' put: tagName;
                                yourself) ]
                on: WDNoSuchElementException
                do: [ nil ]

    "Created: / 22-07-2018 / 08:19:57 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'api - geolocation'!

location
        "Get the current geo location."
        
        ^ self valueFromRequest:'/local_storage/location'

    "Modified: / 21-07-2018 / 13:10:27 / Claus Gittinger"
!

locationLatitude: latitude longitude: longitude altitude: altitude
	^ self
		httpPostHandleResponse: self baseSessionURL , '/location'
		jsonData:
			(Dictionary new
				at: 'location'
					put:
					(Dictionary new
						at: 'latitude' put: latitude;
						at: 'longitude' put: longitude;
						at: 'altitude' put: altitude;
						yourself);
				yourself)
! !

!WDWebDriver methodsFor:'api - local storage'!

localStorage
        "Get all keys of the storage."
        
        ^ self valueFromRequest:'/local_storage'

    "Modified: / 21-07-2018 / 13:09:56 / Claus Gittinger"
!

localStorageAt: key put: value
	"Set the storage item for the given key."
	
	^self
		httpPostHandleResponse: self baseSessionURL , '/local_storage'
		jsonData:
			(Dictionary new
				at: 'key' put: key;
				at: 'value' put: value;
				yourself)
!

localStorageAtKey: key 
        "Get the storage item for the given key"
        
        ^ self valueFromRequest:'/local_storage/key/', key

    "Modified: / 21-07-2018 / 13:10:07 / Claus Gittinger"
!

localStorageClear
	"Clear the storage."
	
	^self
		handleResponse: (self httpDelete: self baseSessionURL , '/local_storage')
		 
!

localStorageDeleteKey: key 
	"Remove the storage item for the given key."
	
	^ self
		handleResponse: (self httpDelete: self baseSessionURL , '/local_storage/key/', key)
	 
!

localStorageSize
        "Get the number of items in the storage."
        
        ^ self valueFromRequest:'/local_storage/size'

    "Modified: / 21-07-2018 / 13:10:18 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'api - navigation'!

back
	"Navigate backwards in the browser history, if possible."

	^ self handleResponse: (self httpPost: self baseSessionURL , '/back')
!

forward
	"Navigate forwards in the browser history, if possible."
	
	^ self handleResponse: (self httpPost: self baseSessionURL , '/forward')
!

refresh
	"Navigate forwards in the browser history, if possible."
	
	^ self handleResponse: (self httpPost: self baseSessionURL , '/refresh')
!

url
        "Retrieve the URL of the current page."
        
        ^ self valueFromRequest:'/url'

    "Modified: / 21-07-2018 / 13:09:39 / Claus Gittinger"
!

url: urlString
	self
		httpPostHandleResponse: self baseSessionURL , '/url'
		jsonData:
			(Dictionary new
				at: 'url' put: urlString;
				yourself)
! !

!WDWebDriver methodsFor:'api - orientation'!

orientation
        "Get the current browser orientation. The server should return a valid orientation value as defined in ScreenOrientation: {LANDSCAPE|PORTRAIT}."
        
        ^ self valueFromRequest:'/orientation'

    "Modified: / 21-07-2018 / 13:09:29 / Claus Gittinger"
!

orientation: orientation   
	"Set the browser orientation. The orientation should be specified as defined in ScreenOrientation: {LANDSCAPE|PORTRAIT}."
	
	^self
		httpPostHandleResponse: self baseSessionURL , '/orientation'
		jsonData:
			(Dictionary new
				at: 'orientation' put: orientation ;
				yourself)
!

setLandscape

	^self orientation: 'LANDSCAPE'
!

setPortrait

	^self orientation: 'PORTRAIT'
! !

!WDWebDriver methodsFor:'api - session storage'!

sessionStorage
        "Get all keys of the storage."
        
        ^ self valueFromRequest:'/session_storage'

    "Modified: / 21-07-2018 / 13:08:47 / Claus Gittinger"
!

sessionStorageAt: key put: value
	"Set the storage item for the given key."
	
	^self
		httpPostHandleResponse: self baseSessionURL , '/session_storage'
		jsonData:
			(Dictionary new
				at: 'key' put: key;
				at: 'value' put: value;
				yourself)
!

sessionStorageAtKey: key 
        "Get the storage item for the given key"
        
        ^ self valueFromRequest:'/session_storage/key/', key

    "Modified: / 21-07-2018 / 13:09:08 / Claus Gittinger"
!

sessionStorageClear
	"Clear the storage."
	
	^self
		handleResponse: (self httpDelete: self baseSessionURL , '/session_storage')
		 
!

sessionStorageDeleteKey: key 
	"Remove the storage item for the given key."
	
	^ self
		handleResponse: (self httpDelete: self baseSessionURL , '/session_storage/key/', key)
	 
!

sessionStorageSize
        "Get the number of items in the storage."
        
        ^ self valueFromRequest:'/session_storage/size'

    "Modified: / 21-07-2018 / 13:09:19 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'api -IME'!

activeIMEEngine
        "Get the name of the active IME engine. The name string is platform specific."
        
        ^ self valueFromRequest:'/ime/active_engine'

    "Modified: / 21-07-2018 / 13:08:38 / Claus Gittinger"
!

availableIMEEngines
        "List all available engines on the machine. To use an engine, it has to be present in this list."
        
        ^ self valueFromRequest:'/ime/available_engines'

    "Modified: / 21-07-2018 / 13:08:28 / Claus Gittinger"
!

hasActivatedIME
        "Indicates whether IME input is active at the moment (not if it's available)."

        ^ self valueFromRequest:'/ime/activated'

    "Modified: / 21-07-2018 / 13:08:21 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'private'!

handleResponse: response
         
        ^(response httpStatus ~= 204) ifTrue: [
                self 
                    handleResponse: response 
                    onSuccess: [ :result | (result at: 'value') ].
        ]

    "Modified (format): / 21-07-2018 / 13:41:30 / Claus Gittinger"
!

sessionIdFromResponse: response 

	response httpStatus = 200
		ifTrue: [^(self jsonRead: response contents) at: 'sessionId'].
	self
		error: 'Unexpected response status code ' , response httpStatus printString
				, ' while creating web driver session.'
! !

!WDWebDriver methodsFor:'private - accessing'!

baseDriverURL
    "returns something like:
        'http://localhost:4444/wd/hub/'
    "    

    baseDriverURL isNil ifTrue:[
        baseDriverURL := 'http://',(self serverHost),':',(self serverPort asString),(self serverServicePath)
    ].
    ^ baseDriverURL

    "Modified: / 19-07-2018 / 00:39:46 / Claus Gittinger"
!

baseSessionURL
	
	^self baseDriverURL , 'session/', self session sessionId asString 
!

baseSessionsURL
	
	^self baseDriverURL , 'sessions'
!

baseStatusURL
	
	^self baseDriverURL , 'status'
!

exceptions
self halt.
	^exceptions
		ifNil: 
			[exceptions := Dictionary new.
			exceptions
				at: 7 put: WDNoSuchElementException;
				at: 10 put: WDStaleElementReferenceException."
				at: 11 put: BPElementNotVisibleException;
				at: 13 put: BPUnknownServerException;
				at: 32 put: BPInvalidSelectorException".
			exceptions]
!

platform
        ^platform

    "Modified: / 22-06-2018 / 08:43:00 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'private - http'!

handleResponse: response onSuccess: successBlock

        | result status message jsonResponse exceptionClass httpStatus |
        
        httpStatus := response httpStatus.
        httpStatus = 200 ifFalse:[
            httpStatus = 400 ifTrue: [ WDUnsupportedCommandException signal ].
            httpStatus = 404 ifTrue: [ WDUnsupportedCommandException signal ].
            httpStatus = 204 ifTrue: [ self error: 'Unexpected response without entity' ].
            self error: 'Error response: ' ,response contents asString
        ]. 
        
        jsonResponse := response contents.
        jsonResponse isEmptyOrNil ifTrue: [ self error: 'Unexpected response without entity' ].

        result := self jsonRead: jsonResponse.
        result isNil ifTrue:[ self error: 'Unexpected empty response without entity' ].
        
        status := result at: 'status' ifAbsent:0.
        status = 0 ifTrue: [^successBlock value: result].
        message := (result at: 'value') at: 'message'.
        exceptionClass := self exceptions at: status ifAbsent: [ WDException ].
        platform signalException: ((exceptionClass new)
                                errorCode: status;
                                messageText: message;
                                yourself)

    "Modified: / 21-07-2018 / 13:47:08 / Claus Gittinger"
!

httpDelete: anURL

        ^ platform httpDelete: anURL

    "Modified: / 22-06-2018 / 08:42:33 / Claus Gittinger"
!

httpGet: anURL

        ^ platform httpGet: anURL

    "Modified: / 22-06-2018 / 08:42:37 / Claus Gittinger"
!

httpGetHandleResponse: url onSuccess: aBlock

        ^self httpGetHandleResponse: url onSuccess: aBlock onFailure: [:e | self error:e printString]

    "Modified: / 21-07-2018 / 15:40:46 / Claus Gittinger"
!

httpGetHandleResponse: anURL onSuccess: successBlock onFailure: failureBlock
        |response|
        response := (self httpGet: anURL).
        ^response isSuccess 
                ifTrue: [ successBlock value: response contents ]
                ifFalse: [ failureBlock value: response ]

    "Modified (format): / 16-07-2018 / 17:10:26 / Claus Gittinger"
!

httpPost: url  

        ^platform
                httpPost: url  
                timeout: (requestTimeout ? self class defaultRequestTimeout)

    "Modified: / 16-07-2018 / 17:10:06 / Claus Gittinger"
!

httpPost: url jsonData: data

        ^platform
                httpPost: url
                data: (platform jsonWrite: data)
                timeout: (requestTimeout ? self class defaultRequestTimeout)

    "Modified: / 16-07-2018 / 17:10:10 / Claus Gittinger"
!

httpPost: url jsonData: data timeout: timeout

        ^platform
                httpPost: url
                data: (platform jsonWrite: data)
                timeout: timeout

    "Modified: / 22-06-2018 / 08:43:21 / Claus Gittinger"
!

httpPostHandleResponse: url jsonData: data

        ^self handleResponse: (platform
                                httpPost: url
                                data: (platform jsonWrite: data)
                                timeout: (requestTimeout ? self class defaultRequestTimeout))

    "Modified: / 16-07-2018 / 17:10:18 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'private - initialization'!

initWithCapabilities: capabilities
        | response |

        self initialize.

        (capabilities includesKey:'serviceURL') ifTrue:[
            self serviceURL:(capabilities at:'serviceURL')
        ] ifFalse:[    
            self serverHost:(capabilities at:'host' ifAbsent:serverHost).
            self serverPort:(capabilities at:'port' ifAbsent:serverPort).
            self serverServicePath:( capabilities at:'restServicePath' ifAbsent:'/' ).
        ].
        
        WDException handle:[:ex |
            |statusResponse|
            
            "/ see if we lost the connection or not
            WDException handle:[:ex2 |
            ] do:[
                statusResponse := self httpGet:(self baseDriverURL , 'status').
            ].
            statusResponse isNil ifTrue:[
                GuiBrowser::GeneralWebDriverError raiseRequestErrorString:'lost connection'
            ] ifFalse:[    
                GuiBrowser::GeneralWebDriverError raiseRequestErrorString:ex description
            ].    
            self error.
        ] do:[    
            response := self
                            httpPost:(self baseDriverURL , 'session')
                            jsonData:((Dictionary new)
                                            at: 'desiredCapabilities' put: capabilities asDictionary;
                                            yourself)
                            timeout:(connectTimeout ? self class defaultConnectTimeout).
        ].
        session := self sessionFromResponse: response

    "Modified: / 21-07-2018 / 12:07:56 / Claus Gittinger"
!

initialize
    platform := WDSmalltalkPlatform current.

    "Created: / 22-06-2018 / 08:41:14 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'private - json'!

jsonRead: aString

        ^platform jsonRead: aString

    "Modified: / 22-06-2018 / 08:42:57 / Claus Gittinger"
!

jsonReadValueFrom: aString
    |object|

    aString isEmptyOrNil ifTrue:[self error:'invalid response: empty json'].
    object := self jsonRead:aString.
    object isNil ifTrue:[self error:'invalid response: no json or missing value field'].
    ^ object at:'value'

    "Created: / 21-07-2018 / 13:04:39 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:07:33 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'private - utilities'!

sessionFromResponse: aResponse
	^WDSession fromDictionary: (self jsonRead: aResponse contents)
!

valueFromRequest:command
    ^ self
            httpGetHandleResponse:(self baseSessionURL , command)
            onSuccess: [ :json | self jsonReadValueFrom: json ]

    "Created: / 21-07-2018 / 13:08:00 / Claus Gittinger"
! !

!WDWebDriver methodsFor:'testing'!

isRunning
    ^ (self httpGet:self baseStatusURL) isSuccess      
    "/ ^ (ZnEasy get: self baseStatusURL) isSuccess

    "Modified: / 22-06-2018 / 09:00:13 / Claus Gittinger"
! !

!WDWebDriver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDWebDriver.st,v 1.16 2018-07-22 09:57:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDWebDriver.st,v 1.16 2018-07-22 09:57:33 cg Exp $'
! !

