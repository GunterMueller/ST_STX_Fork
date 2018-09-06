"{ Package: 'stx:goodies/refactoryBrowser/lint/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RBLintRuleTests2
	instanceVariableNames:'rule'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Tests'
!


!RBLintRuleTests2 methodsFor:'assertions'!

assertResultIncludesTestMethod
    "Asserts that result of current rule includes the test method"

    ^ self assertResultOf: rule includesClass: self class selector: testSelector

    "Created: / 05-12-2014 / 10:10:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assertResultOf: ruleA includesClass: class selector: selector
    self assert: (ruleA notNil).
    self assert: (ruleA result includesSelector: selector in: class)

    "Created: / 05-12-2014 / 01:06:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2014 / 10:18:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRuleTests2 methodsFor:'running rules'!

run: rule0
    "Run given rule on current test method"

    ^ self run: rule0 onSelector: testSelector

    "Created: / 05-12-2014 / 10:05:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: rule0 onClass: class selector: selector
    "Run given rule on given class and selector. Return the rule."

    | environment |

    environment := SelectorEnvironment onEnvironment: BrowserEnvironment new.
    environment addClass: class selector: selector.
    SmalllintChecker runRule: rule0 onEnvironment: environment.
    rule := rule0.
    ^ rule

    "Created: / 05-12-2014 / 10:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: rule0 onSelector: selector
    "Run given rule on method with given selector in this class. Return the rule."

    ^ self run: rule0 onClass: self class selector: selector

    "Created: / 05-12-2014 / 10:05:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRuleTests2 methodsFor:'tests - RBToDoFillRule'!

test_RBToDoFillRule_01
    | a |

    "=== DO NOT USE false ifTrue: ...optimized out by the compiler!!!!!! ==="
    (1 > 2) ifTrue:[
    "=== BEGIN TESTED CODE ==="        
    a := Array new: 10.
    1 to: a size do:[:i | a at: i put: 1 ].
    "==== END TESTED CODE ===="
    ].

    self run: RBToDoFillRule new.
    self assertResultIncludesTestMethod.

    "Created: / 05-12-2014 / 01:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-12-2014 / 11:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRuleTests2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

