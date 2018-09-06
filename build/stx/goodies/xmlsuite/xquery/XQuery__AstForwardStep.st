"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstForwardStep
	instanceVariableNames:'forwardAxis nodeTest abbrevForwardStep'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstForwardStep methodsFor:'accessing'!

abbrevForwardStep
    ^ abbrevForwardStep

    "Created: / 18-03-2006 / 11:58:59 / ked"
!

abbrevForwardStep:something
    abbrevForwardStep := something.

    "Created: / 18-03-2006 / 11:58:59 / ked"
!

forwardAxis
    ^ forwardAxis

    "Created: / 18-03-2006 / 11:58:59 / ked"
!

forwardAxis:something
    forwardAxis := something.

    "Created: / 18-03-2006 / 11:58:59 / ked"
!

nodeTest
    ^ nodeTest

    "Created: / 18-03-2006 / 11:58:59 / ked"
!

nodeTest:something
    nodeTest := something.

    "Created: / 18-03-2006 / 11:58:59 / ked"
! !

!AstForwardStep methodsFor:'testing'!

isAstForwardStep
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstForwardStep methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstForwardStep:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstForwardStep class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
