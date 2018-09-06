"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

RBBlockLintRule subclass:#RBMethodModifierOverrideRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!


!RBMethodModifierOverrideRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Missing super implementation'
!

rationale
	^ 'Checks that a methods marked with <modifier: #override> overrides an actual superclass method.'
!

severity
	^ #error
! !

!RBMethodModifierOverrideRule methodsFor:'running'!

checkMethod: aContext

    | annotations |
    annotations := aContext compiledMethod perform: #annotations ifNotUnderstood: [nil].
    annotations isNil ifTrue:[^self].

    (annotations anySatisfy: [ :each | each key = #modifier: and: [ each arguments first = #override ] ])
        ifFalse: [ ^ self ].
    (aContext selectedClass superclass isNil)
        ifTrue: [ ^ self ].
    (aContext selectedClass superclass whichClassIncludesSelector: aContext selector) isNil
        ifTrue: [ result addClass: aContext selectedClass selector: aContext selector ]

    "Modified: / 04-08-2011 / 21:28:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethodModifierOverrideRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMethodModifierOverrideRule.st,v 1.2 2011-08-05 11:23:58 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMethodModifierOverrideRule.st,v 1.2 2011-08-05 11:23:58 vrany Exp $'
! !
