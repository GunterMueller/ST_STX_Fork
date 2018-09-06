"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

SDCachedStore subclass:#SDFileStore
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Store'
!

SDFileStore class instanceVariableNames:'serializer'

"
 No other class instance variables are inherited by this class.
"
!


!SDFileStore class methodsFor:'accessing'!

serializer
	^ serializer ifNil: [ serializer := SDSmartRefStreamSerializer new ]
!

serializer: aSerializer
	serializer := aSerializer
! !

!SDFileStore methodsFor:'actions'!

commit: aBlock
	self shouldNotImplement
!

ensureDown
	self initializeCache 
!

ensureForClass: aClass 
        | dir |
        super ensureForClass: aClass.
        Smalltalk isSmalltalkX ifTrue:[
            dir := (self dirForClass: aClass) recursiveMakeDirectory.
            0 to: 9 do: [ :num | (dir / num asString) makeDirectory ].
        ] ifFalse:[
            dir := (self dirForClass: aClass) assureExistence.
            0 
                to: 9
                do: [ :num | (dir directoryNamed: num asString) assureExistence ].
        ]
!

loadClass: aClass atId: anId
	[ 
	| obj name |
	name := (self dirForClass: aClass atId: anId) fullNameFor: anId , '.obj'.
	obj := self class serializer materializeFromFile: name.
	^ obj
		onLoad;
		yourself ] on: Error do: [ :err | SDLoadError signal: 'Loading id=' , anId , '. ' , err messageText ]
!

recoverForClass: aClass 
	self
		finishPartialCommitsForClass: aClass;
		deleteFailedCommitsForClass: aClass;
		loadChangesForClass: aClass
!

removeObject: anObject
	| dir |
	super removeObject: anObject.
	dir := self dirForClass: anObject class atId: anObject id.	
	"kill all versions or failed commits of this object"
	dir
		deleteFileNamed: anObject id , '.obj';
		deleteFileNamed: anObject id , '.new';
		deleteFileNamed: anObject id , '.old'
!

storeObject: origObject
	"The basic idea here is to make a save as atomic as possible and no data 
	is corrupted, no partial writes, thus renaming files as atomic."

	| currentVersion newVersion oldVersion dir anObject |
	super storeObject: origObject.
	anObject := origObject sandstoneDeepCopy sandstoneMarkReferences.
	dir := self dirForClass: anObject class atId: anObject id.
	currentVersion := dir fullNameFor: anObject id , '.obj'.
	newVersion := currentVersion , '.new'.
	oldVersion := currentVersion , '.old'.	"just in case a previous commit failed and left junk around"
	dir deleteFileNamed: newVersion.	"the flush ensures all data is actually written to disk before moving on"
	self class serializer serialize: anObject toFile: newVersion.
	dir deleteFileNamed: oldVersion.	"the pre-commit, on first save there won't be a current version, and fileExists is 
	too expensive to check when it'll always be there except on first save"
	[ dir sandstoneRename: currentVersion toBe: oldVersion ]
		ifError: [ 
			"just ignore it"
			 ].	"now the actual commit"
	dir sandstoneRename: newVersion toBe: currentVersion.	"clean up the junk (could fail if OS has lock on it for some reason)"
	dir deleteFileNamed: oldVersion
!

updateObject: anObject
	self storeObject: anObject
! !

!SDFileStore methodsFor:'crash recovery'!

deleteFailedCommitsForClass: aClass 
        "all remaining .new files are failed commits, kill them"
        
        [ 
            false "Smalltalk isSmalltalkX" ifTrue:[
                (self dirForClass: aClass) directoryContentsDo:[:each |
self halt.
                ]
            ] ifFalse:[
                (self dirForClass: aClass) fullNamesOfAllFilesInSubtree 
                    select: [ :each | each endsWith: '.new' ]
                        thenDo: [ :each | FileDirectory deleteFilePath: each ] 
            ]
        ] on: Error
        do: [ :err | self halt. Transcript showCR: err ]
