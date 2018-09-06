"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBPoolVariableNamesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!

RBPoolVariableNamesSpellingRule comment:''
!


!RBPoolVariableNamesSpellingRule methodsFor:'accessing'!

name
	^ 'Pool variable names'
!

resultClass
	^ ClassEnvironment
! !

!RBPoolVariableNamesSpellingRule methodsFor:'running'!

checkClass: aContext 
        (aContext selectedClass isTrait or: [ aContext selectedClass isMeta ]) 
                ifTrue: [ ^ self ].
        aContext selectedClass sharedPoolNames do:[:each |
            (self checkIdentifier: each) do: [ :each |
                result
                        addSearchString: each;
                        addClass: aContext selectedClass 
            ]
        ].

"/        (self check: aContext selectedClass poolDictionaryNames) do: [ :each | 
"/                result
"/                        addSearchString: each;
"/                        addClass: aContext selectedClass ]
! !

!RBPoolVariableNamesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBPoolVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:24:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBPoolVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:24:24 cg Exp $'
! !

