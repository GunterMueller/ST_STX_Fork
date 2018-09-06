"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBCompositeLintRule subclass:#RBLintRuleSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

!RBLintRuleSet class methodsFor:'documentation'!

documentation
"
    RBRuleSet is a composite rule represening a set of rules to be run
    to check some code.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        RBUserRuleSet
        RBBuiltinRuleSet

"
! !

!RBLintRuleSet class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == RBRuleSet.
! !

!RBLintRuleSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

