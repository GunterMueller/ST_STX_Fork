"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

ClassRefactoring subclass:#RenameClassRefactoring
	instanceVariableNames:'newName class'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RenameClassRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk rename: aClass to: aNewName 
	^(self new)
		model: aRBSmalltalk;
		className: aClass name newName: aNewName;
		yourself
!

rename: aClass to: aNewName
	^self new className: aClass name newName: aNewName
!

renameClassNamed: oldClassName to: aNewName
        ^self new className: oldClassName newName: aNewName
! !

!RenameClassRefactoring methodsFor:'initialize-release'!

className: aName newName: aNewName 
	className := aName asSymbol.
	class := self model classNamed: className.
	newName := aNewName asSymbol
! !

!RenameClassRefactoring methodsFor:'performing'!

renameDirectReferences
        | classAssociation replacer changeBuilder |

self halt:'should no longer be invoked'.

        classAssociation := Smalltalk associationAt: className.
        changeBuilder := RefactoryBuilder new.
        replacer := ParseTreeRewriter rename: className
                                to: newName
                                handler: RefactoringError.
        
        "Rename the class first, and then rename the sources"
        changeBuilder renameClass: classAssociation value to: newName.

        "Change all sources to refer to the new class name, we need to search for any occurrence 
        of the old class name"
        self convertAllClassesSelect: 
                        [:aClass | 
                        | selectors |
                        selectors := aClass whichSelectorsReferTo: classAssociation.
                        selectors isEmpty ifFalse: 
                                        [(self allSubtreeVarsIn: aClass includes: newName asString) ifTrue: 
                                                        [self refactoringError: 'Cannot rename class since a variable is defined with that name']].
                        selectors]
                using: replacer
                notifying: changeBuilder.

        changeBuilder doIt: 'Compiling changes'
!

renameSymbols
        | replacer builder |

self halt:'should no longer be invoked'.

        builder := RefactoryBuilder new.
        replacer := ParseTreeRewriter replaceLiteral: className with: newName.
        self
                convertAllClassesSelect: [:aClass | aClass whichSelectorsReferTo: className]
                using: replacer
                notifying: builder.
        builder doIt: 'Renaming symbols'
! !

!RenameClassRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition withBlock: [class notNil and: [class isMeta not]]
                errorString: className , ' is not a valid class name') 
                        & (RBCondition isValidClassName: newName) 
                        & (RBCondition isGlobal: newName in: self model) not
! !

!RenameClassRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' rename: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: #';
		nextPutAll: newName;
		nextPut: $)
! !

!RenameClassRefactoring methodsFor:'transforming'!

renameReferences
        | replacer className2 newName2|

        replacer := (ParseTreeRewriter replaceLiteral: className with: newName)
                                replace: className with: newName;
                                replaceArgument: newName
                                        withValueFrom: 
                                                [:aNode | 
                                                self 
                                                        refactoringError: newName , ' already exists within the reference scope'];
                                yourself.

        (className includes:$:) ifTrue:[
            "/ a private or namespace class
            className2 := className copyFrom:(className lastIndexOf:$:)+1.
            newName2 := newName.
            (newName includes:$:) ifTrue:[
                (className copyTo:(className lastIndexOf:$:)) = (newName copyTo:(newName lastIndexOf:$:)) ifTrue:[
                    newName2 := newName copyFrom:(newName lastIndexOf:$:)+1.
                ]
            ].
            replacer 
                replaceLiteral: className2 with: newName2;
                replace: className2 with: newName2;
                replaceArgument: newName2
                    withValueFrom: [:aNode | self refactoringError: newName2 , ' already exists within the reference scope'].
        ].

        self model allReferencesToClass: class
                do: 
                        [:method | 

                        (method modelClass hierarchyDefinesVariable: newName) 
                                ifTrue: 
                                        [self refactoringError: newName , ' is already defined in hierarchy of ' 
                                                                , method modelClass printString].
                        self 
                                convertMethod: method selector
                                for: method modelClass
                                using: replacer]
!

transform
	self model 
		renameClass: class
		to: newName
		around: [self renameReferences]
! !

!RenameClassRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RenameClassRefactoring.st,v 1.13 2012-10-31 10:14:59 cg Exp $'
! !
