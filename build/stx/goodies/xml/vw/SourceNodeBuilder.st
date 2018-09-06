"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLNodeBuilder subclass:#SourceNodeBuilder
	instanceVariableNames:'selectors classReplacements'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Source Code'
!

SourceNodeBuilder comment:'This subclass of XMLNodeBuilder is used by the XML parser to distill a VisualWorks XML source document (stream) into first XML elements and then into valid Smalltalk objects

Instance Variables:
	selectors       <Dictionary>  map from tag name to accessing selector
'
!


!SourceNodeBuilder methodsFor:'building'!

attribute: name value: value

	^Attribute name: name value: value
!

comment: aText

	^Comment new text: aText; discard
!

makeText: text

	| txt |
	txt := Text text: text.
	(txt isBlankText and: [(tagStack contains: [:c | c tag type ~= 'body']) not])
		ifTrue: [txt discard].
	^txt
!

notation: name value: val

	^name
!

tag: tag attributes: attributes elements: elements position: p stream: stream

	| elm |
	elm := Element tag: tag attributes: attributes elements: elements.
	(tagStack size = 1 or: [(tagStack at: tagStack size-1) tag type = 'st-source'])
		ifTrue:
			[self compile: elm.
			elm discard].
	^elm
! !

!SourceNodeBuilder methodsFor:'compiling'!

compile: element

	| name |
	name := self selectorFor: element tag.
	self perform: name with: element
!

compile_class: anElement
	| name env superclass private indexed instVars classInstVars imports category annotations 
	  superclassName|

	name := self getSymbol: 'name' from: anElement.
	Smalltalk isSmalltalkX ifTrue:[
	    env := self getNameSpaceId: 'environment' from: anElement.
	    env == nil ifTrue: [env := Smalltalk ].
	] ifFalse:[
	    env := self getGlobalId: 'environment' from: anElement.
	    self halt.
	    " env == nil ifTrue: [env := #{Smalltalk} ]. "
	].
	superclass := self getGlobalId: 'super' from: anElement.
	private := self getBoolean: 'private' from: anElement default: 'false'.
	indexed := self getSymbol: 'indexed-type' from: anElement default: 'none'.
	instVars := self getString: 'inst-vars' from: anElement default: ''.
	classInstVars := self getString: 'class-inst-vars' from: anElement default: ''.
	imports := self getString: 'imports' from: anElement default: ''.
	category := self getString: 'category' from: anElement default: 'As yet unclassified'.
	annotations := self getDictionary: 'attributes' from: anElement.
	Smalltalk isSmalltalkX ifTrue:[
	    superclass isNil ifTrue:[
		superclassName := self getString:'super' from:anElement default: ''.
		superclassName size > 0 ifTrue:[
		    [
			superclassName := Dialog 
					    request:'Replacement for missing superclass: ' , superclassName allBold
					    initialAnswer:'Object'.
			superclassName size == 0 ifTrue:[
			    AbortSignal raise.
			].
			superclass := Smalltalk classNamed:superclassName.
		    ] doUntil:[ superclass notNil ].
		]
	    ].
	    env defineClass: name
		    superclass: superclass
		    indexedType: indexed
		    private: private
		    instanceVariableNames: instVars
		    classInstanceVariableNames: classInstVars
		    imports: imports
		    category: category
		    attributes: annotations
	] ifFalse:[
	    env value defineClass: name
		    superclass: superclass
		    indexedType: indexed
		    private: private
		    instanceVariableNames: instVars
		    classInstanceVariableNames: classInstVars
		    imports: imports
		    category: category
		    attributes: annotations
	]
!

compile_comment: anElement

	| class body |
	class := self getGlobal: #('class-id' 'name-space-id' 'object-id') from: anElement.
	body := anElement elementNamed: 'body'.
	class comment: body characterData
!

compile_do_it: anElement

	Compiler evaluate: anElement characterData.
!

compile_initialize: anElement

	| class |
	class := self getGlobal: #('class-id' 'name-space-id' 'object-id' 'variable-id') from: anElement.
	class initialize
!

compile_methods: anElement

	| class protocol bodies |
	class := self getGlobal: #('class-id') from: anElement.
	protocol := self getSymbol: 'category' from: anElement default: ClassOrganizer defaultProtocol.
	bodies := anElement elementsNamed: 'body'.
	bodies do: [:elm | | attributes |
		attributes := Dictionary new.
		elm attributes do: [:attr |
			attributes at: attr tag type asSymbol put: attr value].
		class compile: elm characterData classified: protocol attributes: attributes].
!

