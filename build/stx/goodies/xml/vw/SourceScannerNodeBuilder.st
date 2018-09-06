"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLNodeBuilder subclass:#SourceScannerNodeBuilder
	instanceVariableNames:'selectors currentFile currentPosition positions changeBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Source Code'
!

SourceScannerNodeBuilder comment:'This subclass of XMLNodeBuilder is used by the VisualWorks ChangeScanner to scan a VisualWorks XML source file and distill it into first XML elements and then
 into valid Smalltalk objects for display in the Change List tool.


Instance Variables:
	selectors       <Dictionary>  comment
	currentFile     <ReadStream>  comment
	currentPosition <Integer>  comment
	positions       <Dictionary>  comment
	changeBlock     <BlockClosure>  comment
'
!

!SourceScannerNodeBuilder class methodsFor:'documentation'!

examples
"
										[exBegin]
    |builder|

    builder := XML.SourceScannerNodeBuilder new.
    builder scanFile:'../../goodies/xml/vw/xmlFileInTests/Test1.xml' asFilename readStream
	    do:[:element | self halt]
										[exEnd]


										[exBegin]
    |builder|

    builder := XML.SourceScannerNodeBuilder new.
    builder scanFile:'../../goodies/xml/vw/xmlFileInTests/Test2.xml' asFilename readStream
	    do:[:element | self halt]
										[exEnd]

										[exBegin]
    |builder elements|

    elements := OrderedCollection new.
    builder := XML.SourceScannerNodeBuilder new.
    builder scanFile:'../../goodies/xml/vw/xmlFileInTests/XMLParser.xml' asFilename readStream
	    do:[:element | elements add:element].
    elements inspect
										[exEnd]
"
! !

!SourceScannerNodeBuilder methodsFor:'accessing'!

currentFile

	^currentFile
!

forgetPosition: elm

	positions removeKey: elm ifAbsent: []
!

positionAt: elm

	^positions at: elm
!

positionAt: elm put: p

	positions at: elm put: p
! !

!SourceScannerNodeBuilder methodsFor:'building'!

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

scanFile: file do: aBlock

	| parser |
	changeBlock := aBlock.
	parser := XMLParser new.
	parser on: file.
	parser validate: false.
	parser builder: self.
	parser prolog.
	[file atEnd] whileFalse:
		[parser element.
		[parser misc] whileTrue].
!

tag: tag attributes: attributes elements: elements position: p stream: stream

	| elm |
	elm := Element tag: tag attributes: attributes elements: elements.
	(tagStack size = 1 or: [(tagStack at: tagStack size-1) tag type = 'st-source'])
		ifTrue:
			[currentFile := stream stream.
			currentPosition := p.
			self scan: elm.
			elm discard].
	tag type = 'body' ifTrue: [self positionAt: elm put: p].
	^elm
! !

!SourceScannerNodeBuilder methodsFor:'initialization'!

initialize

	super initialize.
	selectors := IdentityDictionary new.
	positions := IdentityDictionary new.
! !

!SourceScannerNodeBuilder methodsFor:'private'!

doChange: aChange

	aChange file == nil
		ifTrue: [aChange file: currentFile position: currentPosition].
	changeBlock value: aChange
!

getAttributesList: tag from: element

	| list newList |
	list := element elementsNamed: tag.
	newList := OrderedCollection new.
	list do: [:node |
		self listFrom: node to: newList].
	^newList asArray
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

getGlobalId: tag from: element

	| list item |
	list := element elementsNamed: tag.
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [self error: 'Could not find unique "', tag, '".'].
	^item
!

getGlobalIdAny: possibleTags from: element do: aBlock

	| list item name |
	list := OrderedCollection new.
	possibleTags do: [:tag | list addAll: (element elementsNamed: tag)].
	item := list size = 1
		ifTrue: [list first characterData]
		ifFalse: [self error: 'Could not find unique ', possibleTags printString, '.'].
	name := #('name-space-id' 'class-id' 'object-id' 'variable-id') indexOf: list first tag type.
	name := #(#nameSpace #class #object #variable) at: name.
	aBlock value: name.
	^item
!

getNameSpaceId: tag from: element

        | list item ns answer|

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

        answer := Dialog confirmWithCancel:('Unknown NameSpace: ' , item allBold , '\\Create ?') withCRs.
        answer ifFalse:[
            (Dialog confirm:('Load into/Assume Smalltalk ?') withCRs) ifFalse:[
                AbortSignal raise.
            ].
            ^ Smalltalk
        ].
        Class nameSpaceQuerySignal answer:Smalltalk do:[
            ns := NameSpace fullName:item.
        ].
