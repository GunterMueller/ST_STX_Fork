"
 COPYRIGHT (c) 2015 by eXept Software AG
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

Object subclass:#HTTPSimpleJSONRestClient
	instanceVariableNames:'baseUrl protocol'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Rest'
!

!HTTPSimpleJSONRestClient class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by eXept Software AG
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
    Abstract superclass for JSON based Rest service clients.
    This passes arguments as JSON post-data.
    Callable methods can be automatically detected via the protocolInfo rest call,
    if the partner is an ST/X based rest service.
    See concrete subclasses on how the call interface works.

    [start Server with:]
        HTTPServer startServerOnPort:9876

    [start a Demo Service with:]
        (HTTPSimpleJSONRestDemoService new)
            linkName:'/rest';
            registerServiceOn:(HTTPServer serverOnPort:9876)

    [request:]
        |client|

        client := self newForURL:'localHost:9876/rest'.
        (client call:'protocolInfo') inspect.
        (client call:'string') inspect.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HTTPSimpleJSONRestClient class methodsFor:'instance creation'!

newForURL:baseUrlArg
    ^ self new baseUrl:baseUrlArg
! !

!HTTPSimpleJSONRestClient methodsFor:'accessing'!

baseUrl
    ^ baseUrl
!

baseUrl:something
    baseUrl := something.
! !

!HTTPSimpleJSONRestClient methodsFor:'calling'!

call:name
    |url resultData|

    url := baseUrl , '/' , name.
    resultData := HTTPInterface getFile:url.
    resultData notEmptyOrNil ifTrue:[
        ^ JSONReader fromJSON:resultData asString
    ].
    ^ nil.
!

call:name with:argument
    "argument is usually a dictionary with key-value assocs"
    
    |url argumentData response resultData|

    argumentData := JSONReader toJSON:argument.

    url := baseUrl , '/' , name.
    response := HTTPInterface put:url with:argumentData contentType:'text/json'.
    response isErrorResponse ifTrue:[
        ^ Error raiseWith:response errorString:('unexpected response: ' , response responseText).
    ].
    resultData := response data.
    resultData notEmptyOrNil ifTrue:[
        ^ JSONReader fromJSON:resultData asString
    ].
    ^ nil.
! !

!HTTPSimpleJSONRestClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPSimpleJSONRestClient.st,v 1.4 2016-06-29 22:36:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPSimpleJSONRestClient.st,v 1.4 2016-06-29 22:36:44 cg Exp $'
! !

