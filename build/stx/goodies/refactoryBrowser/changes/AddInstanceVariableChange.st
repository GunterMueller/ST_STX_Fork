"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryVariableChange subclass:#AddInstanceVariableChange
	instanceVariableNames:'index'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!AddInstanceVariableChange class methodsFor:'instance creation'!

add: aVariable at: index to: aBehavior 
    "Adds an instance variable to a specified index."

    ^self new class: aBehavior variable: aVariable index: index.

    "Created: / 31-01-2014 / 01:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AddInstanceVariableChange methodsFor:'converting'!

asUndoOperation
	^RemoveInstanceVariableChange remove: variable from: self changeClass
! !

!AddInstanceVariableChange methodsFor:'initialize-release'!

class: aBehavior variable: aString index: anInteger
        self changeClass: aBehavior.
        variable := aString.
        index := anInteger

    "Created: / 31-01-2014 / 01:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AddInstanceVariableChange methodsFor:'printing'!

changeString
"/        ^'Add instance variable named, <1s>, to <2s>' 
"/                expandMacrosWith: variable
"/                with: self displayClassName
        ^'Add instvar <1s> to <2s>' 
                expandMacrosWith: variable allBold
                with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!
! !

!AddInstanceVariableChange methodsFor:'private'!

changeSymbol
	^#addInstVarName:
!

primitiveExecute
        | changeSymbol changeClass |

        changeClass := self changeClass.
        changeSymbol := self changeSymbol.
        (changeClass respondsTo: #addInstVarName:afterIndex:) ifTrue:[
            changeClass addInstVarName: self changeObject afterIndex: index.
        ] ifFalse:[ 
            changeClass addInstVarName: self changeObject
        ].
        ChangeSet current changeClass: changeClass.
        SourceFileManager notNil ifTrue:[
            SourceFileManager default logChange: (self changesFileTemplate 
                                    expandMacrosWith: self changeClass
                                    with: changeSymbol
                                    with: self variable)
        ]

    "Created: / 31-01-2014 / 01:53:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AddInstanceVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/AddInstanceVariableChange.st,v 1.6 2014-12-03 20:14:49 cg Exp $'
! !

