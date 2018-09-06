"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPChallenge
	instanceVariableNames:'scheme realm params rootUri digestUri method'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPChallenge comment:'SptHTTPChallenge

I am a HTTP Authentication challenge. I contain the information that is parsed from a ''WWW-Authenticate'' header included in a 401 (Unauthorized) response.

By supplying user infromation, I can be used to construct the <SptCredentials> required to authorize a request.

See <http://www.ietf.org/rfc/rfc2617.txt> for details on HTTP Authentication.

Instance Variables:
	scheme	<String> ... should be either Basic or Digest
	realm	<String>
	params	<LookupTable>
	rootUri	<String>
	digestUri	<String>
	method	<String>'
!


!SptHTTPChallenge class methodsFor:'private'!

csStringsFrom: stream
	"Answer a collection of comma-separated strings ... ignoring commas embedded in quoted strings"

	| coll string start isQuoted |
	coll := OrderedCollection new.
	string := stream contents.
	[stream atEnd] whileFalse: 
			[start := stream position + 1.
			isQuoted := false.
			stream skipWhile: 
					[:c | 
					c = $" ifTrue: [isQuoted := isQuoted not].
					isQuoted or: [c ~= $,]].
			coll add: (string copyFrom: start to: stream position) trimBlanks.
			"skip ,"
			stream atEnd ifFalse: [stream next].
			stream skipSeparators].
	^coll
! !

!SptHTTPChallenge class methodsFor:'public'!

fromChallengeString: aString
	| scheme realm stream |
	stream := aString readStream.
	scheme := stream upTo: Character space.
	stream upTo: $=.
	realm := stream upToEnd.
	^(self new)
		scheme: scheme;
		realm: (realm copyFrom: 2 to: realm size - 1);
		yourself
!

makeUserIdFor: aUsernameString password: aPasswordString
	| outStream |
	outStream := String writeStream.
	Base64Encoder new 
		encode: (aUsernameString , ':' , aPasswordString) asByteArray readStream
		to: outStream.
	^outStream contents
!

new
	^super new initialize
!

newBasicChallenge
	^(self new)
		scheme: 'Basic';
		yourself
!

newBasicChallengeRealm: aString absoluteUri: aUrlString
	^(self newBasicChallenge)
		realm: aString;
		absoluteUrl: aUrlString;
		yourself
!

readAllFrom: aReadStream
	| subStrings instances |
	subStrings := self csStringsFrom: aReadStream.
	instances := OrderedCollection new.
	subStrings keysAndValuesDo: 
			[:i :each | 
			(self isChallengeString: each) 
				ifTrue: [instances add: (self fromChallengeString: each)]
				ifFalse: 
					[i = 1 ifTrue: [self error: 'Error parsing WWW-Authenticate header'].
					instances last parseParameter: each]].
	^instances
! !

!SptHTTPChallenge class methodsFor:'testing'!

isChallengeString: aString
	| stream |
	stream := aString readStream.
	stream upTo: Character space.
	^(stream nextAvailable: 5) = 'realm'
! !

!SptHTTPChallenge methodsFor:'accessing'!

absoluteUrl: aString
	| url |
	url := SptHTTPUrl fromString: aString.
	rootUri := url rootBaseUrlString.
	self domain: url path
!

credentialsFor: aSptUser
	self isBasic ifFalse: [self error: 'Basic authentication only is supported.'].
	^(SptBasicCredentials new)
		challenge: self;
		user: aSptUser;
		yourself
!

credentialsForUsername: aString password: aString2
	^self credentialsFor: (SptHTTPUser username: aString password: aString2)
!

digestUri
	^digestUri
!

digestUri: aString
	digestUri := aString
!

domain
	^params at: 'domain' ifAbsent: ['/']
!

domain: aString
	params at: 'domain' put: aString
!

method
	^method
!

method: aString
	method := aString
!

nonce
	^params at: 'nonce' ifAbsent: []
!

opaque
	^params at: 'opaque' ifAbsent: []
!

params
	^params
!

params: aCollection
	params := aCollection
!

protectionSpaces
        | url ds|
        url := SptHTTPUrl fromString: rootUri.
        ds := self domain.
        ds isEmpty ifTrue:[^ #() ].
        ^(ds subStrings: $ ) 
                collect: [:each | (SptHTTPUrl fromString: each previous: url) urlString]

    "Modified: / 23-09-2011 / 21:14:21 / cg"
!

qop
	^params at: 'qop' ifAbsent: []
!

realm
	^realm
!

realm: aString
	realm := aString
!

rootUri
	^rootUri
!

rootUri: aString
	rootUri := aString
!

scheme
	^scheme
!

scheme: aString
	scheme := aString
! !

!SptHTTPChallenge methodsFor:'initializing'!

initialize
	super initialize.
	params := LookupTable new
! !

!SptHTTPChallenge methodsFor:'operations'!

parseParameter: aString
	| stream token value |
	stream := aString readStream.
	token := stream upTo: $=.
	value := stream upToEnd.
	params at: token put: (value copyFrom: 2 to: value size - 1)
! !

!SptHTTPChallenge methodsFor:'testing'!

isBasic
	^scheme asLowercase = 'basic'
!

isInProtectionSpace: aString
	"SPEC:
The protection space determines the domain over which credentials can be automatically applied. If a prior request has been authorized, the same credentials MAY be reused for all other requests within that protection space for a period of time determined by the authentication scheme, parameters, and/or user preference. "

	| url |
	url := SptHTTPUrl fromString: aString.
	^self protectionSpaces anySatisfy: [:each | url isInSpaceOf: each]
! !

!SptHTTPChallenge class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPChallenge.st,v 1.3 2011-09-23 20:22:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPChallenge.st,v 1.3 2011-09-23 20:22:00 cg Exp $'
! !
