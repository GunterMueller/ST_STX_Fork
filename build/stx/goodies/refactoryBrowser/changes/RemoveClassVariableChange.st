"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryVariableChange subclass:#RemoveClassVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RemoveClassVariableChange methodsFor:'converting'!

asUndoOperation
	^AddClassVariableChange add: variable to: self changeClass
! !

!RemoveClassVariableChange methodsFor:'printing'!

changeString
        ^'Remove classvar <1s> from <2s>' 
                expandMacrosWith: variable allBold
                with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeClassVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!
! !

!RemoveClassVariableChange methodsFor:'private'!

changeSymbol
	^#removeClassVarName:
!

primitiveExecute
        RBParser isSmalltalkX ifTrue:[super primitiveExecute]
        ifFalse:[
            Object notifySignal handle: [:ex | ex proceed]
                    do: [super primitiveExecute]
        ]
!

variable
	^variable asSymbol
! !

!RemoveClassVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RemoveClassVariableChange.st,v 1.5 2004-03-19 14:48:58 cg Exp $'
! !
