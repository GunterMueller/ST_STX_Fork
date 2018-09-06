"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

RBAbstractClass subclass:#RBMetaclass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Model'
!

RBMetaclass comment:'RBMetaclass represents a Metaclass.
'
!


!RBMetaclass class methodsFor:'instance creation'!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself
!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself
! !

!RBMetaclass methodsFor:'accessing'!

allClassVariableNames
	^self nonMetaclass allClassVariableNames
!

allPoolDictionaryNames
	^self nonMetaclass allPoolDictionaryNames
!

metaclass
	^self
! !

!RBMetaclass methodsFor:'initialize-release'!

realName: aSymbol 
	self realClass: (Smalltalk at: aSymbol) class
! !

!RBMetaclass methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' class'
!

storeOn: aStream 
	super storeOn: aStream.
	aStream nextPutAll: ' class'
! !

!RBMetaclass methodsFor:'testing'!

directlyDefinesClassVariable: aString 
	^self nonMetaclass directlyDefinesClassVariable: aString
!

directlyDefinesPoolDictionary: aString 
	^self nonMetaclass directlyDefinesPoolDictionary: aString
!

isMeta
	^true
! !

!RBMetaclass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/helpers/RBMetaclass.st,v 1.5 2003-09-23 10:47:32 cg Exp $'
! !
