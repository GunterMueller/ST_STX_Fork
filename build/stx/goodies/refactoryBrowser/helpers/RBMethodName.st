"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBMethodName
	instanceVariableNames:'selector arguments'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!


!RBMethodName class methodsFor:'instance creation'!

selector: aSymbol arguments: stringCollection 
	^(self new)
		selector: aSymbol;
		arguments: stringCollection;
		yourself
! !

!RBMethodName methodsFor:'accessing'!

arguments
	^arguments
!

arguments: nameCollection 
	arguments := nameCollection.
	self changed: #arguments
!

moveArgument: aName before: anotherName 
	arguments remove: aName ifAbsent: [^self].
	arguments add: aName before: anotherName.
	self changed: #arguments
!

selector
	^selector
!

selector: aSymbol 
	selector := aSymbol.
	self changed: #selector
! !

!RBMethodName methodsFor:'testing'!

isValid
        ^(RBCondition checkMethodName: selector in: self class) 
                and: [selector numArgs == arguments size]
! !

!RBMethodName class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/helpers/RBMethodName.st,v 1.4 2008-01-10 12:08:17 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

