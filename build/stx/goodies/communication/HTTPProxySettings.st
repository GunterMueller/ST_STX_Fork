"{ Package: 'stx:goodies/communication' }"

Object subclass:#HTTPProxySettings
	instanceVariableNames:'useProxy proxyHost proxyPort'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-HTTP-Client'
!

!HTTPProxySettings class methodsFor:'documentation'!

documentation
"
    adopted from see examples in SptHTTPProxySettings   
    (not much to adapt, though)
"
! !

!HTTPProxySettings class methodsFor:'instance creation'!

useHost:aString port:aSmallInteger 
    ^ self new useHost:aString port:aSmallInteger

    "Modified (format): / 05-10-2011 / 17:16:21 / cg"
! !

!HTTPProxySettings methodsFor:'accessing'!

proxyHost
    proxyHost isNil ifTrue:[
        proxyHost := 'localhost'
    ].
    ^ proxyHost

    "Modified (format): / 05-10-2011 / 17:16:25 / cg"
!

proxyHost:aString 
    proxyHost := aString

    "Modified (format): / 05-10-2011 / 17:16:41 / cg"
!

proxyPort
    proxyPort isNil ifTrue:[
        proxyPort := 8000
    ].
    ^ proxyPort

    "Modified (format): / 05-10-2011 / 17:16:42 / cg"
!

proxyPort:anInteger 
    proxyPort := anInteger

    "Modified (format): / 05-10-2011 / 17:16:44 / cg"
!

useHost:aString port:aSmallInteger 
    useProxy := true.
    proxyHost := aString.
    proxyPort := aSmallInteger

    "Modified (format): / 05-10-2011 / 17:16:46 / cg"
!

useProxy
    useProxy isNil ifTrue:[
        useProxy := false
    ].
    ^ useProxy

    "Modified (format): / 05-10-2011 / 17:16:48 / cg"
!

useProxy:aBool 
    useProxy := aBool

    "Modified (format): / 05-10-2011 / 17:16:51 / cg"
! !

!HTTPProxySettings class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPProxySettings.st,v 1.1 2011-10-05 16:13:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPProxySettings.st,v 1.1 2011-10-05 16:13:19 cg Exp $'
! !
