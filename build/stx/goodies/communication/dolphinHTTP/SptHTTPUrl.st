"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPUrl
	instanceVariableNames:'urlString'
	classVariableNames:'EncodeArray'
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPUrl comment:'I am an absolute HTTP Url.

I can be constructed in the context of a ''previous'' instance, and I will:
  - If not absolute, use the previous instance to make myself absolute

My class has a number of utility methods for testing/accessing url <String>s

Instance Variables:
	urlString		<String> 


'
!


!SptHTTPUrl class methodsFor:'private'!

initialize
	"
	self initialize
	"

	EncodeArray := Array new: 255.
	1 to: 255 do: [:i | EncodeArray at: i put: (self shouldEncode: (Character codePoint: i))]
!

shouldEncode: aCharacter
	^(aCharacter isAlphaNumeric 
		or: [('-_.!!~*''()' includes: aCharacter) or: [';/?:@=&' includes: aCharacter]]) not
! !

!SptHTTPUrl class methodsFor:'public'!

canonicalize: aString
	"Answer a <String>"

	| stream encoding |
	stream := (String new: aString size) writeStream.
	aString do: 
			[:each | 
			(EncodeArray at: each asInteger) 
				ifTrue: 
					[encoding := each asInteger printStringRadix: 16 showRadix: false.
					stream nextPut: $%.
					encoding size = 1 ifTrue: [stream nextPut: $0].
					stream nextPutAll: encoding]
				ifFalse: [stream nextPut: each]].
	^stream contents
!

