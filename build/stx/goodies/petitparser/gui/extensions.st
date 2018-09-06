"{ Package: 'stx:goodies/petitparser/gui' }"!

!PPAndParser methodsFor:'*petitgui-accessing'!

displayDescription
	^ 'and'
! !

!PPAndParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
! !

!PPChoiceParser methodsFor:'*petitgui-morphic'!

exampleOn: aStream
	"If there is already a lot written, try to pick an empty possiblity."
	
	aStream position > 512 ifTrue: [
		(parsers anySatisfy: [ :each | each isNullable ])
			ifTrue: [ ^ self ] ].
	parsers atRandom exampleOn: aStream
! !

!PPChoiceParser methodsFor:'*petitgui-morphic'!

morphicShapeSeen: aSet depth: anInteger
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		| morph |
		morph := self newColumnMorph 
			cellInset: 5;
			yourself.
		self children do: [ :each | 
			morph addMorphBack: (self newRowMorph
				hResizing: #spaceFill;
				addMorphBack: (cc value: each);
				addMorphBack: (self newColumnMorph
					hResizing: #spaceFill;
					addMorphBack: (self newSpacerMorph height: 10);
					addMorphBack: ((LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1)
						hResizing: #spaceFill;
						minWidth: 20;
						yourself);
					yourself);
				yourself) ].
		morph fullBounds.
		self newRowMorph
			addMorphBack: (self newColumnMorph
				addMorphBack: (self newSpacerMorph height: 10);
				addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1);
				yourself);
			addMorphBack: (self newColumnMorph
				addMorphBack: (self newSpacerMorph width: 1; height: 10);
				addMorphBack: (LineMorph from: 0 @ 0 to: 0 @ (morph height - 23) color: Color black width: 1);
				yourself);
			addMorphBack: morph;
			addMorphBack: (self newColumnMorph
				addMorphBack: (self newSpacerMorph width: 1; height: 10);
				addMorphBack: (LineMorph from: 0 @ (morph height - 23) to: 0 @ 0 color: Color black width: 1)
					makeForwardArrow;
					width: 1;
				yourself);
			yourself ]
! !

!PPDelegateParser methodsFor:'*petitgui-accessing'!

displayDescription
	^ nil
! !

!PPDelegateParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
	parser exampleOn: aStream
! !

!PPDelegateParser methodsFor:'*petitgui-morphic'!

morphicShapeSeen: aSet depth: anInteger
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		self displayDescription isNil
			ifTrue: [ cc value: parser ]
			ifFalse: [
				self newRowMorph
					addMorphBack: (self newColumnMorph
						addMorphBack: (self newSpacerMorph height: 10);
						addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1);
						yourself);
					addMorphBack: (self newRowMorph
						color: (self backgroundForDepth: anInteger);
						addMorphBack: (self newColumnMorph
							addMorphBack: (cc value: parser);
							addMorphBack: (self newRowMorph
								hResizing: #spaceFill;
								addMorphBack: (self newSpacerMorph
									width: 20;
									yourself);
								addMorphBack: (self newColumnMorph
									hResizing: #spaceFill;
									listCentering: #center;
									addMorphBack: (self newSpacerMorph);
									addMorphBack: (StringMorph new
										contents: self displayDescription;
										yourself);
									yourself);
								yourself);
							yourself);		
						addMorphBack: (self newColumnMorph
							addMorphBack: (self newSpacerMorph height: 10);
							addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1);
							yourself);
						yourself);
					yourself ] ]
! !

!PPEndOfInputParser methodsFor:'*petitgui-accessing'!

displayDescription
	^ 'end of input'
! !

!PPEpsilonParser methodsFor:'*petitgui-accessing'!

displayName
	^ 'epsilon'
! !

!PPEpsilonParser methodsFor:'*petitgui-morphic'!

morphicShapeSeen: aSet depth: anInteger
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		self newRowMorph
			addMorphBack: (self newColumnMorph
				addMorphBack: (self newSpacerMorph height: 10);
				addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1);
				yourself);
			yourself ]
! !

!PPFailingParser methodsFor:'*petitgui-accessing'!

displayColor
	^ Color red
! !

!PPFailingParser methodsFor:'*petitgui-accessing'!

displayName
	^ message
! !

!PPLiteralParser methodsFor:'*petitgui-accessing'!

displayName
	^ literal printString
! !

!PPLiteralSequenceParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
	aStream nextPutAll: literal
! !

!PPNotParser methodsFor:'*petitgui-accessing'!

