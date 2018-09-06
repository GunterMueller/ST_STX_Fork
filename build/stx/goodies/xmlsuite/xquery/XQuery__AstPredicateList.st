"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstPredicateList
	instanceVariableNames:'predicate predicateList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstPredicateList methodsFor:'accessing'!

predicate
    ^ predicate

    "Created: / 18-03-2006 / 21:15:47 / ked"
!

predicate:something
    predicate := something.

    "Created: / 18-03-2006 / 21:15:47 / ked"
!

predicateList
    ^ predicateList

    "Created: / 18-03-2006 / 21:15:47 / ked"
!

predicateList:something
    predicateList := something.

    "Created: / 18-03-2006 / 21:15:47 / ked"
! !

!AstPredicateList methodsFor:'testing'!

isAstPredicateList
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstPredicateList methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstPredicateList:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstPredicateList class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
