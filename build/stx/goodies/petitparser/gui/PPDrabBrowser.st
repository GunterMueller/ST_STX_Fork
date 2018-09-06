"{ Package: 'stx:goodies/petitparser/gui' }"

Object subclass:#PPDrabBrowser
	instanceVariableNames:'browser input stream output rootClass'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Core'
!


!PPDrabBrowser methodsFor:'accessing'!

rootClass
	^ rootClass
!

rootModel
	^ self subclassesOf: self rootClass
! !

!PPDrabBrowser methodsFor:'accessing-view'!

production
	| parser |
	^ (parser := self selectedClass new)
		productionAt: (self selectedSelector
			ifNil: [ ^ parser ])
!

selectedClass
	^ ((browser paneNamed: #class) port: #selection) value
!

selectedClass: aClass
	((browser paneNamed: #class) update; port: #selection) value: aClass
!

selectedSelector
	^ ((browser paneNamed: #selector) port: #selection) value
!

selectedSelector: aSelector
	((browser paneNamed: #selector) update; port: #selection) value: aSelector
!

sourceCode
	^ (self selectedClass ifNil: [ ^ String new ]) 
		sourceCodeAt: (self selectedSelector ifNil: [ #start ])
		ifAbsent: [ String new ]
!

sourceCode: aString in: aClass
        | tree source selector |
        tree := RBParser parseMethod: aString onError: [ :msg :pos | nil ].
        source := tree isNil
                ifTrue: [ aString ]
                ifFalse: [ 
                        | rewriter |
                        rewriter := ParseTreeRewriter new.
                        rewriter
                                replace: '`#literal' with: '`#literal asParser' when: [ :node |
                                        (node isLiteralNode and: [ node value isString or: [ node value isCharacter ] ])
                                                and: [ (node parent isNil or: [ node parent isMessage not or: [ node parent selector ~= #asParser ] ])
                                                and: [ (node parents noneSatisfy: [ :each | each isBlock ]) ] ] ];
                                replaceMethod: '`@method: `@args | `@temps | ``@.statements. ``.statement `{ :node | node isReturn not }' 
                                        with: '`@method: `@args | `@temps | ``@.statements. ^ ``.statement'.
                        (rewriter executeTree: tree)
                                ifTrue: [ rewriter tree newSource ]
                                ifFalse: [ aString ] ].
        selector := aClass compile: source.
        (aString numArgs = 0 and: [ (aClass allInstVarNames includes: selector) not ])
                ifTrue: [ aClass addInstVarNamed: selector asString ].
        ^ selector
! !

!PPDrabBrowser methodsFor:'browse'!

browseClassesOn: aBrowser
	aBrowser tree
		title: 'Grammars';
		format: [ :class | class name ];
		children: [ :class | self subclassesOf: class ];
		selectionAct: [
			| className |
			className := UIManager default 
				request: 'Class name' 
				initialAnswer: '' 
				title: 'New Parser'.
			className isNil ifFalse: [ 
				PPRefactoringUtils new 
					performRefactoring: (PPAddParserRefactoring
						name: className asSymbol
						category: #ParserExample
						superclass: self selectedClass).
				self selectedClass: (self class environment classNamed: className) ] ]
			on: $n entitled: 'New ... (n)';
		selectionAct: [
			| superclass |
			superclass := self selectedClass superclass.
			self performRefactoring: (PPRemoveParserRefactoring onClass: self selectedClass).
			self selectedClass: superclass ]
			on: $r entitled: 'Remove (x)';
		selectionAct: [
			self selectedClass browse ]
			on: $b entitled: 'Browse (b)'
!

browseDynamicOn: aBrowser
        | tabulator |
        aBrowser useExplicitNotNil.
        
        tabulator := aBrowser tabulator.
        tabulator
                title: 'Dynamic';
                useExplicitNotNil;
                row: #input; row: #output.
        tabulator transmit
                to: #input;
                andShow: [ :a | self browseInputOn: a ].
        tabulator transmit
                to: #output;
                from: #input;
                andShow: [ :a | self browseOutputOn: a ].
                
        tabulator transmit
                from: #output;
                to: #input -> #selectionInterval;
                when: [ :selection | selection notNil ];
                transformed: [ :selection | selection second to: selection third ]
!

browseOn: aComposite
	aComposite title: PPBrowser label; color: Color yellow muchDarker.
	aComposite row: [ :row | row column: #class; column: #selector ].
	aComposite row: [ :row | row column: #part span: 2 ] span: 2.
	aComposite transmit 
		to: #class; 
		andShow: [ :composite | self browseClassesOn: composite ].
	aComposite transmit 
		to: #selector; 
		from: #class; 
		andShow: [ :composite | self browseSelectorsOn: composite ].
	aComposite transmit
		to: #part;
		from: #class;
		from: #selector;
		andShow: [ :composite | self browsePartsOn: composite ]
!

browsePartsOn: aComposite
	aComposite useExplicitNotNil.
	aComposite tabbedArrangement.
	self browseStaticOn: aComposite.
	self browseDynamicOn: aComposite
!

browseSelectorsOn: aBrowser
	aBrowser list
		title: 'Productions';
		format: [ :class | class asString ];
		display: [ :class | 
			((((class allInstVarNames
				copyWithoutAll: class ignoredNames)
				copyWithoutAll: self rootClass allInstVarNames)
				collect: [ :each | each asSymbol ])
				select: [ :each | class includesSelector: each ])
				asSortedCollection ];
		selectionAct: [
			| selector |
			selector := UIManager default 
				request: 'Production name' 
				initialAnswer: self selectedSelector
				title: 'New production'.
			selector isNil ifFalse: [ 
				self performRefactoring: (PPRenameProdcutionRefactoring
					onClass: self selectedClass
					rename: self selectedSelector
					to: selector asSymbol).
				self selectedSelector: selector asSymbol ] ]
			on: $r entitled: 'Rename... (r)';
		selectionAct: [
			self performRefactoring: (PPRemoveProdcutionRefactoring
				onClass: self selectedClass
				production: self selectedSelector).
			self selectedSelector: nil ]
			on: $r entitled: 'Remove (x)';
		selectionAct: [
			Smalltalk tools browser 
				fullOnClass: self selectedClass 
				selector: self selectedSelector ] 
			on: $b entitled: 'Browse (b)'
!

browseStaticOn: aBrowser
	aBrowser useExplicitNotNil.
	aBrowser tabbedArrangement.
	self browseSourceOn: aBrowser.
	self browseGraphOn: aBrowser.
	self browseCyclesOn: aBrowser.
	self browseFirstOn: aBrowser.
	self browseFollowOn: aBrowser.
	self browseExampleOn: aBrowser
! !

!PPDrabBrowser methodsFor:'browse-dynamic'!

browseInputOn: aBrowser
	aBrowser text
		useExplicitNotNil;
		display: [ :class :selector | input ];
		selectionPopulate: #selection on: $s entitled: 'Parse (s)' with: [ :presentation |
			input := presentation text asString.
			stream := PPBrowserStream on: input.
			output := self production end 
				parse: stream.
			output isPetitFailure
				ifTrue: [ presentation selectionInterval: (output position + 1 to: output position) ].
			output ]
!

browseOutputOn: aBrowser
	aBrowser text
		title: 'Result';
		display: [ output ];
		act: [:text | output inspect ] entitled: 'Inspect'.

	aBrowser list
		title: 'Debugger';
		format: [ :each | (String new: 2 * each fourth withAll: $ ) asText , each first, ' - ', each last printString ];
		selectionAct: [:list | list selection last inspect ] entitled: 'Inspect token';
		display: [ 
			| depth trace |
			depth := -1.
			trace := OrderedCollection new.
			(self production end transform: [ :each |
				each name notNil 
					ifTrue: [ 
						each >=> [ :s :cc |
							| t r |
							depth := depth + 1. 
							trace addLast: (t := Array with: each name with: s position + 1 with: s position with: depth with: Object new with: nil).
							r := cc value.
							t at: t size put: r.
							t at: 3 put: s position.
							r isPetitFailure
								ifFalse: [ t at: 1 put: (t at: 1) asText allBold ].
							depth := depth - 1.
							r ] ]
					ifFalse: [ each ] ])
				parse: input.
			trace ].
	aBrowser table 
		title: 'Tally';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Count' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [ stream asFrequencyTable ].
	aBrowser table 
		title: 'Profile';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Time (ms)' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [ stream asTimingTable ].
	aBrowser morph 
		title: 'Progress';
		display: [
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: stream asPositionMorph.
			morph ]
! !

!PPDrabBrowser methodsFor:'browse-static'!

browseCyclesOn: aBrowser
	aBrowser list
		title: 'Cycles';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production cycleSet ]
!

browseExampleOn: aBrowser
	aBrowser text
		title: 'Example';
		useExplicitNotNil;
		display: [ :parsers | self production example ]
!

browseFirstOn: aBrowser
	aBrowser list
		title: 'First';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production firstSet ]
!

browseFollowOn: aBrowser
	aBrowser list
		title: 'Follow';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | 
			| parser |
			parser := self selectedClass new.
			parser followSets
				at: (parser productionAt: self selectedSelector)
				ifAbsent: [ Array with: nil asParser ] ]
!

browseGraphOn: aBrowser
	aBrowser morph
		title: 'Graph';
		useExplicitNotNil;
		display: [ :parsers |
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: self production morphicProduction.
			morph ]
!

browseSourceOn: aBrowser
	aBrowser smalltalkCode
		title: 'Source';
		useExplicitNotNil;
		display: [ self sourceCode ];
		smalltalkClass: [ self selectedClass ];
		act: [ :node |
			| refactoring |
			refactoring := PPDefineProdcutionRefactoring 	
				onClass: self selectedClass 
				source: node text asString
				protocols: #(production).
			self performRefactoring: refactoring.
			self selectedSelector: refactoring selector ]
		on: $s 
		entitled: 'accept (s)'
! !

!PPDrabBrowser methodsFor:'initialize-release'!

initialize
	super initialize.
	input := String new.
	output := String new.
	stream := PPBrowserStream on: input
! !

!PPDrabBrowser methodsFor:'public'!

openOn: aClass
	rootClass := aClass.
	browser := GLMTabulator new.
	self browseOn: browser.
	browser openOn: self rootModel
!

update
	browser entity: self rootModel
! !

!PPDrabBrowser methodsFor:'querying'!

performRefactoring: aRefactoring
	^ PPRefactoringUtils new performRefactoring: aRefactoring
!

subclassesOf: aBehavior
	^ aBehavior subclasses asSortedCollection: [ :a :b | a name < b name ]
! !

!PPDrabBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPDrabBrowser.st,v 1.2 2014-03-04 21:19:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPDrabBrowser.st,v 1.2 2014-03-04 21:19:25 cg Exp $'
! !

