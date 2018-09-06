"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

ClassRefactoring subclass:#AddClassRefactoring
	instanceVariableNames:'category superclass subclasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AddClassRefactoring class methodsFor:'instance creation'!

addClass: aName superclass: aClass subclasses: aCollection category: aSymbol
	^self new
		addClass: aName
		superclass: aClass
		subclasses: aCollection
		category: aSymbol
!

model: aRBSmalltalk addClass: aName superclass: aClass subclasses: aCollection category: aSymbol 
	^(self new)
		model: aRBSmalltalk;
		addClass: aName
			superclass: aClass
			subclasses: aCollection
			category: aSymbol;
		yourself
! !

!AddClassRefactoring methodsFor:'initialize-release'!

addClass: aName superclass: aClass subclasses: aCollection category: aSymbol 
	self className: aName.
	superclass := self classObjectFor: aClass.
	subclasses := aCollection collect: [:each | self classObjectFor: each].
	category := aSymbol
! !

!AddClassRefactoring methodsFor:'preconditions'!

preconditions
        | cond |
        cond := ((RBCondition isMetaclass: superclass) 
                                errorMacro: 'Superclass must not be a metaclass') not.
        cond := subclasses inject: cond
                                into: 
                                        [:sub :each | 
                                        sub 
                                                & ((RBCondition isMetaclass: each) 
                                                                errorMacro: 'Subclass must <1?not :>be a metaclass') not 
                                                        & (RBCondition isImmediateSubclass: each of: superclass)].
        ^cond & (RBCondition isValidClassName: className) 
                "/ & (RBCondition isGlobal: className in: self model) not 
                        & (RBCondition isSymbol: category) 
                        & ((RBCondition withBlock: [category isEmpty not]) 
                                        errorMacro: 'Invalid category name')
! !

!AddClassRefactoring methodsFor:'printing'!

changeString
    |nSubclasses|

    nSubclasses := subclasses size.
    nSubclasses == 1 ifTrue:[
        ^ 'Insert superclass %1 for %2' bindWith:className with:subclasses first name.
    ].
    nSubclasses == 2 ifTrue:[
        ^ 'Insert superclass %1 for %2 and %3' 
                bindWith:className 
                with:subclasses first name
                with:subclasses second name.
    ].

    ^ 'Insert superclass %1 for %2 subclasses' bindWith:className with:nSubclasses.
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addClass: #';
		nextPutAll: className;
		nextPutAll: ' superclass: '.
	superclass storeOn: aStream.
	aStream nextPutAll: ' subclasses: '.
	subclasses asArray storeOn: aStream.
	aStream nextPutAll: ' category: '.
	category storeOn: aStream.
	aStream nextPut: $)
! !

!AddClassRefactoring methodsFor:'transforming'!

transform
        |categoryString model|

        model := self model.

        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            categoryString := category storeString
        ] ifFalse:[
            categoryString := category
        ].

        (model classNamed: className asSymbol) isNil ifTrue:[
            (model)
                defineClass: ('<1p> subclass: #<2s> instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: <3p>' 
                                        expandMacrosWith: superclass
                                        with: className
                                        with: categoryString).
        ].

        (model)
                reparentClasses: subclasses to: (model classNamed: className asSymbol)

    "Modified: / 21-01-2012 / 10:51:16 / cg"
! !

!AddClassRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AddClassRefactoring.st,v 1.14 2013-09-24 20:20:13 cg Exp $'
! !

