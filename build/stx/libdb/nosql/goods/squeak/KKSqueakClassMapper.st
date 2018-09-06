"{ Package: 'stx:libdb/nosql/goods/squeak' }"

KKClassMapper subclass:#KKSqueakClassMapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Platform-Squeak'
!


!KKSqueakClassMapper class methodsFor:'class initialization'!

initialize
	"self initialize"

	self makeDefault
! !

!KKSqueakClassMapper methodsFor:'api'!

findClassForName: aClassName

	"Object allSubclassesDoGently: [:class |
		((class respondsTo: #goodsClassName) and: [class goodsClassName = aClassName])
			ifTrue: [^ class]]."

	^ Smalltalk
		at: (aClassName findTokens: '.') last asSymbol
		ifAbsent: [self error: 'Could not find class for ', aClassName].
!

nameForClass: aClass

	^aClass name
! !

!KKSqueakClassMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/KKSqueakClassMapper.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/KKSqueakClassMapper.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !


KKSqueakClassMapper initialize!
