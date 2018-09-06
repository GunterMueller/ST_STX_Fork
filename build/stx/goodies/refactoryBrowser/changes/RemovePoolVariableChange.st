"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryVariableChange subclass:#RemovePoolVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RemovePoolVariableChange methodsFor:'converting'!

asUndoOperation
	^AddPoolVariableChange add: variable to: self changeClass
! !

!RemovePoolVariableChange methodsFor:'printing'!

changeString
	^'Remove pool variable named, <1s>, from <2s>' 
		expandMacrosWith: self variable
		with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeSharedPool: ';
		nextPutAll: self variable;
		nextPut: $!!
! !

!RemovePoolVariableChange methodsFor:'private'!

changeObject
	| dictionary |
	dictionary := variable isString 
				ifTrue: [Smalltalk at: variable asSymbol]
				ifFalse: [variable].
	^dictionary
!

changeSymbol
	^#removeSharedPool:
!

changesFileTemplate
	^'<1p> <2s> <3s>'
!

variable
	^variable isString 
		ifTrue: [variable]
		ifFalse: 
			[Smalltalk keyAtValue: variable ifAbsent: [self error: 'Cannot find value']]
! !

!RemovePoolVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RemovePoolVariableChange.st,v 1.3 2003-09-23 10:46:57 cg Exp $'
! !
