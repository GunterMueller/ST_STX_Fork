"{ Package: 'stx:goodies/monticello' }"

MCWriteOnlyRepository subclass:#MCSMReleaseRepository
	instanceVariableNames:'packageName user password'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCSMReleaseRepository class methodsFor:'instance creation'!

package: packageString user: userString password: passString
	^ self basicNew initializeWithPackage: packageString user: userString password: passString
! !

!MCSMReleaseRepository class methodsFor:'queries'!

creationTemplate
	^
'MCSMReleaseRepository
	package: ''mypackage''
	user: ''squeak''
	password: ''squeak'''
	
!

description
	^ 'SqueakMap Release'
! !

!MCSMReleaseRepository methodsFor:'accessing'!

description
	^ 'sm://', packageName
! !

!MCSMReleaseRepository methodsFor:'as yet unclassified'!

checkResult: resultString
(#( 'HTTP/1.1 201 ' 'HTTP/1.1 200 ' 'HTTP/1.0 201 ' 'HTTP/1.0 200 ')
		anySatisfy: [:code | resultString beginsWith: code ])
			ifFalse: [self error: resultString].

!

releaseVersion: aVersion url: urlString
	| result |
	result := HTTPSocket
		httpPost: self squeakMapUrl, '/packagebyname/', packageName, '/newrelease'
		args: {'version' -> {(aVersion info name copyAfter: $.) extractNumber asString}.
			   'note' -> {aVersion info message}.
			   'downloadURL' -> {urlString}}
		user: user
		passwd: password.
	result contents size > 4 ifTrue: [self error: result contents]

!

squeakMapUrl 
	^ 'http://localhost:9070/sm'

!

uploadVersion: aVersion
        | result stream |
        result := HTTPSocket
                httpPut: (self stringForVersion: aVersion)
                to: self squeakMapUrl, '/upload/', aVersion fileName
                user: user
                passwd: password.
        self checkResult: result.
        stream := result readStream.
        stream skipThroughAll: 'http://'.
        ^ 'http://', stream upToEnd
! !

!MCSMReleaseRepository methodsFor:'initialization'!

initializeWithPackage: packageString user: userString password: passString
	packageName := packageString.
	user := userString.
	password := passString.

! !

!MCSMReleaseRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	| url |
	url := self uploadVersion: aVersion.
	self releaseVersion: aVersion url: url
! !

!MCSMReleaseRepository methodsFor:'queries'!

stringForVersion: aVersion
	| stream |
	stream := RWBinaryOrTextStream on: String new.
	aVersion fileOutOn: stream.
	^ stream contents
! !

!MCSMReleaseRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSMReleaseRepository.st,v 1.6 2014-03-01 22:43:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSMReleaseRepository.st,v 1.6 2014-03-01 22:43:05 cg Exp $'
!

version_SVN
    ^ '$Id: MCSMReleaseRepository.st,v 1.6 2014-03-01 22:43:05 cg Exp $'
! !

