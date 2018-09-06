"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryVariableChange subclass:#AddClassVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!AddClassVariableChange methodsFor:'converting'!

asUndoOperation
	^RemoveClassVariableChange remove: variable from: self changeClass
! !

!AddClassVariableChange methodsFor:'printing'!

changeString
"/        ^'Add class variable named, <1s>, from <2s>' 
"/                expandMacrosWith: variable
"/                with: self displayClassName
        ^'Add class var <1s> to <2s>' 
                expandMacrosWith: variable allBold
                with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addClassVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!
! !

!AddClassVariableChange methodsFor:'private'!

changeSymbol
	^#addClassVarName:
!

variable
	^variable asSymbol
! !

!AddClassVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/AddClassVariableChange.st,v 1.4 2004-03-19 14:48:50 cg Exp $'
! !
