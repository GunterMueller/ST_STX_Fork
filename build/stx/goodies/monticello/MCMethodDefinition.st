"{ Package: 'stx:goodies/monticello' }"

MCDefinition subclass:#MCMethodDefinition
	instanceVariableNames:'classIsMeta source category selector className timeStamp'
	classVariableNames:'Definitions'
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCMethodDefinition class methodsFor:'as yet unclassified'!

cachedDefinitions
        Definitions ifNil: [Definitions := WeakIdentityDictionary new.  WeakArray addDependent: Definitions].
        ^ Definitions

    "Modified: / 26-08-2009 / 12:20:45 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
!

className: classString
classIsMeta: metaBoolean
selector: selectorString
category: catString
timeStamp: timeString
source: sourceString
	^ self instanceLike:
		(self new initializeWithClassName: classString
					classIsMeta: metaBoolean
					selector: selectorString
					category: catString
					timeStamp: timeString
					source: sourceString)
!

className: classString
selector: selectorString
category: catString
timeStamp: timeString
source: sourceString
	^ self	className: classString
			classIsMeta: false
			selector: selectorString
			category: catString
			timeStamp: timeString
			source: sourceString
!

forMethodReference: aMethodReference
	| definition |
	definition := self cachedDefinitions at: aMethodReference compiledMethod ifAbsent: [].
	(definition isNil
		or: [definition selector ~= aMethodReference methodSymbol]
		or: [definition className ~= aMethodReference classSymbol]
		or: [definition classIsMeta ~= aMethodReference classIsMeta]
		or: [definition category ~= aMethodReference category])
			ifTrue: [definition := self
						className: aMethodReference classSymbol
						classIsMeta: aMethodReference classIsMeta
						selector: aMethodReference methodSymbol
						category: aMethodReference category
						timeStamp: aMethodReference timeStamp
						source: aMethodReference source.
					self cachedDefinitions at: aMethodReference compiledMethod put: definition].
	^ definition

!

initialize
    "
        Smalltalk addToShutDownList: self
    "

    "Modified: / 13-10-2010 / 14:12:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shutDown
	WeakArray removeWeakDependent: Definitions.
	Definitions := nil.
! !

!MCMethodDefinition methodsFor:'accessing'!

actualClass
    ^ Smalltalk
        at:(self installedClassName ? className) asSymbol
        ifPresent: [:class |
            classIsMeta
                ifTrue: [class theMetaclass "classSide"]
                ifFalse: [class]
        ]

    "Modified: / 07-09-2011 / 15:23:45 / cg"
    "Modified: / 12-08-2013 / 01:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

category
	^ category
!

category:something
    category := something.
!

classIsMeta
	^ classIsMeta
!

className
	^className
!

description
	^ Array
		with: className
		with: selector
		with: classIsMeta
!

fullTimeStamp
	^Timestamp fromMethodTimeStamp: timeStamp
!

installedClassName
    | installedClassName |

    installedClassName :=  self objectAttributeAt: #installedClassName.
    ^ installedClassName ? className

    "Created: / 07-09-2011 / 13:36:37 / cg"
    "Modified: / 12-08-2013 / 01:37:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installedClassName:aString
    self objectAttributeAt: #installedClassName put: aString.

    "Modified: / 12-08-2013 / 01:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
	^selector
!

source
	^ source
!

source: something
	source := something
!

timeStamp
	^ timeStamp
! !

!MCMethodDefinition methodsFor:'annotations'!

printAnnotations: requests on: aStream
	"Add a string for an annotation pane, trying to fulfill the annotation requests.
	These might include anything that
		Preferences defaultAnnotationRequests
	might return. Which includes anything in
		Preferences annotationInfo
	To edit these, use:"
	"Preferences editAnnotations"

	requests do: [ :aRequest |
		aRequest == #timeStamp ifTrue: [ aStream nextPutAll: self timeStamp ].
		aRequest == #messageCategory ifTrue: [ aStream nextPutAll: self category ].
		aRequest == #requirements ifTrue: [
			self requirements do: [ :req |
				aStream nextPutAll: req ] separatedBy: [ aStream space ]].
	] separatedBy: [ aStream space ].
! !

