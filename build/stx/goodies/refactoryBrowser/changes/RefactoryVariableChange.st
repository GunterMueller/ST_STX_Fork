"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

RefactoryClassChange subclass:#RefactoryVariableChange
	instanceVariableNames:'variable'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryVariableChange class methodsFor:'instance creation'!

add: aVariable to: aBehavior 
	"This should only be called on the Add*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable
!

remove: aVariable from: aBehavior 
	"This should only be called on the Remove*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable
! !

!RefactoryVariableChange methodsFor:'comparing'!

= aRefactoryVariableChange 
	^super = aRefactoryVariableChange 
		and: [variable = aRefactoryVariableChange variable]
!

hash
	^self class hash bitXor: variable hash
! !

!RefactoryVariableChange methodsFor:'initialize-release'!

class: aBehavior variable: aString 
	self changeClass: aBehavior.
	variable := aString
! !

!RefactoryVariableChange methodsFor:'private'!

changeObject
	^self variable
!

changeSymbol
	self subclassResponsibility
!

changesFileTemplate
	^'<1p> <2s> <3p>'
!

primitiveExecute
        | changeSymbol |
        changeSymbol := self changeSymbol.
        self changeClass perform: changeSymbol with: self changeObject.
        ChangeSet current changeClass: self changeClass.
        SourceFileManager notNil ifTrue:[
            SourceFileManager default logChange: (self changesFileTemplate 
                                    expandMacrosWith: self changeClass
                                    with: changeSymbol
                                    with: self variable)
        ]
!

variable
	^variable
! !

!RefactoryVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RefactoryVariableChange.st,v 1.4 2003-09-23 10:45:00 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

