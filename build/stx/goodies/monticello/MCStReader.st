"{ Package: 'stx:goodies/monticello' }"

MCSnapshotReader subclass:#MCStReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Chunk Format'
!

!MCStReader class methodsFor:'documentation'!

documentation
"
    I read Category/Classes/Methodes/.... definitions from Monticello source.st file format.

    See also MCStWriter.

    Example:

    |source|
    source := String streamContents: [:aStream| |writer|
        writer := MCStWriter on: aStream.
        writer writeDefinitions: {True asClassDefinition. False asClassDefinition}.
    ].

    (MCStReader on: source readStream) definitions explore.
"
! !

!MCStReader class methodsFor:'as yet unclassified'!

extension
	^ 'st'
! !

!MCStReader methodsFor:'as yet unclassified'!

addDefinitionsFromDoit: aString
	| parser |
	(parser := MCDoItParser forDoit: aString) ifNotNil:
		[
		parser addDefinitionsTo: definitions]
!

categoryFromDoIt: aString
	| tokens  |
	tokens := Scanner new scanTokens: aString.
	tokens size = 3 ifFalse: [self error: 'Unrecognized category definition'].
	^ tokens at: 3
!

classDefinitionFrom: aPseudoClass
	| tokens traitCompositionString lastIndex classTraitCompositionString |
	tokens := Scanner new scanTokens: aPseudoClass definition.
	traitCompositionString := ((ReadStream on: aPseudoClass definition)
		match: 'uses:';
		upToAll: 'instanceVariableNames:') withBlanksTrimmed.
	classTraitCompositionString := ((ReadStream on: aPseudoClass metaClass definition asString)
		match: 'uses:';
		upToAll: 'instanceVariableNames:') withBlanksTrimmed.
	traitCompositionString isEmpty ifTrue: [traitCompositionString := '{}'].
	classTraitCompositionString isEmpty ifTrue: [classTraitCompositionString := '{}'].
	lastIndex := tokens size.
	^ MCClassDefinition
		name: (tokens at: 3)
		superclassName: (tokens at: 1)
		traitComposition: traitCompositionString
		classTraitComposition: classTraitCompositionString
		category: (tokens at: lastIndex)
		instVarNames: ((tokens at: lastIndex - 6) findTokens: ' ')
		classVarNames: ((tokens at: lastIndex - 4) findTokens: ' ')
		poolDictionaryNames: ((tokens at: lastIndex - 2) findTokens: ' ')
		classInstVarNames: (self classInstVarNamesFor: aPseudoClass)
		type: (self typeOfSubclass: (tokens at: 2))
		comment: (self commentFor: aPseudoClass)
		commentStamp: (self commentStampFor: aPseudoClass)
!

classInstVarNamesFor: aPseudoClass
	| tokens |
	
	self flag: #traits.
	aPseudoClass metaClass hasDefinition ifFalse: [^ #()].
	tokens := Scanner new scanTokens: aPseudoClass metaClass definition.
	"tokens size = 4 ifFalse: [self error: 'Unrecognized metaclass definition']."
	^ tokens last findTokens: ' '
!

commentFor: aPseudoClass
	| comment |
	comment := aPseudoClass organization classComment.
	^ comment asString = ''
		ifTrue: [comment]
		ifFalse: [comment string]
!

commentStampFor: aPseudoClass
	| comment |
	comment := aPseudoClass organization classComment.
	^  [comment stamp] on: MessageNotUnderstood do: [nil]
!

methodDefinitionsFor: aPseudoClass
        ^ aPseudoClass selectors collect: 
                [:ea |
                 MCMethodDefinition
                        className: aPseudoClass name
                        classIsMeta: aPseudoClass isMeta
                        selector: ea
                        category: (aPseudoClass organization categoryOfElement: ea)
                        timeStamp: (aPseudoClass stampAt: ea)
                        source: (aPseudoClass sourceCodeAt: ea) string]
!

systemOrganizationFromRecords: changeRecords
	| categories |
	categories := changeRecords
					select: [:ea | 'SystemOrganization*' match: ea string]
					thenCollect: [:ea | (self categoryFromDoIt: ea string)].
	^ categories isEmpty ifFalse: [MCOrganizationDefinition categories: categories asArray]
!

typeOfSubclass: aSymbol
	#(
		(subclass: normal)
		(variableSubclass: variable)
		(variableByteSubclass: bytes)
		(variableWordSubclass: words)
		(weakSubclass: weak)
		) do: [:ea | ea first = aSymbol ifTrue: [^ ea second]].
	self error: 'Unrecognized class definition'
! !

!MCStReader methodsFor:'evaluating'!