displayDescription
	^ 'not'
! !

!PPNotParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
! !

!PPParser methodsFor:'*petitgui-accessing'!

backgroundForDepth: anInteger
	^ Color gray: 1.0 - (anInteger / 20.0)
! !

!PPParser methodsFor:'*petitgui-accessing'!

displayColor
	^ self isTerminal
		ifTrue: [ Color r: 0.5 g: 0.0 b: 0.5 ]
		ifFalse: [ Color blue ]
! !

!PPParser methodsFor:'*petitgui-accessing'!

displayName
	^ self name isNil
		ifFalse: [ self name asString ]
		ifTrue: [ self class name asString ]
! !

!PPParser methodsFor:'*petitgui-accessing'!

example
	^ String streamContents: [ :stream | self exampleOn: stream ] limitedTo: 1024
! !

!PPParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
! !

!PPParser methodsFor:'*petitgui'!

gtInspectorParserInspectorIn: composite
	<gtInspectorPresentationOrder: 30>
	composite custom: (
		PPParserInspector new 
			title: 'Inspector';
			startOn: self)
! !

!PPParser methodsFor:'*petitgui-morphic'!

morphicProduction
	^ self newRowMorph
		layoutInset: 4;
		addMorphBack: (self newRowMorph
			layoutInset: 4;
			addMorphBack: (StringMorph new
				contents: self displayName;
				emphasis: TextEmphasis bold emphasisCode;
				yourself);
			yourself);
		addMorphBack: (self morphicShapeSeen: IdentitySet new depth: 0);
		addMorphBack: (self newColumnMorph
			addMorphBack: (self newSpacerMorph);
			addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1)	
				makeForwardArrow;
			yourself);
		yourself
! !

!PPParser methodsFor:'*petitgui-morphic'!

morphicShapeDefault
	^ self newRowMorph
		addMorphBack: (self newColumnMorph
			addMorphBack: (self newSpacerMorph);
			addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1)	
				makeForwardArrow;
			yourself);
		addMorphBack: (self newRowMorph
			borderWidth: 1;
			layoutInset: 3;
			color: Color white;
			addMorphBack: (StringMorph new
				contents: self displayName;
				color: self displayColor;
				yourself);
			yourself);
		yourself
! !

!PPParser methodsFor:'*petitgui-morphic'!

morphicShapeSeen: aSet depth: anInteger
	^ self morphicShapeDefault
! !

!PPParser methodsFor:'*petitgui-morphic'!

morphicShapeSeen: aSet depth: anInteger do: aBlock
	" avoid recursion "
	(aSet includes: self)
		ifTrue: [ ^ self morphicShapeDefault ].
	" display nice name when possible "
	(anInteger > 0 and: [ self name notNil ]) 
		ifTrue: [ ^ self morphicShapeDefault ].
	" don't do it too deep "
	(anInteger > 10)
		ifTrue: [ ^ self morphicShapeDefault ].
	aSet add: self. 
	^ aBlock value: [ :parser |
		parser 
			morphicShapeSeen: aSet 
			depth: anInteger + 1 ]
! !

!PPParser methodsFor:'*petitgui-mondrian'!

namedParsers
    | result |
    result := OrderedCollection new.
    self namedParsersDo: [ :parser | result addLast: parser ].
    ^ result
! !

!PPParser methodsFor:'*petitgui-mondrian'!

namedParsersDo: aBlock
    self namedParsersDo: aBlock seen: IdentitySet new
! !

!PPParser methodsFor:'*petitgui-mondrian'!

namedParsersDo: aBlock seen: aSet
    self children do: [ :each | 
        (aSet includes: each)
            ifFalse: [
		        aSet add: each.
		        each name isEmptyOrNil
		            ifFalse: [ aBlock value: each ]
		            ifTrue: [ each namedParsersDo: aBlock seen: aSet ] ] ]
! !

!PPParser methodsFor:'*petitgui-morphic-creational'!

newColumnMorph
	^ AlignmentMorph newColumn
		cellPositioning: #topLeft;
		color: Color transparent;
		listCentering: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 0;
		yourself
! !

!PPParser methodsFor:'*petitgui-morphic-creational'!

newRowMorph
	^ AlignmentMorph newRow
		cellPositioning: #topLeft;
		color: Color transparent;
		listCentering: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 0;
		yourself
! !

!PPParser methodsFor:'*petitgui-morphic-creational'!

newSpacerMorph
	^ Morph new
		color: Color transparent;
		borderWidth: 0;
		extent: 7 @ 7;
		yourself