!MCMethodDefinition methodsFor:'comparing'!

= aDefinition
        ^(super = aDefinition)
                and: [aDefinition source = self source
                and: [aDefinition category = self category
                "and: [aDefinition timeStamp = self timeStamp]"]]

    "Modified: / 18-08-2009 / 10:18:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-09-2010 / 19:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
	| hash |
	hash := String stringHash: classIsMeta asString initialHash: 0.
	hash := String stringHash: source initialHash: hash.
	hash := String stringHash: category initialHash: hash.
	hash := String stringHash: className initialHash: hash.
	^ hash
!

requirements
	^ Array with: className
!

sortKey
	^ self className, '.', (self classIsMeta ifTrue: ['meta'] ifFalse: ['nonmeta']), '.', self selector
! !

!MCMethodDefinition methodsFor:'converting'!

asChange

    ^MethodDefinitionChange new
        mcDefinition: self;
        className: className , (classIsMeta ifTrue:[' class'] ifFalse:['']);
        selector: selector;
        source: source asStringWithNativeLineEndings;
        category: category;
        yourself

    "Created: / 13-10-2010 / 17:17:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-11-2010 / 17:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMethodDefinition methodsFor:'installing'!

isExtensionMethod
	^ category beginsWith: '*'
!

isOverrideMethod
	"this oughta check the package"
	^ self isExtensionMethod and: [category endsWith: '-override']
!

load
    | env package oldMethod newMethod actualClass|

    env := MCStXNamespaceQuery query ? Smalltalk.
    (env ~~ Smalltalk) ifTrue:[
        self installedClassName:(env name , '::' , className) asSymbol
    ].

    package := MCStXPackageQuery query.
    actualClass := self actualClass.
    actualClass isNil ifTrue:[
        MCCannotLoadMethodError
            raiseRequestWith:self
            errorString:('missing class: %1' bindWith:className).
        ^ self "/ proceeded
    ].
    oldMethod := actualClass compiledMethodAt: self selector.
    (oldMethod notNil and:[oldMethod package ~= package])
        ifTrue:[Class methodRedefinitionNotification
                    raiseRequestWith: (oldMethod -> self)].

    newMethod := actualClass
                compile: source asStringWithNativeLineEndings
                classified: category
                withStamp: timeStamp
                "notifying: (SyntaxError new category: category)".
    newMethod package: package

    "Modified: / 11-09-2012 / 09:54:19 / cg"
    "Modified: / 12-08-2013 / 01:34:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postloadOver: aDefinition
	super postloadOver: aDefinition.
	(self isInitializer
		and: [ self actualClass isTrait not ]
		and: [ aDefinition isNil or: [ self source ~= aDefinition source ] ]) ifTrue: [
			self actualClass theNonMetaClass initialize ]
!

