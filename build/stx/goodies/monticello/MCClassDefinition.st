"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCDefinition subclass:#MCClassDefinition
	instanceVariableNames:'name superclassName variables category type comment commentStamp
		traitComposition classTraitComposition'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCClassDefinition class methodsFor:'instance creation'!

name: nameString
superclassName: superclassString
category: categoryString 
instVarNames: ivarArray
classVarNames: cvarArray
poolDictionaryNames: poolArray
classInstVarNames: civarArray
type: typeSymbol
comment: commentString
commentStamp: stampString
	^ self instanceLike:
		(self new initializeWithName: nameString
					superclassName: superclassString
					traitComposition: '{}'
					classTraitComposition: '{}'
					category: categoryString 
					instVarNames: ivarArray
					classVarNames: cvarArray
					poolDictionaryNames: poolArray
					classInstVarNames: civarArray
					type: typeSymbol
					comment: commentString
					commentStamp: stampString)
!

name: nameString
superclassName: superclassString
traitComposition: traitCompositionString
classTraitComposition: classTraitCompositionString
category: categoryString 
instVarNames: ivarArray
classVarNames: cvarArray
poolDictionaryNames: poolArray
classInstVarNames: civarArray
type: typeSymbol
comment: commentString
commentStamp: stampString
	
	^ self instanceLike:
		(self new initializeWithName: nameString
					superclassName: superclassString
					traitComposition: traitCompositionString
					classTraitComposition: classTraitCompositionString
					category: categoryString 
					instVarNames: ivarArray
					classVarNames: cvarArray
					poolDictionaryNames: poolArray
					classInstVarNames: civarArray
					type: typeSymbol
					comment: commentString
					commentStamp: stampString)
! !

!MCClassDefinition class methodsFor:'obsolete'!

name: nameString
superclassName: superclassString
category: categoryString 
instVarNames: ivarArray
classVarNames: cvarArray
poolDictionaryNames: poolArray
classInstVarNames: civarArray
comment: commentString
	^ self	name: nameString
			superclassName: superclassString
			category: categoryString 
			instVarNames: ivarArray
			classVarNames: cvarArray
			poolDictionaryNames: poolArray
			classInstVarNames: civarArray
			type: #normal
			comment: commentString

!

name: nameString
superclassName: superclassString
category: categoryString 
instVarNames: ivarArray
classVarNames: cvarArray
poolDictionaryNames: poolArray
classInstVarNames: civarArray
type: typeSymbol
comment: commentString
	^ self 
		name: nameString
		superclassName: superclassString
		category: categoryString 
		instVarNames: ivarArray
		classVarNames: cvarArray
		poolDictionaryNames: poolArray
		classInstVarNames: civarArray
		type: typeSymbol
		comment: commentString
		commentStamp: nil
!

name: nameString
superclassName: superclassString
category: categoryString 
instVarNames: ivarArray
comment: commentString
	^ self	name: nameString
			superclassName: superclassString
			category: categoryString 
			instVarNames: ivarArray
			classVarNames: #()
			poolDictionaryNames: #()
			classInstVarNames: #()
			comment: commentString

! !

!MCClassDefinition methodsFor:'accessing'!

actualClass
	^Smalltalk classNamed: self className
!

category
	^ category
!

category:something
    category := something.
!

classInstVarNames
	^ self selectVariables: #isClassInstanceVariable
!

classInstVarNames:civarArray
    self addVariables: civarArray ofType: MCClassInstanceVariableDefinition.

    "Created: / 25-11-2011 / 17:42:34 / cg"
!

className
	^ name
!

className: aString
    name := aString

    "Created: / 31-05-2013 / 10:33:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classTraitComposition
	^classTraitComposition
!

classTraitCompositionString
	^self classTraitComposition ifNil: ['{}'].
!

classVarNames
	^ self selectVariables: #isClassVariable
!

comment
        ^ comment ? ''

    "Modified: / 12-09-2010 / 17:07:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commentStamp
	^ commentStamp
!

description
	^ Array with: name

!

instVarNames
	^ self selectVariables: #isInstanceVariable
!

installedClass
        ^Smalltalk classNamed: self installedClassName

    "Created: / 07-09-2011 / 13:33:10 / cg"
!

installedClassName
    | installedClassName |

    installedClassName :=  self objectAttributeAt: #installedClassName.
    ^ installedClassName ? name

    "Created: / 07-09-2011 / 13:36:37 / cg"
    "Modified: / 12-08-2013 / 01:49:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installedClassName:aString
    self objectAttributeAt: #installedClassName put: aString.

    "Modified: / 12-08-2013 / 01:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

