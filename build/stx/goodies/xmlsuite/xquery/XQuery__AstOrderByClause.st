"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOrderByClause
	instanceVariableNames:'isStable orderSpecList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOrderByClause methodsFor:'accessing'!

isStable
    ^ isStable

    "Created: / 10-03-2006 / 21:53:25 / ked"
!

isStable:something
    isStable := something.

    "Created: / 10-03-2006 / 21:53:25 / ked"
!

orderSpecList
    ^ orderSpecList

    "Created: / 10-03-2006 / 21:53:26 / ked"
!

orderSpecList:something
    orderSpecList := something.

    "Created: / 10-03-2006 / 21:53:26 / ked"
! !

!AstOrderByClause methodsFor:'testing'!

isAstOrderByClause
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstOrderByClause methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstOrderByClause:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstOrderByClause class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