! !

!PPParser methodsFor:'*petitgui-mondrian'!

viewAllNamedParsers
	| view |
	view := MOViewRenderer new.
	self viewAllNamedParsersOn: view.
	view open
! !

!PPParser methodsFor:'*petitgui-mondrian'!

viewAllNamedParsersOn: view
	view shape rectangle text: #displayName; withoutBorder. 
	view nodes: (self allParsers select: [:each |  each name isEmptyOrNil not ]).
	view edgesToAll: #namedParsers.
	view horizontalDominanceTreeLayout layered
! !

!PPParser methodsFor:'*petitgui-mondrian'!

viewAllNamedParsersWithSelection: aCollectionOfNames on: view
	self viewAllNamedParsersWithSelection: aCollectionOfNames previewing: [ :each | each name ] on: view
! !

!PPParser methodsFor:'*petitgui-mondrian'!

viewAllNamedParsersWithSelection: aCollectionOfNames previewing: aBlock on: view
	view shape label 
		color: [:each | (aCollectionOfNames includes: each name) ifFalse: [Color black] ifTrue: [Color red]];
		text: [:each |each displayName].
	view interaction popupText: aBlock.
	view interaction item: 'Explore' action: #explore.
	view nodes: (self allParsers select: [:each |  each name isEmptyOrNil not ]).
	view edges: (self allParsers select: [:each |  each name isEmptyOrNil not ])from: #yourself toAll: #namedParsers.
	view horizontalDominanceTreeLayout verticalGap: 10; layered
! !

!PPPluggableParser methodsFor:'*petitgui-accessing'!

displayName
	^ String streamContents: [ :stream | block decompile shortPrintOn: stream ]
! !

!PPPredicateParser methodsFor:'*petitgui-accessing'!

displayName
	^ predicateMessage
! !

!PPPredicateParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
	"Produce a random character that is valid. If there are characters in the alpha-numeric range prefer those over all others."

	| valid normal |
	valid := Character allCharacters
		select: [ :char | self matches: (String with: char) ].
	normal := valid
		select: [ :char | char asInteger < 127 and: [ char isAlphaNumeric ] ].
	aStream nextPut: (normal isEmpty
		ifTrue: [ valid atRandom ]
		ifFalse: [ normal atRandom ])
! !

!PPRepeatingParser methodsFor:'*petitgui-accessing'!

displayDescription
	^ String streamContents: [ :stream |
		min = 0 
			ifFalse: [ stream print: min; nextPutAll: '..' ].
		max = SmallInteger maxVal
			ifTrue: [ stream nextPut: $* ]
			ifFalse: [ stream print: max ] ]
! !

!PPRepeatingParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
	"Perform the minimal repeatitions required, and a random amount of more if possible and if not that much output has been produced yet."
	
	min timesRepeat: [ 
		super exampleOn: aStream ].
	(max - min min: 5) atRandom timesRepeat: [
		aStream position > 512
			ifTrue: [ ^ self ].
		super exampleOn: aStream ]
! !

!PPSequenceParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
	parsers do: [ :each | each exampleOn: aStream ]
! !

!PPSequenceParser methodsFor:'*petitgui-morphic'!

morphicShapeSeen: aSet depth: anInteger
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		self children
			inject: self newRowMorph
			into: [ :result :each | 
				result 
					addMorphBack: (cc value: each);
					yourself ] ]
! !

!PPTrimmingParser methodsFor:'*petitgui-accessing'!

exampleOn: aStream
	super exampleOn: aStream.
	aStream nextPut: Character space
! !

!PPUnresolvedParser methodsFor:'*petitgui-accessing'!

displayColor
	^ Color red
! !

!Refactoring methodsFor:'*petitgui-utilities'!

checkCompositeParser: aClass
        ^ (RBCondition isMetaclass: aClass) not
        "&  RBCondition isSubclass: class of: self compositeParserClass"
        & (RBCondition new
                type: (Array with: #subclass with: self compositeParserClass with: aClass)
                block: [ aClass includesClass: self compositeParserClass ]
                errorString: aClass printString , ' is <1?:not >a subclass of ' , self compositeParserClass printString)
! !

!Refactoring methodsFor:'*petitgui-utilities'!

compositeParserClass
        ^ self classObjectFor: #PPCompositeParser
! !

!stx_goodies_petitparser_gui class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/extensions.st,v 1.2 2014-03-04 21:19:47 cg Exp $'
! !
