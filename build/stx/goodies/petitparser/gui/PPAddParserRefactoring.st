"{ Package: 'stx:goodies/petitparser/gui' }"

Refactoring subclass:#PPAddParserRefactoring
	instanceVariableNames:'superclass name cateogry'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Refactoring'
!


!PPAddParserRefactoring class methodsFor:'instance creation'!

name: aString category: aSymbol
	^ self name: aString category: aSymbol superclass: PPCompositeParser
!

name: aString category: aSymbol superclass: aClass
	^ self new
		setName: aString;
		setCategory: aSymbol;
		setSuperclass: aClass;
		yourself
! !

!PPAddParserRefactoring methodsFor:'accessing'!

startProductionSource
	^ 'start
	^ self shouldBeImplemented'
! !

!PPAddParserRefactoring methodsFor:'initialization'!

setCategory: aSymbol
	cateogry := aSymbol asSymbol
!

setName: aString
	name := aString
!

setSuperclass: aClass
	superclass := self classObjectFor: aClass
! !

!PPAddParserRefactoring methodsFor:'preconditions'!

preconditions
	^ self checkCompositeParser: superclass
! !

!PPAddParserRefactoring methodsFor:'transforming'!

transform
        self performComponentRefactoring: (AddClassRefactoring
                model: self model
                addClass: name
                superclass: superclass
                subclasses: #()
                category: cateogry).
        (self classObjectFor: name)
                compile: self startProductionSource
                classified: #(accessing)
! !

!PPAddParserRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPAddParserRefactoring.st,v 1.1 2014-03-04 21:15:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPAddParserRefactoring.st,v 1.1 2014-03-04 21:15:19 cg Exp $'
! !