scanForPreviousVersion
	| position prevPos prevFileIndex preamble tokens sourceFilesCopy stamp method file methodCategory |
	method := self actualClass compiledMethodAt: selector ifAbsent: [^ nil].
	position := method filePosition.
	sourceFilesCopy := SourceFiles collect:
		[:x | x isNil ifTrue: [ nil ]
				ifFalse: [x readOnlyCopy]].
	[method fileIndex == 0 ifTrue: [^ nil].
	file := sourceFilesCopy at: method fileIndex.
	[position notNil & file notNil]
		whileTrue:
		[file position: (0 max: position-150).  "Skip back to before the preamble"
		[file position < (position-1)]  "then pick it up from the front"
			whileTrue: [preamble := file nextChunk].

		"Preamble is likely a linked method preamble, if we're in
			a changes file (not the sources file).  Try to parse it
			for prior source position and file index"
		prevPos := nil.
		stamp := ''.
		(preamble findString: 'methodsFor:' startingAt: 1) > 0
			ifTrue: [tokens := Scanner new scanTokens: preamble]
			ifFalse: [tokens := Array new  "ie cant be back ref"].
		((tokens size between: 7 and: 8)
			and: [(tokens at: tokens size-5) = #methodsFor:])
			ifTrue:
				[(tokens at: tokens size-3) = #stamp:
				ifTrue: ["New format gives change stamp and unified prior pointer"
						stamp := tokens at: tokens size-2.
						prevPos := tokens last.
						prevFileIndex := sourceFilesCopy fileIndexFromSourcePointer: prevPos.
						prevPos := sourceFilesCopy filePositionFromSourcePointer: prevPos]
				ifFalse: ["Old format gives no stamp; prior pointer in two parts"
						prevPos := tokens at: tokens size-2.
						prevFileIndex := tokens last].
				(prevPos = 0 or: [prevFileIndex = 0]) ifTrue: [prevPos := nil]].
		((tokens size between: 5 and: 6)
			and: [(tokens at: tokens size-3) = #methodsFor:])
			ifTrue:
				[(tokens at: tokens size-1) = #stamp:
				ifTrue: ["New format gives change stamp and unified prior pointer"
						stamp := tokens at: tokens size]].
		methodCategory := tokens after: #methodsFor: ifAbsent: ['as yet unclassifed'].
		methodCategory = category ifFalse:
			[methodCategory = (Smalltalk
									at: #Categorizer
									ifAbsent: [Smalltalk at: #ClassOrganizer])
										default ifTrue: [methodCategory := methodCategory, ' '].
			^ ChangeRecord new file: file position: position type: #method
						class: className category: methodCategory meta: classIsMeta stamp: stamp].
		position := prevPos.
		prevPos notNil ifTrue:
			[file := sourceFilesCopy at: prevFileIndex]].
		^ nil]
			ensure: [sourceFilesCopy do: [:x | x notNil ifTrue: [x close]]]

!

unload
        | previousVersion class |

        #todo. "/ cg please check if the code below was not good after all

        self todo:'cg: why was the code below removed? see browsers previous versions code'.
        false ifTrue:[
            self isOverrideMethod ifTrue: [previousVersion := self scanForPreviousVersion].
        ].
        previousVersion
                ifNil: [(class := self actualClass) ifNotNil: [class removeSelector: selector]]
                ifNotNil: [previousVersion fileIn]

    "Modified: / 11-09-2010 / 18:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 13:39:38 / cg"
! !

!MCMethodDefinition methodsFor:'printing'!

fullClassName
	"Using #class selector for classes for backwards compatibility"

	^ self classIsMeta
		ifFalse: [self className]
		ifTrue: [
			(self actualClass isNil or: [ self actualClass isTrait ])
				ifFalse: [self className, ' class']
				ifTrue: [self className, ' classSide']]
!

summary
	^ self fullClassName , '>>' , selector
! !

!MCMethodDefinition methodsFor:'private'!

existingMethodOrNil
    | actualClass |
    actualClass := self actualClass.
    ^actualClass
        ifNil:[nil]
        ifNotNil: [actualClass compiledMethodAt:self selector]

    "Modified: / 08-11-2010 / 17:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMethodDefinition methodsFor:'serializing'!

initializeWithClassName: classString
classIsMeta: metaBoolean
selector: selectorString
category: catString
timeStamp: timeString
source: sourceString
        className := classString asSymbol.
        selector := selectorString asSymbol.
        category := catString asSymbol.
        timeStamp := timeString.
        classIsMeta := metaBoolean.
        source := sourceString asStringWithSqueakLineEndings.

    "Modified: / 12-09-2010 / 16:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMethodDefinition methodsFor:'testing'!

isCodeDefinition
	^ true
!

isInitializer
	^ selector = #initialize and: [classIsMeta]

!

isMethodDefinition
	^true
!

isOverrideDefinition

    | oldMethod |

    oldMethod := self existingMethodOrNil.
    ^oldMethod
        ifNil:[false]
        ifNotNil:[oldMethod package ~= MCStXPackageQuery query]

    "Created: / 08-11-2010 / 17:29:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMethodDefinition methodsFor:'visiting'!

accept: aVisitor
	^ aVisitor visitMethodDefinition: self
! !

!MCMethodDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMethodDefinition.st,v 1.16 2014-12-11 15:53:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMethodDefinition.st,v 1.16 2014-12-11 15:53:47 cg Exp $'
!

version_SVN
    ^ '$Id: MCMethodDefinition.st,v 1.16 2014-12-11 15:53:47 cg Exp $'
! !


MCMethodDefinition initialize!
