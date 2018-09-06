"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCRepository subclass:#MCFileBasedRepository
	instanceVariableNames:'cache allFileNames'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCFileBasedRepository class methodsFor:'misc'!

flushAllCaches
	self allSubInstancesDo: [:ea | ea flushCache]
! !

!MCFileBasedRepository methodsFor:'as yet unclassified'!

cache
	^ cache ifNil: [cache := Dictionary new]
!

cacheAllFileNamesDuring: aBlock
	allFileNames := self allFileNames.
	^ aBlock ensure: [allFileNames := nil]
!

cachedFileNames
	^cache == nil
		ifTrue: [#()]
		ifFalse: [cache keys]
!

canReadFileNamed: aString
	| reader |
	reader := MCVersionReader readerClassForFileNamed: aString.
	^ reader notNil
!

filterFileNames: aCollection forVersionNamed: aString
	^ aCollection select: [:ea | (self versionNameFromFileName: ea) = aString] 
!

flushCache
	cache := nil
!

loadVersionFromFileNamed: aString
	^ self versionReaderForFileNamed: aString do: [:r | r version]
!

loadVersionInfoFromFileNamed: aString
	^ self versionReaderForFileNamed: aString do: [:r | r info]
	
!

maxCacheSize
	^ 8
!

notifyList
        (self allFileNames includes: 'notify') ifFalse: [^ #()].
        ^ self readStreamForFileNamed: 'notify' do:
                [:s |
                s upToEnd asStringWithSqueakLineEndings findTokens: (String with: Character cr)]

    "Modified: / 12-09-2010 / 16:06:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageNameFromFileName: aString
        ^ (aString copyUpToLast: $-)

    "Created: / 16-09-2010 / 16:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2010 / 18:45:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStreamForFileNamed: aString do: aBlock
    self subclassResponsibility
!

resizeCache: aDictionary
        [aDictionary size <= self maxCacheSize] whileFalse:
                [aDictionary removeKey: aDictionary keys asArray atRandom]

    "Modified: / 15-09-2010 / 13:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionReaderForFileNamed: aString do: aBlock
        ^ self
                readStreamForFileNamed: aString
                do: [:s | | class |                    
                        (class := MCVersionReader readerClassForFileNamed: aString) ifNotNil:
                                [ aBlock value: (class on: s fileName: aString)]]

    "Modified: / 12-09-2010 / 19:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionWithInfo: aVersionInfo ifAbsent: errorBlock
	| version |
	(self allFileNamesForVersionNamed: aVersionInfo name) do:
		[:fileName |
		version := self versionFromFileNamed: fileName.
		version info = aVersionInfo ifTrue: [^ version]].
	^ errorBlock value
!

writeStreamForFileNamed: aString do: aBlock
	^ self writeStreamForFileNamed: aString replace: false do: aBlock
! !

!MCFileBasedRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	self
		writeStreamForFileNamed: aVersion fileName
		do: [:s | aVersion fileOutOn: s].
	aVersion isCacheable ifTrue: [
		cache ifNil: [cache := Dictionary new].
		cache at: aVersion fileName put: aVersion].

! !

!MCFileBasedRepository methodsFor:'queries'!

allFileNames
	self subclassResponsibility
!

allFileNamesForVersionNamed: aString
	^ self filterFileNames: self readableFileNames forVersionNamed: aString
!

allFileNamesOrCache
	^ allFileNames ifNil: [self allFileNames]
!

allPackageNames
        ^ (self readableFileNames collect: [:ea | self packageNameFromFileName: ea])
            asSet asOrderedCollection

    "Created: / 16-09-2010 / 16:10:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2010 / 18:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allVersionNames
	^ self readableFileNames collect: [:ea | self versionNameFromFileName: ea]
!

closestAncestorVersionFor: anAncestry ifNone: errorBlock
	^ self cacheAllFileNamesDuring:
		[super closestAncestorVersionFor: anAncestry ifNone: errorBlock]
!

includesVersionNamed: aString
	^ self allVersionNames includes: aString
!

possiblyNewerVersionsOfAnyOf: someVersions
        | pkgs |
        pkgs := Dictionary new.

        someVersions do: [:aVersionInfo |
                pkgs at: (aVersionInfo name copyUpToLast: $-)
                        put: (aVersionInfo name copyAfterLast: $.) asNumber].

        ^[
            self allVersionNames select: [:each |
                (pkgs at: (each copyUpToLast: $-) ifPresent: [:verNumber |
                        verNumber < (each copyAfterLast: $.) asNumber
                                or: [verNumber = (each copyAfterLast: $.) asNumber
                                        and: [someVersions noneSatisfy: [:v | v name = each]]]]) == true]
        ] on: Error do: [:ex | 
            ex return: #()
        ]
!

readableFileNames
	| all cached new |
	all := self allFileNamesOrCache.	"from repository"
	cached := self cachedFileNames.	"in memory"
	new := all difference: cached.
	^ (cached asArray, new)
		select: [:ea | self canReadFileNamed: ea]
!

versionFromFileNamed: aString
	| v |
	v := self cache at: aString ifAbsent: [self loadVersionFromFileNamed: aString].
	self resizeCache: cache.
	(v notNil and: [v isCacheable]) ifTrue: [cache at: aString put: v].
	^ v
!

versionInfoFromFileNamed: aString
	self cache at: aString ifPresent: [:v | ^ v info].
	^ self loadVersionInfoFromFileNamed: aString
!

versionNameFromFileName: aString
	^ (aString copyUpToLast: $.) copyUpTo: $(
! !

!MCFileBasedRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFileBasedRepository.st,v 1.7 2015-02-09 13:57:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFileBasedRepository.st,v 1.7 2015-02-09 13:57:21 cg Exp $'
!

version_SVN
    ^ '$Id: MCFileBasedRepository.st,v 1.7 2015-02-09 13:57:21 cg Exp $'
! !

