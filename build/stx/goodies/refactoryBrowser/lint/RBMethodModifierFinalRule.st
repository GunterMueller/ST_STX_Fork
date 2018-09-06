"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

RBBlockLintRule subclass:#RBMethodModifierFinalRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!


!RBMethodModifierFinalRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Overrides a final method'
!

rationale
	^ 'Checks that a methods marked with <modifier: #final> is never overridden.'
!

severity
	^ #error
! !

!RBMethodModifierFinalRule methodsFor:'running'!

checkMethod: aContext
        | current |
        current := aContext selectedClass superclass.
        [ current notNil ] whileTrue: [
                | method |
                method := current methodDictionary at: aContext selector ifAbsent:[nil].
                method notNil ifTrue:[
                    | annotations |
                    annotations := method perform: #annotations ifNotUnderstood: [nil].
                    (annotations anySatisfy: [ :each | each keyword = #modifier: and: [ each arguments first = #final ] ])
                        ifTrue: [ 
                            result addClass: aContext selectedClass selector: aContext selector
                        ].
                ].
                current := current superclass ]

    "Modified: / 04-08-2011 / 19:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethodModifierFinalRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMethodModifierFinalRule.st,v 1.2 2011-08-05 11:04:55 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMethodModifierFinalRule.st,v 1.2 2011-08-05 11:04:55 vrany Exp $'
! !
