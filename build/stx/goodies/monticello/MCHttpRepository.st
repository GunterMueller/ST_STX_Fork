"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCFileBasedRepository subclass:#MCHttpRepository
	instanceVariableNames:'location user password readerCache'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCHttpRepository class methodsFor:'initialization'!

clearPasswords
	self allSubInstancesDo: [:ea | ea password: ''].

! !

!MCHttpRepository class methodsFor:'instance creation'!

location: location user: user password: password
	^ self new
		location: location;
		user: user;
		password: password
! !

!MCHttpRepository class methodsFor:'queries'!

creationTemplate
	^self creationTemplateLocation: 'http://www.squeaksource.com/'
		user: 'squeak'
		password: 'squeak'

!

creationTemplateLocation: location user: user password: password
        ^
'MCHttpRepository
        location: %1
        user: %2
        password: %3' 
            bindWith: location storeString 
            with: user storeString
            with: password storeString

    "Modified: / 16-09-2010 / 14:34:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
	^ 'HTTP'
! !

!MCHttpRepository methodsFor:'accessing'!

location
      ^location 
!

location: aUrlString
	location := aUrlString
!

locationWithTrailingSlash
	^ (location endsWith: '/')
		ifTrue: [location]
		ifFalse: [location, '/']
!

password
	self userAndPasswordFromSettingsDo: [:usr :pwd | ^pwd].

	self user isEmpty ifTrue: [^password].

	[password isEmpty] whileTrue: [
		| answer |
		"Give the user a chance to change the login"
		answer := UIManager default request: 'User name for ' translated, String cr, location
			initialAnswer: self user.
		answer isEmpty
			ifTrue: [^password]
			ifFalse: [self user: answer].
		
		password := UIManager default requestPassword: 'Password for' translated, ' "', self user, '" ', 'at ' translated, String cr, location.
	].

	^ password
!

password: passwordString
	password := passwordString
!

user
	self userAndPasswordFromSettingsDo: [:usr :pwd | ^usr].
	"not in settings"
	^user
!

user: userString
	user := userString
! !

!MCHttpRepository methodsFor:'as yet unclassified'!

asCreationTemplate
	^self class creationTemplateLocation: location user: user password: password
!

parseFileNamesFromStream: aStream
	| names fullName |
	names := OrderedCollection new.
	[aStream atEnd] whileFalse:
		[[aStream upTo: $<. {$a. $A. nil} includes: aStream next] whileFalse.
		aStream upTo: $".
		aStream atEnd ifFalse: [
			fullName := aStream upTo: $".
			names add: fullName unescapePercents]].
	^ names
!

userAndPasswordFromSettingsDo: aBlock
	"The mcSettings file in ExternalSettings preferenceDirectory should contain entries for each account:
	
		account1: *myhost.mydomain* user:password
		account2: *otherhost.mydomain/somerep* dXNlcjpwYXNzd29yZA==

	That is it must start with 'account', followed by anything to distinguish accounts, and a colon. Then comes a match expression for the repository url, and after a space the user:password string.
	
	To not have the clear text password on your disc, you can base64 encode it:
			(Base64MimeConverter mimeEncode: 'user:password' readStream) contents
	"

	| entry userAndPassword |
	Settings ifNotNil: [
		Settings keysAndValuesDo: [:key :value |
			(key asLowercase beginsWith: 'account') ifTrue: [
				entry := value findTokens: '	 '.
				(entry first match: location) ifTrue: [
					userAndPassword := entry second.
					(userAndPassword includes: $:) ifFalse: [
						userAndPassword := (Base64MimeConverter mimeDecodeToChars: userAndPassword readStream) contents].
					userAndPassword := userAndPassword findTokens: $:.
					^aBlock value: userAndPassword first 
						value: userAndPassword second 
					]
			]
		]
	].
	^nil
!

versionReaderForFileNamed: aString
	readerCache ifNil: [readerCache := Dictionary new].
	^ readerCache at: aString ifAbsent:
		[self resizeCache: readerCache.
		super versionReaderForFileNamed: aString do:
			[:r |
			r ifNotNil: [readerCache at: aString put: r]]]
	
!

versionReaderForFileNamed: aString do: aBlock

    | r |

    ^(r := self versionReaderForFileNamed: aString) ifNotNil: [aBlock value: r]

    "Modified: / 14-09-2010 / 19:39:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCHttpRepository methodsFor:'displaying'!

displayString

    ^location

    "Created: / 14-09-2010 / 23:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCHttpRepository methodsFor:'queries'!

urlForFileNamed: aString
        ^ self locationWithTrailingSlash, aString utf8Encoded

    "Modified: / 14-09-2010 / 19:32:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCHttpRepository methodsFor:'required'!

allFileNames
        | response |
        response := HTTPInterface get: self locationWithTrailingSlash, '?C=M;O=D' userName: self user password: self password.
        response responseCode ~= 200 
            ifTrue: [self error:('Could not access "',location,'" (',response response asString,')')].
        ^ self parseFileNamesFromStream: response data readStream

    "Modified: / 14-09-2010 / 19:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 12:34:23 / cg"
!

description
	^ location
!

flushCache
	super flushCache.
	readerCache := nil.
!

readStreamForFileNamed: aString do: aBlock

    | response |
    response := HTTPInterface get: (self urlForFileNamed: aString) userName: self user password: self password.
    ^response responseCode == 200 
        ifTrue: [aBlock value: response data readStream].

    "Modified: / 14-09-2010 / 19:38:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeStreamForFileNamed: aString replace: ignoreBoolean do: aBlock
        | stream response |
        stream := RWBinaryOrTextStream on: String new.
        aBlock value: stream.
"/        response := HTTPSocket
"/                                        httpPut: stream contents
"/                                        to: (self urlForFileNamed: aString)
"/                                        user: self user
"/                                        passwd: self password.
        response := HTTPInterface
                        request:#PUT
                        url:(self urlForFileNamed: aString)
                        fromHost:nil port:nil
                        accept:#('*/*')
                        fromDocument:nil
                        userName:self user password: self password 
                        contentType:'application/octet-stream'
                        contents:stream contents asString.

        (#( 201 200 ) includes: response responseCode) ifFalse: [self error: response].

    "Modified: / 24-04-2015 / 00:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCHttpRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCHttpRepository.st,v 1.7 2014-02-12 14:53:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCHttpRepository.st,v 1.7 2014-02-12 14:53:40 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: MCHttpRepository.st,v 1.7 2014-02-12 14:53:40 cg Exp $'
! !

