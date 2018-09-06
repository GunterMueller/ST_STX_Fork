"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPSessionState
	instanceVariableNames:'proxySettings credentials timeout cookieJar maxRedirects'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPSessionState comment:'I am the state that (can) exist across a number of HTTP requests 

See SptHTTPRequest(class)>>exampleState

Instance Variables:
	proxySettings	<SptHTTPProxySettings>
	credentials	<SptCredentials>
	timeout		<Integer> or nil
	cookieJar		<SptHTTPCookieJar>
	maxRedirects	<Integer>'
!


!SptHTTPSessionState class methodsFor:'instance creation'!

new
	^super new initialize
! !

!SptHTTPSessionState class methodsFor:'constants'!

defaultMaxRedirects
	^5
!

defaultTimeout
	^20000
! !

!SptHTTPSessionState methodsFor:'accessing'!

addCookie: aSptHTTPCookie
	cookieJar addCookie: aSptHTTPCookie
!

authorizationHeader
	^credentials httpHeaderValue
!

cookieJar
	^cookieJar
!

cookieJar: aSptHTTPCookieJar
	cookieJar := aSptHTTPCookieJar
!

credentials
	^credentials
!

credentials: aSptCredentials
	credentials := aSptCredentials
!

maxRedirects
	"Answer the maximum number of redirections that can automatically be followed"

	^maxRedirects
!

maxRedirects: anInteger
	"Set the maximum number of redirects that will be automatically followed"

	maxRedirects := anInteger
!

proxySettings
	^proxySettings
!

proxySettings: aSptHTTPProxySettings
	proxySettings := aSptHTTPProxySettings
!

timeout
	^timeout
!

timeout: anInteger
	timeout := anInteger
! !

!SptHTTPSessionState methodsFor:'enquiries'!

cookieHeaderFor: aSptHTTPUrl
	^cookieJar headerFor: aSptHTTPUrl
!

username: aUsernameString password: aPasswordString for: aUrlString
	| user |
	user := SptHTTPUser new.
	user username: aUsernameString password: aPasswordString.
	credentials isNil ifTrue: [credentials := SptBasicCredentials new].
	credentials user: user.
	credentials challenge: SptHTTPChallenge newBasicChallenge.
	credentials challenge absoluteUrl: aUrlString
! !

!SptHTTPSessionState methodsFor:'initializing'!

initialize
	super initialize.
	timeout := self class defaultTimeout.
	maxRedirects := self class defaultMaxRedirects.
	cookieJar := SptHTTPCookieJar new
! !

!SptHTTPSessionState methodsFor:'testing'!

shouldAuthenticate: aUrlString
	^credentials notNil and: [credentials isInProtectionSpace: aUrlString]
!

useProxy
	proxySettings isNil ifTrue: [^false].
	^proxySettings useProxy
! !

!SptHTTPSessionState class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPSessionState.st,v 1.2 2011-09-23 18:55:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPSessionState.st,v 1.2 2011-09-23 18:55:08 cg Exp $'
! !
