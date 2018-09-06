"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

Object subclass:#RBSpellChecker
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBSpellChecker class methodsFor:'initialization'!

initialize
    Smalltalk isSmalltalkX ifFalse:[
        Smalltalk addToShutDownList: self
    ]
!

shutDown
	Default := nil
!

unload
    Smalltalk isSmalltalkX ifFalse:[
        Smalltalk removeFromShutDownList: self
    ]
! !

!RBSpellChecker class methodsFor:'accessing'!

default
    "cached as singleton, because it is too expensive to reinstantiate"

        ^ Default ifNil: [ Default := self createInstance ]
! !

!RBSpellChecker class methodsFor:'private'!

createInstance
	^ RBMacSpellChecker isSupported
		ifTrue: [ RBMacSpellChecker new ]
		ifFalse: [ RBInternalSpellChecker new ]
! !

!RBSpellChecker methodsFor:'public'!

check: aString
	"Answer a collection of ranges of spell errors in aString."
	
	^ #()
! !

!RBSpellChecker class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBSpellChecker.st,v 1.4 2014-02-26 16:22:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBSpellChecker.st,v 1.4 2014-02-26 16:22:19 cg Exp $'
! !


RBSpellChecker initialize!