self breakPoint:#cg.
        ^ ns
!

getNameSpaceOrClassId: tag from: element
        | list item ns answer|

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

        answer := Dialog confirmWithCancel:('Unknown NameSpace/Class: ' , item allBold , '\\Create ?') withCRs.
        answer == nil ifTrue:[
            AbortSignal raise.
        ].
        answer ifFalse:[
            answer := Dialog confirm:('Load into/Assume Smalltalk ?') withCRs.
            answer ifFalse:[
                AbortSignal raise.
            ].
            ^ Smalltalk
        ].
        Class nameSpaceQuerySignal answer:Smalltalk do:[
            ns := NameSpace fullName:item.
        ].
self breakPoint:#cg.
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

listFrom: node to: list
	"Over time, we may want to accomodate more complex
	annotations for a class."

	| c |
	node elements do: [:elm |
		elm isText ifFalse: [
			(elm elements isEmpty or: [elm elements contains: [:e | e isElement]])
				ifTrue:
					[c := elm elements select: [:i | i isElement].
					list add: (Array with: elm tag type asSymbol with: (c collect: [:i | i characterData]))]
				ifFalse: [list add: (Array with: elm tag type asSymbol with: elm characterData)]]]
!

selectorFor: aTag

        ^selectors at: aTag ifAbsentPut:
                        [| t |
                        t := aTag type copyReplaceAll: $: with: $_.
                        t replaceAll: $. with: $_.
                        t replaceAll: $- with: $_.
                        ('scan_', t, ':') asSymbol]

    "Modified: / 16-07-2013 / 19:44:57 / cg"
! !

!SourceScannerNodeBuilder methodsFor:'scanning'!

parcel_loaded: anElement 
self halt.
!

scan: element

	| name |
	name := self selectorFor: element tag.
	self perform: name with: element
!

scan_bundle_structure: anElement 
"/ self halt.
!

