"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#RemoveObjectRefactoring
	instanceVariableNames:'objectNames'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!

!RemoveObjectRefactoring class methodsFor:'documentation'!

documetation
"
    RemoveObjectRefactoring is an enhanced version of RemoveClassRefactoring.
    It removes unreferenced global objects (classes, shared vars, etc.). 
    It can also remove empty classes from the middle of hierarchies,    
    reparenting all of its children (which RemoveClassRefactoring can also).

    UNFINISHED
"
! !

!RemoveObjectRefactoring class methodsFor:'instance creation'!

model: aRBNameSpace objectNames: aStringCollection 
    ^(self new)
        model: aRBNameSpace;
        objectNames: aStringCollection;
        yourself
!

objectNames: aStringCollection 
    ^(self new)
        objectNames: aStringCollection;
        yourself
! !

!RemoveObjectRefactoring methodsFor:'initialize-release'!

objectNames: aStringCollection 
    objectNames := aStringCollection
! !

!RemoveObjectRefactoring methodsFor:'preconditions'!

hasReferencesTo: aRBProgramItem 
    model allReferencesToObject: aRBProgramItem do: [:each | ^true].
    ^false
!

preconditions
    ^objectNames inject: RBCondition empty
        into: 
            [:sum :each | 
            | item |
            item := self model fullItemNamed: each.
            item isNil ifTrue: [self refactoringError: (#NoSuchObject << #browser >> 'No such object')].
            sum 
                & (RBCondition withBlock: 
                            [(self hasReferencesTo: item) 
                                ifTrue: 
                                    [self refactoringError: ((#x1IsReferencedBrowseQ << #browser >> '<1s> is referenced.%<n%>Browse references?')
            expandMacrosWith: each) 
                                                expandMacros
                                        with: 
                                            [self openBrowserOn: (BrowserEnvironment new referencesTo: item binding)]].
                            item isNameSpace 
                                ifTrue: 
                                    [item definesAnyItem 
                                        ifTrue: 
                                            [self refactoringError: ((#x1sDefinesOtherObjects << #browser >> '<1s> is not empty. It defines other shared variables, name spaces, or classes')
            expandMacrosWith: each)].
                                    item isClassObject 
                                        ifTrue: 
                                            [(item instanceVariableNames isEmpty and: 
                                                    [item selectors isEmpty and: 
                                                            [item metaclass instanceVariableNames isEmpty 
                                                                and: [item metaclass selectors isEmpty]]]) 
                                                ifFalse: 
                                                    [item subclasses notEmpty 
                                                        ifTrue: 
                                                            [self 
                                                                refactoringError: (#CannotRemoveWithInstVarsAndSubclasses << #browser >> 'Cannot remove class that defines instance variables or methods when it has subclasses.')]].
                                            (item subclasses isEmpty and: [item superclass isNil]) 
                                                ifTrue: 
                                                    [self 
                                                        refactoringError: (#CannotRemoveTopWithSubclasses << #browser >> 'Cannot remove top level class when it has subclasses')]]].
                            true])]
! !

!RemoveObjectRefactoring methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll: 'Remove object refactoring'
!

storeOn: aStream 
    aStream nextPut: $(.
    self class storeOn: aStream.
    aStream nextPutAll: ' objectNames: '.
    objectNames asArray storeOn: aStream.
    aStream nextPut: $)
! !

!RemoveObjectRefactoring methodsFor:'transforming'!

removeClasses
    objectNames do: [:each | self model removeObjectNamed: each]
!

reparentSubclasses
    objectNames do: 
            [:each | 
            | class |
            class := self model classNamed: each.
            class notNil 
                ifTrue: 
                    [self model reparentClasses: class subclasses copy to: class superclass]]
!

transform
    self
        reparentSubclasses;
        removeClasses
! !

!RemoveObjectRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RemoveObjectRefactoring.st,v 1.1 2009-09-21 21:29:10 cg Exp $'
! !
