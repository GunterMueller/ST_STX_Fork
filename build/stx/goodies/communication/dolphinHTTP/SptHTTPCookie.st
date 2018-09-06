"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPCookie
	instanceVariableNames:'domain path values expires isSecure'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPCookie comment:'SptHTTPCookie

I am a cookie that is parsed from a Set-Cookie http header

See <http://wp.netscape.com/newsref/std/cookie_spec.html> for more information'
!


!SptHTTPCookie class methodsFor:'instance creation'!

addNextCookieString: cookieString to: aCollection startingAt: anIndex
	"Private - Answer 0 if no more"

	| expiresPos commaPos |
	expiresPos := cookieString indexOfSubCollection: 'expires' startingAt: anIndex.
	commaPos := cookieString indexOfSubCollection: ',' startingAt: anIndex.
	commaPos > expiresPos 
		ifTrue: 
			["The commaPos is in 'DATE', find the next"

			commaPos := cookieString indexOfSubCollection: ',' startingAt: commaPos + 1].
	"Is it the last cookie?"
	^commaPos = 0 
		ifTrue: 
			[aCollection add: (cookieString copyFrom: anIndex to: cookieString size).
			0]
		ifFalse: 
			[aCollection add: (cookieString copyFrom: anIndex to: commaPos - 1).
			commaPos + 1]
!

allFromSetCookieString: aString url: aSptHTTPUrl
	"Answer a collection of Cookies"

	| cookieStrings pos |
	cookieStrings := OrderedCollection new.
	pos := 1.
	"This is disgusting ... multiple cookies can be separated by commas ... NAME=VALUE strings can not contain a comma, 
		but, expires=DATE does ... arrrg"
	[pos = 0] whileFalse: 
			[pos := self 
						addNextCookieString: aString
						to: cookieStrings
						startingAt: pos].
	^cookieStrings select: [:each | each trimBlanks notEmpty]
		thenCollect: [:each | self fromCookieString: aString url: aSptHTTPUrl]
!

fromCookieString: aString url: aSptHTTPUrl
        "Answer a single cookie"

        | fields instance |
        fields := LookupTable new.
        aString notEmpty ifTrue:[
            (aString subStrings: $;) do: 
                            [:each | 
                            each trimBlanks notEmpty 
                                    ifTrue: 
                                            [| stream key value |
                                            stream := each readStream.
                                            key := (stream upTo: $=) trimBlanks.
                                            value := stream upToEnd trimBlanks.
                                            (value notEmpty or: [key = 'secure']) ifTrue: [fields at: key put: value]]].
        ].
        instance := self newForUrl: aSptHTTPUrl.
        instance setFromFields: fields.
        ^instance

    "Modified: / 23-09-2011 / 21:14:55 / cg"
!

new
	^super new initialize
!

newForUrl: aSptHTTPUrl
	^(self new)
		domain: aSptHTTPUrl host;
		path: aSptHTTPUrl path;
		yourself
! !

!SptHTTPCookie class methodsFor:'helpers'!

isSpecialDomain: aString
	aString size < 5 ifTrue: [^false].
	"SPEC: Any domain that fails within one of the seven special top level domains listed below only require two periods"
	(aString select: [:each | each = $.]) size >= 2 ifFalse: [^false].
	^SptHTTPUrl specialDomainEndings 
		includes: (aString copyFrom: aString size - 2 to: aString size) asLowercase
!

isValidDomain: aString
	"SPEC
		and domains must have at least .... three (3) periods "

	^(aString select: [:each | each = $.]) size >= 3
! !

!SptHTTPCookie methodsFor:'accessing'!

atName: aString
	^values at: aString
!

atName: aString ifAbsentPut: operation
	^values at: aString ifAbsentPut: operation
!

domain
	^domain
!

domain: aString
	domain := aString
!

expires
	^expires
!

expires: aString
	expires := aString
!

isSecure
	^isSecure
!

isSecure: aBoolean
	isSecure := aBoolean
!

path
	^path
!

path: aString
	self assert: [aString size >= 1].
	self assert: [aString first = $/].
	path := aString
!

values
	^values
! !

!SptHTTPCookie methodsFor:'initializing'!

initialize
	super initialize.
	values := LookupTable new.
	isSecure := false
! !

!SptHTTPCookie methodsFor:'printing'!

nameValuesDo: aTwoArgBlock
	values keysAndValuesDo: aTwoArgBlock
!

printNameValueOn: aWriteStream
	values associationsDo: 
			[:a | 
			aWriteStream
				display: a key;
				nextPut: $=;
				display: a value]
		separatedBy: [aWriteStream nextPut: $;]
! !

!SptHTTPCookie methodsFor:'setting'!

setDomain: aString
	"The cookie contains a 'domain' field.
	-If this value is not legal (ie check against the actual url's host ), signal an error"

	(domain sameAs: aString) ifTrue: [^self].
	(((self class isSpecialDomain: aString) or: [self class isValidDomain: aString]) 
		and: ['*' , aString match: domain ignoreCase: true]) 
			ifTrue: 
				[domain := aString.
				^self].
	self error: ('The cookies suggested domain %1 is not valid for %2' formatWith: aString
				with: domain)
!

setExpires: aString
	expires := aString
!

setFromFields: aLookupTable
	(aLookupTable includesKey: 'domain') 
		ifTrue: [self setDomain: (aLookupTable removeKey: 'domain')].
	(aLookupTable includesKey: 'path') 
		ifTrue: [self setPath: (aLookupTable removeKey: 'path')].
	(aLookupTable includesKey: 'expires') 
		ifTrue: [self setExpires: (aLookupTable removeKey: 'expires')].
	(aLookupTable includesKey: 'secure') 
		ifTrue: [self setSecure: (aLookupTable removeKey: 'secure')].
	values := aLookupTable
!

setPath: aString
	self assert: [aString size >= 1].
	self assert: [aString first = $/].
	path := aString
!

setSecure: aString
	"Note: It is secure"

	isSecure := true
! !

!SptHTTPCookie methodsFor:'testing'!

isDomainMatch: aString
	^aString size > domain size 
		ifTrue: [self isDomainS: domain matchDomainL: aString]
		ifFalse: [self isDomainS: aString matchDomainL: domain]
!

isDomainS: aSmallerString matchDomainL: aLargerString
	| compString |
	compString := aLargerString copyFrom: aLargerString size - aSmallerString size + 1
				to: aLargerString size.
	^compString sameAs: aSmallerString
!

isPathMatch: aString
	^aString startsWith: path
!

isSameAs: aSptHTTPCookie
	^path = aSptHTTPCookie path and: [self isDomainMatch: aSptHTTPCookie domain]
! !

!SptHTTPCookie class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPCookie.st,v 1.3 2011-09-23 20:21:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPCookie.st,v 1.3 2011-09-23 20:21:55 cg Exp $'
! !