poolDictionaries
	^ self selectVariables: #isPoolImport
!

selectVariables: aSelector
        variables isNil ifTrue:[^#()].
        ^ variables select: [:v | v perform: aSelector] thenCollect: [:v | v name]
!

sortKey
	^ self className
!

superclassName
	^ superclassName
!

superclassName:aStringOrSymbol
    superclassName := aStringOrSymbol asSymbol.

    "Modified: / 20-09-2013 / 00:13:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

traitComposition
	^traitComposition
!

traitCompositionString
	^self traitComposition ifNil: ['{}'].
!

type
	^ type
!

variables
	^ variables
! !

!MCClassDefinition methodsFor:'annotations'!

printAnnotations: requests on: aStream
	"Add a string for an annotation pane, trying to fulfill the annotation requests.
	These might include anything that
		Preferences defaultAnnotationRequests 
	might return. Which includes anything in
		Preferences annotationInfo
	To edit these, use:"
	"Preferences editAnnotations"

	requests do: [ :aRequest |
		aRequest == #requirements ifTrue: [
			self requirements do: [ :req | aStream nextPutAll: req ] separatedBy: [ aStream space ]]
	] separatedBy: [ aStream space ].
! !

!MCClassDefinition methodsFor:'comparing'!

hash
	| hash |
	hash := String stringHash: name initialHash: 0.
	hash := String stringHash: superclassName initialHash: hash.
	hash := String stringHash: self traitCompositionString initialHash: hash.
	hash := String stringHash: self classTraitComposition asString initialHash: hash.
	hash := String stringHash: (category ifNil: ['']) initialHash: hash.
	hash := String stringHash: type initialHash: hash.
	variables do: [
		:v |
		hash := String stringHash: v name initialHash: hash.
	].
	^ hash
!

provisions
	^ Array with: name
!

requirements
	^ (Array with: superclassName), self poolDictionaries
! !

!MCClassDefinition methodsFor:'converting'!

asChange
    |instVarNamesString classVarNamesString classInstVarNamesString poolDictionariesString
     definitionSelector|

    instVarNamesString := self instVarNames asStringWith:' '.
    classVarNamesString := self classVarNames asStringWith:' '.
    classInstVarNamesString := self classInstVarNames asStringWith:' '.
    poolDictionariesString := self poolDictionaries asStringWith:' '.

    definitionSelector := #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'.
    (type notNil and:[type ~~ #normal]) ifTrue:[
        type == #variable ifTrue:[
            definitionSelector := #'variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'.
        ] ifFalse:[
            type == #bytes ifTrue:[
                definitionSelector := #'variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'.
            ] ifFalse:[
                type == #words ifTrue:[
                    "for Squeak compatibility: that is long-words !!!!!!!!"
                    definitionSelector := #'variableLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'.
                ] ifFalse:[
                    type == #compiledMethod ifTrue:[
                        definitionSelector := #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'.
                    ] ifFalse:[
self halt:'unhandled class-type'.
                    ]
                ]
            ]
        ]
    ].

"/ does not work yet
"/    classInstVarNamesString notEmptyOrNil ifTrue:[
"/        definitionSelector := (definitionSelector , 'classInstanceVariableNames:') asSymbol
"/    ].

    ^ClassDefinitionChange new
        mcDefinition: self;
        definitionSelector: definitionSelector;
        className: name;
        superClassName: superclassName;
        instanceVariableString: instVarNamesString ;
        classVariableString: classVarNamesString ;
        classInstanceVariableString: classInstVarNamesString ;
        poolDictionaries: poolDictionariesString ;
        category: category;
        yourself

    "Created: / 13-10-2010 / 17:11:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-11-2010 / 17:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2012 / 12:57:38 / cg"
! !

!MCClassDefinition methodsFor:'initializing'!

addVariables: aCollection ofType: aClass
	variables addAll: (aCollection collect: [:var | aClass name: var asString]).
!

defaultCommentStamp
	^ String new

	"The version below avoids stomping on stamps already in the image

	^ (Smalltalk at: name ifPresent: [:c | c organization commentStamp])
		ifNil: ['']
	"

! !

!MCClassDefinition methodsFor:'installing'!