compile_name_space: anElement

	| name env private category imports annotations |
	name := self getSymbol: 'name' from: anElement.
	env := self getGlobalId: 'environment' from: anElement.
	private := self getBoolean: 'private' from: anElement default: 'false'.
	imports := self getString: 'imports' from: anElement default: ''.
	category := self getString: 'category' from: anElement default: NameSpaceOrganizer defaultProtocol.
	annotations := self getDictionary: 'attributes' from: anElement.
	env value defineNameSpace: name
		private: private
		imports: imports
		category: category
		attributes: annotations.
!

compile_relocate: anElement

	| class |
	class := self getGlobal: #('class-id' 'name-space-id' 'object-id' 'variable-id') from: anElement.
	class relocateTo: (self getGlobal: #('environment') from: anElement)
!

compile_remove: anElement

	| class |
	class := self getGlobal: #('class-id' 'name-space-id' 'object-id' 'variable-id') from: anElement.
	class removeFromSystem
!

compile_remove_selector: anElement

	| class selector |
	class := self getGlobal: #('class-id') from: anElement.
	selector := anElement elementNamed: 'selector'.
	class removeSelector: selector characterData asSymbol
!

compile_rename: anElement

	| class |
	class := self getGlobal: #('class-id' 'name-space-id' 'object-id' 'variable-id') from: anElement.
	class renameTo: (self getSymbol: 'name' from: anElement)
!

compile_reorganize: anElement

	| class |
	class := self getGlobal: #('class-id' 'name-space-id') from: anElement.
	class reorganizeFromString: (self getString: 'organization' from: anElement default: [''])
!

compile_reorganize_data: anElement

	| class |
	class := self getGlobal: #('class-id' 'name-space-id') from: anElement.
	class asNameSpace reorganizeFromString: (self getString: 'organization' from: anElement default: [''])
!

compile_st_source: anElement
	"Do nothing"

	^self
!

compile_static: anElement

	| name env private category constant initializer annotations clsEnv|
	name := self getSymbol: 'name' from: anElement.
	env := self getGlobalId: 'environment' from: anElement.
	Smalltalk isSmalltalkX ifTrue:[
	    env == nil ifTrue: [env := Smalltalk ].
	] ifFalse:[
	    self halt.
	    " env == nil ifTrue: [env := #{Smalltalk} ]. "
	].
	private := self getBoolean: 'private' from: anElement default: 'false'.
	constant := self getBoolean: 'constant' from: anElement default: 'false'.
	category := self getString: 'category' from: anElement default: NameSpaceOrganizer defaultProtocol.
	initializer := self getString: 'initializer' from: anElement default: nil.
	annotations := self getDictionary: 'attributes' from: anElement.

	Smalltalk isSmalltalkX ifTrue:[
	    clsEnv := env.
	] ifFalse:[
	    clsEnv := env value 
	].
	clsEnv defineStatic: name
		    private: private
		    constant: constant
		    category: category
		    initializer: initializer
		    attributes: annotations.
!

compile_time_stamp: anElement
	"Do nothing"

	^self
! !

!SourceNodeBuilder methodsFor:'initialization'!

initialize

	super initialize.
	selectors := IdentityDictionary new
! !

!SourceNodeBuilder methodsFor:'private'!

dictionaryFrom: node to: dict
	"Over time, we may want to accomodate more complex
	annotations for a class."

	| c |
	node elements do: [:elm |
		elm isText ifFalse: [
			(elm elements isEmpty or: [elm elements contains: [:e | e isElement]])
				ifTrue:
					[c := elm elements select: [:i | i isElement].
					dict at: elm tag type asSymbol put: (c collect: [:i | i characterData])]
				ifFalse: [dict at: elm tag type asSymbol put: elm characterData]]]
!

getBoolean: tag from: element default: defaultValue

	| list item |
	list := element elementsNamed: tag.
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [list size = 0
			ifTrue: [defaultValue]
			ifFalse: [self error: 'Could not find unique "', tag, '".']].
	^item = 'true'
		ifTrue: [true]
		ifFalse: [item = 'false'
			ifTrue: [false]
			ifFalse: [self error: '"',item,'" is not a boolean value for "', tag, '".']]
!

getDictionary: tag from: element

	| list dict |
	list := element elementsNamed: tag.
	dict := Dictionary new.
	list do: [:node |
		self dictionaryFrom: node to: dict].
	^dict
!

getGlobal: possibleTags from: element

        | list item data class className|
        list := OrderedCollection new.
        possibleTags do: [:tag | list addAll: (element elementsNamed: tag)].
        list size = 1
                ifTrue: [item := list first]
                ifFalse: [self error: 'Could not find unique ', possibleTags printString, '.'].
        data := item characterData.

        Smalltalk isSmalltalkX ifTrue:[
            className := data.
            (className endsWith:' class') ifTrue:[
                className := className copyButLast:6.
            ].
            class := Smalltalk classNamed:className.
            class isNil ifTrue:[
                (className includes:$.) ifTrue:[
                    className := className replChar:$. withString:'::'.
                    class := Smalltalk classNamed:className.
                    class isNil ifTrue:[
                        self breakPoint:#cg
                    ]
                ].
            ].
        ].

        ((item tag isLike: 'class-id') and: ['* class' match: data caseSensitive:true])
                ifTrue:
                        [
                         Smalltalk isSmalltalkX ifTrue:[
                             ^ class class
                         ].
                        item := data copyFrom: 1 to: data size-6.
                        ^ item asQualifiedReference value class].

        (item tag isLike: 'variable-id') ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self breakPoint:#cg.
            ].
            ^ data asQualifiedReference
        ].

        Smalltalk isSmalltalkX ifTrue:[
            ^ class
        ].
        ^ data asQualifiedReference value

    "Modified: / 27-03-2017 / 13:04:31 / stefan"
