"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBLiteralNode subclass:#RBLiteralArrayNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!


!RBLiteralArrayNode class methodsFor:'instance creation'!

startPosition:start contents:contents stopPosition:stop isByteArray:isByteArray
    | value |

    isByteArray ifTrue:[ 
        value := ByteArray new: contents size.
        1 to: contents size do:[:i | 
            self assert: (contents at: i) isLiteralNode.
            value at: i put: (contents at: i) value.
        ].
    ] ifFalse:[ 
        value := Array new: contents size.
        1 to: contents size do:[:i | 
            self assert: (contents at: i) isLiteralNode.
            value at: i put: (contents at: i) token.
        ].

    ].
    ^ self literalToken:
        (RBLiteralToken value: value start: start stop: stop)

    "Created: / 07-10-2014 / 23:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLiteralArrayNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBLiteralArrayNode.st,v 1.1 2014-10-07 23:03:22 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBLiteralArrayNode.st,v 1.1 2014-10-07 23:03:22 vrany Exp $'
! !