!

finishPartialCommitsForClass: aClass 
	"find where .new exists but .obj doesn't, rename .obj.new to
	.obj to finish commit'"
	
	[ (self dirForClass: aClass) fullNamesOfAllFilesInSubtree 
		select: [ :each | each endsWith: '.obj.new' ]
		thenDo: 
			[ :each | 
			| objFile dir |
			objFile := FileDirectory localNameFor: (each 
					copyReplaceAll: '.new'
					with: '').
			dir := FileDirectory forFileName: each.
			(dir fileExists: objFile) ifFalse: 
				[ dir 
					rename: (FileDirectory localNameFor: each)
					toBe: objFile ] ] ] 
		on: Error
		do: 
			[ :err | 
			Transcript
				show: err;
				cr ]
!

loadChangesForClass: aClass 
	| id obj |
	(self dirForClass: aClass) withSubdirectoriesDo: [ :dir | 
		[ dir entries do: 
			[ :each | 
			"there could be tens of thousands of entries, so using do with 
			a condition to avoid the copy a select would generate"
			each isDirectory ifFalse: 
				[ id := each name copyUpTo: $..
				obj := (cache at: aClass) at: id ifAbsent: [ nil ].
				obj 
					ifNil: [ self cachedLoadOfClass: aClass from:  id ]
					ifNotNil: [ obj abortChanges ] ] ] ]
			on: Error
			do: [ :err | Transcript 	show: err; 	cr ] ]
! !

!SDFileStore methodsFor:'defaults'!

defaultBaseDirectory
        "you can override this if you want to force the db somewhere else"
    Smalltalk isSmalltalkX ifTrue:[
        ^ Filename currentDirectory / '.SandstoneDb'          
    ] ifFalse:[
        ^ FileDirectory default directoryNamed: 
                (FileDirectory baseNameFor: 
                        (FileDirectory localNameFor: 
                                SmalltalkImage current imageName)) , '.SandstoneDb'
    ]
! !

!SDFileStore methodsFor:'queries'!

dirForClass: aClass 
        "compute the path of superclasses all the way up to ActiveRecord, storing 
        subclass records as a subdirectory of the superclasses directory 
        allows ActiveRecord to deal with inheritance"
        | parentClass lineage |
        aClass == SDActiveRecord ifTrue: 
                [ Error signal: 'ActiveRecord itself is abstract, you must only  
 store subclasses' ].
        lineage := OrderedCollection with: aClass.
        parentClass := aClass superclass.
        [ parentClass == SDActiveRecord ] whileFalse: 
                [ lineage addFirst: parentClass.
                parentClass := parentClass superclass ].
        ^ lineage 
                inject: self defaultBaseDirectory
                into: [ :dir :each |
                    Smalltalk isSmalltalkX ifTrue:[
                        dir / each name 
                    ] ifFalse:[
                        dir directoryNamed: each name 
                    ]
                ]
!

dirForClass: aClass atId: anId 
	"Grab the correct hashed subdirectory for this record"
	^ (self dirForClass: aClass) directoryNamed: (self dirNameFor: anId)
!

dirNameFor: anId 
	"Answers a string with one decimal digit corresponding to anId.  There is a bug
	in this that does not ever hash to the directory 1, but because of existing datasets
	this must remain, do not want to rehash my databases and it is no big deal"
	self flag: #knownBug.
	^ (anId inject: 0 into: [ : sum : e | sum + e asInteger ]) asReducedSumOfDigits asString
!

familyForClass: aClass 
	"I'm returing raw cache dictionary here because this read only copy
	doesn't need concurrency protection, just a naked dictionary''"
	^ aClass allSubclasses 
		inject: (cache at: aClass) dictionary
		into: [ :sum :subclass | sum , (cache at: subclass) dictionary ]
! !

!SDFileStore class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDFileStore.st,v 1.7 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDFileStore.st,v 1.7 2013-04-17 23:18:47 cg Exp $'
! !

