"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBArgumentVariableNamesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!

RBArgumentVariableNamesSpellingRule comment:''
!

!RBArgumentVariableNamesSpellingRule methodsFor:'accessing'!

name
	^ 'Argument variable names'
! !

!RBArgumentVariableNamesSpellingRule methodsFor:'running'!

checkMethod: aContext 
        | names |

        Smalltalk isSmalltalkX ifTrue:[
            names := aContext parseTree allArgumentVariables
        ] ifFalse:[
            names := aContext parseTree allArgumentVariables
                    collect: [ :each | each name ].
        ].
        names do:[:each |
            (self checkIdentifier: each) do:[:eachBad |
                result
                        addSearchString: eachBad;
                        addClass: aContext selectedClass selector: aContext selector 
            ].
        ].

"/        (self check: names) do: [ :each |    self halt. (self check: names).
"/                result
"/                        addSearchString: each;
"/                        addClass: aContext selectedClass selector: aContext selector ]

    "Modified: / 04-09-2011 / 20:05:21 / cg"
! !

