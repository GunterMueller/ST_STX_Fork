"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

RBAbstractClass subclass:#RBClass
	instanceVariableNames:'classVariableNames poolDictionaryNames category'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Model'
!

RBClass comment:'RBClass represents a Class.

Instance Variables:
	category	<Symbol>	name of the category that the class should be compiled in
	classVariableNames	<SequenceableCollection of: Symbol>	class variables defined by the class
	poolDictionaryNames	<Collection of: Symbol>	pool variables included by the class'
!


!RBClass class methodsFor:'instance creation'!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself
!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself
! !

!RBClass methodsFor:'accessing'!

allClassVariableNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [self classVariableNames]
		ifFalse: [sprClass allClassVariableNames , self classVariableNames]
!

allPoolDictionaryNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [self poolDictionaryNames]
		ifFalse: [sprClass allPoolDictionaryNames , self poolDictionaryNames]
!

category
	^category isNil 
		ifTrue: [model environment whichCategoryIncludes: self name]
		ifFalse: [category]
!

category: aSymbol 
	category := aSymbol
!

classVarNames
    ^self classVariableNames

    "Created: / 30-01-2012 / 21:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classVariableNames
	^self privateClassVariableNames copy
!

classVariableNames: aCollectionOfStrings 
	classVariableNames := (aCollectionOfStrings 
				collect: [:each | each asSymbol]) asOrderedCollection
!

definitionString
        | definitionStream cat|
        definitionStream := WriteStream on: ''.
        definitionStream
                nextPutAll: self superclass printString;
                nextPutAll: ' subclass: ';
                nextPutAll: self name storeString;
                nextPutAll: '
        instanceVariableNames: '''.
        self instanceVariableNames do: 
                        [:each | 
                        definitionStream
                                nextPutAll: each;
                                nextPut: $ ].
        definitionStream nextPutAll: '''
        classVariableNames: '''.
        self classVariableNames do: 
                        [:each | 
                        definitionStream
                                nextPutAll: each;
                                nextPut: $ ].
        definitionStream nextPutAll: '''
        poolDictionaries: '''.
        self poolDictionaryNames do: 
                        [:each | 
                        definitionStream
                                nextPutAll: each;
                                nextPut: $ ].
        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            cat := category.
            cat isNil ifTrue:[
                realClass isNil ifTrue:[
                    cat := '** As yet undefined **'
                ] ifFalse:[
                    cat := realClass category
                ]
            ].
            definitionStream nextPutAll: '''
        category: '.
            definitionStream
                    nextPutAll: cat storeString.
        ] ifFalse:[
            definitionStream nextPut:$'
        ].
        ^definitionStream contents
!

nonMetaclass
	^self
!

poolDictionaryNames
	^self privatePoolDictionaryNames copy
!

poolDictionaryNames: aCollectionOfStrings 
	poolDictionaryNames := (aCollectionOfStrings 
				collect: [:each | each asSymbol]) asOrderedCollection
!

privateClassesAt:className
    |pClass|

    self isDefined ifTrue: [
        pClass := self realClass privateClassesAt:className.
        pClass notNil ifTrue:[
            ^ model classFor:pClass
        ].
    ].
    ^ nil
!

setCategory: aSymbol 
        category := aSymbol
!

sharedPoolNames
    ^self poolDictionaryNames

    "Created: / 30-01-2012 / 21:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sharedPools
	^self allPoolDictionaryNames 
		collect: [:each | Smalltalk at: each asSymbol ifAbsent: [Dictionary new]]
!

theNonMetaClass
    <resource: #obsolete>

    "alias for theNonMetaclass (Squeak) - return the class.
     sigh; in ST/X, it is called theNonMetaclass; please use that."

    ^ self
!

theNonMetaclass
    "return the nonMetaClass of the class-meta pair.
     Sigh: ST/X naming; Squeak calls this theNonMetaClass"

    ^ self
!

topNameSpace
    self isDefined ifTrue: [
        ^ self realClass topNameSpace.
    ].
    ^ nil
! !

!RBClass methodsFor:'initialize-release'!

realName: aSymbol 
	self realClass: (Smalltalk at: aSymbol)
! !

!RBClass methodsFor:'private'!

privateClassVariableNames
	(self isDefined and: [classVariableNames isNil]) 
		ifTrue: [self classVariableNames: self realClass classVarNames].
	^classVariableNames
!

privatePoolDictionaryNames
        (self isDefined and: [poolDictionaryNames isNil]) ifTrue:[
            Smalltalk isSmalltalkX ifTrue:[
                self poolDictionaryNames:self realClass sharedPoolNames 
            ] ifFalse:[
                self poolDictionaryNames: 
                    (self realClass sharedPools collect: [:each | Smalltalk keyAtValue: each])                    
            ].
        ].
        ^ poolDictionaryNames

    "Modified: / 18-01-2011 / 17:58:46 / cg"
! !

!RBClass methodsFor:'testing'!

directlyDefinesClassVariable: aString 
	^self classVariableNames includes: aString asSymbol
!

directlyDefinesPoolDictionary: aString 
	^self poolDictionaryNames includes: aString asSymbol
!

isMeta
	^false
! !

!RBClass methodsFor:'variable accessing'!

addClassVariable: aString 
	self privateClassVariableNames add: aString asSymbol.
	model addClassVariable: aString to: self
!

addPoolDictionary: aString 
	self privatePoolDictionaryNames add: aString asSymbol.
	model addPool: aString to: self
!

classVarAt:classVarName
    ^ self realClass classVarAt:classVarName
!

removeClassVariable: aString 
	self privateClassVariableNames remove: aString asSymbol.
	model removeClassVariable: aString from: self
!

removePoolDictionary: aString 
	self privatePoolDictionaryNames remove: aString asSymbol
!

renameClassVariable: oldName to: newName around: aBlock 
	self privateClassVariableNames 
		at: (self privateClassVariableNames indexOf: oldName asSymbol)
		put: newName asSymbol.
	model 
		renameClassVariable: oldName
		to: newName
		in: self
		around: aBlock
! !

!RBClass class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

