"{ Package: 'stx:goodies/monticello' }"

MCDirectoryRepository subclass:#MCSubDirectoryRepository
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!

MCSubDirectoryRepository comment:'A MCDirectoryRepository that looks in subdirectories too.'
!


!MCSubDirectoryRepository class methodsFor:'queries'!

description
	^ 'directory with subdirectories'
! !

!MCSubDirectoryRepository methodsFor:'as yet unclassified'!

findFullNameForReading: aBaseName
	"Answer the latest version of aBaseName"
	| possible |
	possible := SortedCollection sortBlock: [ :a :b | b first modificationTime < a first modificationTime ].
	self allDirectories
		do: [:dir | dir entries
				do: [:ent | ent isDirectory
						ifFalse: [
							(ent name = aBaseName) ifTrue: [ possible add: {ent. dir fullNameFor: ent name}]]]].
	^(possible at: 1 ifAbsent: [ ^nil ]) second

!

findFullNameForWriting: aBaseName
	| possible split dirScore fileScore prefix fpattern parts now |
	split := directory splitNameVersionExtensionFor: aBaseName.
	fpattern := split first, '*'.
	possible := SortedCollection sortBlock: [ :a :b |
		a first = b first
			ifTrue: [ a second = b second
					ifFalse: [ a second < b second ]
					ifTrue: [ a third fullName size < b third fullName size ]]
			ifFalse: [ a first > b first ] ].
	now := Time totalSeconds.
	prefix := directory pathParts size.
	self allDirectories do: [:dir |
		parts := dir pathParts allButFirst: prefix.
		dirScore := (parts select: [ :part | fpattern match: part ]) size.
		fileScore := (dir entries collect: [ :ent |
			(ent isDirectory not and: [ fpattern match: ent name ])
				ifFalse: [ SmallInteger maxVal ]
				ifTrue: [ now - ent modificationTime ]]).	"minimum age"
		fileScore := fileScore isEmpty ifTrue: [ SmallInteger maxVal  ]
			ifFalse: [ fileScore min ].
		possible add: { dirScore. fileScore. dir } ].
	^ (possible first third) fullNameFor: aBaseName
!

readStreamForFileNamed: aString do: aBlock
	| file val |
	file := FileStream readOnlyFileNamed: (self findFullNameForReading: aString).
	val := aBlock value: file.
	file close.
	^ val
!

writeStreamForFileNamed: aString replace: aBoolean do: aBlock 
	| file |
	file := aBoolean
				ifTrue: [FileStream
						forceNewFileNamed: (self findFullNameForReading: aString)]
				ifFalse: [FileStream
						newFileNamed: (self findFullNameForWriting: aString)].
	aBlock value: file.
	file close
! !

!MCSubDirectoryRepository methodsFor:'enumeration'!

allDirectories
	| remaining dir dirs |
	remaining := OrderedCollection new.
	dirs := OrderedCollection new.
	remaining addLast: directory.
	[remaining isEmpty]
		whileFalse: [dir := remaining removeFirst.
			dirs add: dir.
			dir entries
				do: [:ent | ent isDirectory
						ifTrue: [remaining
								addLast: (dir directoryNamed: ent name)]]].
	^ dirs
!

allFileNames
	"sorting {entry. dirName. name}"

	| sorted |
	sorted := SortedCollection sortBlock: [:a :b |
		a first modificationTime >= b first modificationTime ].
	self allDirectories
		do: [:dir | dir entries
				do: [:ent | ent isDirectory
						ifFalse: [sorted add: {ent. dir fullName. ent name}]]].
	^ sorted
		collect: [:ea | ea third ]
! !

!MCSubDirectoryRepository methodsFor:'user interface'!

description
	^ directory pathName, '/*'
! !

!MCSubDirectoryRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSubDirectoryRepository.st,v 1.5 2014-02-12 14:53:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSubDirectoryRepository.st,v 1.5 2014-02-12 14:53:39 cg Exp $'
!

version_SVN
    ^ '$Id: MCSubDirectoryRepository.st,v 1.5 2014-02-12 14:53:39 cg Exp $'
! !

