"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBParseTreeLintRule subclass:#RBFloatIdentityComparisonRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!


!RBFloatIdentityComparisonRule methodsFor:'accessing'!

group
        ^ 'Bugs'

    "Modified: / 01-03-2012 / 12:30:32 / cg"
!

name
        ^ 'Float identity comparison'

    "Modified: / 01-03-2012 / 12:30:55 / cg"
!

rationale
        ^ 'Floating point numbers should not be compared with
the identity compare operators (== and ~~), because float values
are instantiated on the fly so that two floats may have equal values, 
but are not necessarily identical (the same object).
<P>
Use the operators = or ~= instead, but be aware that even those may be
problematic due to rounding errors. The best way to compare floating point
numbers is with the almostEqual:epsilon: message.
<P>
Be aware, that due to rounding errors, even those operators may fail to
deliver the expected result. Better use an interval check like
"<code>var between:(v-delta) and:(v+delta)</code>" or the "<code>almostEqual:</code>" compare operation.'

    "Modified: / 01-03-2012 / 12:36:40 / cg"
! !

!RBFloatIdentityComparisonRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`{ :node | node isLiteral and: [ node value isFloat ] } == `@expr'
                        '`{ :node | node isLiteral and: [ node value isFloat ] } ~~ `@expr'
                        '`@expr == `{ :node | node isLiteral and: [ node value isFloat ] }'
                        '`@expr ~~ `{ :node | node isLiteral and: [ node value isFloat ] }' )
                do: [ :node :answer | node ]

    "Modified: / 01-03-2012 / 12:30:49 / cg"
! !

!RBFloatIdentityComparisonRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

