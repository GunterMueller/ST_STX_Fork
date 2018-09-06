"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryVariableChange subclass:#RemoveInstanceVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RemoveInstanceVariableChange methodsFor:'converting'!

asUndoOperation
	^AddInstanceVariableChange add: variable to: self changeClass
! !

!RemoveInstanceVariableChange methodsFor:'printing'!

changeString
        ^'Remove instvar <1s> from <2s>' 
                expandMacrosWith: variable allBold
                with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!
! !

!RemoveInstanceVariableChange methodsFor:'private'!

changeSymbol
	^#removeInstVarName:
! !

!RemoveInstanceVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RemoveInstanceVariableChange.st,v 1.4 2004-03-19 14:48:43 cg Exp $'
! !
