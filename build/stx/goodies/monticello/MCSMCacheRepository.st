"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCFileBasedRepository subclass:#MCSMCacheRepository
	instanceVariableNames:'smCache'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!

MCSMCacheRepository comment:'I am a Monticello repository that reflects the caching of SqueakMap v2.

I refer write attempts to the default MCCacheRepository.'
!


!MCSMCacheRepository class methodsFor:'instance creation'!

description
	^ 'SqueakMap Cache'
!

morphicConfigure
	^self new
! !

!MCSMCacheRepository methodsFor:'accessing'!

allFileNames
	^self allFullFileNames collect: [ :ea | self directory localNameFor: ea ]
!

allFullFileNames
	| cachedPackages |
	cachedPackages _ smCache map installedPackages select: [ :ea | ea isCached ].
	^Array streamContents: [ :s |
		cachedPackages do: [ :ea | | d |
			d _ ea cacheDirectory.
			(d fileNamesMatching: '*.mcz') do: [ :fn | s nextPut: (d fullNameFor: fn) ]]]
!

description
	^ smCache directory pathName
!

directory
	^ smCache directory
!

directory: aDirectory
!

fullNameFor: aFileName
	^self allFullFileNames detect: [ :ffn | (self directory localNameFor: ffn) = aFileName ] ifNone: []
!

smCache
	^smCache
!

smCache: aSMFileCache
	| |
	smCache := aSMFileCache.
	self directory: aSMFileCache directory.
! !

!MCSMCacheRepository methodsFor:'comparing'!

hash
	^ smCache hash
! !

!MCSMCacheRepository methodsFor:'file streaming'!

readStreamForFileNamed: aString do: aBlock
	| file fileName |
	fileName _ self fullNameFor: aString.
	fileName ifNil: [
		"assume that this will come from the cache."
		^MCCacheRepository default readStreamForFileNamed: aString do: aBlock ].
	file _ FileStream readOnlyFileNamed: fileName.
	^[ aBlock value: file ] ensure: [ file close ].
!

writeStreamForFileNamed: aString replace: aBoolean do: aBlock
	"Can't write into the SM cache, so..."
	^MCCacheRepository default writeStreamForFileNamed: aString replace: aBoolean do: aBlock
! !

!MCSMCacheRepository methodsFor:'initialize-release'!

initialize
	super initialize.
	smCache _ SMSqueakMap default cache.
! !

!MCSMCacheRepository methodsFor:'testing'!

isValid
	^smCache notNil and: [ self directory exists ]
! !

!MCSMCacheRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSMCacheRepository.st,v 1.2 2012-09-11 21:14:13 cg Exp $'
! !

