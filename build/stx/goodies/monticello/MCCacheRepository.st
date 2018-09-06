"{ Package: 'stx:goodies/monticello' }"

MCDirectoryRepository subclass:#MCCacheRepository
	instanceVariableNames:'packageCaches seenFiles'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!

MCCacheRepository class instanceVariableNames:'default'

"
 No other class instance variables are inherited by this class.
"
!


!MCCacheRepository class methodsFor:'initialization'!

initialize
	self checkCacheDirectory
! !

!MCCacheRepository class methodsFor:'instance creation'!

default
	self checkCacheDirectory.
	^ default ifNil: [default _ self new directory: self cacheDirectory]
! !

!MCCacheRepository class methodsFor:'misc'!

cacheDirectory
	^ (FileDirectory default directoryNamed: 'package-cache')
		assureExistence;
		yourself
!

checkCacheDirectory
	default notNil and: [default directory exists ifFalse: [default _ nil]]
! !

!MCCacheRepository class methodsFor:'queries'!

description
	^ nil
! !

!MCCacheRepository methodsFor:'accessing'!

seenFileNames
	^ seenFiles ifNil: [seenFiles _ OrderedCollection new]
! !

!MCCacheRepository methodsFor:'as yet unclassified'!

cacheForPackage: aPackage
	packageCaches ifNil: [packageCaches _ Dictionary new].
	^ packageCaches at: aPackage ifAbsentPut: [MCPackageCache new]
!

newFileNames 
	^ self allFileNames difference: self seenFileNames
!

packageForFileNamed: aString
	^ self packageCache at: aString ifAbsentPut: [self versionReaderForFileNamed: aString do: [:r | r package]]
!

rescan
	self newFileNames do:
		[:ea |
		self versionReaderForFileNamed: ea do:
			[:reader |
			(self cacheForPackage: reader package)
				recordVersionInfo: reader info
				forFileNamed: ea.
			self seenFileNames add: ea]]
		displayingProgress: 'Scanning cache...'
! !

!MCCacheRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	(aVersion isCacheable and: [self allFileNames includes: aVersion fileName])
		ifFalse: [super basicStoreVersion: aVersion]
! !

!MCCacheRepository methodsFor:'queries'!

versionInfoForFileNamed: aString
	^ self infoCache at: aString ifAbsentPut: [self versionReaderForFileNamed: aString do: [:r | r info]]
! !

!MCCacheRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCCacheRepository.st,v 1.3 2014-02-12 14:53:37 cg Exp $'
! !


MCCacheRepository initialize!