fromString: aUrlString
	"Answer an instance.
	aUrlString must be absolute (ie http://host:port/path)"

	^self fromString: aUrlString previous: nil
!

fromString: aUrlString previous: aSptHTTPUrlOrNil
	"Answer a new instance.
	- If aUrlString is an absolutePath (ie '/foo/index.html') or local (ie 'index.html') 
		then make it absolute to aSptHTTPUrl"

	^self new urlString: (self makeAbsolute: aUrlString previous: aSptHTTPUrlOrNil)
!

recan: aString
	"Answer a <String>"

	^self canonicalize: (self uncanonicalize: aString)
!

uncanonicalize: aString
	"Answer a <String>"

	^aString unescapePercents
	"| outStream inStream |
	outStream := String writeStream.
	inStream := aString readStream.
	[inStream atEnd] whileFalse: 
			[| char |
			outStream nextPut: ((char := inStream next) = $% 
						ifTrue: 
							[Character value: (Integer readFrom: (inStream next: 2) asUppercase readStream radix: 16)]
						ifFalse: [char])].
	^outStream contents"
! !

!SptHTTPUrl class methodsFor:'utilities-accessing'!

containerOf: aUrlString
	"Answer the container url <String> of aUrlString or nil if it is the root url 
		self containerOf: 'http://www.foo.org/'  answers nil.
		self containerOf: 'http://www.foo.org/foo'  answers 'http://www.foo.org/'.
		self containerOf: 'http://www.foo.org/foo/'  answers 'http://www.foo.org/'.
		self containerOf: 'http://www.foo.org/foo/bar'  answers 'http://www.foo.org/foo/'."

	| contRemoved lastSlash |
	((self isAbsolute: aUrlString) and: [(self fromString: aUrlString) absolutePath = '/']) 
		ifTrue: [^nil].
	aUrlString = '/' ifTrue: [^nil].
	contRemoved := (self isContainer: aUrlString) 
				ifTrue: [aUrlString allButLast]
				ifFalse: [aUrlString].
	lastSlash := contRemoved findLast: [:c | c = $/].
	^aUrlString copyFrom: 1 to: lastSlash
!

extensionOf: aUrlString
	"Answer the last segment <String> of aUrlString  
		self extensionOf: 'http://www.foo.org/'  answers nil.
		self extensionOf: 'http://www.foo.org/foo'  answers nil.
		self extensionOf: 'http://www.foo.org/foo.'  answers ''.
		self extensionOf: 'http://www.foo.org/foo.bar'  answers 'bar'."

	^(SWSU split: (self lastSegmentOf: aUrlString) atLast: $.) second
!

lastSegmentOf: aUrlString
	"Answer the last segment <String> of aUrlString  
		self lastSegmentOf: 'http://www.foo.org/'  answers '/'.
		self lastSegmentOf: 'http://www.foo.org/foo'  answers 'foo'.
		self lastSegmentOf: 'http://www.foo.org/foo/'  answers 'foo'.
		self lastSegmentOf: 'http://www.foo.org/foo/bar'  answers 'bar'.

		self lastSegmentOf: 'http://www.foo.org/foo/bar?blab'  answers 'bar'."

	^self lastSegmentOfPath: ((self isAbsolute: aUrlString) 
				ifTrue: [(self fromString: aUrlString) path]
				ifFalse: [aUrlString])
!

lastSegmentOfPath: aPathString
	| slashRemoved index |
	aPathString = '/' ifTrue: [^aPathString].
	index := (slashRemoved := (self isContainer: aPathString) 
						ifTrue: [aPathString allButLast]
						ifFalse: [aPathString]) findLast: [:c | c = $/].
	self assert: [index > 0].
	^slashRemoved copyFrom: index + 1 to: slashRemoved size
!

schemeOf: aUrlString
	| stream scheme |
	stream := aUrlString readStream.
	scheme := stream upToAll: '://'.
	stream atEnd ifTrue: [^nil].
	^scheme
!

specialDomainEndings
	"As defined by the Cookie specification"

	^#('com' 'edu' 'net' 'org' 'gov' 'mil' 'int')
! !

!SptHTTPUrl class methodsFor:'utilities-converting'!

makeAbsolute: aUrlString previous: aSptHTTPUrl
	| canUrlString |
	canUrlString := self recan: aUrlString.
	(self isAbsolute: canUrlString) 
		ifTrue: [^canUrlString]
		ifFalse: [aSptHTTPUrl isNil ifTrue: [self error: 'Can not make absolute']].
	^(self isAbsolutePath: canUrlString) 
		ifTrue: [aSptHTTPUrl rootBaseUrlString , canUrlString]
		ifFalse: [self makeRelAbsolute: canUrlString previous: aSptHTTPUrl]
!

makeRelAbsolute: aRelUrlString previous: aSptHTTPUrl
	"http://www.ietf.org/rfc/rfc2396.txt  5.2"

	"a) All but the last segment of the base URI's path component is copied to the buffer. "

	| urlString |
	urlString := aSptHTTPUrl localBasePath allButFirst.

	"b) The reference's path component is appended to the buffer string. "
	urlString := urlString , aRelUrlString.	"(SWSU split: aRelUrlString atLast: $/) second displayString."

	"c) All occurrences of './', where '.' is a complete path segment, are removed from the buffer string. "
	urlString := self removeDotSlashOf: urlString.

	"d) If the buffer string ends with '.' as a complete path segment, that '.' is removed. "
	(SWSU does: urlString endWith: '/.') ifTrue: [urlString := urlString allButLast].

	"e) All occurrences of '/../', where is a complete path segment not equal to '..', are removed from the buffer string. Removal of these path segments is performed iteratively, removing the leftmost matching pattern on each iteration, until no matching pattern remains. "
	urlString := self removeSegmentDotDotSlashOf: urlString.

	"f) If the buffer string ends with '/..', where is a complete path segment not equal to '..', that '/..' is removed. "
	(SWSU does: urlString endWith: '/..') ifTrue: [urlString := urlString allButLast: 3].

	"g) If the resulting buffer string still begins with one or more complete path segments of '..', then the reference is considered to be in error. Implementations may handle this error by retaining these components in the resolved path (i.e., treating them as part of the final URI), by removing them from the resolved path (i.e., discarding relative levels above the root), or by avoiding traversal of the reference. "
	(urlString startsWith: '../') ifTrue: [urlString := urlString allButFirst: 3].
	(urlString startsWith: './') ifTrue: [urlString := urlString allButFirst: 2].
	^aSptHTTPUrl rootBaseUrlString , '/' , urlString
!

makeSchemeLowercase: aString
	| stream scheme |
	(scheme := self schemeOf: aString) ifNil: [^aString].
	stream := aString readStream.
	stream skipTo: $:.
	^scheme asLowercase , ':' , stream upToEnd
!

makeUrlRefString: aString
        "This method attempts to make a urlString from aString"

        | text firstLine |
        text := aString trimBlanks.
        firstLine := text readStream nextLine.
        firstLine := self makeSchemeLowercase: firstLine.
        "If aString has an existing scheme, we cant make a http url"
        (#('http' 'https' nil) includes: (self schemeOf: firstLine)) 
                ifFalse: [self error: 'Cant not create a url from a non-http scheme'].
        "Is it already an http url?"
        ('http*' match: firstLine ignoreCase: true) ifTrue: [^firstLine].
        "Doesnt it start with 'www'?"
        ('www.*' match: firstLine ignoreCase: true) ifTrue: [^'http://' , firstLine].
        "If all else fails ... use the same technique as IE"
        ^'http://www.' , firstLine

    "Modified: / 23-09-2011 / 21:08:59 / cg"
!

removeDotSlashOf: aUrlString
	| urlString index |
	urlString := aUrlString.
	[(index := urlString indexOfSubCollection: '/./') = 0] whileFalse: 
			[urlString := (urlString copyFrom: 1 to: index) 
						, (urlString copyFrom: index + 3 to: urlString size)].
	^urlString
!

removeSegmentDotDotSlashOf: aUrlString
	| urlString index |
	urlString := aUrlString.
	[(index := urlString indexOfSubCollection: '/../') = 0] whileFalse: 
			[| segmentIndex |
			segmentIndex := urlString 
						prevIndexOf: $/
						from: index - 1
						to: 1.
			urlString := (urlString copyFrom: 1 to: segmentIndex) 
						, (urlString copyFrom: index + 4 to: urlString size)].
	^urlString
!

splitFragmentOf: aUrlReferenceString
	"http://www.ietf.org/rfc/rfc2396.txt
	A URI reference may be absolute or relative, and may have additional information attached in the form of a fragment identifier. However, 'the URI' that results from such a reference includes only the absolute URI after the fragment identifier (if any) is removed and after any relative URI is resolved to its absolute form."

	^SWSU split: aUrlReferenceString atLast: $#
! !

!SptHTTPUrl class methodsFor:'utilities-testing'!

doesHost: aString1 match: aString2
	"
		SptHTTPUrl doesHost: 'cache.foo.org' match: 'www.foo.org'
			true
	"

	| host1 host2 requiredMatches |
	host1 := (aString1 subStrings: $.) reverse.
	host2 := (aString2 subStrings: $.) reverse.
	host1 isEmpty ifTrue: [^false].
	requiredMatches := (self specialDomainEndings includes: host1 first asLowercase) 
				ifTrue: [2]
				ifFalse: [3].
	(host1 size < requiredMatches or: [host2 size < requiredMatches]) ifTrue: [^false].
	1 to: requiredMatches do: [:i | ((host1 at: i) sameAs: (host2 at: i)) ifFalse: [^false]].
	^true
!

is: aUrlString1 childOf: aUrlString2
	"Assume both strings are the same type of url (ie absolute/relative), 
		answer if 1 is a direct child of 2 in the url namespace"

	| relative separatorPosition |
	(self is: aUrlString1 descendentOf: aUrlString2) ifFalse: [^false].
	relative := aUrlString1 copyFrom: aUrlString2 size + 1 to: aUrlString1 size.
	separatorPosition := relative findFirst: [:each | each = $/].
	^separatorPosition = 0 or: [separatorPosition = relative size]
!

is: aUrlString1 descendentOf: aUrlString2
	"Assume both strings are the same type of url (ie absolute/relative), 
		answer if 1 is a descendent of 2 in the url namespace"

	^(self is: aUrlString1 descendentOrSelfOf: aUrlString2) 
		and: [aUrlString1 size > aUrlString2 size]
!

is: aUrlString1 descendentOrSelfOf: aUrlString2
	"Assume both strings are the same type of url (ie absolute/relative), 
		answer if 1 is a descendent or the same as  2 in the url namespace"

	^aUrlString1 beginsWith: aUrlString2
!

isAbsolute: aUrlString
        "
        self isAbsolute:  'http://www.foo.org/index.html'. 
                true
        self isAbsolute:  '/index.html'. 
                false
        "

        |s|

        ^(s := self schemeOf: aUrlString) 
                isNil ifTrue: [false]
                ifFalse: [ #('http' 'https') includes: s asLowercase]

    "Modified: / 23-09-2011 / 13:34:44 / cg"
!

isAbsolutePath: aUrlString
	^aUrlString beginsWith: '/'
!

isCommonNonHTTPScheme: aUrlString
	| stream possibleScheme |
	stream := aUrlString readStream.
	possibleScheme := stream upTo: $:.
	^#('ftp' 'gopher' 'mailto' 'emailto' 'news' 'telnet' 'javascript') 
		includes: possibleScheme asLowercase
!

isContainer: aUrlString
	^aUrlString last = $/
!

isLocal: aUrlString
	"
	self isLocal:  'http://www.foo.org/index.html'. 
		false
	self isLocal:  '/index.html'. 
		false
	self isLocal:  'index.html'. 
		true

	"

	^(self isAbsolute: aUrlString) not and: [(self isAbsolutePath: aUrlString) not]
! !

!SptHTTPUrl methodsFor:'private'!

authorityFrom: stream
	self schemeFrom: stream.
	^stream upTo: $/
!

schemeFrom: aReadStream
	| scheme |
	scheme := aReadStream upTo: $:.
	self assert: [(aReadStream next: 2) = '//'].
	^scheme
!

urlString: aUrlString
	urlString := aUrlString
! !

!SptHTTPUrl methodsFor:'public'!

= aSptHTTPUrl
	"Note: this is quick and dirty and will have false negatives"

	^(aSptHTTPUrl isKindOf: self class) and: [urlString = aSptHTTPUrl urlString]
!

absolutePath
        | stream |
        stream := urlString readStream.
        self authorityFrom: stream.
        ^'/' , stream upToEnd "/ (stream atEnd ifTrue: [''] ifFalse: [stream upToEnd])

    "Modified: / 05-10-2011 / 17:21:04 / cg"
!

asSegments
	| coll stream |
	coll := OrderedCollection new.
	coll add: self hostPort.
	stream := self path readStream.
	self assert: [stream next = $/].
	[stream atEnd] whileFalse: [coll add: (stream upTo: $/)].
	^coll asArray
!

authority
	^self authorityFrom: urlString readStream
!

defaultPort
        self scheme = 'http' ifTrue: [^80].
        self scheme = 'https' ifTrue: [^443].
        self error: 'Scheme not knowen ' , self scheme asString "displayString"

    "Modified: / 23-09-2011 / 22:17:03 / cg"
!

displayOn: aStream
	aStream display: urlString
!

hash
	^urlString hash
!

host
	^self hostPort readStream upTo: $:
!

hostPort
	| authority authorityStream |
	authority := self authority.
	authorityStream := authority readStream.
	(authority includes: $@) ifTrue: [authorityStream upTo: $@].
	^authorityStream upToEnd
!

lastSegment
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/index.html') lastSegment
		'index.html' 
	"

	^self class lastSegmentOfPath: self path
!

lastSegmentAndQuery
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/index.html?foo=bar') lastSegmentAndQuery
		'index.html?foo=bar'
	"

	| query |
	^(query := self queryString) isEmpty 
		ifTrue: [self lastSegment]
		ifFalse: [self lastSegment , '?' , query]
!

localBasePath
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/bar/index.html') localBasePath
		'/bar/'
	"

	| path |
	path := self path.
	^path last = $/ 
		ifTrue: [path]
		ifFalse: [path copyFrom: 1 to: (path findLast: [:each | each = $/])]
!

localBaseUrl
	Notification deprecated.
	^self localBaseUrlString
!

localBaseUrlString
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/bar/index.html') localBaseUrlString
		'http://www.foo.org/bar/'
	"

	^self rootBaseUrlString , self localBasePath
!

path
	| absolutePath end |
	absolutePath := self absolutePath.
	end := absolutePath indexOfAnyOf: '?#' startingAt: 1.
	^end = 0 ifTrue: [absolutePath] ifFalse: [absolutePath copyFrom: 1 to: end - 1]
!

port
	| stream |
	stream := self hostPort readStream.
	stream upTo: $:.
	^stream atEnd ifTrue: [self defaultPort] ifFalse: [stream upToEnd asNumber]
!

querySegments
        "
        (SptHTTPUrl fromString: 'http://www.foo.org/index.html?foo=bar') querySegments
                an OrderedCollection('foo' 'bar')
        "

        | segments qs |
        segments := OrderedCollection new.
        qs := self queryString.
        qs notEmpty ifTrue:[
            (qs subStrings: $&) do: 
                        [:each | 
                        | stream |
                        stream := each trimBlanks readStream.
                        segments add: (stream upTo: $=).
                        stream atEnd ifFalse: [segments add: stream upToEnd]].
        ].
        ^segments

    "Modified: / 23-09-2011 / 21:15:33 / cg"
!

queryString
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/index.html?foo=bar') queryString
		'foo=bar'
	"

	| stream |
	stream := self absolutePath readStream.
	stream upTo: $?.
	^stream upToEnd
!

queryStrings
        "
        (SptHTTPUrl fromString: 'http://www.foo.org/index.html?foo=bar') queryStrings
                #('foo' -> 'bar')
        "
        |qs|

        qs := self queryString.
        qs isEmpty ifTrue:[^ #() ].
        ^(qs subStrings: $&) collect: 
                        [:each | 
                        | k v stream |
                        stream := each trimBlanks readStream.
                        k := stream upTo: $=.
                        v := stream atEnd ifTrue: [] ifFalse: [stream upToEnd].
                        k -> v]

    "Modified: / 23-09-2011 / 21:13:41 / cg"
!

rootBaseUrl
	Notification deprecated.
	^self rootBaseUrlString
!

rootBaseUrlString
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/bar/index.html') rootBaseUrlString
		'http://www.foo.org'
	"

	| stream scheme |
	stream := urlString readStream.
	scheme := self schemeFrom: stream.
	^scheme , '://' , (stream upTo: $/)
!

scheme
	"
	(SptHTTPUrl fromString: 'http://www.foo.org/bar/index.html') scheme
		'http'
	"

	^self schemeFrom: urlString readStream
!

url: aUrlString
	Notification deprecated.
	urlString := aUrlString
!

urlString
	^urlString
!

userInfo
	| authority authorityStream |
	((authority := self authority) includes: $@) ifFalse: [^nil].
	authorityStream := authority readStream.
	^authorityStream upTo: $@
! !

!SptHTTPUrl methodsFor:'testing'!

hasUserInfo
	^self authority includes: $@
!

isFileScheme
	^false
!

isHttpUrl
	^true
!

isInSpaceOf: aString
	^urlString beginsWith: (self class fromString: aString) localBaseUrlString
!

isNullUrl
	^urlString isNil or: [urlString isEmpty]
!

isSecure
	^self scheme = 'https'
! !

!SptHTTPUrl class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPUrl.st,v 1.3 2011-10-05 16:22:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPUrl.st,v 1.3 2011-10-05 16:22:28 cg Exp $'
! !

SptHTTPUrl initialize!