createClass
        "cg: changed to honor any nameSpace query override"

        | env superClass class installedSuperclassName|

        env := MCStXNamespaceQuery query ? Smalltalk.
        superClass := env at: superclassName.
        (superClass isNil and:[env ~~ Smalltalk]) ifTrue:[
            superClass := Smalltalk at: superclassName.
        ].

        "Create class if not exists"
        superClass isNil ifTrue:[
            installedSuperclassName := (env == Smalltalk)
                                            ifTrue:[ superclassName ]
                                            ifFalse:[ env name ,'::',superclassName].
            superClass := Class undeclared: installedSuperclassName
        ].
        superClass isLoaded ifFalse:[ superClass autoload ].

        "/ env := superClass environment. 

        class := (ClassBuilder new)
                        name: name 
                        inEnvironment: env
                        subclassOf: superClass
                        type: type 
                        instanceVariableNames: self instanceVariablesString 
                        classVariableNames: self classVariablesString 
                        poolDictionaries: self sharedPoolsString
                        category: category.

        self installedClassName:class name.

        self traitComposition ifNotNil: [
                class setTraitComposition: (Compiler
                        evaluate: self traitComposition) asTraitComposition ].
        self classTraitComposition ifNotNil: [
                class class setTraitComposition: (Compiler
                        evaluate: self classTraitComposition) asTraitComposition ].
        ^class.

    "Modified (comment): / 07-09-2011 / 13:32:38 / cg"
    "Modified: / 07-10-2014 / 00:20:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

load
    | class |

    (class := self createClass) notNil ifTrue:[
        class class instanceVariableNames: self classInstanceVariablesString.
        self hasComment ifTrue: [class classComment: comment stamp: commentStamp]
    ].
    class package: MCStXPackageQuery query.

    "Modified: / 14-09-2010 / 22:10:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 13:01:53 / cg"
!

stringForSortedVariablesOfType: aSymbol
	^ String streamContents:
		[:stream |
		(self selectVariables: aSymbol) asSortedCollection
			do: [:ea | stream nextPutAll: ea]
			separatedBy: [stream space]]
!

stringForVariablesOfType: aSymbol
	^ String streamContents:
		[:stream |
		(self selectVariables: aSymbol) 
			do: [:ea | stream nextPutAll: ea]
			separatedBy: [stream space]]
!

unload
	Smalltalk removeClassNamed: name
! !

!MCClassDefinition methodsFor:'printing'!

classInstanceVariablesString
	^ self stringForVariablesOfType: #isClassInstanceVariable
!

classVariablesString
	^ self stringForSortedVariablesOfType: #isClassVariable
!

definitionString
	^ String streamContents: [:stream | self printDefinitionOn: stream]
!

instanceVariablesString
	^ self stringForVariablesOfType: #isInstanceVariable
!