loadDefinitions
    |changeList|

    definitions := OrderedCollection new.

    Smalltalk isSmalltalkX ifTrue:[
        changeList := ChangeSet fromStream:self readStream.
        changeList do:[:eachChange |
            |dfn|

            self addDefinitionFromChange:eachChange.
        ].
    ] ifFalse:[
        | filePackage |
        filePackage :=
                FilePackage new
                        fullName: 'ReadStream';
                        fileInFrom: self readStream.
        filePackage classes do:
                [:pseudoClass |
                pseudoClass hasDefinition
                        ifTrue: [definitions add:
                                        (self classDefinitionFrom: pseudoClass)].
                definitions addAll: (self methodDefinitionsFor: pseudoClass).
                definitions addAll: (self methodDefinitionsFor: pseudoClass metaClass)].
        filePackage doIts do:
                [:ea |
                self addDefinitionsFromDoit: ea string].
    ]

    "Modified: / 25-11-2011 / 17:23:48 / cg"
!

readStream
	^ ('!!!!

', stream contents) readStream
! !

!MCStReader methodsFor:'stx change conversion'!

addDefinitionFromChange:aChange
    aChange acceptChangeVisitor:self.

    "Created: / 25-11-2011 / 17:24:08 / cg"
!

visitClassCommentChange:aChange
    definitions add:(MCClassComment new
                        className: aChange className
                        comment: aChange comment
                        source: aChange source string
                    )
!

visitClassDefinitionChange:aChange
        | tokens traitCompositionString lastIndex classTraitCompositionString |

        tokens := Scanner new scanTokens: aChange source.

"/        traitCompositionString := ((ReadStream on: aChange source)
"/                match: 'uses:';
"/                upToAll: 'instanceVariableNames:') withBlanksTrimmed.
"/        classTraitCompositionString := ((ReadStream on: aPseudoClass metaClass definition asString)
"/                match: 'uses:';
"/                upToAll: 'instanceVariableNames:') withBlanksTrimmed.
        traitCompositionString isEmptyOrNil ifTrue: [traitCompositionString := '{}'].
        classTraitCompositionString isEmptyOrNil ifTrue: [classTraitCompositionString := '{}'].
        lastIndex := tokens size.
        definitions add:( MCClassDefinition
                name: aChange className "/ (tokens at: 3)
                superclassName: aChange superClassName "/ (tokens at: 1)
                traitComposition: traitCompositionString
                classTraitComposition: classTraitCompositionString
                category: aChange category "/ (tokens at: lastIndex)
                instVarNames: aChange instanceVariableNames asCollectionOfWords "/ ((tokens at: lastIndex - 6) findTokens: ' ')
                classVarNames: aChange classVariableNames asCollectionOfWords "/ ((tokens at: lastIndex - 4) findTokens: ' ')
                poolDictionaryNames: aChange poolDictionaries asCollectionOfWords "/ ((tokens at: lastIndex - 2) findTokens: ' ')
                classInstVarNames: (aChange classInstanceVariableNames ? '') asCollectionOfWords "/ (self classInstVarNamesFor: aPseudoClass)
                type: (self typeOfSubclass: (tokens at: 2))
                comment: nil "/ (self commentFor: aPseudoClass)
                commentStamp: nil "/ (self commentStampFor: aPseudoClass)
            )

    "Created: / 25-11-2011 / 17:20:41 / cg"
!

visitClassInstVarDefinitionChange:aChange
    "there must be already a definition change for that class"

    |nonMetaName defn|

    self assert:(aChange className endsWith:' class').
    nonMetaName := aChange className copyWithoutLast:' class' size.

    defn := definitions detectLast:[:def | def isClassDefinition and:[def className = nonMetaName]].
    defn classInstVarNames: (aChange classInstVarNames).

    "Created: / 25-11-2011 / 17:32:12 / cg"
!

visitDoItChange:aChange
    self addDefinitionsFromDoit: aChange source

    "Created: / 25-11-2011 / 17:15:21 / cg"
!

visitMethodChange:aChange
    definitions add:(MCMethodDefinition
                        className: aChange className
                        classIsMeta: aChange isForMeta
                        selector: aChange changeSelector
                        category: aChange category "/ (aPseudoClass organization categoryOfElement: ea)
                        timeStamp: nil "aChange timeStamp" "/ (aPseudoClass stampAt: ea)
                        source: aChange source string"/ (aPseudoClass sourceCodeAt: ea)
                    )

    "Created: / 25-11-2011 / 17:15:36 / cg"
! !

!MCStReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStReader.st,v 1.9 2014-12-23 19:48:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStReader.st,v 1.9 2014-12-23 19:48:43 cg Exp $'
!

version_SVN
    ^ '$Id: MCStReader.st,v 1.9 2014-12-23 19:48:43 cg Exp $'
! !

