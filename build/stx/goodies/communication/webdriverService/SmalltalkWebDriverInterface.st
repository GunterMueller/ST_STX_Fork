"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2018 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication/webdriverService' }"

"{ NameSpace: Smalltalk }"

HTTPSimpleJSONRestService subclass:#SmalltalkWebDriverInterface
	instanceVariableNames:'sessions'
	classVariableNames:'NextSessionID'
	poolDictionaries:''
	category:'WebDriver-Service'
!

!SmalltalkWebDriverInterface class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2018 by eXept Software AG
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
    I implement the webDriver REST service 
    for remote controlling ST/X (or ST/X apps) via the webDriver protocol.

    [startup:]
        SmalltalkWebDriverInterface startOn:(HTTPServer serverOnPort:4446)
"
! !

!SmalltalkWebDriverInterface class methodsFor:'defaults'!

linkName
    "return the default path (with slash).
     Either redefine this method in a concrete subclass, 
     or redefine the sender, #linkNames (for multiple default linkNames)."

    ^ '/wd/'

    "Created: / 18-06-2018 / 00:07:14 / Claus Gittinger"
    "Modified: / 18-07-2018 / 11:33:37 / Claus Gittinger"
! !

!SmalltalkWebDriverInterface methodsFor:'private'!

errorReply:message code:responseCode for:aRequest
    |reply|
    
    reply := OrderedDictionary new.
    reply at:'error' put:message.

    Logger info:'<- error: ',reply printString.
    aRequest response responseCode:responseCode.
    ^ reply

    "Created: / 21-07-2018 / 12:01:25 / Claus Gittinger"
!

forwardToSession:aRequest path:path argument:arg   
    |session id|

    Transcript showCR:'per SESSION request'.

    id := path first asInteger.
    session := sessions at:id ifAbsent:[nil].
    session isNil ifTrue:[
        aRequest reportNotFound:'no such session' moreInfo:nil.
        ^ nil.
    ].

    ^ session 
        process:aRequest 
        method:aRequest method 
        relativePath:((path copyFrom:2) asStringWith:'/')
        argument:arg.

    "Created: / 22-07-2018 / 09:26:33 / Claus Gittinger"
! !

!SmalltalkWebDriverInterface methodsFor:'service entries'!

session:aRequest argument:arg path:path    
    "session information
     see https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#status"

    <Rest: (* name: 'session' 
                 argument: 'Dictionary' 
                 return: 'Dictionary' 
                 comment: 'create a session.') >


    |caps reply desiredCapabilities requiredCapabilities session id 
     applicationName applicationNameToStart application|

    aRequest isDELETE ifTrue:[
        path size == 1 ifTrue:[
            id := path first asInteger.
            session := sessions at:id ifAbsent:[nil].
            session isNil ifTrue:[
                aRequest reportNotFound:'no such session' moreInfo:nil.
                ^ { 'value' -> nil }
            ].
            session release.
            sessions removeKey:id.
            ^ { 'value' -> nil }
        ].
    ].
    
    path notEmptyOrNil ifTrue:[
        ^ self forwardToSession:aRequest path:path argument:arg .
    ].

    (aRequest isPOST or:[aRequest isPUT]) ifFalse:[
        self error:'invalid request'
    ].
    
    Logger info:'POST session'.

    id := NextSessionID ? 1.
    NextSessionID := id + 1.
    "/ id := UUID genRandomUUID.
    
    session := SmalltalkWebDriverSession new.
    session interface:self.
    session sessionID:id printString.
    session linkName:(self linkName,'/session/%1' bindWith:id).
    
    sessions isNil ifTrue:[
        sessions := Dictionary new.
    ].    
        
    desiredCapabilities := arg at:'desiredCapabilities' ifAbsent:nil.
    requiredCapabilities := arg at:'requiredCapabilities' ifAbsent:nil.

    "/ startURL or startApplication cap. is interpreted as class name of app to open
    (applicationNameToStart := desiredCapabilities at:'startURL' ifAbsent:nil) isNil ifTrue:[
        applicationNameToStart := desiredCapabilities at:'startApplication' ifAbsent:nil.
    ].
    applicationNameToStart notNil ifTrue:[
        (application := session startApplicationByName:applicationNameToStart) isNil ifTrue:[
            ^ self errorReply:'no such application to start' code:404 for:aRequest
        ].    
    ] ifFalse:[
        "/ application cap. is interpreted as name of app to connect to
        (applicationName := desiredCapabilities at:'application' ifAbsent:nil) notNil ifTrue:[
            (application := session connectToApplicationByName:applicationName) isNil ifTrue:[
                ^ self errorReply:'no such application' code:404 for:aRequest
            ].    
        ].
    ].
    
    sessions at:id put:session.

    caps := OrderedDictionary new.
    caps at:'browserName' put:'smalltalk'.
    caps at:'version' put:(Smalltalk versionString).
    caps at:'platform' put:(OperatingSystem getOSType).
    caps at:'javascriptEnabled' put:false.
    caps at:'takesScreenshot' put:true.
    caps at:'handlesAlerts' put:false.
    caps at:'databaseEnabled' put:false.
    caps at:'locationContextEnabled' put:false.
    caps at:'applicationCacheEnabled' put:false.  
    caps at:'browserConnectionEnabled' put:false.  
    caps at:'cssSelectorsEnabled' put:false.  
    caps at:'webStorageEnabled' put:false.  
    caps at:'rotatable' put:false.  
    caps at:'acceptSslCerts' put:false.  
    caps at:'nativeEvents' put:false.  
    
    reply := OrderedDictionary new.
    reply at:'capabilities' put:caps.
    reply at:'id' put:id.

    Logger info:'<- ',reply printString.
    "/ httpServer addServiceToServiceList:session. 
    ^ reply

    "Created: / 22-07-2018 / 08:01:08 / Claus Gittinger"
    "Modified: / 22-07-2018 / 09:27:57 / Claus Gittinger"
!

status:aRequest 
    "status information
     see https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#status"

    <Rest: (GET 
                name: 'status' 
                return: 'Dictionary' 
                comment: 'status info.') >

    |reply|

    Logger info:'STATUS GET'.
    
    reply := OrderedDictionary new.
    reply at:'ready' put:true.
    reply at:'build' put:(OrderedDictionary new
                            at:'version' put:(Smalltalk versionString);
                            at:'revision' put:(Smalltalk revision);
                            at:'time' put:(Smalltalk versionDate);
                            yourself).
    reply at:'os' put:(OrderedDictionary new
                            at:'arch' put:'Smalltalk/X';
                            at:'name' put:(OperatingSystem getOSType);
                            at:'version' put:'1';
                            yourself).
                            
    Logger info:'<- ',reply printString.
    ^ reply

    "Created: / 17-06-2018 / 23:52:47 / Claus Gittinger"
    "Modified: / 21-07-2018 / 15:59:36 / Claus Gittinger"
! !

!SmalltalkWebDriverInterface class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriverService/SmalltalkWebDriverInterface.st,v 1.10 2018-07-22 09:54:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriverService/SmalltalkWebDriverInterface.st,v 1.10 2018-07-22 09:54:26 cg Exp $'
! !

