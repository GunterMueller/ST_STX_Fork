"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

MethodNameDialog subclass:#MethodNameDialogForAddParameter
	instanceVariableNames:'defaultValue askForDefaultValue defaultValueHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings UI'
!


!MethodNameDialogForAddParameter methodsFor:'accessing'!

askForDefaultValue
    ^ askForDefaultValue ? true
!

askForDefaultValue:something
    askForDefaultValue := something.
! !

!MethodNameDialogForAddParameter methodsFor:'aspects'!

argOrderBoxVisible
    ^ false
!

argValueBoxVisible
    ^ self askForDefaultValue
!

defaultValue
        ^ self defaultValueHolder value
!

defaultValueHolder
        ^defaultValueHolder isNil
                ifTrue:
                        [defaultValueHolder := 'nil' asValue]
                ifFalse:
                        [defaultValueHolder]
! !

!MethodNameDialogForAddParameter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/MethodNameDialogForAddParameter.st,v 1.1 2009-09-21 19:56:48 cg Exp $'
! !
