"{ Package: 'stx:goodies/monticello' }"

MCReader subclass:#MCVersionReader
	instanceVariableNames:'package info definitions dependencies stepChildren'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCVersionReader class methodsFor:'*monticello-file services'!

loadVersionStream: stream fromDirectory: directory
	| version |
	version := self versionFromStream: stream.
	directory isRemoteDirectory ifFalse: [
	version workingCopy repositoryGroup addRepository:
		(MCDirectoryRepository new directory: directory). ].
	version load.

!

mergeVersionStream: stream
	(self versionFromStream: stream) merge
!

openVersionFromStream: stream
	(self versionFromStream: stream) open
! !

!MCVersionReader class methodsFor:'*monticello-file services-override-override'!

serviceLoadVersion
	^ (SimpleServiceEntry
		provider: self
		label: 'load version'
		selector: #loadVersionStream:fromDirectory:
		description: 'load a package version'
		buttonLabel: 'load')
		argumentGetter: [ :fileList | { fileList readOnlyStream . fileList directory } ]
!

serviceMergeVersion
	^ (SimpleServiceEntry
		provider: self
		label: 'merge version'
		selector: #mergeVersionStream:
		description: 'merge a package version into the image'
		buttonLabel: 'merge')
		argumentGetter: [ :fileList | fileList readOnlyStream ]
!

serviceOpenVersion
	^ (SimpleServiceEntry
		provider: self
		label: 'open version'
		selector: #openVersionFromStream:
		description: 'open a package version'
		buttonLabel: 'open')
		argumentGetter: [ :fileList | fileList readOnlyStream ]
! !

!MCVersionReader class methodsFor:'file services'!

fileReaderServicesForFile: fullName suffix: suffix
	self isAbstract ifTrue: [^ #()].
	^ ((suffix = self extension) or: [ suffix = '*' ])
		ifTrue: [self services]
		ifFalse: [Array new: 0]
		
!

initialize
        "MCVersionReader initialize"
        "
        Smalltalk 
                at: #MczInstaller
                ifPresent: [:installer | FileList unregisterFileReader: installer].
        self concreteSubclasses do: [:aClass | FileList registerFileReader: aClass].
        "
        "get rid of AnObsoleteMCMcReader and AnObsoleteMCMcvReader"
        "(FileList registeredFileReaderClasses  select: [ :ea | ea isObsolete ]) do: 
                [ :ea | FileList unregisterFileReader: ea ]
        "

    "Modified: / 20-10-2010 / 12:02:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadVersionFile: fileName
	| version |
	version := self versionFromFile: fileName.
	version workingCopy repositoryGroup addRepository:
		(MCDirectoryRepository new directory:
			(FileDirectory on: (FileDirectory dirPathFor: fileName))).
	version load.

!

mergeVersionFile: fileName
	(self versionFromFile: fileName) merge
!

openVersionFile: fileName
	(self versionFromFile: fileName) open
!

services
	^ Array 
		with: self serviceLoadVersion
		with: self serviceMergeVersion
		with: self serviceOpenVersion
!

unload
	FileList unregisterFileReader: self 
! !

!MCVersionReader class methodsFor:'reading'!

file: fileName streamDo: aBlock
	| file |
	^ 	[file := FileStream readOnlyFileNamed: fileName.
		aBlock value: file]
			ensure: [file close]
!

on: s fileName: f
	^ self on: s
!

versionFromFile: fileName
	^ self file: fileName streamDo: [:stream | self versionFromStream: stream]
!

versionFromStream: aStream
	^ (self on: aStream) version
!

versionInfoFromStream: aStream
	^ (self on: aStream) info
! !

!MCVersionReader methodsFor:'accessing'!

basicVersion
	^ MCVersion
		package: self package
		info: self info
		snapshot: self snapshot
		dependencies: self dependencies
!

definitions
	definitions ifNil: [self loadDefinitions].
	^ definitions
!

dependencies
	dependencies ifNil: [self loadDependencies].
	^ dependencies
!

info
	info ifNil: [self loadVersionInfo].
	^ info
!

package
	package ifNil: [self loadPackage].
	^ package
!

snapshot
	^ MCSnapshot fromDefinitions: self definitions
!

version
	^ self basicVersion
! !

!MCVersionReader methodsFor:'loading'!

loadDefinitions
	self subclassResponsibility 
!

loadDependencies
	self subclassResponsibility 
!

loadPackage
	self subclassResponsibility 
!

loadVersionInfo
	self subclassResponsibility
! !

!MCVersionReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionReader.st,v 1.5 2012-09-11 21:31:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionReader.st,v 1.5 2012-09-11 21:31:02 cg Exp $'
!

version_SVN
    ^ '§Id: MCVersionReader.st 21 2010-10-20 10:02:41Z vranyj1 §'
! !

MCVersionReader initialize!