scan_class: anElement

	| parameters superStringTheory classChange attr envRef |
	"N.B. Must create otherParameters in same order as keywords in class def."
	parameters := OrderedCollection new.
	superStringTheory := self getString: 'super' from: anElement default: ''.
	parameters addLast:
			#superclass:
			-> (superStringTheory = 'nil' ifFalse:
					[(BindingReference pathString: superStringTheory) makeUnambiguous]).
	parameters addLast:
			#indexedType:
			-> (self getSymbol: 'indexed-type' from: anElement default: #none).
	parameters addLast:
			#private:
			-> (self getBoolean: 'private' from: anElement default: false).
	parameters addLast:
			#instanceVariableNames:
			-> (self getString: 'inst-vars' from: anElement default: '').
	parameters addLast:
			#classInstanceVariableNames:
			-> (self getString: 'class-inst-vars' from: anElement default: '').
	parameters addLast:
			#imports:
			-> (self getString: 'imports' from: anElement default: '').
	parameters addLast:
			#category:
			-> (self getString: 'category' from: anElement default: NameSpaceOrganizer defaultProtocol asString).
	attr := self getAttributesList: 'attributes' from: anElement.
	attr isEmpty ifFalse: [parameters addLast: #attributes: -> attr].

	classChange := ClassDefinitionChange new.
	classChange objectType: #class.
	classChange className: (self getString: 'name' from: anElement default: '').
	Smalltalk isSmalltalkX ifTrue:[
	    envRef := self getString: 'environment' from: anElement default: #Smalltalk.
"/            (envRef knownAsSymbol not
"/            or:[ (envRef := Smalltalk at:envRef asSymbol) isNil
"/            or:[ envRef isNameSpace not and:[envRef ~~ Smalltalk]]])
"/            ifTrue:[
"/                envRef := Smalltalk.
"/            ]
	] ifFalse:[
	    envRef := (self getString: 'environment' from: anElement default: #Smalltalk) asQualifiedReference makeUnambiguous asString asSymbol.
	].
	classChange
		nameSpaceName: envRef
		classType: #defineClass:
		otherParameters: parameters.

	self doChange: classChange
!

scan_comment: anElement 
	| class tp comment|
	class := self
				getGlobalIdAny: #('class-id' 'name-space-id' 'object-id')
				from: anElement
				do: [:type | tp := type].
        
	comment := (anElement elementNamed:'body') characterData.
	self doChange: ((ClassCommentChange new)
				comment:comment;
				className: class;
				objectType: tp)
!

scan_component_created: anElement 
	| class newName newType tp |
"/        class := self
"/                                getGlobalIdAny: #('class-id' 'name-space-id' 'object-id' 'variable-id')
"/                                from: anElement
"/                                do: [:type | tp := type].
	newName := self getSymbol: 'name' from: anElement.
	newType := self getSymbol: 'type' from: anElement.
"/        self doChange: ((ComponentCreatedChange new)
"/                                newName: newName;
"/                                newType: newType)
!

scan_component_definition_change: anElement 
"/ self halt.
!

scan_component_property: anElement 
"/ self halt.
!

scan_component_selector_change: anElement 
"/ self halt.
!

scan_copyright: anElement

	self doChange: (OtherChange new type: #copyright)
!

scan_do_it: anElement

	self doChange:(DoItChange new source:(anElement characterData))
!

scan_initialize: anElement 
	| class tp |
	class := self
				getGlobalIdAny: #('class-id' 'name-space-id' 'object-id' 'variable-id')
				from: anElement
				do: [:type | tp := type].
	self doChange: ((ClassOtherChange new)
				className: class;
				type: #initialize;
				objectType: tp)
!

scan_methods: anElement

        | classId classIdLastDotIndex className nameSpaceName protocol bodies classObject selector attributes savedCurrentPosition |
        classId := self getGlobalId: 'class-id' from: anElement.
        classObject := (classId includes: Character space)
                        ifTrue: [((classId copyUpTo: Character space)
                                        asQualifiedReference valueOrDo: []) class]
                        ifFalse: [classId asQualifiedReference valueOrDo: []].
        classObject isBehavior ifFalse: [classObject := Object].

        "classId is VW-formatted fully qualified reference, i.e., namespaces separated by dots"
        (classId includes:$.) ifTrue:[
            classIdLastDotIndex :=  classId lastIndexOf: $..
            className := classId copyFrom: classIdLastDotIndex + 1.
            nameSpaceName := classId copyTo: classIdLastDotIndex - 1.
        ] ifFalse:[
            className := classId.
        ].

        protocol := self getSymbol: 'category' from: anElement default: ClassOrganizer defaultProtocol.
        bodies := anElement elementsNamed: 'body'.
        savedCurrentPosition := currentPosition.
        bodies do: [:elm |
                |change|

                attributes := Dictionary new.
                elm attributes do: [:attr |
                        attributes at: attr tag type asSymbol put: attr value].
                selector := classObject parserClass new parseSelector: elm characterData.
                currentPosition := self positionAt: elm.
                change := MethodDefinitionChange new
                            className: className;
                            nameSpaceName: nameSpaceName;
                            selector: selector;
                            category: protocol;
                            attributes: attributes;
                            yourself.
                ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
                    change source:(elm characterData)
                ].
                self doChange: change.
                self forgetPosition: elm].
        currentPosition := savedCurrentPosition

    "Modified: / 12-12-2013 / 12:34:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scan_name_space: anElement

        | name env private category imports parameters attr |
        "N.B. Must create otherParameters in same order as keywords in class def."
        name := self getSymbol: 'name' from: anElement.
        env := self getGlobalId: 'environment' from: anElement.
        env := env asQualifiedReference makeUnambiguous asString.
        private := self getBoolean: 'private' from: anElement default: false.
        imports := self getString: 'imports' from: anElement default: ''.
        category := self getString: 'category' from: anElement default: NameSpaceOrganizer defaultProtocol asString.
        (parameters := OrderedCollection new)
                addLast: #private: -> private;
                addLast: #imports: -> imports;
                addLast: #category: -> category.
        attr := self getAttributesList: 'attributes' from: anElement.
        attr isEmpty ifFalse: [parameters addLast: #attributes: -> attr].
        Smalltalk isSmalltalkX ifTrue:[
            self doChange: ((NameSpaceCreationChange new)
                    nameSpaceName:(env , '.' , name);
                    otherParameters: parameters)
        ] ifFalse:[
            self doChange: ((ClassDefinitionChange new)
                    objectType: #nameSpace;
                    className: name;
                    nameSpaceName: env asSymbol classType: #defineNameSpace: otherParameters: parameters)
        ]
!

scan_new_page: anElement
!

scan_parcel_loaded: anElement 
"/ self halt.
!

scan_pundle_loaded: anElement 
"/ self halt.
!

scan_relocate: anElement

	| class newParent tp |
	class := self getGlobalIdAny: #('class-id' 'name-space-id' 'object-id' 'variable-id') from: anElement do: [:type | tp := type].
	newParent := (self getGlobalId: 'environment' from: anElement).
	self notYetImplemented
!

scan_remove: anElement 
	| class tp |
	class := self
				getGlobalIdAny: #('class-id' 'name-space-id' 'object-id' 'variable-id')
				from: anElement
				do: [:type | tp := type].
	self doChange: ((ClassOtherChange new)
				className: class;
				type: #remove;
				objectType: tp)
!

scan_remove_selector: anElement

	| class selector |
	class := self getGlobalId: 'class-id' from: anElement.
	selector := (anElement elementNamed: 'selector') elements first text.
	self doChange: (MethodRemoveChange "MethodOtherChange" new
					className: class; selector: selector; type: #remove)
!

scan_rename: anElement 
	| class newName tp |
	class := self
				getGlobalIdAny: #('class-id' 'name-space-id' 'object-id' 'variable-id')
				from: anElement
				do: [:type | tp := type].
	newName := self getSymbol: 'name' from: anElement.
	self doChange: ((ClassRenameChange new)
				className: newName;
				oldClassName: class;
				objectType: tp)
!

scan_reorganize: anElement 
	| class data tp |
	class := self
				getGlobalIdAny: #('class-id' 'name-space-id')
				from: anElement
				do: [:type | tp := type].
	data := self
				getString: 'organization'
				from: anElement
				default: [''].
	self doChange: ((ClassOtherChange new)
				className: class;
				type: #reorganize;
				objectType: tp;
				otherData: data;
				yourself)
!

scan_reorganize_data: anElement 

	| class data tp |
	class := self
				getGlobalIdAny: #('class-id' 'name-space-id')
				from: anElement
				do: [:type | tp := type].
	data := self
				getString: 'organization'
				from: anElement
				default: [''].
	self doChange: ((ClassOtherChange new)
				className: class;
				type: #reorganize;
				otherData: data;
				objectType: tp;
				yourself)
!

scan_shared_variable: anElement
    | name env private category constant initializer parameters attr |
    "N.B. Must create otherParameters in same order as keywords in class def."
    name := self getSymbol: 'name' from: anElement.
    Smalltalk isSmalltalkX ifTrue:[
	env := self getGlobalId:'environment' from: anElement    
	"/ env := self getNameSpaceOrClassId: 'environment' from: anElement.
	"/ env := env name.
    ] ifFalse:[
	env := self getGlobalId: 'environment' from: anElement.
	env := env asQualifiedReference makeUnambiguous asString.
    ].
    private := self getBoolean: 'private' from: anElement default: false.
    constant := self getBoolean: 'constant' from: anElement default: false.
    category := self getString: 'category' from: anElement default: NameSpaceOrganizer defaultProtocol asString.
    initializer := self getString: 'initializer' from: anElement default: nil.
    (parameters := OrderedCollection new)
	    addLast: #private: -> private;
	    addLast: #constant: -> constant;
	    addLast: #category: -> category;
	    addLast: #initializer: -> initializer.
    attr := self getAttributesList: 'attributes' from: anElement.
    attr isEmpty ifFalse: [parameters addLast: #attributes: -> attr].
    self doChange: ((ClassDefinitionChange new)
					    objectType: #variable;
					    className: name;
					    nameSpaceName: env asSymbol classType: #defineSharedVariable: otherParameters: parameters)
!

scan_st_source: anElement
	"Do nothing"

	^self
!

scan_static: anElement

	| name env private category constant initializer parameters attr |
	"N.B. Must create otherParameters in same order as keywords in class def."
	name := self getSymbol: 'name' from: anElement.
	env := self getGlobalId: 'environment' from: anElement.
	env := env asQualifiedReference makeUnambiguous asString.
	private := self getBoolean: 'private' from: anElement default: false.
	constant := self getBoolean: 'constant' from: anElement default: false.
	category := self getString: 'category' from: anElement default: NameSpaceOrganizer defaultProtocol asString.
	initializer := self getString: 'initializer' from: anElement default: nil.
	(parameters := OrderedCollection new)
		addLast: #private: -> private;
		addLast: #constant: -> constant;
		addLast: #category: -> category;
		addLast: #initializer: -> initializer.
	attr := self getAttributesList: 'attributes' from: anElement.
	attr isEmpty ifFalse: [parameters addLast: #attributes: -> attr].
	self doChange: ((ClassDefinitionChange new)
						objectType: #variable;
						className: name;
						nameSpaceName: env asSymbol classType: #defineStatic: otherParameters: parameters)
!

scan_time_stamp: anElement

        self doChange: (TimestampChange new type: #timeStamp; source:(anElement characterData))
! !

!SourceScannerNodeBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SourceScannerNodeBuilder.st,v 1.17 2013-12-12 14:07:28 vrany Exp $'


!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SourceScannerNodeBuilder.st,v 1.17 2013-12-12 14:07:28 vrany Exp $'
! !

