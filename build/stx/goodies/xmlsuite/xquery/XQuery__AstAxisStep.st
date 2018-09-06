"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAxisStep
	instanceVariableNames:'forwardStep reverseStep predicateList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAxisStep methodsFor:'accessing'!

forwardStep
    ^ forwardStep

    "Created: / 18-03-2006 / 11:40:05 / ked"
!

forwardStep:something
    forwardStep := something.

    "Created: / 18-03-2006 / 11:40:05 / ked"
!

predicateList
    ^ predicateList

    "Created: / 18-03-2006 / 11:40:05 / ked"
!

predicateList:something
    predicateList := something.

    "Created: / 18-03-2006 / 11:40:05 / ked"
!

reverseStep
    ^ reverseStep

    "Created: / 18-03-2006 / 11:40:05 / ked"
!

reverseStep:something
    reverseStep := something.

    "Created: / 18-03-2006 / 11:40:05 / ked"
! !

!AstAxisStep methodsFor:'testing'!

isAstAxisStep
    ^ true

    "Modified: / 12-10-2006 / 21:57:48 / ked"
! !

!AstAxisStep methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAxisStep:self

    "Created: / 06-07-2006 / 19:12:08 / ked"
! !

!AstAxisStep class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
