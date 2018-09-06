"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPCookieJar
	instanceVariableNames:'cookies'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPCookieJar comment:'SptHTTPCookieJar

I am used to store and access http cookies.

See SptHTTPRequest(class)>>exampleCookies

Instance Variables:
	cookies	<SharedIdentitySet>'
!


!SptHTTPCookieJar class methodsFor:'instance creation'!

new
	^super new initialize
! !

!SptHTTPCookieJar methodsFor:'accessing'!

cookies
	^cookies
!

cookiesFor: aSptHTTPUrl
	| fromDomain host path |
	host := aSptHTTPUrl host.
	path := aSptHTTPUrl path.
	fromDomain := cookies select: [:each | each isDomainMatch: host].
	^fromDomain select: [:each | each isPathMatch: path]
!

headerFor: aSptHTTPUrl
	| stream matching |
	matching := self cookiesFor: aSptHTTPUrl.
	stream := String writeStream.
	matching do: [:each | each printNameValueOn: stream] separatedBy: [stream nextPut: $;].
	^stream contents
!

numberOfCookies
	^cookies size
! !

!SptHTTPCookieJar methodsFor:'adding'!

addCookie: aSptHTTPCookie
	"SPEC: Instances of the same path and name will overwrite each other, with the latest instance taking precedence. Instances of the same path but different names will add additional mappings. "

	| removed |
	#todo.	"Parse the expires date so that;
		SPEC: If a CGI script wishes to delete a cookie, it can do so by returning a cookie 
			with the same name, and an expires time which is in the past"
	removed := self removeCookiesMatching: aSptHTTPCookie.
	self assert: [removed size <= 1].
	removed do: 
			[:eachCookie | 
			eachCookie nameValuesDo: 
					[:n :v | 
					"only add the NAME=VALUE pair if not present"

					aSptHTTPCookie atName: n ifAbsentPut: [v]]].
	cookies add: aSptHTTPCookie
! !

!SptHTTPCookieJar methodsFor:'initializing'!

initialize
        super initialize.
        cookies := Dolphin::SharedIdentitySet new

    "Modified: / 23-09-2011 / 13:56:19 / cg"
! !

!SptHTTPCookieJar methodsFor:'operations'!

emptyJar
	cookies := SharedIdentitySet new
! !

!SptHTTPCookieJar methodsFor:'removing'!

removeCookiesMatching: aSptHTTPCookie
	| same |
	same := cookies select: [:each | each isSameAs: aSptHTTPCookie].
	same do: [:each | cookies remove: each ifAbsent: []].
	^same
! !

!SptHTTPCookieJar class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPCookieJar.st,v 1.2 2011-09-23 18:54:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPCookieJar.st,v 1.2 2011-09-23 18:54:43 cg Exp $'
! !
