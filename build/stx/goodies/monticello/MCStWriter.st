"{ Package: 'stx:goodies/monticello' }"

MCWriter subclass:#MCStWriter
	instanceVariableNames:'initStream'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Chunk Format'
!

!MCStWriter class methodsFor:'documentation'!

documentation
"
    I write Category/Classes/Methods/.... definitions into Monticello source.st file format found in .mcz packages.    

    See also MCStReader

    Example:

    String streamContents: [:aStream| |writer|
        writer := MCStWriter on: aStream.
        writer writeDefinitions: {True asClassDefinition. False asClassDefinition}.
    ]
"
! !

!MCStWriter class methodsFor:'as yet unclassified'!

readerClass
	^ MCStReader
! !

!MCStWriter methodsFor:'visiting'!

visitClassDefinition: definition
	self writeClassDefinition: definition.
	definition hasClassInstanceVariables ifTrue: [self writeMetaclassDefinition: definition].
	definition hasComment ifTrue: [self writeClassComment: definition].
!

visitClassTraitDefinition: definition
	self chunkContents: [:s | s
		nextPutAll: definition baseTrait;
		nextPutAll: ' classTrait';
		cr; tab;
		nextPutAll: 'uses: ';
		nextPutAll: (definition classTraitComposition ifNil: ['{}'])]

!

visitMetaclassDefinition: definition
	self writeMetaclassDefinition: definition
!

visitMethodDefinition: definition
	self writeMethodPreamble: definition.
	self writeMethodSource: definition.
	self writeMethodPostscript.
	self writeMethodInitializer: definition.
!

visitOrganizationDefinition: defintion
	defintion categories do: [:cat | self writeCategory: cat].

!

visitTraitDefinition: definition
	self writeClassDefinition: definition.
	definition hasComment ifTrue: [self writeClassComment: definition].
! !

!MCStWriter methodsFor:'writing'!

chunkContents: aBlock
	stream cr; nextChunkPut: (String streamContents: aBlock); cr
!

writeCategory: categoryName
        stream
                nextChunkPut: 'SystemOrganization addCategory: ', categoryName storeString;
                cr

    "Modified: / 12-09-2010 / 15:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeClassComment: definition
        stream
                cr;
                nextPut: $!!;
                nextPutAll: definition className;
                nextPutAll: ' commentStamp: ';
                store: definition commentStamp;
                nextPutAll: ' prior: 0!!';
                cr;
                nextChunkPut: definition comment ? '';
                cr.

    "Modified: / 12-09-2010 / 17:05:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeClassDefinition: definition
	self chunkContents: [:s | definition printDefinitionOn: stream]
!

writeDefinitions: aCollection
	"initStream is an ugly hack until we have proper init defs"
	initStream := String new writeStream.

	(MCDependencySorter sortItems: aCollection)
		do: [:ea | ea accept: self]
		displayingProgress: 'Writing definitions...'.
	
	stream nextPutAll: initStream contents.
!

writeMetaclassDefinition: definition
	self chunkContents: [:str |
		str	nextPutAll: definition className;
			nextPutAll: ' class';
			cr; tab.
			definition hasClassTraitComposition ifTrue: [
				str	nextPutAll: 'uses: ';
					nextPutAll: definition classTraitCompositionString;
					cr; tab].
			str	nextPutAll: 'instanceVariableNames: ''';
				nextPutAll: definition classInstanceVariablesString;
				nextPut: $']
!

writeMethodInitializer: aMethodDefinition
	aMethodDefinition isInitializer ifTrue:
		[initStream nextChunkPut: aMethodDefinition className, ' initialize'; cr]
!

writeMethodPostscript
	stream
		space;
		nextPut: $!!;
		cr
!

writeMethodPreamble: definition
        stream
                cr;
                nextPut: $!!;
                nextPutAll: definition fullClassName;
                nextPutAll: ' methodsFor: ';
                nextPutAll: definition category asString storeString;
                nextPutAll: ' stamp: ';
                nextPutAll: definition timeStamp asString storeString;
                nextPutAll: '!!';
                cr

    "Modified: / 12-09-2010 / 15:39:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMethodSource: definition
	stream nextChunkPut: definition source
!

writeSnapshot: aSnapshot
	self writeDefinitions: aSnapshot definitions
! !

!MCStWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStWriter.st,v 1.6 2013-05-15 12:03:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStWriter.st,v 1.6 2013-05-15 12:03:48 cg Exp $'
!

version_SVN
    ^ '$Id: MCStWriter.st,v 1.6 2013-05-15 12:03:48 cg Exp $'
! !

