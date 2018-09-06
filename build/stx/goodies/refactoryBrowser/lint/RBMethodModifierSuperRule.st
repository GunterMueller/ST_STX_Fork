"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

RBBlockLintRule subclass:#RBMethodModifierSuperRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!


!RBMethodModifierSuperRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Super call required'
!

rationale
	^ 'Checks that a methods marked with <modifier: #super> are always called when overridden.'
!

severity
	^ #error
! !

!RBMethodModifierSuperRule methodsFor:'running'!

checkMethod: aContext

    | current |

    (aContext superMessages includes: aContext selector) ifTrue: [ ^ self ].

    current := aContext selectedClass superclass.
    [ current notNil ] whileTrue: [

        | method annotations |

        annotations := aContext compiledMethod perform: #annotations ifNotUnderstood: [nil].
        annotations notNil ifTrue:[
            (annotations anySatisfy: [ :each | each key = #modifier: and: [ each arguments first = #super ] ])
                ifTrue: [ 
                    result addClass: aContext selectedClass selector: aContext selector
                ].
                current := current superclass 
        ]
    ]

    "Modified: / 04-08-2011 / 21:28:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethodModifierSuperRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMethodModifierSuperRule.st,v 1.2 2011-08-05 11:13:39 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMethodModifierSuperRule.st,v 1.2 2011-08-05 11:13:39 vrany Exp $'
! !
