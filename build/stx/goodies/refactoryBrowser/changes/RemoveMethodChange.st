"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryClassChange subclass:#RemoveMethodChange
	instanceVariableNames:'selector'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RemoveMethodChange class methodsFor:'instance creation'!

remove: aSymbol from: aClass 
	^(self new)
		changeClass: aClass;
		selector: aSymbol;
		yourself
! !

!RemoveMethodChange methodsFor:'comparing'!

= aRemoveMethodChange 
	super = aRemoveMethodChange ifFalse: [^false].
	^selector = aRemoveMethodChange selector
!

hash
	^selector hash
! !

!RemoveMethodChange methodsFor:'converting'!

asUndoOperation
	^AddMethodChange compile: (self methodSourceFor: selector)
		in: self changeClass
! !

!RemoveMethodChange methodsFor:'initialization & release'!

selector: aSymbol 
	selector := aSymbol
! !

!RemoveMethodChange methodsFor:'printing'!

changeString
        ^'Remove <1s> from <2s>' expandMacrosWith: selector allBold
                with: self displayClassName
!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeSelector: ';
		nextPutAll: selector;
		nextPut: $!!
! !

!RemoveMethodChange methodsFor:'private'!

primitiveExecute
	^self changeClass removeSelector: selector
!

selector
	^selector
! !

!RemoveMethodChange methodsFor:'testing'!

isRemoveMethodChange
    ^ true
! !

!RemoveMethodChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RemoveMethodChange.st,v 1.6 2006-08-28 17:11:53 cg Exp $'
! !
