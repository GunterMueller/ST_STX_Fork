"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

Refactoring subclass:#RemoveClassRefactoring
	instanceVariableNames:'classNames'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RemoveClassRefactoring class methodsFor:'instance creation'!

className: aSymbol
	^self classNames: (Array with: aSymbol)
!

classNames: aClassNameCollection 
	^self new classNames: aClassNameCollection
!

model: aRBSmalltalk classNames: aClassNameCollection 
	^(self new)
		model: aRBSmalltalk;
		classNames: aClassNameCollection;
		yourself
! !

!RemoveClassRefactoring methodsFor:'initialize-release'!

classNames: aClassNameCollection 
	classNames := aClassNameCollection
! !

!RemoveClassRefactoring methodsFor:'preconditions'!

hasReferencesTo: aSymbol 
        | literal |
        literal := Smalltalk associationAt: aSymbol.

        BrowserEnvironment new classesDo: 
                        [:each | 
                        (classNames 
                                includes: (each isMeta ifTrue: [each soleInstance] ifFalse: [each]) name) 
                                        ifFalse: 
                                                [((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX])
                                                 ifTrue:[
                                                    (each whichSelectorsReferToGlobal:aSymbol) isEmpty ifFalse: [^true].
                                                 ] ifFalse:[
                                                    (each whichSelectorsReferTo: literal) isEmpty ifFalse: [^true].
                                                 ].
                                                (each whichSelectorsReferTo: aSymbol) isEmpty ifFalse: [^true]]].
        ^false
!

preconditions
        ^classNames 
            inject: RBCondition empty
            into:[:sum :each | 
                | aClass |

                aClass := self model classNamed: each asSymbol.
                aClass isNil ifTrue: [self refactoringError: 'No such class'].
                "/ notice & and | mean something completly different here    
                sum 
                    & (((RBCondition isMetaclass: aClass) 
                                    errorMacro: 'Cannot remove just the metaclass') not 
                    & ((RBCondition withBlock: [(self hasReferencesTo: each asSymbol) not])
                                    errorMacro: each , ' is referenced.<n>Browse references?';
                                    errorBlock:[self openBrowserOn: (BrowserEnvironment new referencesTo: (Smalltalk associationAt: each ifAbsent: [each]))];
                                    yourself) 
                    & ((RBCondition hasSubclasses: aClass) not 
                        | ((RBCondition isEmptyClass: aClass) 
                            & ((RBCondition withBlock: [aClass superclass notNil])
                                            errorMacro: 'Cannot remove top level class<n>when it has subclasses';
                                            yourself))))
            ]
! !

!RemoveClassRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' classNames: '.
	classNames asArray storeOn: aStream.
	aStream nextPut: $)
! !

!RemoveClassRefactoring methodsFor:'transforming'!

removeClasses
	classNames do: [:each | self model removeClassNamed: each]
!

reparentSubclasses
	classNames do: 
			[:each | 
			| class |
			class := self model classNamed: each.
			self model reparentClasses: class subclasses copy to: class superclass]
!

transform
	self
		reparentSubclasses;
		removeClasses
! !

!RemoveClassRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

