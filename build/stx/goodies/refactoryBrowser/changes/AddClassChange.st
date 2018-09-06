"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

RefactoryClassChange subclass:#AddClassChange
	instanceVariableNames:'definition superclassName instanceVariableString
		classVariableString poolDictionaryNames category'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!AddClassChange class methodsFor:'instance creation'!

definition: aString 
	^self new definition: aString
! !

!AddClassChange methodsFor:'accessing'!

category
	category isNil ifTrue: [self fillOutDefinition].
	^category
!

changeClassName
	className isNil ifTrue: [self fillOutDefinition].
	^className
!

classVariableNames
        "attention: used to return a string - now returns a collection of strings.
         Use classVariableString for the old behavior"

        ^ self classVariableString asCollectionOfWords
!

classVariableString
        classVariableString isNil ifTrue: [self fillOutDefinition].
        ^classVariableString
!

instanceVariableNames
        "attention: used to return a string - now returns a collection of strings.
         Use instanceVariableString for the old behavior"

        ^ self instanceVariableString asCollectionOfWords
!

instanceVariableString
        instanceVariableString isNil ifTrue: [self fillOutDefinition].
        ^instanceVariableString
!

poolDictionaryNames
	poolDictionaryNames isNil ifTrue: [self fillOutDefinition].
	^poolDictionaryNames
!

superclassName
	className isNil ifTrue: [self fillOutDefinition].
	^superclassName
! !

!AddClassChange methodsFor:'comparing'!

= anAddClassChange 
	self class = anAddClassChange class ifFalse: [^false].
	^definition = anAddClassChange definition
!

hash
	^definition hash
! !

!AddClassChange methodsFor:'converting'!

asUndoOperation
	| class |
	class := Smalltalk at: self changeClassName ifAbsent: [nil].
	^class isBehavior 
		ifTrue: [AddClassChange definition: class definition]
		ifFalse: [RemoveClassChange removeClassName: self changeClassName]
! !

!AddClassChange methodsFor:'initialize-release'!

definition: aString 
	definition := aString
!

initialize
	super initialize.
	isMeta := false
! !

!AddClassChange methodsFor:'printing'!

changeString
        ^'Define ' , self displayClassName allBold
!

printOn: aStream 
	aStream
		nextPutAll: definition;
		nextPut: $!!
! !

!AddClassChange methodsFor:'private'!

controller
	^nil
!

definingSuperclass
	^self class
!

definition
	^definition
!

definitionClass
    ^ (Smalltalk classNamed:(self superclassName)) ? ProtoObject
!

fillOutDefinition
        | parseTree receiver arguments argumensBySelectorParts |
        parseTree := RBParser parseExpression: definition
                                onError: [:str :pos | ^self parseDefinitionError].
        parseTree isMessage ifFalse: [^self parseDefinitionError].
        (self isValidSubclassCreationMessage: parseTree) 
                ifFalse: [^self parseDefinitionError].
        receiver := parseTree receiver.
        superclassName := receiver isVariable 
                                ifTrue: [receiver name asSymbol]
                                ifFalse: [receiver value].
        arguments := parseTree arguments.
        className := arguments first value.
        instanceVariableString := (arguments at: 2) value asString.
        classVariableString := (arguments at: 3) value asString.
        instanceVariableString := (arguments at: 2) value.
        "/ classVariableString := self namesIn: (arguments at: 3) value.
        classVariableString := (arguments at: 3) value.
        poolDictionaryNames := self namesIn: (arguments at: 4) value.

        argumensBySelectorParts := self argumensBySelectorPartsFromMessage: parseTree.
        (argumensBySelectorParts includesKey: #privateIn:) ifTrue: [
            | argument |

            argument := argumensBySelectorParts at: #privateIn:.
            argument isVariable ifTrue: [ 
                self privateInClassName: argument name asSymbol
            ] ifFalse: [ 
                self privateInClassName: argument value asSymbol
            ].
            className := (self privateInClassName, '::', className) asSymbol.
            category := #''. "Inherited by owner - privateInClassName"
        ] ifFalse: [ 
            category := arguments size < 5 
                                ifTrue: [#Unknown]
                                ifFalse: [(arguments at: 5) value asSymbol]
        ].

    "Modified: / 25-01-2015 / 12:32:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

namesIn: aString 
	| names stream nameStream |
	names := OrderedCollection new.
	stream := ReadStream on: aString.
	
	[stream skipSeparators.
	stream atEnd] whileFalse: 
				[nameStream := WriteStream on: (String new: 10).
				[stream atEnd or: [stream peek isSeparator]] 
					whileFalse: [nameStream nextPut: stream next].
				names add: nameStream contents].
	^names
!

parseDefinitionError
        className := #'Unknown Class'.
        instanceVariableString := ''.
        classVariableString := ''.
        poolDictionaryNames := #()

    "Modified: / 15-05-2015 / 08:36:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primitiveExecute

    package notNil ifTrue:[
        Class packageQuerySignal 
            answer:package
            do:[
                ^ self definingSuperclass subclassDefinerClass 
                    evaluate: definition
                    notifying: self controller
                    logged: true
            ]
    ].

    ^ self definingSuperclass subclassDefinerClass 
                evaluate: definition
                notifying: self controller
                logged: true

    "Modified: / 08-10-2014 / 20:10:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddClassChange methodsFor:'testing'!

isClassDefinitionChange

    ^true

    "Created: / 29-10-2010 / 13:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isOrContainsClassDefinitionChange
    ^true

    "Created: / 21-02-2014 / 22:45:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPrivateClassDefinitionChange
    ^ self definition includesString: 'privateIn'

    "Created: / 15-05-2015 / 08:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isValidMessageName: aMessageNode
    ^ 
        Class definitionSelectors
"/        #( #subclass:instanceVariableNames:classVariableNames:poolDictionaries: 
"/           #subclass:instanceVariableNames:classVariableNames:poolDictionaries:category: 
"/           #variableByteSubclass:classVariableNames:poolDictionaries: 
"/           #variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category: 
"/           #variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries: 
"/           #variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:
"/        ) 
                includes: aMessageNode selector

    "Modified (format): / 16-11-2014 / 12:35:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isValidSubclassCreationMessage: aMessageNode
        | argumensBySelectorParts |

        (aMessageNode receiver isVariable or: [aMessageNode receiver isLiteral]) 
                ifFalse: [^false].

        (self isValidMessageName: aMessageNode) ifFalse: [^false].

        "Each argument should be literal except for privateIn:"
        argumensBySelectorParts := self argumensBySelectorPartsFromMessage: aMessageNode.
        argumensBySelectorParts keysAndValuesDo: [ :name :value |
            value isLiteral ifFalse: [
                name = #privateIn: ifFalse: [ 
                    ^ false
                ]
            ]
        ].

        ^ true.

    "Modified: / 16-11-2014 / 15:32:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddClassChange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

