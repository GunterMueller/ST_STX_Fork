"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPProxySettings
	instanceVariableNames:'useProxy proxyHost proxyPort'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPProxySettings comment:'Instance Variables:
	useProxy		<Boolean>
	proxyHost	<String>
	proxyPort	<Integer>'
!

!SptHTTPProxySettings class methodsFor:'documentation'!

documentation
"
    see examples in SptHTTPRequest
"
! !

!SptHTTPProxySettings class methodsFor:'instance creation'!

useHost: aString port: aSmallInteger
	^self new useHost: aString port: aSmallInteger
! !

!SptHTTPProxySettings methodsFor:'accessing'!

proxyHost
	proxyHost isNil ifTrue: [proxyHost := 'localhost'].
	^proxyHost
!

proxyHost: aString
	proxyHost := aString
!

proxyPort
	proxyPort isNil ifTrue: [proxyPort := 8000].
	^proxyPort
!

proxyPort: anInteger
	proxyPort := anInteger
!

useHost: aString port: aSmallInteger
	useProxy := true.
	proxyHost := aString.
	proxyPort := aSmallInteger
!

useProxy
	useProxy isNil ifTrue: [useProxy := false].
	^useProxy
!

useProxy: aBool
	useProxy := aBool 
! !

!SptHTTPProxySettings class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPProxySettings.st,v 1.3 2011-10-04 16:41:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPProxySettings.st,v 1.3 2011-10-04 16:41:56 cg Exp $'
! !