kindOfSubclass
        type = #normal ifTrue: [^ ' subclass:'].
        type = #words ifTrue: [^ ' variableWordSubclass:'].
        type = #variable ifTrue: [^ ' variableSubclass:'].
        type = #bytes ifTrue: [^ ' variableByteSubclass:'].
        type = #weak ifTrue: [^ ' weakSubclass:' ].
        type = #compiledMethod ifTrue: [^ ' variableByteSubclass:' ].
        self error: 'Unrecognized class type'

    "Modified: / 11-09-2010 / 18:13:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printDefinitionOn: stream
                |clsName|

                stream 
                        nextPutAll: self superclassName;
                        nextPutAll: self kindOfSubclass.
                ((clsName := self className) includes:$_) ifTrue:[
                    stream 
                        nextPutAll: '#''' ;
                        nextPutAll: self className;
                        nextPutAll: '''' .
                ] ifFalse:[
                    stream 
                        nextPut: $#;
                        nextPutAll: self className.
                ].
                stream
                        cr; tab.
                self hasTraitComposition ifTrue: [
                        stream 
                                nextPutAll: 'uses: ';
                                nextPutAll: self traitCompositionString;
                                cr; tab ].
                stream
                        nextPutAll: 'instanceVariableNames:';
                        store: self instanceVariablesString;
                        cr; tab;
                        nextPutAll: 'classVariableNames:';
                        store: self classVariablesString;
                        cr; tab;
                        nextPutAll: 'poolDictionaries:';
                        store: self sharedPoolsString;
                        cr; tab;
                        nextPutAll: 'category:';
                        store: self category asString

    "Modified: / 11-09-2010 / 18:11:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sharedPoolsString
	^ self stringForSortedVariablesOfType: #isPoolImport
!

source
	^ self definitionString
!

summary
	^ name
! !

!MCClassDefinition methodsFor:'serializing'!

initializeWithName: nameString
superclassName: superclassString
category: categoryString 
instVarNames: ivarArray
classVarNames: cvarArray
poolDictionaryNames: poolArray
classInstVarNames: civarArray
type: typeSymbol
comment: commentString
commentStamp: stampStringOrNil
        name := nameString asSymbol.
        superclassName := superclassString ifNil: ['nil'] ifNotNil: [superclassString asSymbol].
        category := categoryString.
        name = #CompiledMethod ifTrue: [type := #compiledMethod] ifFalse: [type := typeSymbol].
        comment := (commentString ? '') asStringWithSqueakLineEndings.
        commentStamp := stampStringOrNil ifNil: [self defaultCommentStamp].
        variables := OrderedCollection  new.
        self addVariables: ivarArray ofType: MCInstanceVariableDefinition.
        self addVariables: cvarArray ofType: MCClassVariableDefinition.
        self addVariables: poolArray ofType: MCPoolImportDefinition.
        self addVariables: civarArray ofType: MCClassInstanceVariableDefinition.

    "Modified: / 12-09-2010 / 17:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

storeDataOn: aDataStream
        | instVarSize |
        instVarSize := (self hasTraitComposition or: [ self hasClassTraitComposition ])
                ifTrue: [ self class instSize ]
                ifFalse: [ self class instSize - 2 ].
        aDataStream
                beginInstance: self class
                size: instVarSize.
        1 to: instVarSize do: [ :index |
                | value |

                value := (self instVarAt: index).
                "/ Special hack for ImmutableString / ImmutableArray which is not known by Squeak / Pharo,
                "/ and therefore will fail to load properly there.
                "/ In one of those is encountered, convert them to their mutable version.
                (value class == ImmutableString or:[value class == ImmutableArray or:[value class == ImmutableByteArray]]) ifTrue:[ 
                    value := value asMutableCollection.
                ].
                aDataStream nextPut: value 
        ].

    "Modified: / 23-04-2015 / 14:33:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCClassDefinition methodsFor:'testing'!

hasClassInstanceVariables
	^ (self selectVariables: #isClassInstanceVariable) isEmpty not
!

hasClassTraitComposition
	^self classTraitCompositionString ~= '{}'
!

hasComment
	^ comment isEmptyOrNil not
!

hasTraitComposition
	^self traitCompositionString ~= '{}'
!

isClassDefinition
	^ true
!

isCodeDefinition
	^ true
! !

!MCClassDefinition methodsFor:'visiting'!

= aDefinition
        ^super = aDefinition
                and: [superclassName = aDefinition superclassName
                and: [self traitCompositionString = aDefinition traitCompositionString
                and: [self classTraitCompositionString = aDefinition classTraitCompositionString
                and: [category = aDefinition category
                and: [type = aDefinition type
                and: [variables = aDefinition variables
                and: [comment = aDefinition comment]]]]]]]

    "Modified: / 18-08-2009 / 10:19:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

accept: aVisitor
	aVisitor visitClassDefinition: self.
	(self hasClassInstanceVariables or: [self hasClassTraitComposition])
		ifTrue: [aVisitor visitMetaclassDefinition: self].

!

initializeWithName: nameString
superclassName: superclassString
traitComposition: traitCompositionString
classTraitComposition: classTraitCompositionString
category: categoryString 
instVarNames: ivarArray
classVarNames: cvarArray
poolDictionaryNames: poolArray
classInstVarNames: civarArray
type: typeSymbol
comment: commentString
commentStamp: stampStringOrNil
        name := nameString asSymbol.
        superclassName := superclassString ifNil: ['nil'] ifNotNil: [superclassString asSymbol].
        traitComposition := traitCompositionString.
        classTraitComposition := classTraitCompositionString.
        category := categoryString.
        name = #CompiledMethod ifTrue: [type := #compiledMethod] ifFalse: [type := typeSymbol].
        comment := commentString isNil ifTrue:[ nil] ifFalse:[ commentString asStringWithSqueakLineEndings].
        commentStamp := stampStringOrNil ifNil: [self defaultCommentStamp].
        variables := OrderedCollection  new.
        self addVariables: ivarArray ofType: MCInstanceVariableDefinition.
        self addVariables: cvarArray ofType: MCClassVariableDefinition.
        self addVariables: poolArray ofType: MCPoolImportDefinition.
        self addVariables: civarArray ofType: MCClassInstanceVariableDefinition.

    "Modified: / 12-09-2010 / 16:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2011 / 17:30:38 / cg"
! !

!MCClassDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassDefinition.st,v 1.19 2015-03-01 01:06:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassDefinition.st,v 1.19 2015-03-01 01:06:15 cg Exp $'
!

version_SVN
    ^ '$Id: MCClassDefinition.st,v 1.19 2015-03-01 01:06:15 cg Exp $'
! !

