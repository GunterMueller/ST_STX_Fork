"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Object subclass:#NavigatorState
	instanceVariableNames:'categories classNames meta protocols selectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Navigator'
!

NavigatorState comment:'NavigatorState is a memento that the navigator uses to hold its state. It is held by each CodeModel so that when switching between the different code models, the navigator can easily be updated to the proper selection.

Instance Variables:
	categories      <Collection of: Symbol> the selected categories
	classNames      <Collection of: Symbol> the selected class'' names
	meta    <Boolean>       are the selected classes metaclasses?
	protocols       <Collection of: Symbol> the selected protocols
	selectors       <Collection of: Symbol> the selected method names'
!


!NavigatorState class methodsFor:'instance creation'!

new
	^super new initialize
! !

!NavigatorState methodsFor:'accessing'!

categories
	^categories
!

categories: symbolCollection
	categories := symbolCollection
!

category
	^self categories detect: [:each | true]
		ifNone: [nil]
!

category: aCategory 
	^categories := aCategory isNil ifTrue: [#()] ifFalse: [Array with: aCategory]
!

className
	^self classNames detect: [:each | true]
		ifNone: [nil]
!

className: aName 
	classNames := aName isNil ifTrue: [#()] ifFalse: [Array with: aName]
!

classNames
	^classNames
!

classNames: aCollection 
	classNames := aCollection
!

isMeta: aBoolean
	meta := aBoolean
!

methods
	| class methods |
	class := self selectedClass.
	class isNil ifTrue: [^#()].
	methods := OrderedCollection new: self selectors size.
	self selectors do: 
			[:each | 
			| method |
			method := class compiledMethodAt: each ifAbsent: [nil].
			method notNil ifTrue: [methods add: method]].
	^methods
!

nonMetaClass
	| classes |
	classes := self nonMetaClasses.
	^classes isEmpty ifTrue: [nil] ifFalse: [classes first]
!

nonMetaClasses
	| classes |
	classes := OrderedCollection new: classNames size.
	classNames do: 
			[:each | 
			| class |
			class := Smalltalk at: each ifAbsent: [nil].
			class notNil ifTrue: [classes add: class]].
	^classes
!

protocol
	^self protocols detect: [:each | true]
		ifNone: [nil]
!

protocol: aSymbol 
	protocols := aSymbol isNil ifTrue: [#()] ifFalse: [Array with: aSymbol]
!

protocols
	^protocols
!

protocols: symbolCollection 
	protocols := symbolCollection
!

selectedClass
	| class |
	class := self nonMetaClass.
	class isNil ifTrue: [^nil].
	^meta
		ifTrue: [class class]
		ifFalse: [class]
!

selectedClass: aClass 
	aClass isNil ifTrue: 
			[meta := false.
			^classNames := nil].
	self className: ((meta := aClass isMeta)
				ifTrue: [aClass soleInstance name]
				ifFalse: [aClass name]).
	^aClass
!

selectedClasses
	| classes |
	classes := self nonMetaClasses.
	^meta
		ifTrue: [classes collect: [:each | each class]]
		ifFalse: [classes]
!

selectedClasses: classCollection 
	classNames := classCollection
				collect: [:each | (each isMeta ifTrue: [each soleInstance] ifFalse: [each]) name].
	classCollection isEmpty ifTrue: 
			[meta := false.
			^self].
	meta := classCollection first isMeta
!

selector
	^self selectors detect: [:each | true]
		ifNone: [nil]
!

selector: aSymbol 
	selectors := aSymbol isNil ifTrue: [#()] ifFalse: [Array with: aSymbol]
!

selectors
	^selectors
!

selectors: symbolCollection 
	selectors := symbolCollection
! !

!NavigatorState methodsFor:'comparing'!

= anObject 
	self class == anObject class ifFalse: [^false].
	^self categories = anObject categories and: 
			[self selectedClasses = anObject selectedClasses and: 
					[self protocols = anObject protocols
						and: [self selectors = anObject selectors]]]
!

hash
	^self category hash bitXor: (self selectedClass hash
				bitXor: (self protocol hash bitXor: self selector hash))
! !

!NavigatorState methodsFor:'initialize-release'!

initialize
	categories := classNames := protocols := selectors := #().
	meta := false
! !

!NavigatorState methodsFor:'printing'!

printOn: aStream 
	| class |
	class := self selectedClass.
	class notNil
		ifTrue: 
			[aStream nextPutAll: class name.
			self selector notNil
				ifTrue: 
					[aStream nextPutAll: '>>';
						nextPutAll: self selector]
				ifFalse: 
					[self protocol notNil ifTrue: 
							[aStream nextPut: $>;
								nextPutAll: self protocol]]]
		ifFalse: 
			[categories isEmpty
				ifTrue: [aStream nextPutAll: '(nothing selected)']
				ifFalse: [aStream nextPutAll: self category]]
! !

!NavigatorState methodsFor:'testing'!

isMeta
	^meta
! !

!NavigatorState class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/NavigatorState.st,v 1.8 2003-09-23 10:45:02 cg Exp $'
! !
