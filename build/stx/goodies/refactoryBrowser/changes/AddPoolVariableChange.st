"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryVariableChange subclass:#AddPoolVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!AddPoolVariableChange methodsFor:'converting'!

asUndoOperation
	^RemovePoolVariableChange remove: variable from: self changeClass
! !

!AddPoolVariableChange methodsFor:'printing'!

changeString
	^'Add pool variable named, <1s>, from <2s>' 
		expandMacrosWith: self variable
		with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addSharedPool: ';
		nextPutAll: self variable;
		nextPut: $!!
! !

!AddPoolVariableChange methodsFor:'private'!

changeObject
	| dictionary |
	dictionary := variable isString 
				ifTrue: [Smalltalk classNamed: variable]
				ifFalse: [variable].
	^dictionary
!

changeSymbol
	^#addSharedPool:
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

!AddPoolVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/AddPoolVariableChange.st,v 1.4 2011-09-05 05:25:58 cg Exp $'
! !
