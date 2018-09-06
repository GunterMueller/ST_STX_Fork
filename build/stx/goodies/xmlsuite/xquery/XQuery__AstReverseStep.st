"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstReverseStep
	instanceVariableNames:'reverseAxis nodeTest abbrevReverseStep'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstReverseStep methodsFor:'accessing'!

abbrevReverseStep
    ^ abbrevReverseStep

    "Created: / 18-03-2006 / 12:44:10 / ked"
!

abbrevReverseStep:something
    abbrevReverseStep := something.

    "Created: / 18-03-2006 / 12:44:10 / ked"
!

nodeTest
    ^ nodeTest

    "Created: / 18-03-2006 / 12:44:10 / ked"
!

nodeTest:something
    nodeTest := something.

    "Created: / 18-03-2006 / 12:44:10 / ked"
!

reverseAxis
    ^ reverseAxis

    "Created: / 18-03-2006 / 12:44:10 / ked"
!

reverseAxis:something
    reverseAxis := something.

    "Created: / 18-03-2006 / 12:44:10 / ked"
! !

!AstReverseStep methodsFor:'testing'!

isAstReverseStep
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstReverseStep methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstReverseStep:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstReverseStep class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
