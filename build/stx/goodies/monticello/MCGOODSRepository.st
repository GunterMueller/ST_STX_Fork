"{ Package: 'stx:goodies/monticello' }"

MCRepository subclass:#MCGOODSRepository
	instanceVariableNames:'hostname port connection'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCGOODSRepository class methodsFor:'instance creation'!

host: hostname port: portNumber
	^ self new
		host: hostname;
		port: portNumber
! !

!MCGOODSRepository class methodsFor:'queries'!

creationTemplate
	^
'MCGOODSRepository
	host: ''localhost''
	port: 6100'
!

description
	^ 'GOODS'
! !

!MCGOODSRepository methodsFor:'accessing'!

description
	^ 'goods://', hostname asString, ':', port asString
!

host: aString
	hostname := aString
!

packages
	^ (self root collect: [:ea | ea package]) asSet asSortedCollection
!

port: aNumber
	port := aNumber
! !

!MCGOODSRepository methodsFor:'as yet unclassified'!

db
	(connection isNil or: [connection isConnected not]) ifTrue: [
		connection := Smalltalk at: #KKDatabase ifPresent: [:cl | 
			cl  onHost:hostname port: port
		]
	].
	^ connection
!

root
	self db root ifNil: [self db root: Dictionary new].
	^ self db root
!

versionWithInfo: aVersionInfo ifAbsent: errorBlock
	^ self root at: aVersionInfo ifAbsent: errorBlock
! !

!MCGOODSRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	self root at: aVersion info put: aVersion.
	self db commit.
! !

!MCGOODSRepository methodsFor:'queries'!

versionsAvailableForPackage: aPackage
	^ self root asArray select: [:ea | ea package = aPackage] thenCollect: [:ea | ea info]
! !

!MCGOODSRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCGOODSRepository.st,v 1.5 2014-02-12 14:53:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCGOODSRepository.st,v 1.5 2014-02-12 14:53:36 cg Exp $'
!

version_SVN
    ^ '$Id: MCGOODSRepository.st,v 1.5 2014-02-12 14:53:36 cg Exp $'
! !

