"{ Package: 'stx:goodies/monticello' }"

MCMczWriter subclass:#MCMcdWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCMcdWriter class methodsFor:'as yet unclassified'!

readerClass
	^ MCMcdReader
! !

!MCMcdWriter methodsFor:'as yet unclassified'!

writeBaseInfo: aVersionInfo
	| string |
	string := self serializeVersionInfo: aVersionInfo.
	self addString: string at: 'base'.

!

writeDefinitions: aVersion
	self writeBaseInfo: aVersion baseInfo.
	self writePatch: aVersion patch.
!

writeNewDefinitions: aCollection
	self addString: (self serializeDefinitions: aCollection) at: 'new/source.', self snapshotWriterClass extension.
!

writeOldDefinitions: aCollection
	self addString: (self serializeDefinitions: aCollection) at: 'old/source.', self snapshotWriterClass extension.
!

writePatch: aPatch
	| old new |
	old := OrderedCollection new.
	new := OrderedCollection new.
	aPatch operations do:
		[:ea |
		ea isRemoval ifTrue: [old add: ea definition].
		ea isAddition ifTrue: [new add: ea definition].
		ea isModification ifTrue: [old add: ea baseDefinition. new add: ea definition]].
	self writeOldDefinitions: old.
	self writeNewDefinitions: new.
	self addString: (self serializeInBinary: aPatch) at: 'patch.bin'.
! !

!MCMcdWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMcdWriter.st,v 1.4 2012-09-11 21:22:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMcdWriter.st,v 1.4 2012-09-11 21:22:51 cg Exp $'
!

version_SVN
    ^ '§Id: MCMcdWriter.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