!

getGlobalId: tag from: element

        | list item nsOrClass repl baseName|
        list := element elementsNamed: tag.
        item := list size = 1
                ifTrue: [list first characterData]
                ifFalse: [self error: 'Could not find unique "', tag, '".'].
        item isEmpty ifTrue: [^nil].
        Smalltalk isSmalltalkX ifTrue:[
            (item includes:$.) ifTrue:[
                item := item replChar:$. withString:'::'   
            ].
            classReplacements isNil ifTrue:[
                classReplacements := Dictionary new.
            ].
            nsOrClass := classReplacements at:item asSymbol ifAbsent:nil.
            nsOrClass notNil ifTrue:[^ nsOrClass].

            nsOrClass := Smalltalk at:item asSymbol.
            nsOrClass notNil ifTrue:[^ nsOrClass].
            baseName := item copyFrom:( item lastIndexOf:$: )+1. 
            repl := Dialog request:'Replacement class for ', item initialAnswer:baseName.
            [repl size ~~ 0] whileTrue:[
                nsOrClass := Smalltalk at:repl asSymbol2.
                nsOrClass notNil ifTrue:[
                    classReplacements at:item asSymbol put:nsOrClass.
                    ^ nsOrClass
                ].
                repl := Dialog request:'Replacement class for ', item initialAnswer:repl.
            ].
            self breakPoint:#cg info:('Unknown NameSpace/Class: ' , item).
            ^ nil
        ].
        ^item asQualifiedReference
!

getNameSpaceId: tag from: element

	| list item ns|
	list := element elementsNamed: tag.
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [self error: 'Could not find unique "', tag, '".'].
	item isEmpty ifTrue: [^nil].

	Smalltalk isSmalltalkX ifFalse:[
	    self error:'only required for ST/X'.
	].
	(item includes:$.) ifTrue:[
	    item := item replChar:$. withString:'::'   
	].
	ns := Smalltalk at:item asSymbol.
	ns notNil ifTrue:[^ ns ].

	(Dialog confirm:('Unknown NameSpace: ' , item allBold , '\\Create ?') withCRs) ifFalse:[
	    (Dialog confirm:('Load into Smalltalk ?') withCRs) ifFalse:[
		AbortSignal raise.
	    ].
	    ^ Smalltalk
	].
	Class nameSpaceQuerySignal answer:Smalltalk do:[
	    ns := NameSpace fullName:item.
	].
	^ ns
!

getString: tag from: element default: defaultValue

	| list item |
	list := element elementsNamed: tag.
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [list size = 0
			ifTrue: [defaultValue]
			ifFalse: [self error: 'Could not find unique "', tag, '".']].
	^item
!

getSymbol: tag from: element

	| list item |
	list := element elementsNamed: tag.
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [self error: 'Could not find unique "', tag, '".'].
	^item asSymbol
!

getSymbol: tag from: element default: defaultValue

	| list item |
	list := element elementsNamed: tag.
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [list size = 0
			ifTrue: [defaultValue]
			ifFalse: [self error: 'Could not find unique "', tag, '".']].
	^item asSymbol
!

selectorFor: aTag

        ^selectors at: aTag ifAbsentPut:
                        [| t |
                        t := aTag type copyReplaceAll: $: with: $_.
                        t replaceAll: $. with: $_.
                        t replaceAll: $- with: $_.
                        ('compile_', t, ':') asSymbol]

    "Modified: / 16-07-2013 / 19:45:02 / cg"
! !

!SourceNodeBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SourceNodeBuilder.st,v 1.14 2017-03-27 11:22:20 stefan Exp $'


!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SourceNodeBuilder.st,v 1.14 2017-03-27 11:22:20 stefan Exp $'
! !

