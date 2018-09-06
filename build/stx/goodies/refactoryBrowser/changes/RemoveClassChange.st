"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryClassChange subclass:#RemoveClassChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RemoveClassChange class methodsFor:'instance creation'!

remove: aClass 
	^self new changeClass: aClass
!

removeClassName: aSymbol 
	^self new changeClassName: aSymbol
! !

!RemoveClassChange methodsFor:'converting'!

asUndoOperation
        | classChanges theClass|
        classChanges := CompositeRefactoryChange new.
        theClass := self changeClass.
        theClass ifNotNil:[
            theClass withAllSubclasses do: 
                            [:each | 
                            classChanges defineClass: each definition.
                            each class instVarNames 
                                    do: [:varName | classChanges addInstanceVariable: varName to: each class].
                            each selectors 
                                    do: [:selector | classChanges compile: (each sourceCodeAt: selector) in: each].
                            each class selectors 
                                    do: [:selector | classChanges compile: (each class sourceCodeAt: selector) in: each class]].
        ].
        ^classChanges
! !

!RemoveClassChange methodsFor:'printing'!

changeString
	^'Remove class ', self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeFromSystem';
		nextPut: $!!
! !

!RemoveClassChange methodsFor:'private'!

primitiveExecute
        |theClass|

        theClass := self changeClass.
        theClass ifNotNil:[theClass removeFromSystem]
! !

!RemoveClassChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RemoveClassChange.st,v 1.4 2003-09-23 10:43:51 cg Exp $'
! !
